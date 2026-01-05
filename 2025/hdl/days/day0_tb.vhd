library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.blk_mem_wrapper_pkg_hdr.all;

entity day0_tb is
end entity day0_tb;

architecture RTL of DAY0_TB is
  -- 25 MHz clock, 40 ns period
  constant c_half_period_25_mhz : time := 20 ns;

  signal clk   : std_logic := '1';
  signal reset : std_logic := '1';

  signal data_len_bytes_in : unsigned(BRAM_PORT_B_ADDR_WIDTH - 1 downto 0);
  signal day_done_out      : std_logic;
  signal bram_addr         : t_addr_b;
  signal bram_write_data   : std_logic_vector(7 downto 0);
  signal bram_read_data    : std_logic_vector(7 downto 0) := x"00";

  signal bram_write_enable : std_logic;
  signal bram_enabled_in   : std_logic := '0';

  signal part_a_output : std_logic_vector(31 downto 0);
  signal part_b_output : std_logic_vector(31 downto 0);

  signal verbose : boolean := false;

  procedure wait_edge is
  begin
    wait until rising_edge(clk);
    wait for 2 ns;
  end procedure wait_edge;

  procedure wait_eq (
    signal value : in std_logic;
    expected     : in std_logic;
    message      : in string
  ) is
    variable clock_count : integer := 0;

  begin
    if (verbose) then
      report "wait for: " & message
        severity note;
    end if;
    wait_edge;

    while value /= expected loop
      wait_edge;
      clock_count := clock_count + 1;
      if (clock_count = 10) then
        report "condition not met after timeout: " & message
          severity failure;
        exit;
      end if;
    end loop;
  end procedure wait_eq;

  subtype byte is std_logic_vector(7 downto 0);

  function to_byte (c : character) return byte is
  begin
    return byte(to_unsigned(character'pos(c), 8));
  end function to_byte;

  function to_character (b: byte) return character is
  begin
    return character'val(to_integer(unsigned(b)));
  end function to_character;

  constant input : string := "10" & LF & "22" & LF & "322" & LF;
-- expected sum is 354

begin

  UUT : entity work.day0(rtl)
    port map (
      RESET => reset,
      CLK   => clk,

      DATA_LEN_BYTES_IN => data_len_bytes_in,
      DAY_DONE_OUT      => day_done_out,
      PART_A_OUT        => part_a_output,
      PART_B_OUT        => part_b_output,

      -- Port B controls --
      BRAM_ADDR_OUT         => bram_addr,
      BRAM_WRITE_DATA_OUT   => bram_write_data,
      BRAM_READ_DATA_IN     => bram_read_data,
      BRAM_WRITE_ENABLE_OUT => bram_write_enable,
      BRAM_ENABLED_IN       => bram_enabled_in
    );

  clk <= not clk after c_half_period_25_mhz;

  STIMULUS : process is
    variable expected_bram_addr : unsigned(BRAM_PORT_B_ADDR_WIDTH - 1 downto 0);
    variable result             : std_logic_vector(31 downto 0);
  begin
    data_len_bytes_in <= (others => '0');

    for idx in 0 to 3 loop
      wait_edge;
    end loop;
    reset <= '0';
    wait_edge;

    assert day_done_out = '0'
      report "day done out init";

    data_len_bytes_in <= 15x"000A";
    bram_enabled_in   <= '1';

    wait_edge;

    for chr in 1 to 10 loop
      wait_edge;
      expected_bram_addr := to_unsigned(chr, expected_bram_addr'length) - 1;
      assert bram_addr = std_logic_vector(expected_bram_addr)
        report "bram addr isn't "
               & integer'image(to_integer(expected_bram_addr))
               & ", chr index is: "
               & integer'image(chr);
      bram_read_data     <= to_byte(INPUT(chr));
    end loop;
    result := (others => '0');

    wait_eq(day_done_out, '1', "day done out");
    assert day_done_out = '1'
      report "day done out end";

    assert part_a_output = x"0000_0354"
      report "PART_A_OUT";
    assert part_b_output = x"0000_0354"
      report "PART_B_OUT";

    bram_enabled_in <= '0';

    for idx in 0 to 3 loop
      wait_edge;
    end loop;
    std.env.stop;
  end process STIMULUS;

end architecture RTL;
