library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package bin_to_bcd_pkg_hdr is

  constant c_bin_width : natural := 32;

  -- Register width = n + 4×ceil(n/3)
  -- ceil( M / N ) = (M + N - 1) / N;
  -- => ceil(width/3) = (width + 3 - 1) / 3
  constant c_num_digits : natural := (c_BIN_WIDTH + 2) / 3;     -- 6
  constant c_bcd_width  : natural := 4 * c_num_digits;          -- 24
  constant c_reg_width  : natural := c_BIN_WIDTH + c_bcd_width; -- 40

  type t_bcd_out is array(0 to c_num_digits - 1)
   of std_logic_vector(3 downto 0);

end package bin_to_bcd_pkg_hdr;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.bin_to_bcd_pkg_hdr.all;

entity BIN_TO_BCD is
  port (
    BIN_IN  : in    unsigned(c_BIN_WIDTH - 1 downto 0);
    BCD_OUT : out   t_bcd_out
  );
end entity BIN_TO_BCD;

architecture RTL of BIN_TO_BCD is
begin

  CONV_PROC : process (all) is
    variable bin_src       : unsigned (c_bin_width - 1 downto 0);
    variable bcd           : unsigned (c_bcd_width - 1 downto 0);
    variable nibble_offset : natural;
    variable nibble        : unsigned(3 downto 0);
  begin
    bin_src := BIN_IN;
    bcd     := (others => '0');

    for bit_idx in 0 to (c_bin_width - 1) loop
      for nibble_idx in 0 to c_num_digits - 1 loop
        nibble_offset := nibble_idx * 4;
        nibble        := bcd(nibble_offset + 3 downto nibble_offset);

        if (nibble > x"4") then
          bcd(nibble_offset + 3 downto nibble_offset) := nibble + 3;
        end if;
      end loop;
      -- shift in next bit
      bcd     := bcd(c_bcd_width - 2 downto 0) & bin_src(c_bin_width - 1);
      bin_src := bin_src(c_bin_width - 2 downto 0) & '0';
    end loop;
    for idx in 0 to c_num_digits - 1 loop
      nibble_offset := idx * 4;
      nibble        := bcd(nibble_offset + 3 downto nibble_offset);

      BCD_OUT(c_num_digits - 1 - idx) <= std_logic_vector(nibble);
    end loop;
  end process CONV_PROC;

end architecture RTL;
