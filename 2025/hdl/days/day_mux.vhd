library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.day_mux_top_level_pkg_hdr.all;

entity DAY_MUX is
  port (
    RESET : in    std_logic;
    CLK   : in    std_logic;

    DAY_SEL_IN   : in    unsigned(7 downto 0);
    DAY_DONE_OUT : out   std_logic;

    -- Port B controls --
    BRAM_ADDR_OUT         : out   std_logic_vector(11 downto 0);
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
end entity DAY_MUX;

architecture RTL of DAY_MUX is
begin

  MUX : process (all) is
  begin
    case DAY_SEL_IN is
      -- TODO switch on day sel value rather than static case switch

      when x"00" =>
        -- day zero
        BRAM_ADDR_OUT         <= BRAM_ADDR_MUX(0);
        BRAM_WRITE_DATA_OUT   <= BRAM_WRITE_DATA_MUX(0);
        BRAM_ENABLED_MUX      <=
        (
          0      => BRAM_ENABLED_IN,
          others => '0'
        );
        BRAM_WRITE_ENABLE_OUT <= BRAM_WRITE_ENABLE_MUX(0);
        DAY_DONE_OUT          <= DAY_DONE_MUX(0);

      when others =>
        BRAM_ADDR_OUT         <= x"000";
        BRAM_WRITE_DATA_OUT   <= x"00";
        BRAM_ENABLED_MUX      <= (others => '0');
        BRAM_WRITE_ENABLE_OUT <= '0';
        DAY_DONE_OUT          <= '0';
    end case;
  end process MUX;

end architecture RTL;
