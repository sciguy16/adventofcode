library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity day0 is
  port (
    reset: in std_logic;
    clk: in std_logic;

    data_len_bytes_IN: in unsigned(11 downto 0);
    day_done_OUT: out std_logic;

    -- Port B controls --
    bram_addr_b_OUT: OUT std_logic_vector(11 downto 0);
    bram_write_data_b_OUT: OUT std_logic_vector(7 downto 0);
    bram_read_data_b_IN: IN std_logic_vector(7 downto 0);
    bram_port_b_write_enable_OUT: OUT std_logic;
    bram_port_b_enabled_IN: IN std_logic
  );
end day0;

architecture rtl of day0 is
  signal accumulator: unsigned(31 downto 0) := x"00000000";

  type T_STATE is (
    STATE_IDLE,
    STATE_RUNNING
  );
  signal state: T_STATE := STATE_IDLE;

begin
  day0_proc: process(clk)
  begin
    if rising_edge(clk) then
      if bram_port_b_enabled_IN = '1' then
        day_done_OUT <= '1';
      else
        day_done_OUT <= '0';
      end if;

      if reset = '1' then
        day_done_OUT <= '0';
        bram_addr_b_OUT <= x"000";
        bram_write_data_b_OUT <= x"00";
        bram_port_b_write_enable_OUT <= '0';
      end if;
    end if;
  end process day0_proc;
end rtl;
