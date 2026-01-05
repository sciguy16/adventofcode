library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.packet_types_pkg_hdr.all;
  use work.packet_handler_pkg.all;
  use work.blk_mem_wrapper_pkg_hdr.all;

entity packet_handler_tb_bram is
end entity packet_handler_tb_bram;

architecture RTL of PACKET_HANDLER_TB_BRAM is
  -- 25 MHz clock, 40 ns period
  constant c_half_period_25_mhz : time := 20 ns;
  constant c_timeout            : time := 8 * c_half_period_25_mhz;

  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';

  signal axi_str_rxd_tvalid : std_logic                     := '0';
  signal axi_str_rxd_tready : std_logic;
  signal axi_str_rxd_tdata  : std_logic_vector(31 downto 0) := x"00000000";

  signal axi_str_txd_tvalid : std_logic;
  signal axi_str_txd_tready : std_logic := '0';
  signal axi_str_txd_tdata  : std_logic_vector(31 downto 0);

  -- Write controls --
  signal bram_write_word_off_a : t_addr_a;
  signal bram_awlen_a          : std_logic_vector(7 downto 0);
  signal bram_awvalid_a        : std_logic;
  signal bram_awready_a        : std_logic;

  -- Write data --
  signal bram_wdata_a  : std_logic_vector(31 downto 0);
  signal bram_wlast_a  : std_logic;
  signal bram_wvalid_a : std_logic;
  signal bram_wready_a : std_logic;

  -- Write response --
  signal bram_bresp_a  : std_logic_vector(1 downto 0);
  signal bram_bvalid_a : std_logic;
  signal bram_bready_a : std_logic;

  -- Read controls --
  signal bram_read_word_offset_a : t_addr_a;
  signal bram_arlen_a            : std_logic_vector(7 downto 0);
  signal bram_arvalid_a          : std_logic;
  signal bram_arready_a          : std_logic;

  -- Read data --
  signal bram_rdata_a  : std_logic_vector(31 downto 0);
  signal bram_rresp_a  : std_logic_vector(1 downto 0);
  signal bram_rlast_a  : std_logic;
  signal bram_rvalid_a : std_logic;
  signal bram_rready_a : std_logic;

  signal verbose : boolean := false;

  procedure wait_edge is
  begin
    wait until rising_edge(clk);
    wait for 2 ns;
  end procedure wait_edge;

  procedure wait_eq (
    signal value : in std_logic;
    expected     : in std_logic;
    message      : in string
  ) is
    variable clock_count : integer := 0;

  begin
    if (verbose) then
      report "wait for: " & message
        severity note;
    end if;
    wait_edge;

    while value /= expected loop
      wait_edge;
      clock_count := clock_count + 1;
      if (clock_count = 10) then
        report "condition not met after timeout: " & message
          severity failure;
        exit;
      end if;
    end loop;
  end procedure wait_eq;

