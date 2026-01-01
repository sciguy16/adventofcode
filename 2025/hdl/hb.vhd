library ieee;
  use ieee.std_logic_1164.all;

entity HB is
  generic (
    G_PERIOD : natural := 25000000
  );
  port (
    RESET  : in    std_logic;
    CLK    : in    std_logic;
    HB_LED : out   std_logic
  );
end entity HB;

architecture RTL of HB is
  signal counter : integer := 0;

begin

  HB_PROC : process (CLK) is
  begin
    if (rising_edge(CLK)) then
      counter <= counter + 1;
      if (counter <= G_PERIOD / 2 - 1) then
        HB_LED <= '1';
      else
        HB_LED <= '0';
      end if;
      if (counter = G_PERIOD - 1) then
        counter <= 0;
      end if;
      if (RESET = '1') then
        HB_LED  <= '1';
        counter <= 0;
      end if;
    end if;
  end process HB_PROC;

end architecture RTL;
