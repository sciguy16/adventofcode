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
    BRAM_ADDR_B_OUT       : out   std_logic_vector(11 downto 0);
    BRAM_WRITE_DATA_B_OUT : out   std_logic_vector(7 downto 0);
    BRAM_READ_DATA_B_IN   : in    std_logic_vector(7 downto 0);
    BRAM_WRITE_ENABLE_OUT : out   std_logic;
    BRAM_ENABLED_IN       : in    std_logic
  );
end entity DAY0;

architecture RTL of DAY0 is

  signal accumulator : unsigned(31 downto 0);
  signal bram_addr   : unsigned(11 downto 0);
  signal value_reg   : unsigned(31 downto 0);
  signal go          : std_logic;
  signal done        : std_logic;

  type t_control_state is (
    CTRL_IDLE,
    CTRL_RUNNING,
    CTRL_DONE
  );

  signal ctrl_state : t_control_state := CTRL_IDLE;

  type t_run_state is (
    RUN_IDLE,
    RUN_RUNNING,
    RUN_WRITE_RESULT,
    RUN_DONE
  );

  signal run_state : t_run_state := RUN_IDLE;

begin

  BRAM_ADDR_FROM_UNSIGNED : process (all) is
  begin

    BRAM_ADDR_B_OUT <= std_logic_vector(bram_addr);

  end process BRAM_ADDR_FROM_UNSIGNED;

  -- Parse the numbers from decimal and sum them
  DAY0_CTRL_PROC : process (CLK) is
  begin

    if rising_edge(CLK) then
      DAY_DONE_OUT <= '0';
      go           <= '0';

      case ctrl_state is

        when CTRL_IDLE =>
          if (BRAM_ENABLED_IN = '1') then
            ctrl_state <= CTRL_RUNNING;
            go         <= '1';
          else
            ctrl_state <= CTRL_IDLE;
          end if;

        when CTRL_RUNNING =>

          if (done = '1') then
            ctrl_state <= CTRL_DONE;
          else
            ctrl_state <= CTRL_RUNNING;
          end if;

        when CTRL_DONE =>
          DAY_DONE_OUT <= '1';
          ctrl_state   <= CTRL_IDLE;

      end case;

      if (RESET = '1') then
        DAY_DONE_OUT <= '0';
        ctrl_state   <= CTRL_IDLE;
      end if;
    end if;

  end process DAY0_CTRL_PROC;

  DAY0_RUN_PROC : process (CLK) is

    variable current_digit     : std_logic_vector(7 downto 0);
    variable current_digit_int : unsigned(7 downto 0);

  begin

    if rising_edge(CLK) then
      done                  <= '0';
      BRAM_WRITE_ENABLE_OUT <= '0';

      case run_state is

        when RUN_IDLE =>
          bram_addr   <= x"000";
          accumulator <= x"00000000";
          value_reg   <= (others => '0');
          if (go = '1') then
            run_state <= RUN_RUNNING;
          end if;

        when RUN_RUNNING =>
          -- Read digit from bram
          current_digit     := BRAM_READ_DATA_B_IN;
          current_digit_int := x"0" & unsigned(current_digit(3 downto 0));

          -- If it's a newline then add register to accumulator, otherwise
          -- shift it into the register
          if (current_digit = x"0A") then
            accumulator <= accumulator + value_reg;
            value_reg   <= (others => '0');
          else
            value_reg <= resize(value_reg * 10, 32) + current_digit_int;
          end if;

          if (bram_addr = DATA_LEN_BYTES_IN) then
            run_state <= RUN_WRITE_RESULT;
          else
            bram_addr <= bram_addr + 1;
            run_state <= RUN_RUNNING;
          end if;

        when RUN_WRITE_RESULT =>
          -- for now, just write the 32-bit result value into the next
          -- four bytes of bram
          if (bram_addr = DATA_LEN_BYTES_IN + 4) then
            run_state <= RUN_DONE;
          else
            BRAM_WRITE_DATA_B_OUT <= std_logic_vector(accumulator(7 downto 0));
            BRAM_WRITE_ENABLE_OUT <= '1';
            accumulator           <= x"00" & accumulator(31 downto 8);
            bram_addr             <= bram_addr + 1;
            run_state             <= RUN_WRITE_RESULT;
          end if;

        when RUN_DONE =>
          run_state <= RUN_IDLE;
          done      <= '1';

      end case;

      if (RESET = '1') then
        BRAM_WRITE_DATA_B_OUT <= x"00";
        BRAM_WRITE_ENABLE_OUT <= '0';
        accumulator           <= x"00000000";
        bram_addr             <= x"000";
        run_state             <= RUN_IDLE;
      end if;
    end if;

  end process DAY0_RUN_PROC;

end architecture RTL;
