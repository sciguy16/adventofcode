library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.bin_to_bcd_pkg_hdr.all;
  use work.blk_mem_wrapper_pkg_hdr.all;

-- duplicate of day 0 for now
-- TODO implement day 1

entity DAY1 is
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
end entity DAY1;

architecture RTL of DAY1 is
  signal accumulator : unsigned(31 downto 0);
  signal bram_addr   : unsigned(BRAM_PORT_B_ADDR_WIDTH - 1 downto 0);
  signal value_reg   : std_logic_vector(15 downto 0) := (others => '0');
  signal go          : std_logic;
  signal done        : std_logic;

  signal accumulator_bcd   : t_bcd_out;
  signal bcd_digit_counter : integer range 0 to c_num_digits := 0;
  signal is_leading_zeroes : boolean                         := false;

  constant ascii_digit_prefix : std_logic_vector(3 downto 0) := x"3";

  constant ascii_l  : std_logic_vector(7 downto 0) := x"4C";
  constant ascii_r  : std_logic_vector(7 downto 0) := x"52";
  constant ascii_lf : std_logic_vector(7 downto 0) := x"0A";

  constant dial_init : signed(15 downto 0) := 16d"50";

  signal parse_enable      : boolean             := false;
  signal dial_position     : signed(15 downto 0) := (others => '0');
  signal number_to_process : std_logic_vector(15 downto 0) := (others => '0');
  signal process_go        : std_logic;
  signal process_ready     : std_logic;

  type t_direction is (DIR_LEFT, DIR_RIGHT);

  signal direction_reg        : t_direction := DIR_RIGHT;
  signal direction_to_process : t_direction := DIR_RIGHT;

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
    RUN_WAIT_PROC_IDLE,
    RUN_WRITE_RESULT,
    RUN_DONE
  );

  signal run_state : t_run_state := RUN_IDLE;

  type t_parse_state is (
    PARSE_DIRECTION,
    PARSE_DIGIT
  );

  signal parse_state : t_parse_state := PARSE_DIRECTION;

  type t_process_state is (
    PROCESS_IDLE,
    PROCESS_MOVE_DIAL,
    PROCESS_DO_MOD
  );

  signal process_state : t_process_state := PROCESS_IDLE;

  attribute mark_debug : string;
  attribute mark_debug of accumulator       : signal is "TRUE";
  attribute mark_debug of bram_addr         : signal is "TRUE";
  attribute mark_debug of value_reg         : signal is "TRUE";
  attribute mark_debug of go                : signal is "TRUE";
  attribute mark_debug of done              : signal is "TRUE";
  attribute mark_debug of accumulator_bcd   : signal is "TRUE";
  attribute mark_debug of bcd_digit_counter : signal is "TRUE";
  attribute mark_debug of ctrl_state        : signal is "TRUE";
  attribute mark_debug of run_state         : signal is "TRUE";

