library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.aoc_top_pkg_hdr.ALL;

entity blk_mem_wrapper_tb is
end blk_mem_wrapper_tb;

architecture rtl of blk_mem_wrapper_tb is
  constant c_HALF_PERIOD_25_MHz : time := 20 ns; -- 25 MHz clock, 40 ns period

  signal clk   : std_logic := '1';
  signal reset : std_logic := '1';

  -- Write controls --
  signal bram_axi_write_word_offset_port_a_IN : STD_LOGIC_VECTOR(9 DOWNTO 0)
    := 10x"000";
  signal bram_axi_awlen_port_a_IN : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
  signal bram_axi_awvalid_port_a_IN : STD_LOGIC := '0';
  signal bram_axi_awready_port_a_OUT : STD_LOGIC;

  -- Write data --
  signal bram_axi_wdata_port_a_IN : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal bram_axi_wlast_port_a_IN : STD_LOGIC := '0';
  signal bram_axi_wvalid_port_a_IN : STD_LOGIC := '0';
  signal bram_axi_wready_port_a_OUT : STD_LOGIC;

  -- Write response --
  signal bram_axi_bresp_port_a_OUT : STD_LOGIC_VECTOR(1 DOWNTO 0);
  signal bram_axi_bvalid_port_a_OUT : STD_LOGIC;
  signal bram_axi_bready_port_a_IN : STD_LOGIC := '0';

  -- Read controls --
  signal bram_axi_read_word_offset_port_a_IN : STD_LOGIC_VECTOR(9 DOWNTO 0)
    := 10x"000";
  signal bram_axi_arlen_port_a_IN : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
  signal bram_axi_arvalid_port_a_IN : STD_LOGIC := '0';
  signal bram_axi_arready_port_a_OUT : STD_LOGIC;

  -- Read data --
  signal bram_axi_rdata_port_a_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal bram_axi_rresp_port_a_OUT : STD_LOGIC_VECTOR(1 DOWNTO 0);
  signal bram_axi_rlast_port_a_OUT : STD_LOGIC;
  signal bram_axi_rvalid_port_a_OUT : STD_LOGIC;
  signal bram_axi_rready_port_a_IN : STD_LOGIC := '0';

    -- Port B controls --
  signal bram_addr_b_in: std_logic_vector(11 downto 0);
  signal bram_data_b_in: std_logic_vector(7 downto 0);
  signal bram_data_b_out: std_logic_vector(7 downto 0);
  signal bram_port_b_write_enable_in: std_logic;
  signal bram_port_b_enabled_out: std_logic;

  signal verbose: boolean := false;

  procedure wait_edge is
  begin
    wait until rising_edge(clk);
    wait for 2 ns;
  end procedure wait_edge;

  procedure wait_eq(
    signal value: in std_logic;
    expected: in std_logic;
    message: in string
  ) is
    variable clock_count: integer := 0;
  begin
    if verbose then
      report "wait for: " & message severity note;
    end if;
    wait_edge;
    while value /= expected loop
      wait_edge;
      clock_count := clock_count + 1;
      if clock_count = 10 then
        report "condition not met after timeout: " & message severity failure;
        exit;
      end if;
    end loop;
  end procedure wait_eq;

