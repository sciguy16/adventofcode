library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.aoc_top_pkg_hdr.all;

entity BLK_MEM_WRAPPER_TB is
end entity BLK_MEM_WRAPPER_TB;

architecture RTL of BLK_MEM_WRAPPER_TB is
  constant c_half_period_25_mhz : time := 20 ns; -- 25 MHz clock, 40 ns period

  signal clk   : std_logic := '1';
  signal reset : std_logic := '1';

  -- Write controls --
  signal bram_axi_write_word_off_a   : std_logic_vector(9 downto 0) := 10x"000";
  signal bram_axi_awlen_port_a_in    : std_logic_vector(7 downto 0) := x"00";
  signal bram_axi_awvalid_port_a_in  : std_logic                    := '0';
  signal bram_axi_awready_port_a_out : std_logic;

  -- Write data --
  signal bram_axi_wdata_port_a_in   : std_logic_vector(31 downto 0);
  signal bram_axi_wlast_port_a_in   : std_logic := '0';
  signal bram_axi_wvalid_port_a_in  : std_logic := '0';
  signal bram_axi_wready_port_a_out : std_logic;

  -- Write response --
  signal bram_axi_bresp_port_a_out  : std_logic_vector(1 downto 0);
  signal bram_axi_bvalid_port_a_out : std_logic;
  signal bram_axi_bready_port_a_in  : std_logic := '0';

  -- Read controls --
  signal bram_axi_read_word_offset_a : std_logic_vector(9 downto 0) := 10x"000";
  signal bram_axi_arlen_port_a_in    : std_logic_vector(7 downto 0) := x"00";
  signal bram_axi_arvalid_port_a_in  : std_logic                    := '0';
  signal bram_axi_arready_port_a_out : std_logic;

  -- Read data --
  signal bram_axi_rdata_port_a_out  : std_logic_vector(31 downto 0);
  signal bram_axi_rresp_port_a_out  : std_logic_vector(1 downto 0);
  signal bram_axi_rlast_port_a_out  : std_logic;
  signal bram_axi_rvalid_port_a_out : std_logic;
  signal bram_axi_rready_port_a_in  : std_logic := '0';

  -- Port B controls --
  signal bram_addr_b_in              : std_logic_vector(11 downto 0);
  signal bram_data_b_in              : std_logic_vector(7 downto 0);
  signal bram_data_b_out             : std_logic_vector(7 downto 0);
  signal bram_port_b_write_enable_in : std_logic;
  signal bram_port_b_enabled_out     : std_logic;

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

  UUT : entity work.blk_mem_wrapper(rtl)
    port map (
      RESET => reset,
      CLK   => clk,

      -- Port A controls --

      -- Write controls --
      S_AXI_WRITE_WORD_OFFSET_PORT_A_IN => bram_axi_write_word_off_a,
      S_AXI_AWLEN_PORT_A_IN             => bram_axi_awlen_port_a_in,
      S_AXI_AWVALID_PORT_A_IN           => bram_axi_awvalid_port_a_in,
      S_AXI_AWREADY_PORT_A_OUT          => bram_axi_awready_port_a_out,

      -- Write data --
      S_AXI_WDATA_PORT_A_IN   => bram_axi_wdata_port_a_in,
      S_AXI_WLAST_PORT_A_IN   => bram_axi_wlast_port_a_in,
      S_AXI_WVALID_PORT_A_IN  => bram_axi_wvalid_port_a_in,
      S_AXI_WREADY_PORT_A_OUT => bram_axi_wready_port_a_out,

      -- Write response --
      S_AXI_BRESP_PORT_A_OUT  => bram_axi_bresp_port_a_out,
      S_AXI_BVALID_PORT_A_OUT => bram_axi_bvalid_port_a_out,
      S_AXI_BREADY_PORT_A_IN  => bram_axi_bready_port_a_in,

      -- Read controls --
      S_AXI_READ_WORD_OFFSET_PORT_A_IN => bram_axi_read_word_offset_a,
      S_AXI_ARLEN_PORT_A_IN            => bram_axi_arlen_port_a_in,
      S_AXI_ARVALID_PORT_A_IN          => bram_axi_arvalid_port_a_in,
      S_AXI_ARREADY_PORT_A_OUT         => bram_axi_arready_port_a_out,

      -- Read data --
      S_AXI_RDATA_PORT_A_OUT  => bram_axi_rdata_port_a_out,
      S_AXI_RRESP_PORT_A_OUT  => bram_axi_rresp_port_a_out,
      S_AXI_RLAST_PORT_A_OUT  => bram_axi_rlast_port_a_out,
      S_AXI_RVALID_PORT_A_OUT => bram_axi_rvalid_port_a_out,
      S_AXI_RREADY_PORT_A_IN  => bram_axi_rready_port_a_in,

      -- Port B controls --
      BRAM_ADDR_B_IN              => bram_addr_b_in,
      BRAM_DATA_B_IN              => bram_data_b_in,
      BRAM_DATA_B_OUT             => bram_data_b_out,
      BRAM_PORT_B_WRITE_ENABLE_IN => bram_port_b_write_enable_in,
      BRAM_PORT_B_ENABLED_OUT     => bram_port_b_enabled_out
    );

  clk <= not clk after c_half_period_25_mhz;

  STIMULUS : process is
    variable nibble_slv : std_logic_vector(3 downto 0);
  begin
    bram_addr_b_in              <= x"000";
    bram_data_b_in              <= x"00";
    bram_port_b_write_enable_in <= '0';
    assert bram_data_b_out = x"00";
    assert bram_port_b_enabled_out = '0';
    bram_axi_arvalid_port_a_in  <= '0';
    bram_axi_rready_port_a_in   <= '0';

    wait_edge;
    reset <= '0';

    wait_edge;
    wait_edge;

    -- Write four words over the AXI interface
    bram_axi_write_word_off_a  <= 10x"0000";
    bram_axi_awlen_port_a_in   <= x"04";
    bram_axi_awvalid_port_a_in <= '1';

    bram_axi_wdata_port_a_in  <= x"00112233";
    bram_axi_wlast_port_a_in  <= '0';
    bram_axi_wvalid_port_a_in <= '1';

    wait_eq(bram_axi_awready_port_a_out, '1', "bram_axi_awready_port_a_OUT");
    assert bram_axi_awready_port_a_out = '1'
      report "AWREADY";
    bram_axi_awvalid_port_a_in <= '0';

    wait_eq(bram_axi_wready_port_a_out, '1',
            "bram_axi_wready_port_a_OUT for "
            & to_hex_string(bram_axi_wdata_port_a_in)
          );
    assert bram_axi_wready_port_a_out = '1'
      report "WREADY";

    bram_axi_wdata_port_a_in <= x"44556677";
    -- wait_edge;
    wait_eq(bram_axi_wready_port_a_out, '1',
            "bram_axi_wready_port_a_OUT for "
            & to_hex_string(bram_axi_wdata_port_a_in)
          );
    assert bram_axi_wready_port_a_out = '1'
      report "WREADY";

    bram_axi_wdata_port_a_in <= x"8899AABB";
    -- wait_edge;
    wait_eq(bram_axi_wready_port_a_out, '1',
            "bram_axi_wready_port_a_OUT for "
            & to_hex_string(bram_axi_wdata_port_a_in)
          );
    assert bram_axi_wready_port_a_out = '1'
      report "WREADY";

    bram_axi_wdata_port_a_in <= x"CCDDEEFF";
    bram_axi_wlast_port_a_in <= '1';
    -- wait_edge;
    wait_eq(bram_axi_wready_port_a_out, '1',
            "bram_axi_wready_port_a_OUT for "
            & to_hex_string(bram_axi_wdata_port_a_in)
          );
    assert bram_axi_wready_port_a_out = '1'
      report "WREADY";
    bram_axi_wlast_port_a_in  <= '0';
    bram_axi_wvalid_port_a_in <= '0';

    bram_axi_bready_port_a_in <= '1';
    assert bram_axi_bvalid_port_a_out = '1'
      report "bram_axi_bvalid_port_a_OUT";
    -- wait_eq(bram_axi_bvalid_port_a_OUT, '1', "bram_axi_bvalid_port_a_OUT");
    wait_edge;
    assert bram_axi_bresp_port_a_out = c_AXI_RESP_OKAY;
    bram_axi_bready_port_a_in <= '0';

    wait_edge;
    wait_edge;

    -- Read the four words back
    bram_axi_read_word_offset_a <= 10x"0000";
    bram_axi_arlen_port_a_in    <= x"04";
    bram_axi_arvalid_port_a_in  <= '1';
    -- wait_edge;
    wait_eq(bram_axi_arready_port_a_out, '1', "bram_axi_arready_port_a_OUT");
    bram_axi_arvalid_port_a_in <= '0';
    bram_axi_rready_port_a_in  <= '1';

    -- wait_edge;
    wait_eq(bram_axi_rvalid_port_a_out, '1', "bram_axi_rvalid_port_a_OUT");
    assert bram_axi_rvalid_port_a_out = '1'
      report "rvalid";
    assert bram_axi_rdata_port_a_out = x"00112233"
      report "rdata";
    assert bram_axi_rresp_port_a_out = c_AXI_RESP_OKAY
      report "rresp";

    -- wait_edge;
    wait_eq(bram_axi_rvalid_port_a_out, '1', "bram_axi_rvalid_port_a_OUT");
    assert bram_axi_rvalid_port_a_out = '1'
      report "rvalid";
    assert bram_axi_rdata_port_a_out = x"44556677"
      report "rdata";
    assert bram_axi_rresp_port_a_out = c_AXI_RESP_OKAY
      report "rresp";

    -- wait_edge;
    wait_eq(bram_axi_rvalid_port_a_out, '1', "bram_axi_rvalid_port_a_OUT");
    assert bram_axi_rvalid_port_a_out = '1'
      report "rvalid";
    assert bram_axi_rdata_port_a_out = x"8899AABB"
      report "rdata";
    assert bram_axi_rresp_port_a_out = c_AXI_RESP_OKAY
      report "rresp";

    -- wait_edge;
    wait_eq(bram_axi_rvalid_port_a_out, '1', "bram_axi_rvalid_port_a_OUT");
    assert bram_axi_rvalid_port_a_out = '1'
      report "rvalid";
    assert bram_axi_rdata_port_a_out = x"CCDDEEFF"
      report "rdata";
    assert bram_axi_rresp_port_a_out = c_AXI_RESP_OKAY
      report "rresp";

    wait_edge;
    assert bram_axi_rlast_port_a_out = '1'
      report "rlast asserted";
    wait_edge;
    bram_axi_rready_port_a_in <= '0';
    assert bram_axi_rlast_port_a_out = '0'
      report "rlast deasserted";

    for idx in 0 to 1 loop
      wait_edge;
    end loop;
    report "-- test the byte interface";
    assert bram_port_b_enabled_out = '1'
      report "Port B is not enabled";

    bram_addr_b_in <= x"000";
    bram_data_b_in <= x"00";

    for nibble in 0 to 15 loop
      nibble_slv := std_logic_vector(to_unsigned(nibble, nibble_slv'length));

      wait_edge;
      assert bram_data_b_out = nibble_slv & nibble_slv
        report "data B out: "
               & to_hex_string(bram_data_b_out)
               & " != "
               & to_hex_string(nibble_slv & nibble_slv);
      bram_addr_b_in <= std_logic_vector(unsigned(bram_addr_b_in) + 1);
    end loop;
    -- bram_port_b_write_enable_in <= '1';

    for idx in 0 to 5 loop
      wait_edge;
    end loop;
    std.env.stop;
  end process STIMULUS;

end architecture RTL;
