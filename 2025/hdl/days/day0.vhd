library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity DAY0 is
  port (
    RESET : in    std_logic;
    CLK   : in    std_logic;

    DATA_LEN_BYTES_IN : in    unsigned(11 downto 0);
    DAY_DONE_OUT      : out   std_logic;

    -- Port B controls --
    BRAM_ADDR_B_OUT              : out   std_logic_vector(11 downto 0);
    BRAM_WRITE_DATA_B_OUT        : out   std_logic_vector(7 downto 0);
    BRAM_READ_DATA_B_IN          : in    std_logic_vector(7 downto 0);
    BRAM_PORT_B_WRITE_ENABLE_OUT : out   std_logic;
    BRAM_PORT_B_ENABLED_IN       : in    std_logic
  );
end entity DAY0;

architecture RTL of DAY0 is

  signal accumulator : unsigned(31 downto 0);

  type t_state is (
    STATE_IDLE,
    STATE_RUNNING
  );

  signal state : t_state := STATE_IDLE;

begin

  DAY0_PROC : process (CLK) is
  begin

    if rising_edge(CLK) then
      if (BRAM_PORT_B_ENABLED_IN = '1') then
        DAY_DONE_OUT <= '1';
      else
        DAY_DONE_OUT <= '0';
      end if;

      if (RESET = '1') then
        DAY_DONE_OUT                 <= '0';
        BRAM_ADDR_B_OUT              <= x"000";
        BRAM_WRITE_DATA_B_OUT        <= x"00";
        BRAM_PORT_B_WRITE_ENABLE_OUT <= '0';
        accumulator                  <= x"00000000";
      end if;
    end if;

  end process DAY0_PROC;

end architecture RTL;
