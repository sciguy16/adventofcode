library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.packet_types_pkg_hdr.ALL;

entity packet_handler_internal_tb is
end packet_handler_internal_tb;

architecture rtl of packet_handler_internal_tb is
  signal clk: std_logic := '0';
  signal reset: std_logic := '0';

  signal axi_str_rxd_tvalid: std_logic;
  signal axi_str_rxd_tready: std_logic;
  signal axi_str_rxd_tdata: std_logic_vector(31 downto 0);

  signal axi_str_txd_tvalid: std_logic;
  signal axi_str_txd_tready: std_logic;
  signal axi_str_txd_tdata: std_logic_vector(31 downto 0);
  signal axi_str_txd_prog_full: std_logic := '0';

  signal done: std_logic;

begin
  packet_handler_internal_inst: entity work.packet_handler_internal(rtl)
    port map(
        reset => reset,
        clk => clk,

        axi_str_rxd_tvalid_IN => axi_str_rxd_tvalid,
        axi_str_rxd_tready_OUT => axi_str_rxd_tready,
        axi_str_rxd_tdata_IN => axi_str_rxd_tdata,

        axi_str_txd_tvalid_OUT => axi_str_txd_tvalid,
        axi_str_txd_tready_IN => axi_str_txd_tready,
        axi_str_txd_tdata_OUT => axi_str_txd_tdata,
        axi_str_txd_prog_full_IN => '0',

        done_OUT => done
    );

    -- in the simulation time, call it 1 clock cycle per ns
    clk <= not clk after 1 ns; -- 25 MHz clock

    stimulus: process
    begin
      axi_str_txd_tready <= '0';
      axi_str_rxd_tvalid <= '0';
      axi_str_rxd_tdata <= x"00000000";
      reset <= '1';
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      reset <= '0';
      wait until rising_edge(clk);

      -- packet header
      axi_str_rxd_tdata <= x"00000004";
      axi_str_rxd_tvalid <= '1';
      wait until rising_edge(clk) and axi_str_rxd_tready = '1';
      axi_str_rxd_tvalid <= '0';
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);

      -- packet payload
      axi_str_rxd_tdata <= x"12345678";
      axi_str_rxd_tvalid <= '1';
      wait until rising_edge(clk) and axi_str_rxd_tready = '1';
      axi_str_rxd_tvalid <= '0';

      wait until rising_edge(clk);
      wait until rising_edge(clk);

      axi_str_txd_tready <= '1';
      wait until rising_edge(clk) and axi_str_txd_tvalid = '1';
      assert axi_str_txd_tdata = x"00000004";
      wait until rising_edge(clk) and axi_str_txd_tvalid = '1';
      assert axi_str_txd_tdata = x"12345678";
      assert done = '1';

      wait until rising_edge(clk);
      assert done = '0';
      assert axi_str_txd_tvalid = '0';
      wait until rising_edge(clk);

    std.env.stop;
  end process;
end rtl;
