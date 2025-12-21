library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.packet_types_pkg_hdr.ALL;

entity packet_handler_tb is
end packet_handler_tb;

architecture rtl of packet_handler_tb is
  signal clk: std_logic := '0';
  signal reset: std_logic := '0';

  signal axi_str_rxd_tvalid: std_logic := '0';
  signal axi_str_rxd_tready: std_logic;
  signal axi_str_rxd_tdata: std_logic_vector(31 downto 0) := x"00000000";

  signal axi_str_txd_tvalid: std_logic;
  signal axi_str_txd_tready: std_logic := '0';
  signal axi_str_txd_tdata: std_logic_vector(31 downto 0);

  signal done: std_logic;
begin
  packet_handler_inst: entity work.packet_handler(rtl)
    port map(
        reset => reset,
        clk => clk,

        axi_str_rxd_tvalid_IN => axi_str_rxd_tvalid,
        axi_str_rxd_tready_OUT => axi_str_rxd_tready,
        axi_str_rxd_tdata_IN => axi_str_rxd_tdata,

        axi_str_txd_tvalid_OUT => axi_str_txd_tvalid,
        axi_str_txd_tready_IN => axi_str_txd_tready,
        axi_str_txd_tdata_OUT => axi_str_txd_tdata

    );

    -- in the simulation time, call it 1 clock cycle per ns
    clk <= not clk after 1 ns; -- 25 MHz clock

    stimulus: process
      alias reply_done_internal is
        << signal packet_handler_inst.reply_done: std_logic >>;
    begin
      reset <= '1';
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      reset <= '0';
      wait until rising_edge(clk);

      for clocks_between_header_and_payload in 0 to 2 loop
        report "clocks=" & integer'image(clocks_between_header_and_payload);

        -- packet header
        wait until falling_edge(clk);
        axi_str_rxd_tdata <= x"00000004";
        axi_str_rxd_tvalid <= '1';
        -- wait for UUT to clock in the data on a rising edge
        wait until rising_edge(clk) and axi_str_rxd_tready = '1';
        wait until falling_edge(clk);
        axi_str_rxd_tvalid <= '0';

        for clock in clocks_between_header_and_payload - 1 downto 0 loop
          wait until falling_edge(clk);
        end loop;

        -- packet payload
        axi_str_rxd_tdata <= x"12345678";
        axi_str_rxd_tvalid <= '1';
        -- wait for UUT to clock in the data on a rising edge
        wait until rising_edge(clk) and axi_str_rxd_tready = '1';
        wait until falling_edge(clk);
        axi_str_rxd_tvalid <= '0';

        assert axi_str_rxd_tready = '0' severity error;

        wait until falling_edge(clk) and axi_str_txd_tvalid = '1';
        axi_str_txd_tready <= '1';
        assert axi_str_txd_tdata = x"00010004" report "header" severity error;

        wait until falling_edge(clk) and axi_str_txd_tvalid = '1';
        assert axi_str_txd_tdata = x"12345678" report "payload" severity error;
        assert reply_done_internal = '0' report "done internal" severity error;
        assert done = '0' report "done" severity error;

        wait until falling_edge(clk);
        assert reply_done_internal = '1' report "done internal" severity error;
        assert done = '0' report "done" severity error;
        assert axi_str_txd_tvalid = '0' severity error;

        wait until falling_edge(clk);
        assert reply_done_internal = '0' report "done internal" severity error;
        assert done = '1' report "done" severity error;

        wait until falling_edge(clk);
        assert axi_str_rxd_tready = '1';
        assert reply_done_internal = '0' report "done internal" severity error;
        assert done = '0' report "done" severity error;

        wait until falling_edge(clk);

      end loop;

    std.env.stop;
  end process;
end rtl;
