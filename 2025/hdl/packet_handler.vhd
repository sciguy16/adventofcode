library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package packet_handler_pkg is

  subtype word is std_logic_vector(31 downto 0);

  -- Biggest packet is a 128-byte BRAM write. Consists of:
  -- * 4 byte offset
  -- * 128 bytes data
  -- Total = 132 bytes
  constant c_max_packet_length_bytes : unsigned(31 downto 0) := x"0000_0084";

  -- BRAM is 8192 32-bit words deep, and packet payload is fixed at 128 bytes.
  -- 128 bytes is 32 words, so upper bound is 8192 - 32 = 0x2000 - 0x20 = 0x1fe0
  constant c_max_ram_offset    : word := x"0000_1FE0";
  constant c_bram_off_okay     : word := x"0100_0000";
  constant c_bram_off_not_okay : word := x"0000_0000";
  -- 128 bytes = 32 words
  constant c_bram_read_len_words      : unsigned(7 downto 0) := x"20";
  constant c_bram_max_write_len_words : unsigned(7 downto 0) := x"20";

  constant c_bram_arlen : unsigned(7 downto 0) := c_BRAM_READ_LEN_WORDS - 1;

end package packet_handler_pkg;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.packet_types_pkg_hdr.all;
  use work.packet_handler_pkg.all;
  use work.day_mux_top_level_pkg_hdr.c_num_days;
  use work.blk_mem_wrapper_pkg_hdr.all;

-- TODO
-- * Make read/write length variable
-- * Day operation controls
-- * Day zero mode that's approximately a self-test

entity packet_handler is
  port (
    RESET : in    std_logic;
    CLK   : in    std_logic;

    -- Request packet data in
    AXI_STR_RXD_TVALID_IN  : in    std_logic;
    AXI_STR_RXD_TREADY_OUT : out   std_logic;
    AXI_STR_RXD_TDATA_IN   : in    word;

    -- Response packet data out
    AXI_STR_TXD_TVALID_OUT : out   std_logic;
    AXI_STR_TXD_TREADY_IN  : in    std_logic;
    AXI_STR_TXD_TDATA_OUT  : out   word;

    -- BRAM Port A controls --

    -- Write controls --
    -- Start address of write transaction, in bytes?
    M_AXI_WRITE_WORD_OFFSET_OUT : out   t_addr_a;
    -- Burst length of write transaction, in words/data beats
    M_AXI_AWLEN_OUT             : out   std_logic_vector(7 downto 0);
    M_AXI_AWVALID_OUT           : out   std_logic;
    M_AXI_AWREADY_IN            : in    std_logic;

    -- Write data --
    M_AXI_WDATA_OUT  : out   word;
    M_AXI_WLAST_OUT  : out   std_logic;
    M_AXI_WVALID_OUT : out   std_logic;
    M_AXI_WREADY_IN  : in    std_logic;

    -- Write response --
    M_AXI_BRESP_IN   : in    std_logic_vector(1 downto 0);
    M_AXI_BVALID_IN  : in    std_logic;
    M_AXI_BREADY_OUT : out   std_logic;

    -- Read controls --
    M_AXI_READ_WORD_OFFSET_OUT : out   t_addr_a;
    M_AXI_ARLEN_OUT            : out   std_logic_vector(7 downto 0);
    M_AXI_ARVALID_OUT          : out   std_logic;
    M_AXI_ARREADY_IN           : in    std_logic;

    -- Read data --
    M_AXI_RDATA_IN   : in    word;
    M_AXI_RRESP_IN   : in    std_logic_vector(1 downto 0);
    M_AXI_RLAST_IN   : in    std_logic;
    M_AXI_RVALID_IN  : in    std_logic;
    M_AXI_RREADY_OUT : out   std_logic;

    -- Day mux controls
    DAY_SEL_OUT        : out   unsigned(7 downto 0);
    DATA_LEN_BYTES_OUT : out   unsigned(BRAM_PORT_B_ADDR_WIDTH - 1 downto 0);
    DAY_START_OUT      : out   std_logic;
    DAY_DONE_IN        : in    std_logic;
    PART_A_IN          : in    std_logic_vector(31 downto 0);
    PART_B_IN          : in    std_logic_vector(31 downto 0)
  );
end entity packet_handler;

