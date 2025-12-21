library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.packet_types_pkg_hdr.ALL;

entity packet_router_tb is
end packet_router_tb;

architecture rtl of packet_router_tb is
  signal clk: std_logic := '0';
  signal reset: std_logic := '0';

  signal axi_str_rxd_tvalid: std_logic := '0';
  signal axi_str_rxd_tready: std_logic;
  signal axi_str_rxd_tdata: std_logic_vector(31 downto 0) := x"00000000";

  signal axi_str_txd_tvalid: std_logic;
  signal axi_str_txd_tready: std_logic := '0';
  signal axi_str_txd_tdata: std_logic_vector(31 downto 0);
  signal axi_str_txd_prog_full: std_logic := '0';

  signal send_counter: natural range 0 to 255 := 0;
  signal receive_counter: natural range 0 to 255 := 0;

begin
  packet_router_inst: entity work.packet_router(rtl)
    port map(
        reset => reset,
        clk => clk,

        axi_str_rxd_tvalid_IN => axi_str_rxd_tvalid,
        axi_str_rxd_tready_OUT => axi_str_rxd_tready,
        axi_str_rxd_tdata_IN => axi_str_rxd_tdata,

        axi_str_txd_tvalid_OUT => axi_str_txd_tvalid,
        axi_str_txd_tready_IN => axi_str_txd_tready,
        axi_str_txd_tdata_OUT => axi_str_txd_tdata,
        axi_str_txd_prog_full_IN => '0'
  );

    -- in the simulation time, call it 1 clock cycle per ns
    clk <= not clk after 1 ns; -- 25 MHz clock

  stimulus: process
  begin
    wait until falling_edge(clk);
    reset <= '1';
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until falling_edge(clk);
    reset <= '0';

    -- packet header
    wait until falling_edge(clk);
    axi_str_rxd_tdata <= x"00000004";
    axi_str_rxd_tvalid <= '1';
    -- wait for UUT to clock in the data on a rising edge
    wait until rising_edge(clk) and axi_str_rxd_tready = '1';
    wait until falling_edge(clk);
    axi_str_rxd_tvalid <= '0';

    -- packet payload
    axi_str_rxd_tdata <= x"12345678";
    axi_str_rxd_tvalid <= '1';
    -- wait for UUT to clock in the data on a rising edge
    wait until rising_edge(clk) and axi_str_rxd_tready = '1';
    wait until falling_edge(clk);
    axi_str_rxd_tvalid <= '0';

    --assert axi_str_rxd_tready = '0' report "tready" severity error;

    wait until falling_edge(clk) and axi_str_txd_tvalid = '1';
    axi_str_txd_tready <= '1';
    assert axi_str_txd_tdata = x"00010004" report "header" severity error;

    wait until falling_edge(clk) and axi_str_txd_tvalid = '1';
    assert axi_str_txd_tdata = x"12345678" report "payload" severity error;

    wait until falling_edge(clk);
    assert axi_str_txd_tvalid = '0' report "tvalid" severity error;

    wait until falling_edge(clk);
    wait until falling_edge(clk);

    std.env.stop;
  end process;
end rtl;