begin

  PACKET_HANDLER_INST : entity work.packet_handler(rtl)
    port map (
      RESET => reset,
      CLK   => clk,

      AXI_STR_RXD_TVALID_IN  => axi_str_rxd_tvalid,
      AXI_STR_RXD_TREADY_OUT => axi_str_rxd_tready,
      AXI_STR_RXD_TDATA_IN   => axi_str_rxd_tdata,

      AXI_STR_TXD_TVALID_OUT => axi_str_txd_tvalid,
      AXI_STR_TXD_TREADY_IN  => axi_str_txd_tready,
      AXI_STR_TXD_TDATA_OUT  => axi_str_txd_tdata,

      -- BRAM Port A controls --

      -- Write controls --
      M_AXI_WRITE_WORD_OFFSET_OUT => bram_write_word_off_a,
      M_AXI_AWLEN_OUT             => bram_awlen_a,
      M_AXI_AWVALID_OUT           => bram_awvalid_a,
      M_AXI_AWREADY_IN            => bram_awready_a,

      -- Write data --
      M_AXI_WDATA_OUT  => bram_wdata_a,
      M_AXI_WLAST_OUT  => bram_wlast_a,
      M_AXI_WVALID_OUT => bram_wvalid_a,
      M_AXI_WREADY_IN  => bram_wready_a,

      -- Write response --
      M_AXI_BRESP_IN   => bram_bresp_a,
      M_AXI_BVALID_IN  => bram_bvalid_a,
      M_AXI_BREADY_OUT => bram_bready_a,

      -- Read controls --
      M_AXI_READ_WORD_OFFSET_OUT => bram_read_word_offset_a,
      M_AXI_ARLEN_OUT            => bram_arlen_a,
      M_AXI_ARVALID_OUT          => bram_arvalid_a,
      M_AXI_ARREADY_IN           => bram_arready_a,

      -- Read data --
      M_AXI_RDATA_IN   => bram_rdata_a,
      M_AXI_RRESP_IN   => bram_rresp_a,
      M_AXI_RLAST_IN   => bram_rlast_a,
      M_AXI_RVALID_IN  => bram_rvalid_a,
      M_AXI_RREADY_OUT => bram_rready_a,

      -- Day mux controls
      DAY_SEL_OUT        => open,
      DATA_LEN_BYTES_OUT => open,
      DAY_DONE_IN        => '0'
    );

  clk <= not clk after c_half_period_25_mhz;

  STIMULUS : process is
    alias    reply_done_internal is
      << signal packet_handler_inst.reply_done : std_logic >>;
    variable counter_byte        : std_logic_vector(7 downto 0);
    variable counter_tdata       : std_logic_vector(31 downto 0);
  begin
    reset <= '1';
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    reset <= '0';
    wait until rising_edge(clk);

    report "SEND WRITE REQ";

    -- packet header
    wait_edge;
    axi_str_rxd_tdata  <= x"00020084"; -- WRITE RAM, LENGTH 128 + 4 = 0x84
    axi_str_rxd_tvalid <= '1';
    -- wait for UUT to clock in the data on a rising edge
    wait_eq(axi_str_rxd_tready, '1', "packet header");
    -- wait_edge;
    axi_str_rxd_tvalid <= '0';

    wait_edge;
    wait_edge;
    wait_edge;

    -- BRAM offset
    axi_str_rxd_tdata  <= x"00000000";
    axi_str_rxd_tvalid <= '1';
    -- wait for UUT to clock in the data on a rising edge
    wait_eq(axi_str_rxd_tready, '1', "BRAM offset");
    axi_str_rxd_tvalid <= '0';

    wait_edge;
    wait_edge;
    wait_edge;

    -- data to write - 32 words
    for word in 0 to 31 loop
      -- report "word = " & integer'image(word);
      counter_byte  := std_logic_vector(
                         to_unsigned(word, counter_byte'length));
      counter_tdata := counter_byte
                       & counter_byte
                       & counter_byte
                       & counter_byte;

      axi_str_rxd_tdata <= counter_tdata;

      axi_str_rxd_tvalid <= '1';
      -- wait for UUT to clock in the data on a rising edge
      wait_eq(
              axi_str_rxd_tready,
              '1',
              "txd tready for word " & integer'image(word)
            );
      assert axi_str_rxd_tready = '1'
        report "tready not asserted for word " & integer'image(word);

      axi_str_rxd_tvalid <= '0';
      wait_edge;
      wait_edge;
      wait_edge;
    end loop;
    axi_str_rxd_tvalid <= '0';

    report "WAIT FOR WRITE ACK";

    -- wait for TVALID on ack

    -- ACK header
    wait_eq(axi_str_txd_tvalid, '1', "txd valid for ack");
    assert axi_str_txd_tvalid = '1'
      report "WRITE ACK header valid";
    assert axi_str_txd_tdata = x"00030008"
      report "WRITE ACK header data";
    axi_str_txd_tready <= '1';

    -- ACK payload = BRAM OFFSET
    wait_edge;
    assert axi_str_txd_tvalid = '1'
      report "WRITE ACK offset valid";
    assert axi_str_txd_tdata = x"00000000"
      report "WRITE ACK offset data";

    -- ACK payload = BRAM WRITE OKAY
    wait_edge;
    assert axi_str_txd_tvalid = '1'
      report "WRITE ACK okay valid";
    assert axi_str_txd_tdata = x"01000000"
      report "WRITE ACK okay data";

    wait_edge;
    axi_str_txd_tready <= '0';

    wait_edge;
    wait_edge;
    wait_edge;

    report "SEND READ REQ";

    -- issue a read to verify the written data
    -- packet header
    wait_edge;
    axi_str_rxd_tdata  <= x"00040004"; -- WRITE RAM, LENGTH 128 + 4 = 0x84
    axi_str_rxd_tvalid <= '1';
    -- wait for UUT to clock in the data on a rising edge
    wait_eq(axi_str_rxd_tready, '1', "rxd tready");
    axi_str_rxd_tvalid <= '0';

    -- BRAM offset
    axi_str_rxd_tdata  <= x"00000000";
    axi_str_rxd_tvalid <= '1';
    -- wait for UUT to clock in the data on a rising edge
    wait_eq(axi_str_rxd_tready, '1', "rxd tready");
    axi_str_rxd_tvalid <= '0';

    report "WAIT FOR READ ACK";
    verbose <= true;

    -- wait for TVALID on ack

    -- ACK header
    wait_eq(axi_str_txd_tvalid, '1', "txd tvalid");
    -- wait_edge;
    assert axi_str_txd_tvalid = '1'
      report "READ ACK header valid";
    assert axi_str_txd_tdata = x"00050088"
      report "READ ACK header data";
    axi_str_txd_tready <= '1';

    -- ACK payload = BRAM OFFSET
    wait_edge;
    assert axi_str_txd_tvalid = '1'
      report "READ ACK offset valid";
    assert axi_str_txd_tdata = x"00000000"
      report "READ ACK offset data";

    -- ACK payload = BRAM WRITE OKAY
    wait_edge;
    assert axi_str_txd_tvalid = '1'
      report "READ ACK okay valid";
    assert axi_str_txd_tdata = x"01000000"
      report "READ ACK okay data";

    -- data read back - 32 words
    for word in 0 to 31 loop
      -- wait for UUT to clock out the data on a rising edge
      wait_eq(
              axi_str_txd_tvalid,
              '1',
              "txd tvalid for word " & integer'image(word)
            );

      counter_byte  := std_logic_vector(to_unsigned(word, counter_byte'length));
      counter_tdata := counter_byte
                       & counter_byte
                       & counter_byte
                       & counter_byte;
      assert axi_str_txd_tvalid = '1'
        report "READ ACK data valid word" & integer'image(word);
      assert axi_str_txd_tdata = counter_tdata
        report "READ ACK data word" & integer'image(word);
    -- wait until rising_edge(clk);
    end loop;
    wait_edge;
    axi_str_txd_tready <= '0';

    wait_edge;
    wait_edge;
    wait_edge;
    wait_edge;
    std.env.stop;
  end process STIMULUS;

  BLK_MEM_WRAPPER_INST : entity work.blk_mem_wrapper(rtl)
    port map (
      RESET => reset,
      CLK   => clk,

      -- Port A controls --

      -- Write controls --
      S_AXI_WRITE_WORD_OFFSET_PORT_A_IN => bram_write_word_off_a,
      S_AXI_AWLEN_PORT_A_IN             => bram_awlen_a,
      S_AXI_AWVALID_PORT_A_IN           => bram_awvalid_a,
      S_AXI_AWREADY_PORT_A_OUT          => bram_awready_a,

      -- Write data --
      S_AXI_WDATA_PORT_A_IN   => bram_wdata_a,
      S_AXI_WLAST_PORT_A_IN   => bram_wlast_a,
      S_AXI_WVALID_PORT_A_IN  => bram_wvalid_a,
      S_AXI_WREADY_PORT_A_OUT => bram_wready_a,

      -- Write response --
      S_AXI_BRESP_PORT_A_OUT  => bram_bresp_a,
      S_AXI_BVALID_PORT_A_OUT => bram_bvalid_a,
      S_AXI_BREADY_PORT_A_IN  => bram_bready_a,

      -- Read controls --
      S_AXI_READ_WORD_OFFSET_PORT_A_IN => bram_read_word_offset_a,
      S_AXI_ARLEN_PORT_A_IN            => bram_arlen_a,
      S_AXI_ARVALID_PORT_A_IN          => bram_arvalid_a,
      S_AXI_ARREADY_PORT_A_OUT         => bram_arready_a,

      -- Read data --
      S_AXI_RDATA_PORT_A_OUT  => bram_rdata_a,
      S_AXI_RRESP_PORT_A_OUT  => bram_rresp_a,
      S_AXI_RLAST_PORT_A_OUT  => bram_rlast_a,
      S_AXI_RVALID_PORT_A_OUT => bram_rvalid_a,
      S_AXI_RREADY_PORT_A_IN  => bram_rready_a,

      -- Port B controls --
      BRAM_ADDR_B_IN              => (others => '0'),
      BRAM_DATA_B_IN              => x"00",
      BRAM_DATA_B_OUT             => open,
      BRAM_PORT_B_WRITE_ENABLE_IN => '0',
      BRAM_PORT_B_ENABLED_OUT     => open
    );

end architecture RTL;
