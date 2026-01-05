library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.day_mux_top_level_pkg_hdr.all;
  use work.blk_mem_wrapper_pkg_hdr.all;

entity day_mux is
  port (
    DAY_SEL_IN   : in    unsigned(7 downto 0);
    DAY_DONE_OUT : out   std_logic;

    -- Port B controls --
    BRAM_ADDR_OUT         : out   t_addr_b;
    BRAM_WRITE_DATA_OUT   : out   std_logic_vector(7 downto 0);
    BRAM_WRITE_ENABLE_OUT : out   std_logic;
    BRAM_ENABLED_IN       : in    std_logic;

    -- Day signals to mux --
    BRAM_ADDR_MUX         : in    t_bram_addr_arr;
    BRAM_WRITE_DATA_MUX   : in    t_bram_data_arr;
    BRAM_ENABLED_MUX      : out   t_std_logic_arr;
    BRAM_WRITE_ENABLE_MUX : in    t_std_logic_arr;
    DAY_DONE_MUX          : in    t_std_logic_arr
  );
end entity day_mux;

architecture RTL of DAY_MUX is
begin

  MUX : process (all) is
    variable v_day_sel_int : integer range 0 to DAY_SEL_IN'high;
  begin
    if (DAY_SEL_IN < c_NUM_DAYS) then
      v_day_sel_int                   := to_integer(DAY_SEL_IN);
      BRAM_ADDR_OUT                   <= BRAM_ADDR_MUX(v_day_sel_int);
      BRAM_WRITE_DATA_OUT             <= BRAM_WRITE_DATA_MUX(v_day_sel_int);
      BRAM_ENABLED_MUX                <= (others => '0');
      BRAM_ENABLED_MUX(v_day_sel_int) <= BRAM_ENABLED_IN;
      BRAM_WRITE_ENABLE_OUT           <= BRAM_WRITE_ENABLE_MUX(v_day_sel_int);
      DAY_DONE_OUT                    <= DAY_DONE_MUX(v_day_sel_int);
    else
      BRAM_ADDR_OUT         <= (others => '0');
      BRAM_WRITE_DATA_OUT   <= x"00";
      BRAM_ENABLED_MUX      <= (others => '0');
      BRAM_WRITE_ENABLE_OUT <= '0';
      DAY_DONE_OUT          <= '0';
    end if;
  end process MUX;

end architecture RTL;
