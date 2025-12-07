library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hb is
      Generic (
        g_PERIOD: natural := 25000000
      );
    port(
        reset: in std_logic;
        clk: in std_logic;
        hb_led: out std_logic
    );
end hb;

architecture rtl of hb is
    signal counter: integer := 0;
    begin
    process(clk, reset) is
    begin
        if(rising_edge(clk)) then
            if (reset = '1') then
                hb_led <= '0';
                counter <= 0;
            else
                counter <= counter + 1;
                if (counter <= g_PERIOD/2 - 1) then
                    hb_led <= '1';
                else
                    hb_led <= '0';
                end if;

                if(counter = g_PERIOD - 1) then
                    counter <= 0;
                end if;
            end if;
        end if;
    end process;

end rtl;
