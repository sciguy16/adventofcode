library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- 8192 deep at 32 bits wide
-- 32768 deep at 8 bits wide
--
-- 32-bit AXI interface
-- 15-bit address, addressing byte offsets
-- 13-bit address, addressing word offsets

package blk_mem_wrapper_pkg_hdr is

  constant bram_port_b_addr_width : natural := 15;
  constant bram_port_a_addr_width : natural := bram_port_b_addr_width - 2;

  subtype t_addr_a is std_logic_vector(bram_port_a_addr_width - 1 downto 0);

  subtype t_addr_b is std_logic_vector(BRAM_PORT_B_ADDR_WIDTH - 1 downto 0);

end package blk_mem_wrapper_pkg_hdr;
