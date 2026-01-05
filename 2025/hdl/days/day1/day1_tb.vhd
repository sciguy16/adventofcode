library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.blk_mem_wrapper_pkg_hdr.all;

entity day1_tb is
end entity day1_tb;

architecture RTL of DAY1_TB is
  -- 25 MHz clock, 40 ns period
  constant c_half_period_25_mhz : time := 20 ns;

  constant input : string := "L68" & LF
                             & "L30" & LF
                             & "R48" & LF
                             & "L5" & LF
                             & "R60" & LF
                             & "L55" & LF
                             & "L1" & LF
                             & "L99" & LF
                             & "R14" & LF
                             & "L82" & LF
                             & "L32" & LF
                             & "L310" & LF
                             & "R10" & LF
                             & "L310" & LF;
  -- expected count is 3

  subtype byte is std_logic_vector(7 downto 0);

  function to_byte (c : character) return byte is
  begin
    return byte(to_unsigned(character'pos(c), 8));
  end function to_byte;

  function to_character (b: byte) return character is
  begin
    return character'val(to_integer(unsigned(b)));
  end function to_character;

  signal clk   : std_logic := '1';
  signal reset : std_logic := '1';

  signal data_len_bytes_in : unsigned(14 downto 0) := (others => '0');
  signal day_done_out      : std_logic;

  signal bram_addr_b         : t_addr_b;
  signal bram_write_data_b   : std_logic_vector(7 downto 0);
  signal bram_read_data_b    : std_logic_vector(7 downto 0);
  signal bram_write_enable_b : std_logic;
  signal bram_enabled_b      : std_logic;

  signal bram_addr_b_uut         : t_addr_b;
  signal bram_write_data_b_uut   : std_logic_vector(7 downto 0);
  signal bram_read_data_b_uut    : std_logic_vector(7 downto 0);
  signal bram_write_enable_b_uut : std_logic;

  signal bram_addr_b_preload         : t_addr_b  := (others => '0');
  signal bram_write_data_b_preload   : byte      := (others => '0');
  signal bram_read_data_b_preload    : byte;
  signal bram_write_enable_b_preload : std_logic := '0';

  signal bram_mux_uut_npreload : std_logic := '0';

  signal bram_preload : std_logic := '0';
  signal day1_go      : std_logic := '0';

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

begin

  UUT : entity work.day1(rtl)
    port map (
      RESET => reset,
      CLK   => clk,

      DATA_LEN_BYTES_IN => data_len_bytes_in,
      DAY_DONE_OUT      => day_done_out,

      -- Port B controls --
      BRAM_ADDR_OUT         => bram_addr_b_uut,
      BRAM_WRITE_DATA_OUT   => bram_write_data_b_uut,
      BRAM_READ_DATA_IN     => bram_read_data_b_uut,
      BRAM_WRITE_ENABLE_OUT => bram_write_enable_b_uut,
      BRAM_ENABLED_IN       => day1_go
    );

  clk <= not clk after c_half_period_25_mhz;

  STIMULUS : process is
  begin
    wait_edge;
    reset <= '0';
    for idx in input'range loop
      wait_edge;
    end loop;
    assert day_done_out = '0'
      report "day done out init";

    -- preload the input into bram
    wait_eq(bram_preload, '1', "BRAM preload");

    data_len_bytes_in <= to_unsigned(input'length, data_len_bytes_in'length);
    assert bram_enabled_b = '1'
      report "bram enabled b";

    wait_edge;

    day1_go <= '1';
    wait_edge;
    day1_go <= '0';

    for idx in input'range loop
      wait_edge;
    end loop;
    for idx in 1 to 10 loop
      wait_edge;
    end loop;
    wait_eq(day_done_out, '1', "day done out");
    assert day_done_out = '1'
      report "day done out end";

    wait;
  end process STIMULUS;

  BRAM_MUX : process (all) is
  begin
    case bram_mux_uut_npreload is

      when '0' =>
        bram_addr_b              <= bram_addr_b_preload;
        bram_write_data_b        <= bram_write_data_b_preload;
        bram_read_data_b_uut     <= (others => '0');
        bram_read_data_b_preload <= bram_read_data_b;
        bram_write_enable_b      <= bram_write_enable_b_preload;

      when '1' =>
        bram_addr_b              <= bram_addr_b_uut;
        bram_write_data_b        <= bram_write_data_b_uut;
        bram_read_data_b_uut     <= bram_read_data_b;
        bram_read_data_b_preload <= (others => '0');
        bram_write_enable_b      <= bram_write_enable_b_uut;

      when others =>
        bram_addr_b              <= bram_addr_b_preload;
        bram_write_data_b        <= bram_write_data_b_preload;
        bram_read_data_b_uut     <= (others => '0');
        bram_read_data_b_preload <= (others => '0');
        bram_write_enable_b      <= bram_write_enable_b_preload;
    end case;
  end process BRAM_MUX;

  BRAM_PRELOAD_PROC : process is
    variable input_word_offset : natural;
    variable to_write          : std_logic_vector(7 downto 0);
    variable v_bram_addr       : unsigned(bram_addr_b'range);

    type t_output is array(0 to 9) of std_logic_vector(7 downto 0);

    variable v_read_output : t_output;
  begin
    bram_mux_uut_npreload <= '0';
    wait_edge;

    for idx in input'range loop
      -- expected_bram_addr := to_unsigned(idx, expected_bram_addr'length);
      -- assert bram_addr = std_logic_vector(expected_bram_addr)
      --  report "bram addr isn't "
      --         & integer'image(to_integer(expected_bram_addr))
      --         & ", chr index is: "
      --         & integer'image(idx);
      bram_addr_b_preload <= std_logic_vector(to_unsigned(
                                                          idx - 1,
                                                          bram_addr_b'length
                                                        ));

      bram_write_enable_b_preload <= '1';
      bram_write_data_b_preload   <= to_byte(INPUT(idx));

      -- report "Input is: " & input(idx);
      wait_edge;
    end loop;
    bram_write_enable_b_preload <= '0';

    wait_edge;

    -- wait_eq(bram_write_enable, '1', "bram write enable");

    wait_edge;
    bram_mux_uut_npreload <= '1';
    bram_preload          <= '1';

    -- wait for done signal, then switch the mux back and read the output back

    wait_edge;
    wait_edge;

    report "wait for day done out";
    while day_done_out = '0' loop
      wait_edge;
    -- if day_done_out = '1' then
    -- exit;
    end loop;
    bram_mux_uut_npreload <= '0';

    wait_edge;

    bram_addr_b_preload <= 15x"003A";
    wait_edge;
    assert bram_read_data_b = x"35"
      report "digit 5";

    bram_addr_b_preload <= 15x"003B";
    wait_edge;
    assert bram_read_data_b = x"00"
      report "NUL";

    -- bram_addr_b_preload <= std_logic_vector(v_bram_addr);

    -- for idx in v_read_output'range loop
    --  wait_edge;
    --  v_read_output(idx)  := bram_read_data_b;
    --  v_bram_addr         := v_bram_addr + 1;
    --  bram_addr_b_preload <= std_logic_vector(v_bram_addr);
    -- end loop;
    -- assert v_bram_addr = (
    --  x"00",
    --  x"00",
    --  x"00",
    --  x"00",
    --  x"00",
    --  x"00",
    --  x"00",
    --  x"00",
    --  x"00",
    --  x"05"
    --  )
    --  report "output mismatch";

    for idx in 0 to 3 loop
      wait_edge;
    end loop;
    report "DONE";

    std.env.stop;

    wait;
  end process BRAM_PRELOAD_PROC;

  BLK_MEM_WRAPPER_INST : entity work.blk_mem_wrapper(rtl)
    port map (
      RESET => reset,
      CLK   => clk,

      -- Port A controls --

      -- Write controls --
      S_AXI_WRITE_WORD_OFFSET_PORT_A_IN => (others => '0'),
      S_AXI_AWLEN_PORT_A_IN             => (others => '0'),
      S_AXI_AWVALID_PORT_A_IN           => '0',
      S_AXI_AWREADY_PORT_A_OUT          => open,

      -- Write data --
      S_AXI_WDATA_PORT_A_IN   => (others => '0'),
      S_AXI_WLAST_PORT_A_IN   => '0',
      S_AXI_WVALID_PORT_A_IN  => '0',
      S_AXI_WREADY_PORT_A_OUT => open,

      -- Write response --
      S_AXI_BRESP_PORT_A_OUT  => open,
      S_AXI_BVALID_PORT_A_OUT => open,
      S_AXI_BREADY_PORT_A_IN  => '0',

      -- Read controls --
      S_AXI_READ_WORD_OFFSET_PORT_A_IN => (others => '0'),
      S_AXI_ARLEN_PORT_A_IN            => (others => '0'),
      S_AXI_ARVALID_PORT_A_IN          => '0',
      S_AXI_ARREADY_PORT_A_OUT         => open,

      -- Read data --
      S_AXI_RDATA_PORT_A_OUT  => open,
      S_AXI_RRESP_PORT_A_OUT  => open,
      S_AXI_RLAST_PORT_A_OUT  => open,
      S_AXI_RVALID_PORT_A_OUT => open,
      S_AXI_RREADY_PORT_A_IN  => '0',

      -- Port B controls --
      BRAM_ADDR_B_IN              => bram_addr_b,
      BRAM_DATA_B_IN              => bram_write_data_b,
      BRAM_DATA_B_OUT             => bram_read_data_b,
      BRAM_PORT_B_WRITE_ENABLE_IN => bram_write_enable_b,
      BRAM_PORT_B_ENABLED_OUT     => bram_enabled_b
    );

end architecture RTL;
