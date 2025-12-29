library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

PACKAGE aoc_top_pkg_hdr is
  -- AXI burst type enumeration
  constant c_AXI_BURST_TYPE_FIXED: std_logic_vector(1 downto 0) := "00";
  constant c_AXI_BURST_TYPE_INCR: std_logic_vector(1 downto 0) := "01";
  constant c_AXI_BURST_TYPE_WRAP: std_logic_vector(1 downto 0) := "10";

  -- AXI burst size enumeration, corresponds to the number of bytes written
  -- from the incoming AXI word
  constant c_AXI_BURST_SIZE_BYTES_1: std_logic_vector(2 downto 0) := o"0";
  constant c_AXI_BURST_SIZE_BYTES_2: std_logic_vector(2 downto 0) := o"1";
  constant c_AXI_BURST_SIZE_BYTES_4: std_logic_vector(2 downto 0) := o"2";
  constant c_AXI_BURST_SIZE_BYTES_8: std_logic_vector(2 downto 0) := o"3";
  constant c_AXI_BURST_SIZE_BYTES_16: std_logic_vector(2 downto 0) := o"4";
  constant c_AXI_BURST_SIZE_BYTES_32: std_logic_vector(2 downto 0) := o"5";
  constant c_AXI_BURST_SIZE_BYTES_64: std_logic_vector(2 downto 0) := o"6";
  constant c_AXI_BURST_SIZE_BYTES_128: std_logic_vector(2 downto 0) := o"7";

  -- AXI read/write responses:
  --  OKAY (0b00):
  --    Normal access success. Indicates that a normal access has been successful
  --  EXOKAY (0b01):
  --    Exclusive access okay.
  --  SLVERR (0b10):
  --    Slave error. The slave was reached successfully but the slave wishes to
  --    return an error condition to the originating master (for example, data
  --    read not valid).
  --  DECERR (0b11):
  --    Decode error. Generated, typically by an interconnect component, to
  --    indicate that there is no slave at the transaction address
  constant c_AXI_RESP_OKAY   : std_logic_vector(1 downto 0) := "00";
  constant c_AXI_RESP_EXOKAY : std_logic_vector(1 downto 0) := "01";
  constant c_AXI_RESP_SLVERR : std_logic_vector(1 downto 0) := "10";
  constant c_AXI_RESP_DECERR : std_logic_vector(1 downto 0) := "11";
END PACKAGE aoc_top_pkg_hdr;
