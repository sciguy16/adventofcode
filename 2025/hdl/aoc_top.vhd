library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

  -- Uncomment the following library declaration if instantiating
  -- any Xilinx leaf cells in this code.
  -- library UNISIM;
  -- use UNISIM.VComponents.all;
  use work.packet_types_pkg_hdr.all;
  use work.aoc_top_pkg_hdr.all;

entity AOC_TOP is
  port (
    RESET_IN     : in    std_logic;
    CLK_12MHZ_IN : in    std_logic;

    HB_LED       : out   std_logic;
    LED0_B       : out   std_logic;
    LED0_G       : out   std_logic;
    LED0_R       : out   std_logic;

    UART_RX      : in    std_logic;
    UART_TX      : out   std_logic
  );
end entity AOC_TOP;

architecture RTL of AOC_TOP is

  signal clk_25mhz                         : std_logic;
  signal clk_50mhz                         : std_logic;
  signal reset_in_reg                      : std_logic := '0';
  signal reset                             : std_logic;
  signal reset_50mhz                       : std_logic;

  signal axi_uart_rxd_tvalid               : std_logic;
  signal axi_uart_rxd_tready               : std_logic;
  signal axi_uart_rxd_tdata                : std_logic_vector(31 downto 0);

  signal axi_uart_txd_tvalid               : std_logic;
  signal axi_uart_txd_tready               : std_logic;
  signal axi_uart_txd_tdata                : std_logic_vector(31 downto 0);

  -- Write controls --
  signal bram_axi_write_word_offset_port_a : std_logic_vector(9 downto 0);
  signal bram_axi_awlen_port_a             : std_logic_vector(7 downto 0);
  signal bram_axi_awvalid_port_a           : std_logic;
  signal bram_axi_awready_port_a           : std_logic;

  -- Write data --
  signal bram_axi_wdata_port_a             : std_logic_vector(31 downto 0);
  signal bram_axi_wlast_port_a             : std_logic;
  signal bram_axi_wvalid_port_a            : std_logic;
  signal bram_axi_wready_port_a            : std_logic;

  -- Write response --
  signal bram_axi_bresp_port_a             : std_logic_vector(1 downto 0);
  signal bram_axi_bvalid_port_a            : std_logic;
  signal bram_axi_bready_port_a            : std_logic;

  -- Read controls --
  signal bram_axi_read_word_offset_port_a  : std_logic_vector(9 downto 0);
  signal bram_axi_arlen_port_a             : std_logic_vector(7 downto 0);
  signal bram_axi_arvalid_port_a           : std_logic;
  signal bram_axi_arready_port_a           : std_logic;

  -- Read data --
  signal bram_axi_rdata_port_a             : std_logic_vector(31 downto 0);
  signal bram_axi_rresp_port_a             : std_logic_vector(1 downto 0);
  signal bram_axi_rlast_port_a             : std_logic;
  signal bram_axi_rvalid_port_a            : std_logic;
  signal bram_axi_rready_port_a            : std_logic;

  -- Port B controls --
  signal bram_addr_b                       : std_logic_vector(11 downto 0);
  signal bram_write_data_b                 : std_logic_vector(7 downto 0);
  signal bram_read_data_b                  : std_logic_vector(7 downto 0);
  signal bram_port_b_write_enable          : std_logic;
  signal bram_port_b_enabled               : std_logic;

  -- Day mux controls
  signal day_sel                           : unsigned(7 downto 0);
  signal data_len_bytes                    : unsigned(11 downto 0);
  signal day_done                          : std_logic;

  attribute mark_debug : string;
  attribute mark_debug of bram_axi_arlen_port_a : signal is "TRUE";

  component CLK_WIZ_0 is
    port (
      -- Clock out ports
      CLK_25MHZ : out   std_logic;
      CLK_50MHZ : out   std_logic;
      -- Status and control signals
      RESET     : in    std_logic;
      CLK_IN1   : in    std_logic
    );
  end component CLK_WIZ_0;

