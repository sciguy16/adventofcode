library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package day_mux_top_level_pkg_hdr is

  constant c_num_days : natural := 1;

  type t_bram_addr_arr is
    array (0 to C_NUM_DAYS - 1) of std_logic_vector(11 downto 0);

  type t_bram_data_arr is
    array (0 to C_NUM_DAYS - 1) of std_logic_vector(7 downto 0);

  type t_std_logic_arr is array(0 to C_NUM_DAYS - 1) of std_logic;

end package day_mux_top_level_pkg_hdr;