architecture RTL of PACKET_HANDLER is
  signal packet_type         : unsigned(7 downto 0)  := (others => '0');
  signal rx_packet_len_bytes : unsigned(15 downto 0) := (others => '0');
  signal rx_packet_len_words : unsigned(15 downto 0) := (others => '0');
  signal rx_packet_len_okay  : boolean;
  signal ping_payload        : word                  := (others => '0');
  signal ram_offset          : word                  := (others => '0');
  signal payload_counter     : unsigned(15 downto 0) := (others => '0');
  signal reply_done          : std_logic;
  signal reply_header        : word                  := (others => '0');
  signal bram_offset_okay    : boolean;

  signal day_sel        : unsigned(7 downto 0)  := (others => '0');
  signal data_len_bytes : unsigned(15 downto 0) := (others => '0');
  signal run_day_ok     : boolean;

  type t_rx_state is (
    RX_STATE_IDLE,
    RX_STATE_PAYLOAD_1,
    RX_STATE_RAM_OFFSET,
    RX_STATE_WRITE_REQ_WAIT_AWREADY,
    RX_STATE_WRITE_RAM,
    RX_STATE_WRITE_RAM_LAST_WORD,
    RX_STATE_SEND_REPLY
  );

  signal rx_state : t_rx_state := RX_STATE_IDLE;

  type t_reply_state is (
    REPLY_ST_IDLE,
    REPLY_ST_SEND_PONG_PAYLOAD,
    REPLY_ST_SEND_BRAM_OFFSET,
    REPLY_ST_SEND_BRAM_OKAY,
    REPLY_ST_SETUP_BRAM_READ,
    REPLY_ST_SEND_BRAM_DATA,
    REPLY_ST_RUN_DAY_STATUS,
    REPLY_ST_RUN_DAY_PART1,
    REPLY_ST_RUN_DAY_PART2,
    REPLY_ST_WAIT_DONE,
    REPLY_ST_WAIT_IDLE
  );

  signal reply_state : t_reply_state := REPLY_ST_IDLE;



  function bool_to_std_logic (
    input: boolean
  ) return std_logic is
    variable ret : std_logic;

  begin
    if (input) then
      ret := '1';
    else
      ret := '0';
    end if;
    return ret;
  end function bool_to_std_logic;

