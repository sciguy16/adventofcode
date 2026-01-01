library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.packet_types_pkg_hdr.all;
  use work.packet_handler_pkg.all;

entity PACKET_HANDLER_TB_DAY_MUX is
end entity PACKET_HANDLER_TB_DAY_MUX;

architecture RTL of PACKET_HANDLER_TB_DAY_MUX is

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
  signal bram_write_word_off_a : std_logic_vector(9 downto 0);
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
  signal bram_read_word_off_a : std_logic_vector(9 downto 0);
  signal bram_arlen_a         : std_logic_vector(7 downto 0);
  signal bram_arvalid_a       : std_logic;
  signal bram_arready_a       : std_logic;

  -- Read data --
  signal bram_rdata_a  : std_logic_vector(31 downto 0);
  signal bram_rresp_a  : std_logic_vector(1 downto 0);
  signal bram_rlast_a  : std_logic;
  signal bram_rvalid_a : std_logic;
  signal bram_rready_a : std_logic;

  -- Port B controls --
  signal bram_addr_b          : std_logic_vector(11 downto 0) := x"000";
  signal bram_write_data_b    : std_logic_vector(7 downto 0)  := x"00";
  signal bram_read_data_b     : std_logic_vector(7 downto 0);
  signal bram_port_b_write_en : std_logic                     := '0';
  signal bram_port_b_enabled  : std_logic;

  -- Day mux controls
  signal day_sel        : unsigned(7 downto 0);
  signal data_len_bytes : unsigned(11 downto 0);
  signal day_done       : std_logic;

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

    variable clock_count : integer;

  begin

    if (verbose) then
      report "wait for: " & message
        severity note;
    end if;

    wait_edge;

    clock_count := 0;

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
      M_AXI_READ_WORD_OFFSET_OUT => bram_read_word_off_a,
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
      DAY_SEL_OUT        => day_sel,
      DATA_LEN_BYTES_OUT => data_len_bytes,
      DAY_DONE_IN        => day_done
    );

  clk <= not clk after c_half_period_25_mhz;

  STIMULUS : process is
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
    -- RUN DAY, LENGTH 4
    axi_str_rxd_tdata  <= x"00060004";
    axi_str_rxd_tvalid <= '1';
    -- wait for UUT to clock in the data on a rising edge
    wait_eq(axi_str_rxd_tready, '1', "packet header");
    -- wait_edge;
    axi_str_rxd_tvalid <= '0';

    -- control
    -- day, data len, padding
    axi_str_rxd_tdata  <= x"00" & x"00" & x"0000";
    axi_str_rxd_tvalid <= '1';
    -- wait for UUT to clock in the data on a rising edge
    wait_eq(axi_str_rxd_tready, '1', "BRAM offset");
    axi_str_rxd_tvalid <= '0';

    report "WAIT FOR ACK";

    -- wait for TVALID on ack

    -- ACK header
    wait_eq(axi_str_txd_tvalid, '1', "txd valid for ack");
    assert axi_str_txd_tvalid = '1'
      report "ACK header valid";
    assert axi_str_txd_tdata = x"00070004"
      report "ACK header data";
    axi_str_txd_tready <= '1';

    -- ACK payload = status
    wait_edge;
    assert axi_str_txd_tvalid = '1'
      report "ACK data valid";
    -- day, ok, padding
    assert axi_str_txd_tdata = x"00" & x"01" & x"0000"
      report "ACK data data";

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
      S_AXI_READ_WORD_OFFSET_PORT_A_IN => bram_read_word_off_a,
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
      BRAM_ADDR_B_IN              => bram_addr_b,
      BRAM_DATA_B_IN              => bram_write_data_b,
      BRAM_DATA_B_OUT             => bram_read_data_b,
      BRAM_PORT_B_WRITE_ENABLE_IN => bram_port_b_write_en,
      BRAM_PORT_B_ENABLED_OUT     => bram_port_b_enabled
    );

  DAY_MUX_INST : entity work.day_mux_top_level(rtl)
    port map (
      RESET => reset,
      CLK   => clk,

      DAY_SEL_IN        => day_sel,
      DATA_LEN_BYTES_IN => data_len_bytes,
      DAY_DONE_OUT      => day_done,

      -- Port B controls --
      BRAM_ADDR_OUT              => bram_addr_b,
      BRAM_WRITE_DATA_OUT        => bram_write_data_b,
      BRAM_READ_DATA_IN          => bram_read_data_b,
      BRAM_WRITE_ENABLE_OUT => bram_port_b_write_en,
      BRAM_ENABLED_IN       => bram_port_b_enabled
    );

end architecture RTL;
