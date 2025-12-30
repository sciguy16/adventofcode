library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity day_mux_tb is
end day_mux_tb;

architecture rtl of day_mux_tb is
  constant c_HALF_PERIOD_25_MHz : time := 20 ns; -- 25 MHz clock, 40 ns period

  signal clk   : std_logic := '1';
  signal reset : std_logic := '1';

	signal day_sel_IN: unsigned(7 downto 0) := x"ff";
	signal data_len_bytes_IN: unsigned(11 downto 0) := x"000";
	signal day_done_OUT: std_logic;
	signal bram_addr_b_OUT: std_logic_vector(11 downto 0);
	signal bram_write_data_b_OUT: std_logic_vector(7 downto 0);
	signal bram_read_data_b_IN: std_logic_vector(7 downto 0) := x"00";
	signal bram_port_b_write_enable_OUT: std_logic;
	signal bram_port_b_enabled_IN: std_logic := '0';

  procedure wait_edge is
  begin
    wait until rising_edge(clk);
    wait for 2 ns;
  end procedure wait_edge;
begin
  uut: entity work.day_mux(rtl)
  port map(
    reset => reset,
    clk   => clk,

    day_sel_IN => day_sel_IN,
    data_len_bytes_IN => data_len_bytes_IN,
    day_done_OUT => day_done_OUT,

    -- Port B controls --
    bram_addr_b_OUT => bram_addr_b_OUT,
    bram_write_data_b_OUT => bram_write_data_b_OUT,
    bram_read_data_b_IN => bram_read_data_b_IN,
    bram_port_b_write_enable_OUT => bram_port_b_write_enable_OUT,
    bram_port_b_enabled_IN => bram_port_b_enabled_IN
  );

  clk <= not clk after c_HALF_PERIOD_25_MHz;

  stimulus : process
  begin
  	for idx in 0 to 3 loop
  		wait_edge;
  	end loop;
  	reset <= '0';
  	wait_edge;

  	assert day_done_out = '0' report "day done out init";

  	day_sel_IN <= x"00";
  	bram_port_b_enabled_IN <= '1';

  	wait_edge;
  	assert day_done_out = '1' report "day done out end";


  	-- async mux
  	day_sel_IN <= x"ff";
  	assert day_done_out = '1' report "day done out end";

  	for idx in 0 to 3 loop
  		wait_edge;
  	end loop;
  	std.env.stop;

  end process stimulus;
end rtl;
