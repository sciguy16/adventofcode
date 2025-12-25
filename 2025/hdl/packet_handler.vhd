library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package packet_handler_pkg is
  type T_RX_STATE is (
      RX_STATE_IDLE,
      RX_STATE_PING,
      RX_STATE_RAM_OFFSET,
      RX_STATE_WRITE_RAM,
      RX_STATE_WRITE_RAM_WAIT_READY,
      --RX_STATE_READ_RAM,
      RX_STATE_SEND_REPLY
    );

  -- BRAM is 512 32-bit words deep, and packet payload is fixed at 128 bytes.
  -- 128 bytes is 32 words, so upper bound is 512 - 32 = 0x200 - 0x20 = 0x1e0
  constant c_MAX_RAM_OFFSET: std_logic_vector(31 downto 0) := x"000001e0";
  constant c_BRAM_OFFSET_OKAY: std_logic_vector(31 downto 0) := x"01000000";
  constant c_BRAM_OFFSET_NOT_OKAY: std_logic_vector(31 downto 0) := x"00000000";
  -- 128 bytes = 32 words
  constant c_BRAM_READ_LEN_WORDS: unsigned(7 downto 0) := x"20";
  constant c_BRAM_MAX_WRITE_LEN_WORDS: unsigned(7 downto 0) := x"20";
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.packet_types_pkg_hdr.ALL;
use work.packet_handler_pkg.ALL;

entity packet_handler is
  port(
    reset : in std_logic;
    clk   : in std_logic;

    axi_str_rxd_tvalid_IN  : IN  STD_LOGIC;
    axi_str_rxd_tready_OUT : OUT STD_LOGIC;
    axi_str_rxd_tdata_IN   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);

    axi_str_txd_tvalid_OUT : OUT STD_LOGIC;
    axi_str_txd_tready_IN  : IN  STD_LOGIC;
    axi_str_txd_tdata_OUT  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

    bram_write_data_a_OUT  : OUT std_logic_vector(31 downto 0);
    bram_read_data_a_IN    : IN  std_logic_vector(31 downto 0);
    bram_addr_a_OUT        : OUT std_logic;
    bram_write_valid_a_OUT : OUT std_logic;
    bram_write_ready_a_IN  : IN  std_logic;
    bram_read_req_a_OUT    : OUT std_logic;
    bram_read_valid_a_IN   : IN  std_logic;
    bram_read_ready_a_OUT  : OUT std_logic
  );
end packet_handler;

