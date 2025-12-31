library ieee;
  use ieee.std_logic_1164.all;

entity TB_CLK is
  generic (
    CLK_CYCLE_TIME  : time := 1 ns;
    CLK_HIGH_TIME   : time := 500 ps;
    DATA_SETUP_TIME : time := 400 ps;
    DATA_HOLD_TIME  : time := 400 ps
  );
  port (
    CLK              : out   std_logic;
    DATA_SETUP_EVENT : out   std_logic;
    CLK_RISE_EVENT   : out   std_logic;
    CLK_FALL_EVENT   : out   std_logic;
    DATA_HOLD_EVENT  : out   std_logic
  );
end entity TB_CLK;

architecture RTL of TB_CLK is

begin

  CLK              <= '0';
  DATA_SETUP_EVENT <= '0';
  CLK_RISE_EVENT   <= '0';
  CLK_FALL_EVENT   <= '0';
  DATA_HOLD_EVENT  <= '0';

  -- generate events for data setup, clock rise, data hold and clock fall times:
  DATA_SETUP_EVENT <= transport not DATA_SETUP_EVENT after CLK_CYCLE_TIME;
  CLK_RISE_EVENT   <= transport     DATA_SETUP_EVENT after DATA_SETUP_TIME;
  CLK_FALL_EVENT   <= transport     CLK_RISE_EVENT   after CLK_HIGH_TIME;
  DATA_HOLD_EVENT  <= transport     CLK_RISE_EVENT   after DATA_HOLD_TIME;

  CLK_GEN_P : process is
  begin

    wait on CLK_RISE_EVENT;
    CLK <= '1';
    wait on CLK_FALL_EVENT;
    CLK <= '0';

  end process CLK_GEN_P;

end architecture RTL;