begin
  uut : entity work.blk_mem_wrapper(rtl)
  port map(
    reset => reset,
    clk   => clk,

    -- Port A controls --

    -- Write controls --
    s_axi_write_word_offset_port_a_IN => bram_axi_write_word_offset_port_a_IN,
    s_axi_awlen_port_a_IN => bram_axi_awlen_port_a_IN,
    s_axi_awvalid_port_a_IN => bram_axi_awvalid_port_a_IN,
    s_axi_awready_port_a_OUT => bram_axi_awready_port_a_OUT,

    -- Write data --
    s_axi_wdata_port_a_IN => bram_axi_wdata_port_a_IN,
    s_axi_wlast_port_a_IN => bram_axi_wlast_port_a_IN,
    s_axi_wvalid_port_a_IN => bram_axi_wvalid_port_a_IN,
    s_axi_wready_port_a_OUT => bram_axi_wready_port_a_OUT,

    -- Write response --
    s_axi_bresp_port_a_OUT => bram_axi_bresp_port_a_OUT,
    s_axi_bvalid_port_a_OUT => bram_axi_bvalid_port_a_OUT,
    s_axi_bready_port_a_IN => bram_axi_bready_port_a_IN,

    -- Read controls --
    s_axi_read_word_offset_port_a_IN => bram_axi_read_word_offset_port_a_IN,
    s_axi_arlen_port_a_IN => bram_axi_arlen_port_a_IN,
    s_axi_arvalid_port_a_IN => bram_axi_arvalid_port_a_IN,
    s_axi_arready_port_a_OUT => bram_axi_arready_port_a_OUT,

    -- Read data --
    s_axi_rdata_port_a_OUT => bram_axi_rdata_port_a_OUT,
    s_axi_rresp_port_a_OUT => bram_axi_rresp_port_a_OUT,
    s_axi_rlast_port_a_OUT => bram_axi_rlast_port_a_OUT,
    s_axi_rvalid_port_a_OUT => bram_axi_rvalid_port_a_OUT,
    s_axi_rready_port_a_IN => bram_axi_rready_port_a_IN,

    -- Port B controls --
    bram_addr_b_in => bram_addr_b_in,
    bram_data_b_in => bram_data_b_in,
    bram_data_b_out => bram_data_b_out,
    bram_port_b_write_enable_in => bram_port_b_write_enable_in,
    bram_port_b_enabled_out => bram_port_b_enabled_out
  );

  clk <= not clk after c_HALF_PERIOD_25_MHz;


  stimulus : process
    variable nibble_slv: std_logic_vector(3 downto 0);
  begin
    bram_addr_b_in <= x"000";
    bram_data_b_in <= x"00";
    bram_port_b_write_enable_in <= '0';
    assert bram_data_b_out = x"00";
    assert bram_port_b_enabled_out = '0';
    bram_axi_arvalid_port_a_IN <= '0';
    bram_axi_rready_port_a_IN <= '0';

    wait_edge;
    reset <= '0';

    wait_edge;
    wait_edge;

    -- Write four words over the AXI interface
    bram_axi_write_word_offset_port_a_IN  <= 10x"0000";
    bram_axi_awlen_port_a_IN   <= x"04";
    bram_axi_awvalid_port_a_IN <= '1';

    bram_axi_wdata_port_a_IN <= x"00112233";
    bram_axi_wlast_port_a_IN <= '0';
    bram_axi_wvalid_port_a_IN <= '1';

    wait_eq(bram_axi_awready_port_a_OUT, '1', "bram_axi_awready_port_a_OUT");
    assert bram_axi_awready_port_a_OUT = '1' report "AWREADY";
    bram_axi_awvalid_port_a_IN <= '0';

    wait_eq(bram_axi_wready_port_a_OUT, '1',
      "bram_axi_wready_port_a_OUT for " & to_hex_string(bram_axi_wdata_port_a_IN)
    );
    assert bram_axi_wready_port_a_OUT = '1' report "WREADY";

    bram_axi_wdata_port_a_IN <= x"44556677";
    --wait_edge;
    wait_eq(bram_axi_wready_port_a_OUT, '1',
      "bram_axi_wready_port_a_OUT for " & to_hex_string(bram_axi_wdata_port_a_IN)
    );
    assert bram_axi_wready_port_a_OUT = '1' report "WREADY";

    bram_axi_wdata_port_a_IN <= x"8899aabb";
    --wait_edge;
    wait_eq(bram_axi_wready_port_a_OUT, '1',
      "bram_axi_wready_port_a_OUT for " & to_hex_string(bram_axi_wdata_port_a_IN)
    );
    assert bram_axi_wready_port_a_OUT = '1' report "WREADY";

    bram_axi_wdata_port_a_IN <= x"ccddeeff";
    bram_axi_wlast_port_a_IN <= '1';
    --wait_edge;
    wait_eq(bram_axi_wready_port_a_OUT, '1',
      "bram_axi_wready_port_a_OUT for " & to_hex_string(bram_axi_wdata_port_a_IN)
    );
    assert bram_axi_wready_port_a_OUT = '1' report "WREADY";
    bram_axi_wlast_port_a_IN <= '0';
    bram_axi_wvalid_port_a_IN <= '0';

    bram_axi_bready_port_a_IN <= '1';
    assert bram_axi_bvalid_port_a_OUT = '1' report "bram_axi_bvalid_port_a_OUT";
    --wait_eq(bram_axi_bvalid_port_a_OUT, '1', "bram_axi_bvalid_port_a_OUT");
    wait_edge;
    assert bram_axi_bresp_port_a_OUT = c_AXI_RESP_OKAY;
    bram_axi_bready_port_a_IN <= '0';

    wait_edge;
    wait_edge;

    -- Read the four words back
    bram_axi_read_word_offset_port_a_IN <= 10x"0000";
    bram_axi_arlen_port_a_IN <= x"04";
    bram_axi_arvalid_port_a_IN <= '1';
    --wait_edge;
    wait_eq(bram_axi_arready_port_a_OUT, '1', "bram_axi_arready_port_a_OUT");
    bram_axi_arvalid_port_a_IN <= '0';
    bram_axi_rready_port_a_IN <= '1';

    --wait_edge;
    wait_eq(bram_axi_rvalid_port_a_OUT, '1', "bram_axi_rvalid_port_a_OUT");
    assert bram_axi_rvalid_port_a_OUT = '1' report "rvalid";
    assert bram_axi_rdata_port_a_OUT = x"00112233" report "rdata";
    assert bram_axi_rresp_port_a_OUT = c_AXI_RESP_OKAY report "rresp";

    --wait_edge;
    wait_eq(bram_axi_rvalid_port_a_OUT, '1', "bram_axi_rvalid_port_a_OUT");
    assert bram_axi_rvalid_port_a_OUT = '1' report "rvalid";
    assert bram_axi_rdata_port_a_OUT = x"44556677" report "rdata";
    assert bram_axi_rresp_port_a_OUT = c_AXI_RESP_OKAY report "rresp";

    --wait_edge;
    wait_eq(bram_axi_rvalid_port_a_OUT, '1', "bram_axi_rvalid_port_a_OUT");
    assert bram_axi_rvalid_port_a_OUT = '1' report "rvalid";
    assert bram_axi_rdata_port_a_OUT = x"8899aabb" report "rdata";
    assert bram_axi_rresp_port_a_OUT = c_AXI_RESP_OKAY report "rresp";

    --wait_edge;
    wait_eq(bram_axi_rvalid_port_a_OUT, '1', "bram_axi_rvalid_port_a_OUT");
    assert bram_axi_rvalid_port_a_OUT = '1' report "rvalid";
    assert bram_axi_rdata_port_a_OUT = x"ccddeeff" report "rdata";
    assert bram_axi_rresp_port_a_OUT = c_AXI_RESP_OKAY report "rresp";

    wait_edge;
    assert bram_axi_rlast_port_a_OUT = '1' report "rlast asserted";
    wait_edge;
    bram_axi_rready_port_a_IN <= '0';
    assert bram_axi_rlast_port_a_OUT = '0' report "rlast deasserted";

    for idx in 0 to 1 loop
      wait_edge;
    end loop;

    report "-- test the byte interface";
    assert bram_port_b_enabled_out = '1' report "Port B is not enabled";

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
    --bram_port_b_write_enable_in <= '1';

    for idx in 0 to 5 loop
      wait_edge;
    end loop;
    std.env.stop;
  end process;
end rtl;
