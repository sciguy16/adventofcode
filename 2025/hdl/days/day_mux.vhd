library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package day_mux_pkg_hdr is

  constant c_num_days : natural := 1;

end package day_mux_pkg_hdr;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.day_mux_pkg_hdr.all;

entity DAY_MUX is
  port (
    RESET : in    std_logic;
    CLK   : in    std_logic;

    DAY_SEL_IN        : in    unsigned(7 downto 0);
    DATA_LEN_BYTES_IN : in    unsigned(11 downto 0);
    DAY_DONE_OUT      : out   std_logic;

    -- Port B controls --
    BRAM_ADDR_B_OUT              : out   std_logic_vector(11 downto 0);
    BRAM_WRITE_DATA_B_OUT        : out   std_logic_vector(7 downto 0);
    BRAM_READ_DATA_B_IN          : in    std_logic_vector(7 downto 0);
    BRAM_PORT_B_WRITE_ENABLE_OUT : out   std_logic;
    BRAM_PORT_B_ENABLED_IN       : in    std_logic
  );
end entity DAY_MUX;

architecture RTL of DAY_MUX is

  type t_bram_addr_arr is
    array (0 to C_NUM_DAYS - 1) of std_logic_vector(11 downto 0);

  signal bram_addr_b : t_bram_addr_arr;

  type t_bram_data_arr is
    array (0 to C_NUM_DAYS - 1) of std_logic_vector(7 downto 0);

  signal bram_write_data_b : t_bram_data_arr;

  signal bram_port_b_enabled      : std_logic_vector(0 to C_NUM_DAYS - 1);
  signal bram_port_b_write_enable : std_logic_vector(0 to C_NUM_DAYS - 1);
  signal day_done                 : std_logic_vector(0 to C_NUM_DAYS - 1);

begin

  MUX : process (all) is
  begin

    case DAY_SEL_IN is

      when x"00" =>

        -- day zero
        BRAM_ADDR_B_OUT              <= bram_addr_b(0);
        BRAM_WRITE_DATA_B_OUT        <= bram_write_data_b(0);
        bram_port_b_enabled          <=
        (
          0      => BRAM_PORT_B_ENABLED_IN,
          others => '0'
        );
        BRAM_PORT_B_WRITE_ENABLE_OUT <= bram_port_b_write_enable(0);
        DAY_DONE_OUT                 <= day_done(0);

      when others =>

        BRAM_ADDR_B_OUT              <= x"000";
        BRAM_WRITE_DATA_B_OUT        <= x"00";
        bram_port_b_enabled          <= (others => '0');
        BRAM_PORT_B_WRITE_ENABLE_OUT <= '0';
        DAY_DONE_OUT                 <= '0';

    end case;

  end process MUX;

  DAY0_INST : entity work.day0(rtl)
    port map (
      RESET => RESET,
      CLK   => CLK,

      DATA_LEN_BYTES_IN => DATA_LEN_BYTES_IN,
      DAY_DONE_OUT      => day_done(0),

      -- Port B controls --
      BRAM_ADDR_B_OUT              => bram_addr_b(0),
      BRAM_WRITE_DATA_B_OUT        => bram_write_data_b(0),
      BRAM_READ_DATA_B_IN          => BRAM_READ_DATA_B_IN,
      BRAM_PORT_B_WRITE_ENABLE_OUT => bram_port_b_write_enable(0),
      BRAM_PORT_B_ENABLED_IN       => bram_port_b_enabled(0)
    );

end architecture RTL;
