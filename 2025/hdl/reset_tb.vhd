library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reset_expander_tb is
end reset_expander_tb;

architecture rtl of reset_expander_tb is
  constant c_HALF_PERIOD_25_MHz : time := 20 ns;-- 25 MHz clock, 40 ns period
  constant c_HALF_PERIOD_50_MHz : time := 10 ns; -- 50 MHz clock, 20 ns period
  constant c_QUARTER_PERIOD_50_MHz : time := 5 ns; -- 50 MHz clock, 20 ns period

  signal clk_25MHz: std_logic := '1';
  signal clk_50MHz: std_logic := '1';
  signal reset_in: std_logic := '0';
  signal reset_25MHz: std_logic;
  signal reset_50MHz: std_logic;

  signal clocks: std_logic_vector(1 downto 0);
  signal reset_out: std_logic_vector(1 downto 0);

begin
  uut: entity work.reset_expander(rtl)
    port map(
      reset_in => reset_in,
      clk => clk_25MHz,

      reset_out_25MHz => reset_25MHz,
      reset_clk_25MHz => clk_25MHz,

      reset_out_50MHz => reset_50MHz,
      reset_clk_50MHz => clk_50MHz
    );

    clk_25MHz <= not clk_25MHz after c_HALF_PERIOD_25_MHz; 
    clk_50MHz <= not clk_50MHz after c_HALF_PERIOD_50_MHz;

    clocks <= clk_25MHz & clk_50MHz;
    reset_out <= reset_25MHz & reset_50MHz;

    stimulus: process
      alias uut_reset_in_reg is << signal uut.reset_in_reg: std_logic >>;
      alias uut_reset_latch is << signal uut.reset_latch: std_logic >>;
      alias uut_counter is << signal uut.counter: natural >>;
      alias uut_rst_pipe_25MHz is
        << signal uut.rst_pipe_25MHz: std_logic_vector(1 downto 0) >>;
      alias uut_rst_pipe_50MHz is
        << signal uut.rst_pipe_50MHz: std_logic_vector(3 downto 0) >>;
    begin
      reset_in <= '0';

      wait for 40 ns;
      wait until falling_edge(clk_25MHz);

      reset_in <= '1';
      wait until falling_edge(clk_25MHz);
      wait until falling_edge(clk_50MHz) and clk_25MHz = '0';
      assert uut_reset_in_reg = '1' report "uut_reset_in_reg";
      assert uut_reset_latch = '0' report "uut_reset_latch";

      reset_in <= '0';
      wait until falling_edge(clk_25MHz);
      assert uut_reset_in_reg = '0' report "uut_reset_in_reg";
      assert uut_reset_latch = '1' report "uut_reset_latch";
      assert uut_rst_pipe_25MHz = "00" report "rst pipe 25MHz is clear";
      assert uut_rst_pipe_50MHz = "0000" report "rst pipe 50MHz is clear";
      assert reset_out = "00" report "Reset out should not be asserted yet";


      wait until falling_edge(clk_50MHz);
      -- allow signals to settle after the clock edges
      wait for c_QUARTER_PERIOD_50_MHz; -- t=155 ns
      assert clocks = "00" report "both clocks are low";
      assert uut_rst_pipe_25MHz = "00" report "rst pipe 25MHz is clear";
      assert uut_rst_pipe_50MHz = "0001" report "rst pipe 50MHz clocked in 1";

      wait for c_HALF_PERIOD_50_MHz; -- t=165 ns
      assert clocks = "11" report "both clocks have just had a rising edge";
      assert uut_rst_pipe_25MHz = "01" report "rst pipe 25MHz clocked in 1";
      assert uut_rst_pipe_50MHz = "0011" report "rst pipe 50MHz clocked in 2";

      wait for c_HALF_PERIOD_50_MHz; -- t=175 ns
      assert clocks = "10" report "50 MHz falling edge";
      assert uut_rst_pipe_25MHz = "01" report "rst pipe 25MHz unchanged";
      assert uut_rst_pipe_50MHz = "0011" report "rst pipe 50MHz unchanged";

      wait for c_HALF_PERIOD_50_MHz; -- t=185 ns
      assert clocks = "01" report "25 MHz falling edge, 50 MHz rising edge";
      assert uut_rst_pipe_25MHz = "01" report "rst pipe 25MHz clocked in 1";
      assert uut_rst_pipe_50MHz = "0111" report "rst pipe 50MHz clocked in 3";

      wait for c_HALF_PERIOD_50_MHz; -- t=195 ns
      assert clocks = "00" report "50 MHz falling edge";
      assert uut_rst_pipe_25MHz = "01" report "rst pipe 25MHz unchanged";
      assert uut_rst_pipe_50MHz = "0111" report "rst pipe 50MHz unchanged";
      assert reset_out = "00" report "Reset out should not be asserted yet";

      wait for c_HALF_PERIOD_50_MHz; -- t=205 ns
      assert clocks = "11" report "both clocks have just had a rising edge";
      assert uut_rst_pipe_25MHz = "11" report "rst pipe 25MHz clocked in 2";
      assert uut_rst_pipe_50MHz = "1111" report "rst pipe 50MHz clocked in 4";

      assert reset_out = "11" report "Reset out should be asserted";
      --assert counter = 0 report "Testbench counter should be reset";

      --wait until falling_edge(reset_out);
      --assert counter = 63 report "Reset out should deassert after 64 clocks";


      wait until falling_edge(clk_25MHz);
      wait until falling_edge(clk_25MHz);
      assert uut_rst_pipe_25MHz = "11" report "rst pipe 25MHz unchanged";
      assert uut_rst_pipe_50MHz = "1111" report "rst pipe 50MHz unchanged";
      assert reset_out = "11" report "Reset out should still be asserted";
      wait until falling_edge(clk_25MHz);
      wait until falling_edge(clk_25MHz);
      assert uut_rst_pipe_25MHz = "11" report "rst pipe 25MHz unchanged";
      assert uut_rst_pipe_50MHz = "1111" report "rst pipe 50MHz unchanged";
      assert reset_out = "11" report "Reset out should still be asserted";


      wait until falling_edge(uut_reset_latch);

      -- allow signals to settle after the clock edges
      wait for c_QUARTER_PERIOD_50_MHz; -- t=1405 ns
      assert clocks = "11" report "both clocks have just had a rising edge";
      assert uut_counter = 32 report "counter one more than max";
      assert uut_rst_pipe_25MHz = "11" report "rst pipe 25MHz unchanged";
      assert uut_rst_pipe_50MHz = "1111" report "rst pipe 50MHz unchanged";

      wait for c_HALF_PERIOD_50_MHz; -- t=1415 ns
      assert clocks = "10" report "50 MHz falling edge";
      assert uut_rst_pipe_25MHz = "11" report "rst pipe 25MHz unchanged";
      assert uut_rst_pipe_50MHz = "1111" report "rst pipe 50MHz unchanged";

      wait for c_HALF_PERIOD_50_MHz; -- t=1425 ns
      assert clocks = "01" report "25 MHz falling edge, 50 MHz rising edge";
      assert uut_rst_pipe_25MHz = "11" report "rst pipe 25MHz unchanged";
      assert uut_rst_pipe_50MHz = "1110" report "rst pipe 50MHz clocked out 1";

      wait for c_HALF_PERIOD_50_MHz; -- t=1435 ns
      assert clocks = "00" report "50 MHz falling edge";
      wait for c_HALF_PERIOD_50_MHz; -- t=1445 ns
      assert clocks = "11" report "25 MHz rising edge, 50 MHz rising edge";
      assert uut_rst_pipe_25MHz = "10" report "rst pipe 25MHz clocked out 1";
      assert uut_rst_pipe_50MHz = "1100" report "rst pipe 50MHz clocked out 2";

      wait for c_HALF_PERIOD_50_MHz; -- t=1455 ns
      assert clocks = "10" report "50 MHz falling edge";
      wait for c_HALF_PERIOD_50_MHz; -- t=1465 ns
      assert clocks = "01" report "25 MHz falling edge, 50 MHz rising edge";
      assert uut_rst_pipe_25MHz = "10" report "rst pipe 25MHz unchanged";
      assert uut_rst_pipe_50MHz = "1000" report "rst pipe 50MHz clocked out 3";
      assert reset_out = "11" report "Reset out should still be asserted";

      wait for c_HALF_PERIOD_50_MHz; -- t=1475 ns
      assert clocks = "00" report "50 MHz falling edge";
      wait for c_HALF_PERIOD_50_MHz; -- t=1485 ns
      assert clocks = "11" report "25 MHz rising edge, 50 MHz rising edge";
      assert uut_rst_pipe_25MHz = "00" report "rst pipe 25MHz clocked out 2";
      assert uut_rst_pipe_50MHz = "0000" report "rst pipe 50MHz clocked out 4";
      assert reset_out = "00" report "Reset out should be deasserted";


      wait until falling_edge(clk_25MHz);
      assert reset_out = "00" report "Reset out should still be deasserted";
      wait until falling_edge(clk_25MHz);
      assert reset_out = "00" report "Reset out should still be deasserted";
      wait until falling_edge(clk_25MHz);
      assert reset_out = "00" report "Reset out should still be deasserted";

      std.env.stop;
    end process;
end rtl;