architecture rtl of packet_handler is
  signal PACKET_TYPE     : unsigned(7 downto 0)          := (others => '0');
  signal RX_PACKET_LENGTH   : unsigned(15 downto 0)         := (others => '0');
  signal PING_PAYLOAD    : std_logic_vector(31 downto 0) := (others => '0');
  signal RAM_OFFSET      : std_logic_vector(31 downto 0) := (others => '0');
  signal payload_counter : unsigned(15 downto 0)          := (others => '0');
  signal reply_payload_counter : unsigned(7 downto 0)    := (others => '0');
  signal reply_done      : std_logic;
  signal REPLY_HEADER    : std_logic_vector(31 downto 0) := (others => '0');
  signal BRAM_OFFSET_OKAY: boolean;

  signal rx_state : T_RX_STATE := RX_STATE_IDLE;

  type T_REPLY_STATE is (
      REPLY_STATE_IDLE,
      REPLY_STATE_SEND_PONG_PAYLOAD,
      REPLY_STATE_SEND_BRAM_OFFSET,
      REPLY_STATE_SEND_BRAM_OKAY,
      REPLY_STATE_SEND_BRAM_DATA,
      REPLY_STATE_SEND_BRAM_DATA_WAIT_READ_VALID,
      REPLY_STATE_WAIT_DONE,
      REPLY_STATE_WAIT_IDLE
    );
  signal reply_state : T_REPLY_STATE := REPLY_STATE_IDLE;

  type T_AXI_REPLY_STATE is (
    AXI_REPLY_STATE_IDLE,
    AXI_REPLY_STATE_WAIT_READY
  );
  signal axi_reply_state: T_AXI_REPLY_STATE := AXI_REPLY_STATE_IDLE;
  signal axi_reply_data: std_logic_vector(31 downto 0) := (others => '0');
  signal axi_reply_data_valid: boolean := false;
  signal axi_reply_data_done: boolean := false;

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
      when others =>
        v_header_typ := x"00";
        v_packet_len := x"0004";
    end case;

    v_header_typ_slv := std_logic_vector(v_header_typ);
    REPLY_HEADER  <= (x"00" & v_header_typ_slv) & v_packet_len;
  end process set_reply_header;

  set_bram_okay: process(RAM_OFFSET) is
  begin
    BRAM_OFFSET_OKAY <= RAM_OFFSET < c_MAX_RAM_OFFSET;
  end process set_bram_okay;

  process(clk) is
    variable v_packet_type : unsigned(7 downto 0);
    variable v_ram_offset  : std_logic_vector(31 downto 0);
  begin
    if rising_edge(clk) then
      axi_str_rxd_tready_OUT <= '0';
      bram_addr_a_OUT        <= '0';
      bram_write_valid_a_OUT <= '0';

      case rx_state is
        when RX_STATE_IDLE =>
          axi_str_rxd_tready_OUT <= '1';
          if axi_str_rxd_tvalid_IN = '1' then
            v_packet_type   := unsigned(axi_str_rxd_tdata_IN(23 downto 16));
            PACKET_TYPE     <= v_packet_type;
            RX_PACKET_LENGTH   <= "00" & unsigned(axi_str_rxd_tdata_IN(15 downto 2));
            payload_counter <= x"0000";
            with v_packet_type select rx_state <=
              RX_STATE_PING       when C_DESTINATION_top_TYPE_ping,
              RX_STATE_RAM_OFFSET when C_DESTINATION_top_TYPE_write_ram,
              RX_STATE_RAM_OFFSET when C_DESTINATION_top_TYPE_read_ram,
              RX_STATE_IDLE       when others;
          end if;
        when RX_STATE_PING =>
          axi_str_rxd_tready_OUT <= '1';
          if axi_str_rxd_tvalid_IN = '1' then
            payload_counter <= payload_counter + 1;
            PING_PAYLOAD    <= axi_str_rxd_tdata_IN;
            if(payload_counter = RX_PACKET_LENGTH - 1) then
              rx_state <= RX_STATE_SEND_REPLY;
            else
              rx_state <= RX_STATE_PING;
            end if;
          end if;
        when RX_STATE_RAM_OFFSET =>
          axi_str_rxd_tready_OUT <= '1';
          if axi_str_rxd_tvalid_IN = '1' then
            payload_counter       <= payload_counter + 1;
            v_ram_offset          := axi_str_rxd_tdata_IN;
            RAM_OFFSET            <= v_ram_offset;
            bram_write_data_a_OUT <= v_ram_offset;
            bram_addr_a_OUT       <= '1';

            with PACKET_TYPE select rx_state <=
              RX_STATE_WRITE_RAM when C_DESTINATION_top_TYPE_write_ram,
              RX_STATE_SEND_REPLY  when C_DESTINATION_top_TYPE_read_ram,
              RX_STATE_IDLE      when others;
          end if;
        when RX_STATE_WRITE_RAM =>
          -- forward data words to RAM writer
          if payload_counter = RX_PACKET_LENGTH then
            rx_state <= RX_STATE_SEND_REPLY;
          elsif axi_str_rxd_tvalid_IN = '1' then
            -- only perform the write if the payload is within bounds
            if payload_counter <= x"00" & c_BRAM_MAX_WRITE_LEN_WORDS then
              bram_write_data_a_OUT  <= axi_str_rxd_tdata_IN;
              bram_write_valid_a_OUT <= '1';
              rx_state               <= RX_STATE_WRITE_RAM_WAIT_READY;
            else
              rx_state               <= RX_STATE_WRITE_RAM;
            end if;
            payload_counter        <= payload_counter + 1;
          else
            rx_state <= RX_STATE_WRITE_RAM;
          end if;
        when RX_STATE_WRITE_RAM_WAIT_READY =>
          -- wait for RAM writer to assert READY
          axi_str_rxd_tready_OUT <= '0';
          if bram_write_ready_a_IN = '1' then
            axi_str_rxd_tready_OUT <= '1';
            rx_state               <=
              --RX_STATE_SEND_REPLY when payload_counter = RX_PACKET_LENGTH
              --else 
              RX_STATE_WRITE_RAM;
          else
            rx_state <= RX_STATE_WRITE_RAM_WAIT_READY;
          end if;
        --when RX_STATE_READ_RAM =>
        --  rx_state <= RX_STATE_IDLE;
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
      end if;
    end if;
  end process;

  reply_ctrl : process(clk) is
    variable v_header_typ: unsigned(7 downto 0);
    variable v_header_typ_slv: std_logic_vector(7 downto 0);
    variable v_packet_len: std_logic_vector(15 downto 0);
  begin
    if rising_edge(clk) then
      reply_done             <= '0';
      bram_read_req_a_OUT    <= '0';
      bram_read_ready_a_OUT  <= '0';

      case reply_state is
        when REPLY_STATE_IDLE =>
          if rx_state = RX_STATE_SEND_REPLY then
            axi_reply_data  <= REPLY_HEADER;
            axi_reply_data_valid <= true;

            with PACKET_TYPE select reply_state <=
              REPLY_STATE_SEND_PONG_PAYLOAD when C_DESTINATION_top_TYPE_ping,
              REPLY_STATE_SEND_BRAM_OFFSET when C_DESTINATION_top_TYPE_write_ram,
              REPLY_STATE_SEND_BRAM_OFFSET when C_DESTINATION_top_TYPE_read_ram,
              REPLY_STATE_IDLE when others;
          end if;
        when REPLY_STATE_SEND_PONG_PAYLOAD =>
          if axi_reply_data_done then
            axi_reply_data_valid <= true;
            reply_state           <= REPLY_STATE_WAIT_DONE;
            axi_reply_data <= PING_PAYLOAD;
          end if;
        when REPLY_STATE_SEND_BRAM_OFFSET =>
          if axi_reply_data_done then
            axi_reply_data_valid <= true;
            reply_state           <= REPLY_STATE_SEND_BRAM_OKAY;
            axi_reply_data <= RAM_OFFSET;
          end if;
        when REPLY_STATE_SEND_BRAM_OKAY =>
          if axi_reply_data_done then
            axi_reply_data_valid <= true;
            axi_reply_data <=
              c_BRAM_OFFSET_OKAY when BRAM_OFFSET_OKAY
              else c_BRAM_OFFSET_NOT_OKAY;
            reply_payload_counter <= c_BRAM_READ_LEN_WORDS;

            with PACKET_TYPE select reply_state <=
              REPLY_STATE_SEND_BRAM_DATA when C_DESTINATION_top_TYPE_read_ram,
              REPLY_STATE_WAIT_DONE when others;
          end if;
        when REPLY_STATE_SEND_BRAM_DATA =>
          bram_read_req_a_OUT <= '1';
          bram_read_ready_a_OUT <= '1';
          if axi_reply_data_done then
            axi_reply_data_valid <= false;

            if reply_payload_counter = 0 then
              reply_done             <= '1';
              reply_state            <= REPLY_STATE_WAIT_DONE;
            else
              bram_read_req_a_OUT <= '1';
              bram_read_ready_a_OUT <= '1';
              reply_state <= REPLY_STATE_SEND_BRAM_DATA_WAIT_READ_VALID;
            end if;
          else
            reply_state <= REPLY_STATE_SEND_BRAM_DATA;
          end if;
        when REPLY_STATE_SEND_BRAM_DATA_WAIT_READ_VALID =>
          bram_read_req_a_OUT <= '1';
          bram_read_ready_a_OUT <= '1';
          if bram_read_valid_a_IN = '1' then
            axi_reply_data <= bram_read_data_a_IN;
            axi_reply_data_valid <= true;
            reply_payload_counter <= reply_payload_counter - 1;
            reply_state <= REPLY_STATE_SEND_BRAM_DATA;
          else
            reply_state <= REPLY_STATE_SEND_BRAM_DATA_WAIT_READ_VALID;
          end if;
        when REPLY_STATE_WAIT_DONE =>
          if axi_reply_data_done then
            axi_reply_data_valid <= false;
            reply_done             <= '1';
            reply_state            <= REPLY_STATE_WAIT_IDLE;
          end if;
        when REPLY_STATE_WAIT_IDLE =>
          if (rx_state = RX_STATE_IDLE) then
            reply_state <= REPLY_STATE_IDLE;
          end if;
      end case;

      if reset = '1' then
        reply_state            <= REPLY_STATE_IDLE;
        reply_done             <= '0';
      end if;
    end if;
  end process;

  axi_reply_process: process(clk) is
  begin
    if rising_edge(clk) then
      axi_reply_data_done <= false;

      case axi_reply_state is
        when AXI_REPLY_STATE_IDLE =>
          if axi_reply_data_valid then
            axi_str_txd_tdata_OUT <= axi_reply_data;
            axi_str_txd_tvalid_OUT <= '1';
            axi_reply_state <= AXI_REPLY_STATE_WAIT_READY;
            axi_reply_data_done <= true;
          end if;
        when AXI_REPLY_STATE_WAIT_READY =>
          if axi_str_txd_tready_IN = '1' then
            axi_str_txd_tvalid_OUT <= '0';
            axi_reply_state <= AXI_REPLY_STATE_IDLE;
          end if;
      end case;

      if reset = '1' then
        axi_reply_state <= AXI_REPLY_STATE_IDLE;
        axi_str_txd_tvalid_OUT <= '0';
        axi_str_txd_tdata_OUT  <= (others => '0');
      end if;
    end if;
  end process;
end rtl;
