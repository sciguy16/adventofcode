library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package packet_handler_pkg is
  -- Biggest packet is a 128-byte BRAM write. Consists of:
  -- * 4 byte offset
  -- * 128 bytes data
  -- Total = 132 bytes
  constant c_MAX_PACKET_LENGTH_BYTES: unsigned(31 downto 0) := x"0000_0084";

  -- BRAM is 1024 32-bit words deep, and packet payload is fixed at 128 bytes.
  -- 128 bytes is 32 words, so upper bound is 1024 - 32 = 0x400 - 0x20 = 0x3e0
  constant c_MAX_RAM_OFFSET: std_logic_vector(31 downto 0) := x"0000_03e0";
  constant c_BRAM_OFFSET_OKAY: std_logic_vector(31 downto 0) := x"0100_0000";
  constant c_BRAM_OFFSET_NOT_OKAY: std_logic_vector(31 downto 0) := x"0000_0000";
  -- 128 bytes = 32 words
  constant c_BRAM_READ_LEN_WORDS: unsigned(7 downto 0) := x"20";
  constant c_BRAM_MAX_WRITE_LEN_WORDS: unsigned(7 downto 0) := x"20";
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.packet_types_pkg_hdr.ALL;
use work.packet_handler_pkg.ALL;
use work.day_mux_pkg_hdr.c_NUM_DAYS;

--TODO
-- * Make read/write length variable
-- * Day operation controls
-- * Day zero mode that's approximately a self-test

entity packet_handler is
  port(
    reset : in std_logic;
    clk   : in std_logic;

    -- Request packet data in
    axi_str_rxd_tvalid_IN  : IN  STD_LOGIC;
    axi_str_rxd_tready_OUT : OUT STD_LOGIC;
    axi_str_rxd_tdata_IN   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Response packet data out
    axi_str_txd_tvalid_OUT : OUT STD_LOGIC;
    axi_str_txd_tready_IN  : IN  STD_LOGIC;
    axi_str_txd_tdata_OUT  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- BRAM Port A controls --

    -- Write controls --
    -- Start address of write transaction, in bytes?
    m_axi_write_word_offset_port_a_OUT : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    -- Burst length of write transaction, in words/data beats
    m_axi_awlen_port_a_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axi_awvalid_port_a_OUT : OUT STD_LOGIC;
    m_axi_awready_port_a_IN : IN STD_LOGIC;

    -- Write data --
    m_axi_wdata_port_a_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_wlast_port_a_OUT : OUT STD_LOGIC;
    m_axi_wvalid_port_a_OUT : OUT STD_LOGIC;
    m_axi_wready_port_a_IN : IN STD_LOGIC;

    -- Write response --
    m_axi_bresp_port_a_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_bvalid_port_a_IN : IN STD_LOGIC;
    m_axi_bready_port_a_OUT : OUT STD_LOGIC;

    -- Read controls --
    m_axi_read_word_offset_port_a_OUT : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    m_axi_arlen_port_a_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axi_arvalid_port_a_OUT : OUT STD_LOGIC;
    m_axi_arready_port_a_IN : IN STD_LOGIC;

    -- Read data --
    m_axi_rdata_port_a_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_rresp_port_a_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_rlast_port_a_IN : IN STD_LOGIC;
    m_axi_rvalid_port_a_IN : IN STD_LOGIC;
    m_axi_rready_port_a_OUT : OUT STD_LOGIC;

    -- Day mux controls
    day_sel_OUT: OUT unsigned(7 downto 0);
    data_len_bytes_OUT: OUT unsigned(11 downto 0);
    day_done_IN: IN std_logic
  );
end packet_handler;

