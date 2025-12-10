library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

PACKAGE packet_types_pkg_hdr is
    -- Top-level packets, e.g. ping/pong
    constant c_DESTINATION_top: std_logic_vector(7 downto 0) := x"00";
END PACKAGE packet_types_pkg_hdr;
