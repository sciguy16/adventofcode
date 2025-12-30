library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.aoc_top_pkg_hdr.ALL;

entity blk_mem_wrapper_tb is
end blk_mem_wrapper_tb;

architecture rtl of blk_mem_wrapper_tb is
  constant c_HALF_PERIOD_25_MHz : time := 20 ns; -- 25 MHz clock, 40 ns period

  signal clk   : std_logic := '1';
  signal reset : std_logic := '1';

  -- Write controls --
  signal bram_axi_write_word_offset_port_a : STD_LOGIC_VECTOR(9 DOWNTO 0);
  signal bram_axi_awlen_port_a : STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal bram_axi_awvalid_port_a : STD_LOGIC;
  signal bram_axi_awready_port_a : STD_LOGIC;

  -- Write data --
  signal bram_axi_wdata_port_a : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal bram_axi_wlast_port_a : STD_LOGIC;
  signal bram_axi_wvalid_port_a : STD_LOGIC;
  signal bram_axi_wready_port_a : STD_LOGIC;

  -- Write response --
  signal bram_axi_bresp_port_a : STD_LOGIC_VECTOR(1 DOWNTO 0);
  signal bram_axi_bvalid_port_a : STD_LOGIC;
  signal bram_axi_bready_port_a : STD_LOGIC;

  -- Read controls --
  signal bram_axi_read_word_offset_port_a : STD_LOGIC_VECTOR(9 DOWNTO 0);
  signal bram_axi_arlen_port_a : STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal bram_axi_arvalid_port_a : STD_LOGIC;
  signal bram_axi_arready_port_a : STD_LOGIC;

  -- Read data --
  signal bram_axi_rdata_port_a : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal bram_axi_rresp_port_a : STD_LOGIC_VECTOR(1 DOWNTO 0);
  signal bram_axi_rlast_port_a : STD_LOGIC;
  signal bram_axi_rvalid_port_a : STD_LOGIC;
  signal bram_axi_rready_port_a : STD_LOGIC;

    -- Port B controls --
  signal bram_addr_b_in: std_logic_vector(11 downto 0);
  signal bram_data_b_in: std_logic_vector(7 downto 0);
  signal bram_data_b_out: std_logic_vector(7 downto 0);
  signal bram_port_b_write_enable_in: std_logic;
  signal bram_port_b_enabled_out: std_logic;

  procedure wait_edge is
  begin
    wait until rising_edge(clk);
    wait for 2 ns;
  end procedure wait_edge;

