library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reset_expander is
    port(
        reset_in: in std_logic;
        reset_out: out std_logic;
        clk: in std_logic
    );
end reset_expander;

architecture rtl of reset_expander is
    constant C_COUNTER_MAX: natural := 63;
    signal counter: natural range 0 to 63 := 0;
begin
    process(clk, reset_in) is
    begin
        if(rising_edge(clk)) then
            if (reset_in = '1') then
                counter <= 0;
                reset_out <= '1';
            else
                if (counter = C_COUNTER_MAX) then
                    reset_out <= '0';
                else
                    reset_out <= '1';
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;
end rtl;
