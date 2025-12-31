library ieee;
  use ieee.std_logic_1164.all;

entity RESET_EXPANDER_TB is
end entity RESET_EXPANDER_TB;

architecture RTL of RESET_EXPANDER_TB is

  -- 25 MHz clock, 40 ns period
  constant c_half_period_25_mhz    : time := 20 ns;
  -- 50 MHz clock, 20 ns period
  constant c_half_period_50_mhz    : time := 10 ns;
  -- 50 MHz clock, 20 ns period
  constant c_quarter_period_50_mhz : time := 5 ns;

  signal clk_25mhz   : std_logic := '1';
  signal clk_50mhz   : std_logic := '1';
  signal reset_in    : std_logic := '0';
  signal reset_25mhz : std_logic;
  signal reset_50mhz : std_logic;

  signal clocks    : std_logic_vector(1 downto 0);
  signal reset_out : std_logic_vector(1 downto 0);

begin

  UUT : entity work.reset_expander(rtl)
    port map (
      RESET_IN => reset_in,
      CLK      => clk_25mhz,

      RESET_OUT_25MHZ => reset_25mhz,
      RESET_CLK_25MHZ => clk_25mhz,

      RESET_OUT_50MHZ => reset_50mhz,
      RESET_CLK_50MHZ => clk_50mhz
    );

  clk_25mhz <= not clk_25mhz after c_half_period_25_mhz;
  clk_50mhz <= not clk_50mhz after c_half_period_50_mhz;

  clocks    <= clk_25mhz & clk_50mhz;
  reset_out <= reset_25mhz & reset_50mhz;

  STIMULUS : process is

    alias uut_reset_in_reg   is << signal uut.reset_in_reg : std_logic >>;
    alias uut_reset_latch    is << signal uut.reset_latch : std_logic >>;
    alias uut_counter        is << signal uut.counter : natural >>;
    alias uut_rst_pipe_25mhz is << signal uut.rst_pipe_25MHz : std_logic >>;
    alias uut_rst_pipe_50mhz is
        << signal uut.rst_pipe_50MHz : std_logic_vector(2 downto 0) >>;

  begin

    reset_in <= '0';

    wait for 40 ns;
    wait until falling_edge(clk_25mhz);

    reset_in <= '1';
    wait until falling_edge(clk_25mhz);
    wait until falling_edge(clk_50mhz) and clk_25mhz = '0';
    assert uut_reset_in_reg = '1'
      report "uut_reset_in_reg";
    assert uut_reset_latch = '0'
      report "uut_reset_latch";

    reset_in <= '0';
    wait until falling_edge(clk_50mhz); -- t=130 ns
    assert uut_reset_in_reg = '0'
      report "uut_reset_in_reg";
    assert uut_reset_latch = '1'
      report "uut_reset_latch";
    assert uut_rst_pipe_25mhz = '0'
      report "rst pipe 25MHz is clear";
    assert uut_rst_pipe_50mhz = "000"
      report "rst pipe 50MHz is clear";
    assert reset_out = "00"
      report "Reset out should not be asserted yet";

    wait until falling_edge(clk_50mhz);
    -- allow signals to settle after the clock edges
    wait for c_quarter_period_50_mhz; -- t=155 ns
    assert clocks = "00"
      report "both clocks are low";
    assert uut_rst_pipe_25mhz = '0'
      report "rst pipe 25MHz is clear";
    assert uut_rst_pipe_50mhz = "001"
      report "rst pipe 50MHz clocked in 1";

    wait for c_half_period_50_mhz; -- t=165 ns
    assert clocks = "11"
      report "both clocks have just had a rising edge";
    assert uut_rst_pipe_25mhz = '1'
      report "rst pipe 25MHz clocked in 1";
    assert uut_rst_pipe_50mhz = "011"
      report "rst pipe 50MHz clocked in 2";

    wait for c_half_period_50_mhz; -- t=175 ns
    assert clocks = "10"
      report "50 MHz falling edge";
    assert uut_rst_pipe_25mhz = '1'
      report "rst pipe 25MHz unchanged";
    assert uut_rst_pipe_50mhz = "011"
      report "rst pipe 50MHz unchanged";

    wait for c_half_period_50_mhz; -- t=185 ns
    assert clocks = "01"
      report "25 MHz falling edge, 50 MHz rising edge";
    assert uut_rst_pipe_25mhz = '1'
      report "rst pipe 25MHz clocked in 1";
    assert uut_rst_pipe_50mhz = "111"
      report "rst pipe 50MHz clocked in 3";

    wait for c_half_period_50_mhz; -- t=195 ns
    assert clocks = "00"
      report "50 MHz falling edge";
    assert uut_rst_pipe_25mhz = '1'
      report "rst pipe 25MHz unchanged";
    assert uut_rst_pipe_50mhz = "111"
      report "rst pipe 50MHz unchanged";
    assert reset_out = "00"
      report "Reset out should not be asserted yet";

    wait for c_half_period_50_mhz; -- t=205 ns
    assert clocks = "11"
      report "both clocks have just had a rising edge";
    assert uut_rst_pipe_25mhz = '1'
      report "rst pipe 25MHz clocked in 2";
    assert uut_rst_pipe_50mhz = "111"
      report "rst pipe 50MHz clocked in 4";
    assert reset_out = "11"
      report "Reset out should be asserted";

    wait until falling_edge(clk_25mhz);
    wait until falling_edge(clk_25mhz);
    assert uut_rst_pipe_25mhz = '1'
      report "rst pipe 25MHz unchanged";
    assert uut_rst_pipe_50mhz = "111"
      report "rst pipe 50MHz unchanged";
    assert reset_out = "11"
      report "Reset out should still be asserted";
    wait until falling_edge(clk_25mhz);
    wait until falling_edge(clk_25mhz);
    assert uut_rst_pipe_25mhz = '1'
      report "rst pipe 25MHz unchanged";
    assert uut_rst_pipe_50mhz = "111"
      report "rst pipe 50MHz unchanged";
    assert reset_out = "11"
      report "Reset out should still be asserted";

    wait until falling_edge(uut_reset_latch);

    -- allow signals to settle after the clock edges
    wait for c_quarter_period_50_mhz; -- t=1405 ns
    assert clocks = "11"
      report "both clocks have just had a rising edge";
    assert uut_counter = 32
      report "counter one more than max";
    assert uut_rst_pipe_25mhz = '1'
      report "rst pipe 25MHz unchanged";
    assert uut_rst_pipe_50mhz = "111"
      report "rst pipe 50MHz unchanged";

    wait for c_half_period_50_mhz; -- t=1415 ns
    assert clocks = "10"
      report "50 MHz falling edge";
    assert uut_rst_pipe_25mhz = '1'
      report "rst pipe 25MHz unchanged";
    assert uut_rst_pipe_50mhz = "111"
      report "rst pipe 50MHz unchanged";

    wait for c_half_period_50_mhz; -- t=1425 ns
    assert clocks = "01"
      report "25 MHz falling edge, 50 MHz rising edge";
    assert uut_rst_pipe_25mhz = '1'
      report "rst pipe 25MHz unchanged";
    assert uut_rst_pipe_50mhz = "110"
      report "rst pipe 50MHz clocked out 1";

    wait for c_half_period_50_mhz; -- t=1435 ns
    assert clocks = "00"
      report "50 MHz falling edge";
    wait for c_half_period_50_mhz; -- t=1445 ns
    assert clocks = "11"
      report "25 MHz rising edge, 50 MHz rising edge";
    assert uut_rst_pipe_25mhz = '0'
      report "rst pipe 25MHz clocked out 1";
    assert uut_rst_pipe_50mhz = "100"
      report "rst pipe 50MHz clocked out 2";

    wait for c_half_period_50_mhz; -- t=1455 ns
    assert clocks = "10"
      report "50 MHz falling edge";
    wait for c_half_period_50_mhz; -- t=1465 ns
    assert clocks = "01"
      report "25 MHz falling edge, 50 MHz rising edge";
    assert uut_rst_pipe_25mhz = '0'
      report "rst pipe 25MHz unchanged";
    assert uut_rst_pipe_50mhz = "000"
      report "rst pipe 50MHz clocked out 3";
    assert reset_out = "11"
      report "Reset out should still be asserted";

    wait for c_half_period_50_mhz; -- t=1475 ns
    assert clocks = "00"
      report "50 MHz falling edge";
    wait for c_half_period_50_mhz; -- t=1485 ns
    assert clocks = "11"
      report "25 MHz rising edge, 50 MHz rising edge";
    assert uut_rst_pipe_25mhz = '0'
      report "rst pipe 25MHz clocked out 2";
    assert uut_rst_pipe_50mhz = "000"
      report "rst pipe 50MHz clocked out 4";
    assert reset_out = "00"
      report "Reset out should be deasserted";

    wait until falling_edge(clk_25mhz);
    assert reset_out = "00"
      report "Reset out should still be deasserted";
    wait until falling_edge(clk_25mhz);
    assert reset_out = "00"
      report "Reset out should still be deasserted";
    wait until falling_edge(clk_25mhz);
    assert reset_out = "00"
      report "Reset out should still be deasserted";

    std.env.stop;

  end process STIMULUS;

end architecture RTL;