begin
  uut : entity work.blk_mem_wrapper(rtl)
  port map(
    reset => reset,
    clk   => clk,

    -- Port A controls --

    -- Write controls --
    s_axi_write_word_offset_port_a => bram_axi_write_word_offset_port_a,
    s_axi_awlen_port_a => bram_axi_awlen_port_a,
    s_axi_awvalid_port_a => bram_axi_awvalid_port_a,
    s_axi_awready_port_a => bram_axi_awready_port_a,

    -- Write data --
    s_axi_wdata_port_a => bram_axi_wdata_port_a,
    s_axi_wlast_port_a => bram_axi_wlast_port_a,
    s_axi_wvalid_port_a => bram_axi_wvalid_port_a,
    s_axi_wready_port_a => bram_axi_wready_port_a,

    -- Write response --
    s_axi_bresp_port_a => bram_axi_bresp_port_a,
    s_axi_bvalid_port_a => bram_axi_bvalid_port_a,
    s_axi_bready_port_a => bram_axi_bready_port_a,

    -- Read controls --
    s_axi_read_word_offset_port_a => bram_axi_read_word_offset_port_a,
    s_axi_arlen_port_a => bram_axi_arlen_port_a,
    s_axi_arvalid_port_a => bram_axi_arvalid_port_a,
    s_axi_arready_port_a => bram_axi_arready_port_a,

    -- Read data --
    s_axi_rdata_port_a => bram_axi_rdata_port_a,
    s_axi_rresp_port_a => bram_axi_rresp_port_a,
    s_axi_rlast_port_a => bram_axi_rlast_port_a,
    s_axi_rvalid_port_a => bram_axi_rvalid_port_a,
    s_axi_rready_port_a => bram_axi_rready_port_a,

    -- Port B controls --
    bram_addr_b_in => bram_addr_b_in,
    bram_data_b_in => bram_data_b_in,
    bram_data_b_out => bram_data_b_out,
    bram_port_b_write_enable_in => bram_port_b_write_enable_in,
    bram_port_b_enabled_out => bram_port_b_enabled_out
  );

  clk <= not clk after c_HALF_PERIOD_25_MHz;


  stimulus : process
  begin
    bram_addr_b_in <= x"000";
    bram_data_b_in <= x"00";
    bram_port_b_write_enable_in <= '0';
    assert bram_data_b_out = x"00";
    assert bram_port_b_enabled_out = '0';

    wait_edge;
    reset <= '0';
    bram_axi_rready_port_a <= '0';

    wait_edge;
    wait_edge;

    -- Write four words over the AXI interface
    bram_axi_write_word_offset_port_a  <= 10x"0000";
    bram_axi_awlen_port_a   <= x"04";
    bram_axi_awvalid_port_a <= '1';

    bram_axi_wdata_port_a <= x"00112233";
    bram_axi_wlast_port_a <= '0';
    bram_axi_wvalid_port_a <= '1';

    while bram_axi_awready_port_a = '0' loop
      wait_edge;
    end loop;
    assert bram_axi_awready_port_a = '1' report "AWREADY";
    bram_axi_awvalid_port_a <= '0';

    while bram_axi_wready_port_a = '0' loop
      wait_edge;
    end loop;
    assert bram_axi_wready_port_a = '1' report "WREADY";

    bram_axi_wdata_port_a <= x"44556677";
    wait_edge;
    while bram_axi_wready_port_a = '0' loop
      wait_edge;
    end loop;
    assert bram_axi_wready_port_a = '1' report "WREADY";

    bram_axi_wdata_port_a <= x"8899aabb";
    wait_edge;
    while bram_axi_wready_port_a = '0' loop
      wait_edge;
    end loop;
    assert bram_axi_wready_port_a = '1' report "WREADY";

    bram_axi_wdata_port_a <= x"ccddeeff";
    bram_axi_wlast_port_a <= '1';
    wait_edge;
    bram_axi_wlast_port_a <= '0';
    while bram_axi_wready_port_a = '0' loop
      wait_edge;
    end loop;
    assert bram_axi_wready_port_a = '1' report "WREADY";

    bram_axi_wvalid_port_a <= '0';

    bram_axi_bready_port_a <= '1';
    while bram_axi_bvalid_port_a = '0' loop
      wait_edge;
    end loop;
    assert bram_axi_bresp_port_a = c_AXI_RESP_OKAY;
    bram_axi_bready_port_a <= '0';

    wait_edge;
    wait_edge;

    -- Read the four words back
    bram_axi_read_word_offset_port_a <= 10x"0000";
    bram_axi_arlen_port_a <= x"04";
    bram_axi_arvalid_port_a <= '1';
    wait_edge;
    while bram_axi_arready_port_a = '0' loop
      wait_edge;
    end loop;
    bram_axi_arvalid_port_a <= '0';

    bram_axi_rready_port_a <= '1';

    wait_edge;
    while bram_axi_rvalid_port_a = '0' loop
      wait_edge;
    end loop;
    assert bram_axi_rvalid_port_a = '1' report "rvalid";
    assert bram_axi_rdata_port_a = x"00112233" report "rdata";
    assert bram_axi_rresp_port_a = c_AXI_RESP_OKAY report "rresp";

    wait_edge;
    while bram_axi_rvalid_port_a = '0' loop
      wait_edge;
    end loop;
    assert bram_axi_rvalid_port_a = '1' report "rvalid";
    assert bram_axi_rdata_port_a = x"44556677" report "rdata";
    assert bram_axi_rresp_port_a = c_AXI_RESP_OKAY report "rresp";

    wait_edge;
    while bram_axi_rvalid_port_a = '0' loop
      wait_edge;
    end loop;
    assert bram_axi_rvalid_port_a = '1' report "rvalid";
    assert bram_axi_rdata_port_a = x"8899aabb" report "rdata";
    assert bram_axi_rresp_port_a = c_AXI_RESP_OKAY report "rresp";

    wait_edge;
    while bram_axi_rvalid_port_a = '0' loop
      wait_edge;
    end loop;
    assert bram_axi_rvalid_port_a = '1' report "rvalid";
    assert bram_axi_rdata_port_a = x"ccddeeff" report "rdata";
    assert bram_axi_rresp_port_a = c_AXI_RESP_OKAY report "rresp";

    wait_edge;
    assert bram_axi_rlast_port_a = '1' report "rlast";
    bram_axi_rready_port_a <= '0';

    for idx in 0 to 5 loop
      wait_edge;
    end loop;

    report "-- test the byte interface";
    assert bram_port_b_enabled_out = '1' report "Port B is not enabled";

    bram_addr_b_in <= x"000";
    bram_data_b_in <= x"00";
    assert bram_data_b_out = x"00";
    --bram_port_b_write_enable_in <= '1';

    for idx in 0 to 5 loop
      wait_edge;
    end loop;
    std.env.stop;
  end process;
end rtl;