architecture rtl of packet_handler is
  signal PACKET_TYPE     : unsigned(7 downto 0)          := (others => '0');
  signal RX_PACKET_LENGTH_BYTES   : unsigned(15 downto 0)         := (others => '0');
  signal RX_PACKET_LENGTH_WORDS   : unsigned(15 downto 0)         := (others => '0');
  signal RX_PACKET_LENGTH_OKAY: boolean;
  signal PING_PAYLOAD    : std_logic_vector(31 downto 0) := (others => '0');
  signal RAM_OFFSET      : std_logic_vector(31 downto 0) := (others => '0');
  signal payload_counter : unsigned(15 downto 0)          := (others => '0');
  signal reply_payload_counter : unsigned(7 downto 0)    := (others => '0');
  signal reply_done      : std_logic;
  signal REPLY_HEADER    : std_logic_vector(31 downto 0) := (others => '0');
  signal BRAM_OFFSET_OKAY: boolean;

  signal day_sel: unsigned(7 downto 0) := (others => '0');
  signal data_len_bytes: unsigned(15 downto 0) := (others => '0');
  signal run_day_ok: boolean;

  type T_RX_STATE is (
    RX_STATE_IDLE,
    RX_STATE_PAYLOAD_1,
    RX_STATE_RAM_OFFSET,
    RX_STATE_WRITE_REQ_WAIT_AWREADY,
    RX_STATE_WRITE_RAM,
    RX_STATE_WRITE_RAM_LAST_WORD,
    RX_STATE_SEND_REPLY
  );
  signal rx_state : T_RX_STATE := RX_STATE_IDLE;

  type T_REPLY_STATE is (
      REPLY_STATE_IDLE,
      REPLY_STATE_SEND_PONG_PAYLOAD,
      REPLY_STATE_SEND_BRAM_OFFSET,
      REPLY_STATE_SEND_BRAM_OKAY,
      REPLY_STATE_SETUP_BRAM_READ,
      REPLY_STATE_SEND_BRAM_DATA,
      REPLY_STATE_RUN_DAY,
      REPLY_STATE_WAIT_DONE,
      REPLY_STATE_WAIT_IDLE
    );
  signal reply_state : T_REPLY_STATE := REPLY_STATE_IDLE;

  ATTRIBUTE MARK_DEBUG: string;
  ATTRIBUTE MARK_DEBUG of rx_state: signal is "TRUE";
  ATTRIBUTE MARK_DEBUG of PACKET_TYPE: signal is "TRUE";
  ATTRIBUTE MARK_DEBUG of RX_PACKET_LENGTH_WORDS: signal is "TRUE";
  ATTRIBUTE MARK_DEBUG of RAM_OFFSET: signal is "TRUE";
  ATTRIBUTE MARK_DEBUG of payload_counter: signal is "TRUE";
  ATTRIBUTE MARK_DEBUG of reply_payload_counter: signal is "TRUE";
  ATTRIBUTE MARK_DEBUG of reply_done: signal is "TRUE";
  ATTRIBUTE MARK_DEBUG of reply_state: signal is "TRUE";

  function bool_to_std_logic(input: boolean) return std_logic is
    variable ret: std_logic;
  begin
    if input then
      ret := '1';
    else
      ret := '0';
    end if;
    return ret;
  end;

