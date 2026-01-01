library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity DAY_MUX_TB is
end entity DAY_MUX_TB;

architecture RTL of DAY_MUX_TB is

  -- 25 MHz clock, 40 ns period
  constant c_half_period_25_mhz : time := 20 ns;

  signal clk   : std_logic := '1';
  signal reset : std_logic := '1';

  signal day_sel_in            : unsigned(7 downto 0)         := x"FF";
  signal data_len_bytes_in     : unsigned(11 downto 0)        := x"000";
  signal day_done_out          : std_logic;
  signal bram_addr_out         : std_logic_vector(11 downto 0);
  signal bram_write_data_out   : std_logic_vector(7 downto 0);
  signal bram_read_data_in     : std_logic_vector(7 downto 0) := x"00";
  signal bram_write_enable_out : std_logic;
  signal bram_enabled_in       : std_logic                    := '0';

  procedure wait_edge is
  begin

    wait until rising_edge(clk);
    wait for 2 ns;

  end procedure wait_edge;

begin

  UUT : entity work.day_mux_top_level(rtl)
    port map (
      RESET => reset,
      CLK   => clk,

      DAY_SEL_IN        => day_sel_in,
      DATA_LEN_BYTES_IN => data_len_bytes_in,
      DAY_DONE_OUT      => day_done_out,

      -- Port B controls --
      BRAM_ADDR_OUT         => bram_addr_out,
      BRAM_WRITE_DATA_OUT   => bram_write_data_out,
      BRAM_READ_DATA_IN     => bram_read_data_in,
      BRAM_WRITE_ENABLE_OUT => bram_write_enable_out,
      BRAM_ENABLED_IN       => bram_enabled_in
    );

  clk <= not clk after c_half_period_25_mhz;

  STIMULUS : process is
  begin

    for idx in 0 to 3 loop

      wait_edge;

    end loop;

    reset <= '0';
    wait_edge;

    assert day_done_out = '0'
      report "day done out init";

    day_sel_in      <= x"00";
    bram_enabled_in <= '1';

    wait_edge;
    assert day_done_out = '1'
      report "day done out end";

    -- async mux
    day_sel_in <= x"FF";
    wait for 1 ps;
    assert day_done_out = '0'
      report "day done out end";

    for idx in 0 to 3 loop

      wait_edge;

    end loop;

    std.env.stop;

  end process STIMULUS;

end architecture RTL;
