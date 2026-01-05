library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.bin_to_bcd_pkg_hdr.all;

entity bin_to_bcd_tb is
end entity bin_to_bcd_tb;

architecture RTL of BIN_TO_BCD_TB is
  signal bin_in  : unsigned(31 downto 0) := x"0000_0000";
  signal bcd_out : t_bcd_out;

  constant bcd_out_expected : t_bcd_out :=
  (
    x"0",
    x"0",
    x"0",
    x"0",
    x"0",
    x"0",
    x"0",
    x"2",
    x"7",
    x"4",
    x"8"
  );

begin

  UUT : entity work.bin_to_bcd(rtl)
    port map (
      BIN_IN  => bin_in,
      BCD_OUT => bcd_out
    );

  STIMULUS : process is
  begin
    wait for 10 ns;

    -- 0xabc = 2748
    bin_in <= x"0000_0ABC";

    wait for 10 ns;

    assert bcd_out = bcd_out_expected
      report "bcd_out";

    wait for 10 ns;
    std.env.stop;
  end process STIMULUS;

end architecture RTL;