begin

  -- active-low RGB LED
  LED0_R <= axi_uart_rxd_tvalid;
  LED0_G <= '1';
  LED0_B <= '1';

  process (clk_25mhz) is
  begin

    if rising_edge(clk_25mhz) then
      reset_in_reg <= RESET_IN;
    end if;

  end process;

  RESET_EXPANDER_INST : entity work.reset_expander(rtl)
    port map (
      RESET_IN => reset_in_reg,
      CLK      => clk_25mhz,

      RESET_OUT_25MHZ => reset,
      RESET_CLK_25MHZ => clk_25mhz,

      RESET_OUT_50MHZ => reset_50mhz,
      RESET_CLK_50MHZ => clk_50mhz
    );

  CLK_WIZ_0_INST : CLK_WIZ_0
    port map (
      -- Clock out ports
      CLK_25MHZ => clk_25mhz,
      CLK_50MHZ => clk_50mhz,
      -- Status and control signals
      RESET => RESET_IN,
      -- Clock in ports
      CLK_IN1 => CLK_12MHZ_IN
    );

  HB_INSTANCE : entity work.hb(rtl)
    port map (
      RESET  => reset,
      CLK    => clk_25mhz,
      HB_LED => HB_LED
    );

  AXI_UART_WRAPPER_INST : entity work.axi_uart_wrapper(rtl)
    port map (
      RESET    => reset,
      CLK      => clk_25mhz,
      AXI_CLK  => clk_50mhz,
      AXI_NRST => not reset_50mhz,
      RX_IN    => UART_RX,
      TX_OUT   => UART_TX,

      AXI_STR_RXD_TVALID_OUT => axi_uart_rxd_tvalid,
      AXI_STR_RXD_TREADY_IN  => axi_uart_rxd_tready,
      AXI_STR_RXD_TDATA_OUT  => axi_uart_rxd_tdata,

      AXI_STR_TXD_TVALID_IN  => axi_uart_txd_tvalid,
      AXI_STR_TXD_TREADY_OUT => axi_uart_txd_tready,
      AXI_STR_TXD_TDATA_IN   => axi_uart_txd_tdata
    );

  PACKET_HANDLER_INST : entity work.packet_handler(rtl)
    port map (
      RESET => reset,
      CLK   => clk_25mhz,

      AXI_STR_RXD_TVALID_IN  => axi_uart_rxd_tvalid,
      AXI_STR_RXD_TREADY_OUT => axi_uart_rxd_tready,
      AXI_STR_RXD_TDATA_IN   => axi_uart_rxd_tdata,

      AXI_STR_TXD_TVALID_OUT => axi_uart_txd_tvalid,
      AXI_STR_TXD_TREADY_IN  => axi_uart_txd_tready,
      AXI_STR_TXD_TDATA_OUT  => axi_uart_txd_tdata,

      -- BRAM Port A controls --

      -- Write controls --
      M_AXI_WRITE_WORD_OFFSET_PORT_A_OUT => bram_axi_write_word_offset_port_a,
      M_AXI_AWLEN_PORT_A_OUT             => bram_axi_awlen_port_a,
      M_AXI_AWVALID_PORT_A_OUT           => bram_axi_awvalid_port_a,
      M_AXI_AWREADY_PORT_A_IN            => bram_axi_awready_port_a,

      -- Write data --
      M_AXI_WDATA_PORT_A_OUT  => bram_axi_wdata_port_a,
      M_AXI_WLAST_PORT_A_OUT  => bram_axi_wlast_port_a,
      M_AXI_WVALID_PORT_A_OUT => bram_axi_wvalid_port_a,
      M_AXI_WREADY_PORT_A_IN  => bram_axi_wready_port_a,

      -- Write response --
      M_AXI_BRESP_PORT_A_IN   => bram_axi_bresp_port_a,
      M_AXI_BVALID_PORT_A_IN  => bram_axi_bvalid_port_a,
      M_AXI_BREADY_PORT_A_OUT => bram_axi_bready_port_a,

      -- Read controls --
      M_AXI_READ_WORD_OFFSET_PORT_A_OUT => bram_axi_read_word_offset_port_a,
      M_AXI_ARLEN_PORT_A_OUT            => bram_axi_arlen_port_a,
      M_AXI_ARVALID_PORT_A_OUT          => bram_axi_arvalid_port_a,
      M_AXI_ARREADY_PORT_A_IN           => bram_axi_arready_port_a,

      -- Read data --
      M_AXI_RDATA_PORT_A_IN   => bram_axi_rdata_port_a,
      M_AXI_RRESP_PORT_A_IN   => bram_axi_rresp_port_a,
      M_AXI_RLAST_PORT_A_IN   => bram_axi_rlast_port_a,
      M_AXI_RVALID_PORT_A_IN  => bram_axi_rvalid_port_a,
      M_AXI_RREADY_PORT_A_OUT => bram_axi_rready_port_a,

      -- Day mux controls
      DAY_SEL_OUT        => day_sel,
      DATA_LEN_BYTES_OUT => data_len_bytes,
      DAY_DONE_IN        => day_done
    );

  BLK_MEM_WRAPPER_INST : entity work.blk_mem_wrapper(rtl)
    port map (
      RESET => reset,
      CLK   => clk_25mhz,

      -- Port A controls --

      -- Write controls --
      S_AXI_WRITE_WORD_OFFSET_PORT_A_IN => bram_axi_write_word_offset_port_a,
      S_AXI_AWLEN_PORT_A_IN             => bram_axi_awlen_port_a,
      S_AXI_AWVALID_PORT_A_IN           => bram_axi_awvalid_port_a,
      S_AXI_AWREADY_PORT_A_OUT          => bram_axi_awready_port_a,

      -- Write data --
      S_AXI_WDATA_PORT_A_IN   => bram_axi_wdata_port_a,
      S_AXI_WLAST_PORT_A_IN   => bram_axi_wlast_port_a,
      S_AXI_WVALID_PORT_A_IN  => bram_axi_wvalid_port_a,
      S_AXI_WREADY_PORT_A_OUT => bram_axi_wready_port_a,

      -- Write response --
      S_AXI_BRESP_PORT_A_OUT  => bram_axi_bresp_port_a,
      S_AXI_BVALID_PORT_A_OUT => bram_axi_bvalid_port_a,
      S_AXI_BREADY_PORT_A_IN  => bram_axi_bready_port_a,

      -- Read controls --
      S_AXI_READ_WORD_OFFSET_PORT_A_IN => bram_axi_read_word_offset_port_a,
      S_AXI_ARLEN_PORT_A_IN            => bram_axi_arlen_port_a,
      S_AXI_ARVALID_PORT_A_IN          => bram_axi_arvalid_port_a,
      S_AXI_ARREADY_PORT_A_OUT         => bram_axi_arready_port_a,

      -- Read data --
      S_AXI_RDATA_PORT_A_OUT  => bram_axi_rdata_port_a,
      S_AXI_RRESP_PORT_A_OUT  => bram_axi_rresp_port_a,
      S_AXI_RLAST_PORT_A_OUT  => bram_axi_rlast_port_a,
      S_AXI_RVALID_PORT_A_OUT => bram_axi_rvalid_port_a,
      S_AXI_RREADY_PORT_A_IN  => bram_axi_rready_port_a,

      -- Port B controls --
      BRAM_ADDR_B_IN              => bram_addr_b,
      BRAM_DATA_B_IN              => bram_write_data_b,
      BRAM_DATA_B_OUT             => bram_read_data_b,
      BRAM_PORT_B_WRITE_ENABLE_IN => bram_port_b_write_enable,
      BRAM_PORT_B_ENABLED_OUT     => bram_port_b_enabled
    );

  DAY_MUX_INST : entity work.day_mux
    port map (
      RESET => reset,
      CLK   => clk_25mhz,

      DAY_SEL_IN        => day_sel,
      DATA_LEN_BYTES_IN => data_len_bytes,
      DAY_DONE_OUT      => day_done,

      -- Port B controls --
      BRAM_ADDR_B_OUT              => bram_addr_b,
      BRAM_WRITE_DATA_B_OUT        => bram_write_data_b,
      BRAM_READ_DATA_B_IN          => bram_read_data_b,
      BRAM_PORT_B_WRITE_ENABLE_OUT => bram_port_b_write_enable,
      BRAM_PORT_B_ENABLED_IN       => bram_port_b_enabled
    );

end architecture RTL;
