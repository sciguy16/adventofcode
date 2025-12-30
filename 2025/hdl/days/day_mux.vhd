library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package day_mux_pkg_hdr is
  constant C_NUM_DAYS: natural := 1;
end package day_mux_pkg_hdr;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.day_mux_pkg_hdr.ALL;

entity day_mux is
  port(
    reset : in std_logic;
    clk   : in std_logic;

    day_sel_IN: in unsigned(7 downto 0);
    data_len_bytes_IN: in unsigned(11 downto 0);
    day_done_OUT: out std_logic;

    -- Port B controls --
    bram_addr_b_OUT: OUT std_logic_vector(11 downto 0);
    bram_write_data_b_OUT: OUT std_logic_vector(7 downto 0);
    bram_read_data_b_IN: IN std_logic_vector(7 downto 0);
    bram_port_b_write_enable_OUT: OUT std_logic;
    bram_port_b_enabled_IN: IN std_logic
  );
end day_mux;

architecture rtl of day_mux is

  type T_BRAM_ADDR_ARR is
    array (0 to C_NUM_DAYS - 1) of std_logic_vector(11 downto 0);
  signal bram_addr_b: T_BRAM_ADDR_ARR;

  type T_BRAM_DATA_ARR is
    array (0 to C_NUM_DAYS - 1) of std_logic_vector(7 downto 0);
  signal bram_write_data_b: T_BRAM_DATA_ARR;

  signal bram_port_b_enabled: std_logic_vector(0 to C_NUM_DAYS - 1);
  signal bram_port_b_write_enable: std_logic_vector(0 to C_NUM_DAYS - 1);
  signal day_done: std_logic_vector(0 to C_NUM_DAYS - 1);
begin
  mux: process(all) is
  begin
    case day_sel_IN is
    when x"00" =>
      -- day zero
      bram_addr_b_OUT <= bram_addr_b(0);
      bram_write_data_b_OUT <= bram_write_data_b(0);
      bram_port_b_enabled <= (0 => bram_port_b_enabled_IN, others => '0');
      bram_port_b_write_enable_OUT <= bram_port_b_write_enable(0);
      day_done_OUT <= day_done(0);
    when others =>
      bram_addr_b_OUT <= x"000";
      bram_write_data_b_OUT <= x"00";
      bram_port_b_enabled <= (others => '0');
      bram_port_b_write_enable_OUT <= '0';
        day_done_OUT <= '0';
    end case;
  end process mux;

  day0_inst: entity work.day0(rtl)
  port map (
    reset => reset,
    clk => clk,

    data_len_bytes_IN => data_len_bytes_IN,
    day_done_OUT => day_done(0),

    -- Port B controls --
    bram_addr_b_OUT => bram_addr_b(0),
    bram_write_data_b_OUT => bram_write_data_b(0),
    bram_read_data_b_IN => bram_read_data_b_IN,
    bram_port_b_write_enable_OUT => bram_port_b_write_enable(0),
    bram_port_b_enabled_IN => bram_port_b_enabled(0)
  );
end rtl;