begin

  SET_REPLY_HEADER : process (packet_type) is
    variable v_header_typ     : unsigned(7 downto 0);
    variable v_header_typ_slv : std_logic_vector(7 downto 0);
    variable v_packet_len     : std_logic_vector(15 downto 0);
  begin
    case packet_type is

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
        v_packet_len := x"000C";

      when others =>
        report "Unexpected packet type" & to_hex_string(packet_type)
          severity error;
        v_header_typ := x"00";
        v_packet_len := x"0004";
    end case;

    v_header_typ_slv := std_logic_vector(v_header_typ);
    reply_header     <= (x"00" & v_header_typ_slv) & v_packet_len;
  end process SET_REPLY_HEADER;

  SET_BRAM_OKAY : process (all) is
  begin
    bram_offset_okay <= ram_offset < c_MAX_RAM_OFFSET;
  end process SET_BRAM_OKAY;

  -- Packet length must be no greater than the max packet length and it
  -- must (for now) be a multiple of four bytes
  SET_RX_PACKET_LENGTH_OKAY : process (all) is
    variable length_ok           : boolean;
    variable is_multiple_of_four : boolean;
  begin
    length_ok           := rx_packet_len_bytes <= c_MAX_PACKET_LENGTH_BYTES;
    is_multiple_of_four := rx_packet_len_bytes(1 downto 0) = "00";
    rx_packet_len_okay  <= length_ok and is_multiple_of_four;
  end process SET_RX_PACKET_LENGTH_OKAY;

  SET_RUN_DAY_OK : process (all) is
  begin
    run_day_ok <= packet_type = C_DESTINATION_top_TYPE_run_day
                  and day_sel < c_NUM_DAYS
                  and data_len_bytes(15) = '0';
    if (run_day_ok) then
      DATA_LEN_BYTES_OUT <= data_len_bytes(14 downto 0);
      DAY_SEL_OUT        <= day_sel;
    else
      DATA_LEN_BYTES_OUT <= (others => '0');
      DAY_SEL_OUT        <= x"00";
    end if;
  end process SET_RUN_DAY_OK;

  RX_PROC : process (CLK) is
    variable v_packet_type   : unsigned(7 downto 0);
    variable v_ram_offset    : word;
    variable v_pkt_len_bytes : unsigned(15 downto 0);
    variable v_current_word  : word;
    variable v_awlen_tmp     : unsigned(7 downto 0);
  begin
    if rising_edge(CLK) then
      -- defaults
      AXI_STR_RXD_TREADY_OUT <= '0';
      M_AXI_WDATA_OUT        <= (others => '0');
      M_AXI_WVALID_OUT       <= '0';
      M_AXI_WLAST_OUT        <= '0';
      -- leave bready asserted until such time as we check the response.
      -- Without it asserted there's a FIFO in the AXI IP that gets full
      -- and blocks further transfers
      M_AXI_BREADY_OUT <= '1';
      DAY_START_OUT    <= '0';

      case rx_state is

        when RX_STATE_IDLE =>
          AXI_STR_RXD_TREADY_OUT <= '1';
          if (AXI_STR_RXD_TVALID_IN = '1') then
            v_packet_type       := unsigned(AXI_STR_RXD_TDATA_IN(23 downto 16));
            packet_type         <= v_packet_type;
            v_pkt_len_bytes     := unsigned(AXI_STR_RXD_TDATA_IN(15 downto 0));
            rx_packet_len_bytes <= v_pkt_len_bytes;
            rx_packet_len_words <= "00" & v_pkt_len_bytes(15 downto 2);
            payload_counter     <= x"0000";
            with v_packet_type select rx_state <=
              RX_STATE_PAYLOAD_1 when C_DESTINATION_top_TYPE_ping,
              RX_STATE_RAM_OFFSET when C_DESTINATION_top_TYPE_write_ram,
              RX_STATE_RAM_OFFSET when C_DESTINATION_top_TYPE_read_ram,
              RX_STATE_PAYLOAD_1 when C_DESTINATION_top_TYPE_run_day,
              RX_STATE_IDLE when others;
          end if;

        when RX_STATE_PAYLOAD_1 =>
          AXI_STR_RXD_TREADY_OUT <= '1';
          if (AXI_STR_RXD_TVALID_IN = '1') then
            v_current_word := AXI_STR_RXD_TDATA_IN;

            case packet_type is

              when C_DESTINATION_top_TYPE_ping =>
                ping_payload <= v_current_word;

              when C_DESTINATION_top_TYPE_run_day =>
                day_sel        <= unsigned(v_current_word(31 downto 24));
                data_len_bytes <= unsigned(v_current_word(23 downto 8));

              when others =>
            -- nothing (latch)
            end case;

            payload_counter <= payload_counter + 1;
            if (payload_counter = rx_packet_len_words - 1) then
              rx_state <= RX_STATE_SEND_REPLY;

              if (run_day_ok) then
                DAY_START_OUT <= '1';
              end if;
            else
              rx_state <= RX_STATE_PAYLOAD_1;
            end if;
          end if;

        when RX_STATE_RAM_OFFSET =>
          AXI_STR_RXD_TREADY_OUT <= '1';
          if (AXI_STR_RXD_TVALID_IN = '1') then
            -- Record the RAM offset into a register
            payload_counter <= payload_counter + 1;
            v_ram_offset    := AXI_STR_RXD_TDATA_IN;
            ram_offset      <= v_ram_offset;

            -- If it's a write transaction then set up the BRAM AXI write
            -- interface (but only if the write request is valid)
            if (packet_type = C_DESTINATION_top_TYPE_write_ram
                and rx_packet_len_okay) then
              M_AXI_WRITE_WORD_OFFSET_OUT <= v_ram_offset(t_addr_a'range);
              -- TODO validate that the word count fits into 8 bits
              -- RX_PACKET_LEN_WORDS is the number of words in the packet
              -- first word is offset
              -- AWLEN is 1 less than the burst length (AWLEN=0 => burst 1)
              -- so subtract 2 from RX_PACKET_LEN_WORDS
              v_awlen_tmp       := rx_packet_len_words(7 downto 0) - 2;
              M_AXI_AWLEN_OUT   <= std_logic_vector(v_awlen_tmp);
              M_AXI_AWVALID_OUT <= '1';

              -- If the BRAM AXI interface immediately accepts the write
              -- request then go straight to the data phase, otherwise
              -- go to the state which waits for AWREADY to be asserted
              if (M_AXI_AWREADY_IN = '1') then
                rx_state <= RX_STATE_WRITE_RAM;
              else
                rx_state <= RX_STATE_WRITE_REQ_WAIT_AWREADY;
              end if;
            else
              with packet_type select rx_state <=
                RX_STATE_WRITE_RAM when C_DESTINATION_top_TYPE_write_ram,
                RX_STATE_SEND_REPLY when C_DESTINATION_top_TYPE_read_ram,
                RX_STATE_IDLE when others;
            end if;
          end if;

        when RX_STATE_WRITE_REQ_WAIT_AWREADY =>
          if (M_AXI_AWREADY_IN = '1') then
            rx_state          <= RX_STATE_WRITE_RAM;
            M_AXI_AWVALID_OUT <= '0';
          else
            rx_state <= RX_STATE_WRITE_REQ_WAIT_AWREADY;
          end if;

        when RX_STATE_WRITE_RAM =>
          M_AXI_AWVALID_OUT <= '0';
          -- forward data words to BRAM axi interface
          rx_state <= RX_STATE_WRITE_RAM; -- default stay in this state

          -- only forward data from valid incoming packets, otherwise
          -- clock the words through but ignore them
          if (rx_packet_len_okay) then
            -- TODO it's possible this wants a skid buffer
            M_AXI_WDATA_OUT        <= AXI_STR_RXD_TDATA_IN;
            M_AXI_WVALID_OUT       <= AXI_STR_RXD_TVALID_IN;
            AXI_STR_RXD_TREADY_OUT <= M_AXI_WREADY_IN;
          else
            AXI_STR_RXD_TREADY_OUT <= '1';
          end if;
          if (AXI_STR_RXD_TVALID_IN = '1') then
            if (payload_counter = rx_packet_len_words - 1) then
              M_AXI_WLAST_OUT <= '1';
            end if;
            payload_counter <= payload_counter + 1;
          end if;
          if (payload_counter = rx_packet_len_words) then
            rx_state         <= RX_STATE_SEND_REPLY;
            M_AXI_WVALID_OUT <= '0';
          end if;

        when RX_STATE_WRITE_RAM_LAST_WORD =>
          M_AXI_WLAST_OUT <= '1';
          if (AXI_STR_RXD_TVALID_IN = '1') then
            rx_state        <= RX_STATE_SEND_REPLY;
            M_AXI_WLAST_OUT <= '0';
          end if;
        -- TODO check BRESP

        when RX_STATE_SEND_REPLY =>
          if (reply_done = '1') then
            rx_state <= RX_STATE_IDLE;
          else
            rx_state <= RX_STATE_SEND_REPLY;
          end if;
      end case;

      if (RESET = '1') then
        rx_state                    <= RX_STATE_IDLE;
        packet_type                 <= (others => '0');
        AXI_STR_RXD_TREADY_OUT      <= '0';
        M_AXI_AWVALID_OUT           <= '0';
        M_AXI_BREADY_OUT            <= '0';
        M_AXI_WRITE_WORD_OFFSET_OUT <= (others => '0');
        M_AXI_AWLEN_OUT             <= x"00";
      end if;
    end if;
  end process RX_PROC;

  REPLY_CTRL : process (CLK) is
    variable v_header_typ     : unsigned(7 downto 0);
    variable v_header_typ_slv : std_logic_vector(7 downto 0);
    variable v_packet_len     : std_logic_vector(15 downto 0);
  begin
    if rising_edge(CLK) then
      -- defaults
      reply_done             <= '0';
      AXI_STR_TXD_TVALID_OUT <= '0';
      M_AXI_RREADY_OUT       <= '0';
      M_AXI_ARVALID_OUT      <= '0';

      case reply_state is

        when REPLY_ST_IDLE =>
          if (rx_state = RX_STATE_SEND_REPLY) then
            AXI_STR_TXD_TDATA_OUT  <= reply_header;
            AXI_STR_TXD_TVALID_OUT <= '1';

            with packet_type select reply_state <=
              REPLY_ST_SEND_PONG_PAYLOAD when C_DESTINATION_top_TYPE_ping,
              REPLY_ST_SEND_BRAM_OFFSET when C_DESTINATION_top_TYPE_write_ram,
              REPLY_ST_SEND_BRAM_OFFSET when C_DESTINATION_top_TYPE_read_ram,
              REPLY_ST_RUN_DAY_STATUS when C_DESTINATION_top_TYPE_run_day,
              REPLY_ST_IDLE when others;
          end if;

        when REPLY_ST_SEND_PONG_PAYLOAD =>
          if (AXI_STR_TXD_TREADY_IN) then
            AXI_STR_TXD_TVALID_OUT <= '1';
            reply_state            <= REPLY_ST_WAIT_DONE;
            AXI_STR_TXD_TDATA_OUT  <= ping_payload;
          end if;

        when REPLY_ST_SEND_BRAM_OFFSET =>
          AXI_STR_TXD_TVALID_OUT <= '1';
          if (AXI_STR_TXD_TREADY_IN) then
            reply_state           <= REPLY_ST_SEND_BRAM_OKAY;
            AXI_STR_TXD_TDATA_OUT <= ram_offset;
          end if;

        when REPLY_ST_SEND_BRAM_OKAY =>
          AXI_STR_TXD_TVALID_OUT <= '1';
          if (AXI_STR_TXD_TREADY_IN) then
            AXI_STR_TXD_TVALID_OUT <= '1';
            AXI_STR_TXD_TDATA_OUT  <= c_BRAM_OFF_OKAY when bram_offset_okay else
                                      c_BRAM_OFF_NOT_OKAY;

            with packet_type select reply_state <=
              REPLY_ST_SETUP_BRAM_READ when C_DESTINATION_top_TYPE_read_ram,
              REPLY_ST_WAIT_DONE when others;
          end if;

        when REPLY_ST_SETUP_BRAM_READ =>
          reply_state <= REPLY_ST_SETUP_BRAM_READ;
          -- set up the read request
          -- TODO validate that the ram offset fits into 12 bits
          M_AXI_READ_WORD_OFFSET_OUT <= ram_offset(t_addr_a'range);
          -- ARLEN is one less than burst length (ARLEN=0 => burst 1)
          M_AXI_ARLEN_OUT   <= std_logic_vector(c_bram_arlen);
          M_AXI_ARVALID_OUT <= '1';
          if (M_AXI_ARREADY_IN = '1') then
            reply_state <= REPLY_ST_SEND_BRAM_DATA;
          end if;

        when REPLY_ST_SEND_BRAM_DATA =>
          reply_state <= REPLY_ST_SEND_BRAM_DATA; -- default

          AXI_STR_TXD_TDATA_OUT  <= M_AXI_RDATA_IN;
          AXI_STR_TXD_TVALID_OUT <= M_AXI_RVALID_IN;
          M_AXI_RREADY_OUT       <= AXI_STR_TXD_TREADY_IN;
          if (M_AXI_RLAST_IN = '1') then
            reply_state <= REPLY_ST_WAIT_DONE;
          end if;

        when REPLY_ST_RUN_DAY_STATUS =>
          -- if request is bad then send ACK immediately, otherwise
          -- wait for the day mux to report DONE
          if (not run_day_ok or DAY_DONE_IN = '1') then
            AXI_STR_TXD_TDATA_OUT  <= std_logic_vector(day_sel)
                                      & "0000000"
                                      & bool_to_std_logic(run_day_ok)
                                      & x"0000";
            AXI_STR_TXD_TVALID_OUT <= '1';
            reply_state            <= REPLY_ST_RUN_DAY_PART1;
          else
            reply_state <= REPLY_ST_RUN_DAY_STATUS;
          end if;

        when REPLY_ST_RUN_DAY_PART1 =>
          AXI_STR_TXD_TVALID_OUT <= '1';
          if (AXI_STR_TXD_TREADY_IN) then
            reply_state           <= REPLY_ST_RUN_DAY_PART2;
            AXI_STR_TXD_TDATA_OUT <= PART_A_IN;
          end if;

        when REPLY_ST_RUN_DAY_PART2 =>
          AXI_STR_TXD_TVALID_OUT <= '1';
          if (AXI_STR_TXD_TREADY_IN) then
            reply_state           <= REPLY_ST_WAIT_DONE;
            AXI_STR_TXD_TDATA_OUT <= PART_B_IN;
          end if;

        when REPLY_ST_WAIT_DONE =>
          if (AXI_STR_TXD_TREADY_IN) then
            AXI_STR_TXD_TVALID_OUT <= '0';
            reply_done             <= '1';
            reply_state            <= REPLY_ST_WAIT_IDLE;
          end if;

        when REPLY_ST_WAIT_IDLE =>
          if (rx_state = RX_STATE_IDLE) then
            reply_state <= REPLY_ST_IDLE;
          end if;
      end case;

      if (RESET = '1') then
        reply_state                <= REPLY_ST_IDLE;
        reply_done                 <= '0';
        M_AXI_ARVALID_OUT          <= '0';
        M_AXI_ARLEN_OUT            <= std_logic_vector(c_BRAM_ARLEN);
        M_AXI_READ_WORD_OFFSET_OUT <= (others => '0');
        AXI_STR_TXD_TDATA_OUT      <= (others => '0');
      end if;
    end if;
  end process REPLY_CTRL;

end architecture RTL;
