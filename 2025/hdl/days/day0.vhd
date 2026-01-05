library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.bin_to_bcd_pkg_hdr.all;
  use work.blk_mem_wrapper_pkg_hdr.all;

entity day0 is
  port (
    RESET : in    std_logic;
    CLK   : in    std_logic;

    DATA_LEN_BYTES_IN : in    unsigned(BRAM_PORT_B_ADDR_WIDTH - 1 downto 0);
    DAY_DONE_OUT      : out   std_logic;

    -- Port B controls --
    BRAM_ADDR_OUT         : out   t_addr_b;
    BRAM_WRITE_DATA_OUT   : out   std_logic_vector(7 downto 0);
    BRAM_READ_DATA_IN     : in    std_logic_vector(7 downto 0);
    BRAM_WRITE_ENABLE_OUT : out   std_logic;
    BRAM_ENABLED_IN       : in    std_logic
  );
end entity day0;

architecture RTL of DAY0 is
  signal accumulator : unsigned(31 downto 0);
  signal bram_addr   : unsigned(BRAM_PORT_B_ADDR_WIDTH - 1 downto 0);
  signal value_reg   : unsigned(31 downto 0);
  signal go          : std_logic;
  signal done        : std_logic;

  signal accumulator_bcd   : t_bcd_out;
  signal bcd_digit_counter : integer range 0 to c_num_digits := 0;
  signal is_leading_zeroes : boolean                         := false;

  constant ascii_digit_prefix : std_logic_vector(3 downto 0) := x"3";

  type t_control_state is (
    CTRL_IDLE,
    CTRL_RUNNING,
    CTRL_DONE
  );

  signal ctrl_state : t_control_state := CTRL_IDLE;

  type t_run_state is (
    RUN_IDLE,
    -- RUN_WAIT_ONE_CLK,
    RUN_RUNNING,
    RUN_WRITE_RESULT,
    RUN_DONE
  );

  signal run_state : t_run_state := RUN_IDLE;

begin

  BRAM_ADDR_FROM_UNSIGNED : process (all) is
  begin
    BRAM_ADDR_OUT <= std_logic_vector(bram_addr);
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
    variable current_digit      : std_logic_vector(7 downto 0);
    variable current_digit_int  : unsigned(7 downto 0);
    variable current_bcd_nibble : std_logic_vector(3 downto 0);
  begin
    if rising_edge(CLK) then
      done                  <= '0';
      BRAM_WRITE_ENABLE_OUT <= '0';

      case run_state is

        when RUN_IDLE =>
          bram_addr         <= (others => '0');
          accumulator       <= (others => '0');
          value_reg         <= (others => '0');
          bcd_digit_counter <= 0;
          if (go = '1') then
            -- preemptively increment bram_addr since the bram read output
            -- is one cycle behind
            bram_addr <= bram_addr + 1;
            run_state <= RUN_RUNNING;
          end if;

        -- when RUN_WAIT_ONE_CLK =>
        --  -- wait one clock to allow the bram address update to return new
        --  -- data through its pipeline
        --  bram_addr <= bram_addr + 1;
        --  run_state <= RUN_RUNNING;

        when RUN_RUNNING =>
          -- Read digit from bram
          current_digit     := BRAM_READ_DATA_IN;
          current_digit_int := x"0" & unsigned(current_digit(3 downto 0));

          -- If it's a newline then add register to accumulator, otherwise
          -- shift it into the register
          if (current_digit = x"0A") then
            accumulator <= accumulator + value_reg;
            value_reg   <= (others => '0');
          else
            value_reg <= resize(value_reg * 10, 32) + current_digit_int;
          end if;
          if (bram_addr = DATA_LEN_BYTES_IN + 1) then
            run_state         <= RUN_WRITE_RESULT;
            is_leading_zeroes <= true;
          else
            bram_addr <= bram_addr + 1;
            run_state <= RUN_RUNNING;
          end if;

        when RUN_WRITE_RESULT =>
          BRAM_WRITE_ENABLE_OUT <= '1';
          -- Write the BCD-encoded result into the next section of BRAM
          if (bcd_digit_counter = c_num_digits) then
            run_state           <= RUN_DONE;
            bram_addr           <= bram_addr + 1;
            BRAM_WRITE_DATA_OUT <= x"00";
          else
            current_bcd_nibble := accumulator_bcd(bcd_digit_counter);
            if (not is_leading_zeroes or current_bcd_nibble /= x"0") then
              is_leading_zeroes   <= false;
              BRAM_WRITE_DATA_OUT <= ascii_digit_prefix
                                     & current_bcd_nibble;
              bram_addr           <= bram_addr + 1;
            end if;
            bcd_digit_counter <= bcd_digit_counter + 1;
            run_state         <= RUN_WRITE_RESULT;
          end if;

        when RUN_DONE =>
          run_state <= RUN_IDLE;
          done      <= '1';
      end case;

      if (RESET = '1') then
        BRAM_WRITE_DATA_OUT   <= x"00";
        BRAM_WRITE_ENABLE_OUT <= '0';
        accumulator           <= (others => '0');
        bram_addr             <= (others => '0');
        run_state             <= RUN_IDLE;
      end if;
    end if;
  end process DAY0_RUN_PROC;

  BIN_TO_BCD_INST : entity work.bin_to_bcd(rtl)
    port map (
      BIN_IN  => accumulator,
      BCD_OUT => accumulator_bcd
    );

end architecture RTL;
