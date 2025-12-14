library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reset_expander_tb is
end reset_expander_tb;

architecture rtl of reset_expander_tb is

  signal clk: std_logic := '0';
  signal reset_in: std_logic := '0';
  signal reset_out: std_logic;
  signal counter: natural range 0 to 127 := 0;

begin
  reset_expander_inst: entity work.reset_expander(rtl)
    port map(
      reset_in => reset_in,
      reset_out => reset_out,
      clk => clk
    );

    -- in the simulation time, call it 1 clock cycle per ns
    clk <= not clk after 1 ns; -- 25 MHz clock

    stimulus: process
    begin
      reset_in <= '0';

      wait for 2 ns;
      wait until rising_edge(clk);

      reset_in <= '1';
      wait until rising_edge(clk);
      assert reset_out = '1' report "Reset out should be asserted";

      reset_in <= '0';
      wait until rising_edge(clk);
      assert reset_out = '1' report "Reset out should be asserted";
      assert counter = 0 report "Testbench counter should be reset";

      wait until falling_edge(reset_out);
      assert counter = 63 report "Reset out should deassert after 64 clocks";

    std.env.stop;
  end process;

  process(clk, reset_in) is
  begin
    if(rising_edge(clk)) then
      counter <= counter + 1;
      if (reset_in = '1') then
        counter <= 0;
      end if;
    end if;
  end process;
end rtl;
