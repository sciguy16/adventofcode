library ieee;
  use ieee.std_logic_1164.all;

entity RESET_EXPANDER is
  port (
    RESET_IN : in    std_logic;
    CLK      : in    std_logic;

    RESET_CLK_25MHZ : in    std_logic;
    RESET_OUT_25MHZ : out   std_logic;

    RESET_CLK_50MHZ : in    std_logic;
    RESET_OUT_50MHZ : out   std_logic
  );
end entity RESET_EXPANDER;

architecture RTL of RESET_EXPANDER is
  attribute async_reg        : string;

  constant c_counter_max : natural                          := 31;
  signal   counter       : natural range 0 to c_counter_max := 0;

  signal reset_in_reg   : std_logic                    := '0';
  signal reset_latch    : std_logic                    := '0';
  signal rst_pipe_25mhz : std_logic                    := '0';
  signal rst_pipe_50mhz : std_logic_vector(2 downto 0) := (others => '0');

  -- mark pipeline register inputs as asynchronous
  attribute async_reg of rst_pipe_25MHz : signal is "TRUE";
  attribute async_reg of rst_pipe_50MHz : signal is "TRUE";

begin

  RESET_EXPANDER_PROC : process (CLK) is
  begin
    if (rising_edge(CLK)) then
      reset_in_reg <= RESET_IN;
      if (reset_in_reg = '1') then
        counter     <= 0;
        reset_latch <= '1';
      elsif (reset_latch = '1') then
        counter <= counter + 1;
      end if;
      if (counter = c_counter_max) then
        reset_latch <= '0';
      end if;
    end if;
  end process RESET_EXPANDER_PROC;

  OUTPUT_PIPE_25MHZ : process (RESET_CLK_25MHZ) is
  begin
    if rising_edge(RESET_CLK_25MHZ) then
      rst_pipe_25mhz  <= reset_latch;
      RESET_OUT_25MHZ <= rst_pipe_25mhz;
    end if;
  end process OUTPUT_PIPE_25MHZ;

  OUTPUT_PIPE_50MHZ : process (RESET_CLK_50MHZ) is
  begin
    if rising_edge(RESET_CLK_50MHZ) then
      rst_pipe_50mhz  <= rst_pipe_50mhz(rst_pipe_50mhz'high - 1 downto 0)
                         & reset_latch;
      RESET_OUT_50MHZ <= rst_pipe_50mhz(rst_pipe_50mhz'high);
    end if;
  end process OUTPUT_PIPE_50MHZ;

end architecture RTL;
