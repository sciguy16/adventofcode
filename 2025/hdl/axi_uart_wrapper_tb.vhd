library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--package axi_uart_wrapper_tb_pkg is
--  constant c_CYCLES_PER_BIT: integer:= 234; -- 27,000,000 (27Mhz) / 115200 Baud rate;
--end package;
--package body axi_uart_wrapper_tb_pkg is
--end package body;

--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--library work;
--use work.axi_uart_wrapper_tb_pkg.ALL;

entity axi_uart_wrapper_tb is
end axi_uart_wrapper_tb;

architecture rtl of axi_uart_wrapper_tb is
  constant c_CYCLES_PER_BIT: integer:= 434; -- 50,000,000 (50 Mhz) / 115200 Baud rate;

  signal clk: std_logic := '0';
  signal axi_clk: std_logic := '0';
  signal reset: std_logic := '0';
  signal uart_loopback: std_logic;

  signal axi_str_txd_tvalid: std_logic;
  signal axi_str_txd_tready: std_logic;
  signal axi_str_txd_tdata: std_logic_vector(31 downto 0);

  signal axi_str_rxd_tvalid: std_logic;
  signal axi_str_rxd_tready: std_logic;
  signal axi_str_rxd_tdata: std_logic_vector(31 downto 0);
begin
  axi_uart_wrapper_inst: entity work.axi_uart_wrapper(rtl)
    port map(
      reset => reset,
      clk => clk,
      axi_clk => axi_clk,
      rx_IN => uart_loopback,
      tx_OUT => uart_loopback,

      axi_str_rxd_tvalid_OUT => axi_str_rxd_tvalid,
      axi_str_rxd_tready_IN => axi_str_rxd_tready,
      axi_str_rxd_tdata_OUT => axi_str_rxd_tdata,

      axi_str_txd_tvalid_IN => axi_str_txd_tvalid,
      axi_str_txd_tready_OUT => axi_str_txd_tready,
      axi_str_txd_tdata_IN => axi_str_txd_tdata,
      axi_str_txd_prog_full_OUT => open
    );

    -- in the simulation time, call it 1 clock cycle per ns
    clk <= not clk after 1 ns; -- 25 MHz clock
    axi_clk <= not axi_clk after 0.5 ns; -- 50 MHz clock
    reset <= '1', '0' after 8 ns;

    stimulus: process
    begin
      axi_str_txd_tvalid <= '0';
      axi_str_txd_tdata <= x"0000_0000";
      axi_str_rxd_tready <= '1';

      --reset <= '1';
      --wait for 1 ns;

      --reset <= '0';

      wait for 20 ns;
      assert uart_loopback = '1' report "tx should idle high";

      wait for 5 ns;

      -- send one data word
      axi_str_rxd_tready <= '0';
      axi_str_txd_tdata <= x"01234567";
      axi_str_txd_tvalid <= '1';
      wait until (axi_str_txd_tready = '1');
      wait for 2 ns; -- sampled on slower clock
      axi_str_txd_tvalid <= '0';

      -- wait for it to appear on receive side
      wait until (axi_str_rxd_tvalid = '1');
      axi_str_rxd_tready <= '1';
      assert axi_str_rxd_tdata = x"1234567";
      wait for 2 ns;
      axi_str_rxd_tready <= '0';
     

      -- 115200 baud is 8.68 µs per bit
      -- with a 50 MHz clock, that's 20 ns per cycle, so 434 cycles per bit
      -- 8 bits is 3472 clocks, or 4340 including stop/start bits
      -- 4 bytes is then 17360 clocks
      --wait for 200_000 ns;

    std.env.stop;
  end process;
end rtl;
