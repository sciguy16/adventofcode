
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.day_mux_top_level_pkg_hdr.all;
  use work.blk_mem_wrapper_pkg_hdr.all;

entity day_mux_top_level is
  port (
    RESET : in    std_logic;
    CLK   : in    std_logic;

    DAY_SEL_IN        : in    unsigned(7 downto 0);
    DATA_LEN_BYTES_IN : in    unsigned(BRAM_PORT_B_ADDR_WIDTH - 1 downto 0);
    DAY_DONE_OUT      : out   std_logic;
    PART_A_OUT        : out   std_logic_vector(31 downto 0);
    PART_B_OUT        : out   std_logic_vector(31 downto 0);

    -- Port B controls --
    BRAM_ADDR_OUT         : out   t_addr_b;
    BRAM_WRITE_DATA_OUT   : out   std_logic_vector(7 downto 0);
    BRAM_READ_DATA_IN     : in    std_logic_vector(7 downto 0);
    BRAM_WRITE_ENABLE_OUT : out   std_logic;
    BRAM_ENABLED_IN       : in    std_logic
  );
end entity day_mux_top_level;

architecture RTL of DAY_MUX_TOP_LEVEL is
  -- Day signals to mux --
  signal bram_addr_mux         : t_bram_addr_arr;
  signal bram_write_data_mux   : t_bram_data_arr;
  signal bram_enabled_mux      : t_std_logic_arr;
  signal bram_write_enable_mux : t_std_logic_arr;
  signal day_done_mux          : t_std_logic_arr;
  signal part_a_out_mux        : t_out_arr;
  signal part_b_out_mux        : t_out_arr;

begin

  DAY_MUX_INST : entity work.day_mux(rtl)
    port map (
      DAY_SEL_IN   => DAY_SEL_IN,
      DAY_DONE_OUT => DAY_DONE_OUT,
      PART_A_OUT   => PART_A_OUT,
      PART_B_OUT   => PART_B_OUT,

      -- Port B controls --
      BRAM_ADDR_OUT         => BRAM_ADDR_OUT,
      BRAM_WRITE_DATA_OUT   => BRAM_WRITE_DATA_OUT,
      BRAM_WRITE_ENABLE_OUT => BRAM_WRITE_ENABLE_OUT,
      BRAM_ENABLED_IN       => BRAM_ENABLED_IN,

      -- Day signals to mux --
      BRAM_ADDR_MUX         => bram_addr_mux,
      BRAM_WRITE_DATA_MUX   => bram_write_data_mux,
      BRAM_ENABLED_MUX      => bram_enabled_mux,
      BRAM_WRITE_ENABLE_MUX => bram_write_enable_mux,
      DAY_DONE_MUX          => day_done_mux,
      PART_A_OUT_MUX        => part_a_out_mux,
      PART_B_OUT_MUX        => part_b_out_mux
    );

  DAY0_INST : entity work.day0(rtl)
    port map (
      RESET => RESET,
      CLK   => CLK,

      DATA_LEN_BYTES_IN => DATA_LEN_BYTES_IN,
      DAY_DONE_OUT      => day_done_mux(0),
      PART_A_OUT        => part_a_out_mux(0),
      PART_B_OUT        => part_b_out_mux(0),

      -- Port B controls --
      BRAM_ADDR_OUT         => bram_addr_mux(0),
      BRAM_WRITE_DATA_OUT   => bram_write_data_mux(0),
      BRAM_READ_DATA_IN     => BRAM_READ_DATA_IN,
      BRAM_WRITE_ENABLE_OUT => bram_write_enable_mux(0),
      BRAM_ENABLED_IN       => bram_enabled_mux(0)
    );

  DAY1_INST : entity work.day1(rtl)
    port map (
      RESET => RESET,
      CLK   => CLK,

      DATA_LEN_BYTES_IN => DATA_LEN_BYTES_IN,
      DAY_DONE_OUT      => day_done_mux(1),
      PART_A_OUT        => part_a_out_mux(1),
      PART_B_OUT        => part_b_out_mux(1),

      -- Port B controls --
      BRAM_ADDR_OUT         => bram_addr_mux(1),
      BRAM_WRITE_DATA_OUT   => bram_write_data_mux(1),
      BRAM_READ_DATA_IN     => BRAM_READ_DATA_IN,
      BRAM_WRITE_ENABLE_OUT => bram_write_enable_mux(1),
      BRAM_ENABLED_IN       => bram_enabled_mux(1)
    );

end architecture RTL;