begin
  set_reply_header: process(PACKET_TYPE) is
    variable v_header_typ: unsigned(7 downto 0);
    variable v_header_typ_slv: std_logic_vector(7 downto 0);
    variable v_packet_len: std_logic_vector(15 downto 0);
  begin
    case PACKET_TYPE is
      when C_DESTINATION_top_TYPE_ping =>
        v_header_typ := C_DESTINATION_top_TYPE_pong;
        v_packet_len := x"0004";
      when C_DESTINATION_top_TYPE_write_ram =>
        v_header_typ := C_DESTINATION_top_TYPE_write_ram_ack;
        v_packet_len := x"0008";
      when C_DESTINATION_top_TYPE_read_ram =>
        v_header_typ := C_DESTINATION_top_TYPE_read_ram_ack;
        v_packet_len := x"0088";
      when C_DESTINATION_top_TYPE_run_day =>
        v_header_typ := C_DESTINATION_top_TYPE_run_day_ack;
        v_packet_len := x"0004";
      when others =>
        report "Unexpected packet type" & to_hex_string(PACKET_TYPE)
          severity error;
        v_header_typ := x"00";
        v_packet_len := x"0004";
    end case;

    v_header_typ_slv := std_logic_vector(v_header_typ);
    REPLY_HEADER  <= (x"00" & v_header_typ_slv) & v_packet_len;
  end process set_reply_header;

  set_bram_okay: process(all) is
  begin
    BRAM_OFFSET_OKAY <= RAM_OFFSET < c_MAX_RAM_OFFSET;
  end process set_bram_okay;

  -- Packet length must be no greater than the max packet length and it
  -- must (for now) be a multiple of four bytes
  set_rx_packet_length_okay: process(all) is
    variable length_ok: boolean;
    variable is_multiple_of_four: boolean;
  begin
    length_ok := RX_PACKET_LENGTH_BYTES <= c_MAX_PACKET_LENGTH_BYTES;
    is_multiple_of_four := RX_PACKET_LENGTH_BYTES(1 downto 0) = "00";
    RX_PACKET_LENGTH_OKAY <= length_ok and is_multiple_of_four;
  end process set_rx_packet_length_okay;

  set_run_day_ok: process(all) is
  begin
    run_day_ok <= day_sel < c_NUM_DAYS and data_len_bytes(15 downto 12) = "000";
  end process set_run_day_ok;

  process(clk) is
    variable v_packet_type : unsigned(7 downto 0);
    variable v_ram_offset  : std_logic_vector(31 downto 0);
    variable v_pkt_len_bytes: unsigned(15 downto 0);
    variable v_current_word  : std_logic_vector(31 downto 0);
  begin
    if rising_edge(clk) then
      -- defaults
      axi_str_rxd_tready_OUT <= '0';
      m_axi_wdata_port_a_OUT <= (others => '0');
      m_axi_wvalid_port_a_OUT <= '0';
      m_axi_wlast_port_a_OUT <= '0';

      case rx_state is

        when RX_STATE_IDLE =>
          axi_str_rxd_tready_OUT <= '1';
          if axi_str_rxd_tvalid_IN = '1' then
            v_packet_type   := unsigned(axi_str_rxd_tdata_IN(23 downto 16));
            PACKET_TYPE     <= v_packet_type;
            v_pkt_len_bytes        := unsigned(axi_str_rxd_tdata_IN(15 downto 0));
            RX_PACKET_LENGTH_BYTES <= v_pkt_len_bytes;
            RX_PACKET_LENGTH_WORDS <= "00" & v_pkt_len_bytes(15 downto 2);
            payload_counter <= x"0000";
            with v_packet_type select rx_state <=
              RX_STATE_PAYLOAD_1  when C_DESTINATION_top_TYPE_ping,
              RX_STATE_RAM_OFFSET when C_DESTINATION_top_TYPE_write_ram,
              RX_STATE_RAM_OFFSET when C_DESTINATION_top_TYPE_read_ram,
              RX_STATE_PAYLOAD_1  when C_DESTINATION_top_TYPE_run_day,
              RX_STATE_IDLE       when others;
          end if;

        when RX_STATE_PAYLOAD_1 =>
          axi_str_rxd_tready_OUT <= '1';

          if axi_str_rxd_tvalid_IN = '1' then
            v_current_word := axi_str_rxd_tdata_IN;
            case PACKET_TYPE is
            when C_DESTINATION_top_TYPE_ping =>
              PING_PAYLOAD    <= v_current_word;
            when C_DESTINATION_top_TYPE_run_day =>
              day_sel <= unsigned(v_current_word(7 downto 0));
              data_len_bytes <= unsigned(v_current_word(23 downto 8));
            when others =>
              -- nothing (latch)
            end case;

            payload_counter <= payload_counter + 1;
            if(payload_counter = RX_PACKET_LENGTH_WORDS - 1) then
              rx_state <= RX_STATE_SEND_REPLY;
            else
              rx_state <= RX_STATE_PAYLOAD_1;
            end if;
          end if;

        when RX_STATE_RAM_OFFSET =>
          axi_str_rxd_tready_OUT <= '1';
          if axi_str_rxd_tvalid_IN = '1' then
            -- Record the RAM offset into a register
            payload_counter       <= payload_counter + 1;
            v_ram_offset          := axi_str_rxd_tdata_IN;
            RAM_OFFSET            <= v_ram_offset;

            -- If it's a write transaction then set up the BRAM AXI write
            -- interface (but only if the write request is valid)
            if PACKET_TYPE = C_DESTINATION_top_TYPE_write_ram
              and RX_PACKET_LENGTH_OKAY then
              m_axi_write_word_offset_port_a_OUT  <= v_ram_offset(9 downto 0);
              --TODO validate that the word count fits into 8 bits
              m_axi_awlen_port_a_OUT   <=
                std_logic_vector(RX_PACKET_LENGTH_WORDS(7 downto 0));
              m_axi_awvalid_port_a_OUT <= '1';

              -- If the BRAM AXI interface immediately accepts the write
              -- request then go straight to the data phase, otherwise
              -- go to the state which waits for AWREADY to be asserted
              if m_axi_awready_port_a_IN = '1' then
                rx_state <= RX_STATE_WRITE_RAM;
              else
                rx_state <= RX_STATE_WRITE_REQ_WAIT_AWREADY;
              end if;
            else
              with PACKET_TYPE select rx_state <=
                RX_STATE_WRITE_RAM   when C_DESTINATION_top_TYPE_write_ram,
                RX_STATE_SEND_REPLY  when C_DESTINATION_top_TYPE_read_ram,
                RX_STATE_IDLE        when others;
            end if;
          end if;

        when RX_STATE_WRITE_REQ_WAIT_AWREADY =>
          if m_axi_awready_port_a_IN = '1' then
            rx_state <= RX_STATE_WRITE_RAM;
            m_axi_awvalid_port_a_OUT <= '0';
          else
            rx_state <= RX_STATE_WRITE_REQ_WAIT_AWREADY;
          end if;

        when RX_STATE_WRITE_RAM =>
          m_axi_awvalid_port_a_OUT <= '0';
          -- forward data words to BRAM axi interface
          rx_state <= RX_STATE_WRITE_RAM; -- default stay in this state

          -- only forward data from valid incoming packets, otherwise
          -- clock the words through but ignore them
          if RX_PACKET_LENGTH_OKAY then
            --TODO it's possible this wants a skid buffer
            m_axi_wdata_port_a_OUT  <= axi_str_rxd_tdata_IN;
            m_axi_wvalid_port_a_OUT <= axi_str_rxd_tvalid_IN;
            axi_str_rxd_tready_OUT  <= m_axi_wready_port_a_IN;
          else
            axi_str_rxd_tready_OUT  <= '1';
          end if;

          if axi_str_rxd_tvalid_IN = '1' then
            --if payload_counter = RX_PACKET_LENGTH_WORDS then
            --  rx_state <= RX_STATE_WRITE_RAM_LAST_WORD;
            --  m_axi_wlast_port_a_OUT <= '1';
            --end if;
            payload_counter        <= payload_counter + 1;
          end if;

          if payload_counter = RX_PACKET_LENGTH_WORDS - 1 then
            m_axi_wlast_port_a_OUT <= '1';
            m_axi_wvalid_port_a_OUT <= '1';
          elsif payload_counter = RX_PACKET_LENGTH_WORDS then
            rx_state <= RX_STATE_SEND_REPLY;
            m_axi_wlast_port_a_OUT <= '0';
            m_axi_wvalid_port_a_OUT <= '0';
          end if;

        when RX_STATE_WRITE_RAM_LAST_WORD =>
          m_axi_wlast_port_a_OUT <= '1';
          if axi_str_rxd_tvalid_IN = '1' then
            rx_state <= RX_STATE_SEND_REPLY; 
            m_axi_wlast_port_a_OUT <= '0';
          end if;
        --TODO check BRESP

        when RX_STATE_SEND_REPLY =>
          if reply_done = '1' then
            rx_state <= RX_STATE_IDLE;
          else
            rx_state <= RX_STATE_SEND_REPLY;
          end if;

      end case;

      if reset = '1' then
        rx_state               <= RX_STATE_IDLE;
        PACKET_TYPE            <= (others => '0');
        axi_str_rxd_tready_OUT <= '0';
        m_axi_awvalid_port_a_OUT <= '0';
        m_axi_bready_port_a_OUT <= '0';
        m_axi_write_word_offset_port_a_OUT <= 10x"000";
        m_axi_awlen_port_a_OUT <= x"00";
        day_sel_OUT <= x"00";
        data_len_bytes_OUT <= x"000";
      end if;
    end if;
  end process;

  reply_ctrl : process(clk) is
    variable v_header_typ: unsigned(7 downto 0);
    variable v_header_typ_slv: std_logic_vector(7 downto 0);
    variable v_packet_len: std_logic_vector(15 downto 0);
  begin
    if rising_edge(clk) then
      -- defaults
      reply_done             <= '0';
      axi_str_txd_tvalid_OUT  <= '0';
      m_axi_rready_port_a_OUT <= '0';
      m_axi_arvalid_port_a_OUT <= '0';

      case reply_state is
 
        when REPLY_STATE_IDLE =>
          if rx_state = RX_STATE_SEND_REPLY then
            axi_str_txd_tdata_OUT <= REPLY_HEADER;
            axi_str_txd_tvalid_OUT <= '1';

            with PACKET_TYPE select reply_state <=
              REPLY_STATE_SEND_PONG_PAYLOAD when C_DESTINATION_top_TYPE_ping,
              REPLY_STATE_SEND_BRAM_OFFSET when C_DESTINATION_top_TYPE_write_ram,
              REPLY_STATE_SEND_BRAM_OFFSET when C_DESTINATION_top_TYPE_read_ram,
              REPLY_STATE_RUN_DAY when C_DESTINATION_top_TYPE_run_day,
              REPLY_STATE_IDLE when others;
          end if;
 
        when REPLY_STATE_SEND_PONG_PAYLOAD =>
          if axi_str_txd_tready_IN then
            axi_str_txd_tvalid_OUT <= '1';
            reply_state           <= REPLY_STATE_WAIT_DONE;
            axi_str_txd_tdata_OUT<= PING_PAYLOAD;
          end if;
 
        when REPLY_STATE_SEND_BRAM_OFFSET =>
          axi_str_txd_tvalid_OUT <= '1';
          if axi_str_txd_tready_IN then
            reply_state           <= REPLY_STATE_SEND_BRAM_OKAY;
            axi_str_txd_tdata_OUT<= RAM_OFFSET;
          end if;
 
        when REPLY_STATE_SEND_BRAM_OKAY =>
          axi_str_txd_tvalid_OUT <= '1';
          if axi_str_txd_tready_IN then
            axi_str_txd_tvalid_OUT <= '1';
            axi_str_txd_tdata_OUT<=
              c_BRAM_OFFSET_OKAY when BRAM_OFFSET_OKAY
              else c_BRAM_OFFSET_NOT_OKAY;

            with PACKET_TYPE select reply_state <=
              REPLY_STATE_SETUP_BRAM_READ when C_DESTINATION_top_TYPE_read_ram,
              REPLY_STATE_WAIT_DONE when others;
          end if;

        when REPLY_STATE_SETUP_BRAM_READ =>
          reply_state <= REPLY_STATE_SETUP_BRAM_READ;
          -- set up the read request
          --TODO validate that the ram offset fits into 12 bits
          m_axi_read_word_offset_port_a_OUT  <= RAM_OFFSET(9 downto 0);
          m_axi_arlen_port_a_OUT   <= std_logic_vector(c_BRAM_READ_LEN_WORDS);
          m_axi_arvalid_port_a_OUT <= '1';

          if m_axi_arready_port_a_IN = '1' then
            reply_state <= REPLY_STATE_SEND_BRAM_DATA;
          end if;
 
        when REPLY_STATE_SEND_BRAM_DATA =>
          reply_state <= REPLY_STATE_SEND_BRAM_DATA; -- default

          axi_str_txd_tdata_OUT   <= m_axi_rdata_port_a_IN;
          axi_str_txd_tvalid_OUT  <= m_axi_rvalid_port_a_IN;
          m_axi_rready_port_a_OUT <= axi_str_txd_tready_IN;

          if m_axi_rlast_port_a_IN = '1' then
            reply_state            <= REPLY_STATE_WAIT_DONE;
          end if;

        when REPLY_STATE_RUN_DAY =>
          -- if request is bad then send ACK immediately, otherwise
          -- wait for the day mux to report DONE
          if not run_day_ok or day_done_IN = '1' then
            axi_str_txd_tdata_OUT  <= std_logic_vector(day_sel)
                                      & "0000000"
                                      & bool_to_std_logic(run_day_ok)
                                      & x"0000";
            axi_str_txd_tvalid_OUT <= '1';
            reply_state            <= REPLY_STATE_WAIT_DONE;
          else
            reply_state            <= REPLY_STATE_RUN_DAY;
          end if;
 
        when REPLY_STATE_WAIT_DONE =>
          if axi_str_txd_tready_IN then
            axi_str_txd_tvalid_OUT <= '0';
            reply_done             <= '1';
            reply_state            <= REPLY_STATE_WAIT_IDLE;
          end if;
 
        when REPLY_STATE_WAIT_IDLE =>
          if rx_state = RX_STATE_IDLE then
            reply_state <= REPLY_STATE_IDLE;
          end if;
      end case;

      if reset = '1' then
        reply_state                   <= REPLY_STATE_IDLE;
        reply_done                    <= '0';
        m_axi_arvalid_port_a_OUT      <= '0';
        m_axi_arlen_port_a_OUT        <= x"00";
        m_axi_read_word_offset_port_a_OUT <= 10x"000";
        axi_str_txd_tdata_OUT   <= (others => '0');
      end if;
    end if;
  end process;

end rtl;
