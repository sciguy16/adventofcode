library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clk is
  generic (
    CLK_CYCLE_TIME  : time     := 1 ns;
    CLK_HIGH_TIME   : time     := 500 ps;
    DATA_SETUP_TIME : time     := 400 ps;
    DATA_HOLD_TIME  : time     := 400 ps
  );
  port (
  	clk: OUT std_logic;
  	data_setup_event: OUT std_logic;
   	clk_rise_event: OUT std_logic;
   	clk_fall_event: OUT std_logic;
   	data_hold_event: OUT std_logic
  );
end entity;

architecture rtl of tb_clk is

begin
	clk <= '0';
	data_setup_event <= '0';
	clk_rise_event <= '0';
	clk_fall_event <= '0';
	data_hold_event <= '0';

	-- generate events for data setup, clock rise, data hold and clock fall times:
    data_setup_event <= transport not data_setup_event after CLK_CYCLE_TIME;
    clk_rise_event   <= transport     data_setup_event after DATA_SETUP_TIME;
    clk_fall_event   <= transport     clk_rise_event   after CLK_HIGH_TIME;
    data_hold_event  <= transport     clk_rise_event   after DATA_HOLD_TIME;

    clk_gen_p: process is
    begin
      wait on clk_rise_event;
      clk <= '1';
      wait on clk_fall_event;
      clk <= '0';
    end process;
end rtl;