begin

  BRAM_ADDR_FROM_UNSIGNED : process (all) is
  begin
    BRAM_ADDR_OUT <= std_logic_vector(bram_addr);
  end process BRAM_ADDR_FROM_UNSIGNED;

  -- Parse the numbers from decimal and sum them
  DAY1_CTRL_PROC : process (CLK) is
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
  end process DAY1_CTRL_PROC;

  DAY1_RUN_PROC : process (CLK) is
    variable current_bcd_nibble : std_logic_vector(3 downto 0);
  begin
    if rising_edge(CLK) then
      done                  <= '0';
      BRAM_WRITE_ENABLE_OUT <= '0';

      case run_state is

        when RUN_IDLE =>
          bram_addr         <= (others => '0');
          bcd_digit_counter <= 0;
          if (go = '1') then
            -- preemptively increment bram_addr since the bram read output
            -- is one cycle behind
            bram_addr    <= bram_addr + 1;
            run_state    <= RUN_RUNNING;
            parse_enable <= true;
          end if;

        when RUN_RUNNING =>
          if (bram_addr = DATA_LEN_BYTES_IN + 1) then
            run_state         <= RUN_WRITE_RESULT;
            is_leading_zeroes <= true;
            parse_enable      <= false;
          else
            --if (not (parse_state = PARSE_DIGIT
            --         and BRAM_READ_DATA_IN = ascii_lf
            --         and process_ready = '0')) then
              bram_addr <= bram_addr + 1;
            --end if;
            run_state <= RUN_RUNNING;
          end if;

        when RUN_WAIT_PROC_IDLE =>
          if (process_state = PROCESS_IDLE) then
            run_state <= RUN_WRITE_RESULT;
          else
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
        bram_addr             <= (others => '0');
        run_state             <= RUN_IDLE;
        parse_enable          <= false;
      end if;
    end if;
  end process DAY1_RUN_PROC;

  PARSE_PROC : process (CLK) is
    variable current_char      : std_logic_vector(7 downto 0);
    variable current_digit_int : signed(7 downto 0);
  begin
    if (rising_edge(CLK)) then
      -- Read digit from bram
      current_char      := BRAM_READ_DATA_IN;
      current_digit_int := x"0" & signed(current_char(3 downto 0));
      process_go        <= '0';

      if (parse_enable) then
        case parse_state is

          when PARSE_DIRECTION =>
            -- Parse the direction value (left/right)
            case current_char is

              when ascii_l =>
                direction_reg <= DIR_LEFT;

              when ascii_r =>
                direction_reg <= DIR_RIGHT;

              when others =>
                direction_reg <= DIR_LEFT;
            end case;

            value_reg   <= (others => '0');
            parse_state <= PARSE_DIGIT;

          when PARSE_DIGIT =>
            -- If it's a newline then process the command, otherwise
            -- base 10-shift it into the number register
            if (current_char = ascii_lf) then
              -- wait until the process FSM is ready, since the modulo operation
              -- can take several clocks to complete
              --if (process_ready = '1') then
                process_go           <= '1';
                number_to_process    <= value_reg;
                direction_to_process <= direction_reg;

                value_reg   <= (others => '0');
                parse_state <= PARSE_DIRECTION;
              --else
                --parse_state <= PARSE_DIGIT;
              --end if;
            else
              -- store BCD value in value_reg
              value_reg <= value_reg(11 downto 0) & current_char(3 downto 0);
              --value_reg   <= resize(value_reg * 10, value_reg'length)
              --               + current_digit_int;
              parse_state <= PARSE_DIGIT;
            end if;
        end case;
      else
        parse_state <= PARSE_DIRECTION;
        value_reg   <= (others => '0');
      end if;

      if (RESET = '1' or run_state = RUN_IDLE) then
        parse_state <= PARSE_DIRECTION;
        value_reg   <= (others => '0');
      end if;
    end if;
  end process PARSE_PROC;

  PROCESSING_PROC : process (CLK) is
  variable v_hundreds: std_logic_vector(3 downto 0);
  variable v_tens: std_logic_vector(3 downto 0);
  variable v_units: std_logic_vector(3 downto 0);
  variable v_to_rotate_by: unsigned(7 downto 0);
  begin
    if (rising_edge(CLK)) then
      process_ready <= '0';

      v_hundreds := number_to_process(11 downto 8);
      v_tens := number_to_process(7 downto 4);
      v_units := number_to_process(3 downto 0);
      v_to_rotate_by := unsigned(v_tens) * 10 + unsigned(v_units);

      case process_state is

        when PROCESS_IDLE =>
          if (process_go) then
            process_state <= PROCESS_MOVE_DIAL;
          else
            process_state <= PROCESS_IDLE;
            process_ready <= '1';
          end if;

        when PROCESS_MOVE_DIAL =>
          -- Add/subtract tens and units from dial position. Hundreds
          -- field has no impact
          report "Rotate by: " & integer'image(to_integer(v_to_rotate_by));
          case direction_to_process is

            when DIR_LEFT =>
              dial_position <= dial_position - to_integer(resize(v_to_rotate_by,16));

            when DIR_RIGHT =>
              dial_position <= dial_position + to_integer(resize(v_to_rotate_by,16));
          end case;
          process_state <= PROCESS_DO_MOD;

        when PROCESS_DO_MOD =>
          -- If the dial has rotated past zero then increment the counter. Oh
          -- wait, that's part 2. For now, if the dial position is congruent
          -- to zero mod 100 then increment the counter

          if (dial_position = 0
            or dial_position = 100
            or dial_position = -100
          ) then
            accumulator <= accumulator + 1;
          end if;

          if (dial_position > 99) then
            -- accumulator   <= accumulator + 1;
            dial_position <= dial_position - 100;
            --process_state <= PROCESS_DO_MOD;
          elsif (dial_position < 0) then
            -- accumulator   <= accumulator + 1;
            dial_position <= dial_position + 100;
            --process_state <= PROCESS_DO_MOD;
          --else
          end if;
            process_state <= PROCESS_IDLE;
      end case;

      if (RESET = '1' or run_state = RUN_IDLE) then
        dial_position <= dial_init;
        accumulator   <= (others => '0');
        process_state <= PROCESS_IDLE;
      end if;
    end if;
  end process PROCESSING_PROC;

  BIN_TO_BCD_INST : entity work.bin_to_bcd(rtl)
    port map (
      BIN_IN  => accumulator,
      BCD_OUT => accumulator_bcd
    );

end architecture RTL;
