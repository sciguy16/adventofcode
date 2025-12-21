library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reset_expander is
    port(
        reset_in: in std_logic;
        clk: in std_logic;

        reset_clk_25MHz: in std_logic;
        reset_out_25MHz: out std_logic;

        reset_clk_50MHz: in std_logic;
        reset_out_50MHz: out std_logic
    );
end reset_expander;

architecture rtl of reset_expander is
    constant C_COUNTER_MAX: natural := 31;
    signal counter: natural range 0 to C_COUNTER_MAX := 0;
    signal reset_in_reg: std_logic := '0';
    signal reset_latch: std_logic := '0';
    signal rst_pipe_25MHz: std_logic_vector(1 downto 0) := (others => '0');
    signal rst_pipe_50MHz: std_logic_vector(3 downto 0) := (others => '0');
begin
    process(clk, reset_in) is
    begin
        if(rising_edge(clk)) then
            reset_in_reg <= reset_in;
            if (reset_in_reg = '1') then
                counter <= 0;
                reset_latch <= '1';
            elsif reset_latch = '1' then
                counter <= counter + 1;
            end if;

            if (counter = C_COUNTER_MAX) then
                reset_latch <= '0';
            end if;
        end if;
    end process;

    process(reset_clk_25MHz) is
    begin
        if rising_edge(reset_clk_25MHz) then
            rst_pipe_25MHz <=
                rst_pipe_25MHz(rst_pipe_25MHz'high-1 downto 0)
                & reset_latch;
            reset_out_25MHz <= rst_pipe_25MHz(rst_pipe_25MHz'high-1);
        end if;
    end process;

    process(reset_clk_50MHz) is
    begin
        if rising_edge(reset_clk_50MHz) then
            rst_pipe_50MHz <=
                rst_pipe_50MHz(rst_pipe_50MHz'high-1 downto 0)
                & reset_latch;
            reset_out_50MHz <= rst_pipe_50MHz(rst_pipe_50MHz'high-1);
        end if;
    end process;
end rtl;
