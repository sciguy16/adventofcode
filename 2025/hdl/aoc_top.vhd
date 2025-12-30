library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.packet_types_pkg_hdr.ALL;
use work.aoc_top_pkg_hdr.ALL;

entity aoc_top is
  port(
    reset_in     : in std_logic;
    clk_12MHz_in : in std_logic;

    hb_led : out std_logic;
    led0_b : out std_logic;
    led0_g : out std_logic;
    led0_r : out std_logic;

    uart_rx : in  std_logic;
    uart_tx : out std_logic
  );
end aoc_top;

architecture rtl of aoc_top is
  signal clk_25MHz    : std_logic;
  signal clk_50MHz    : std_logic;
  signal reset_in_reg : std_logic := '0';
  signal reset        : std_logic;
  signal reset_50MHz  : std_logic;

  signal axi_uart_rxd_tvalid : std_logic;
  signal axi_uart_rxd_tready : std_logic;
  signal axi_uart_rxd_tdata  : std_logic_vector(31 downto 0);

  signal axi_uart_txd_tvalid : std_logic;
  signal axi_uart_txd_tready : std_logic;
  signal axi_uart_txd_tdata  : std_logic_vector(31 downto 0);

  -- Write controls --
  signal bram_axi_write_word_offset_port_a : STD_LOGIC_VECTOR(9 DOWNTO 0);
  signal bram_axi_awlen_port_a : STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal bram_axi_awvalid_port_a : STD_LOGIC;
  signal bram_axi_awready_port_a : STD_LOGIC;

  -- Write data --
  signal bram_axi_wdata_port_a : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal bram_axi_wlast_port_a : STD_LOGIC;
  signal bram_axi_wvalid_port_a : STD_LOGIC;
  signal bram_axi_wready_port_a : STD_LOGIC;

  -- Write response --
  signal bram_axi_bresp_port_a : STD_LOGIC_VECTOR(1 DOWNTO 0);
  signal bram_axi_bvalid_port_a : STD_LOGIC;
  signal bram_axi_bready_port_a : STD_LOGIC;

  -- Read controls --
  signal bram_axi_read_word_offset_port_a : STD_LOGIC_VECTOR(9 DOWNTO 0);
  signal bram_axi_arlen_port_a : STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal bram_axi_arvalid_port_a : STD_LOGIC;
  signal bram_axi_arready_port_a : STD_LOGIC;

  -- Read data --
  signal bram_axi_rdata_port_a : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal bram_axi_rresp_port_a : STD_LOGIC_VECTOR(1 DOWNTO 0);
  signal bram_axi_rlast_port_a : STD_LOGIC;
  signal bram_axi_rvalid_port_a : STD_LOGIC;
  signal bram_axi_rready_port_a : STD_LOGIC;

  -- Port B controls --
  signal bram_addr_b: std_logic_vector(11 downto 0);
  signal bram_write_data_b: std_logic_vector(7 downto 0);
  signal bram_read_data_b: std_logic_vector(7 downto 0);
  signal bram_port_b_write_enable: std_logic;
  signal bram_port_b_enabled: std_logic;

  -- Day mux controls
  signal day_sel: unsigned(7 downto 0);
  signal data_len_bytes: unsigned(11 downto 0);
  signal day_done: std_logic;

  component clk_wiz_0
    port
    ( -- Clock in ports
      -- Clock out ports
      clk_25MHz : out std_logic;
      clk_50MHz : out std_logic;
      -- Status and control signals
      reset   : in std_logic;
      clk_in1 : in std_logic
    );
  end component;

begin
  -- active-low RGB LED
  led0_r <= axi_uart_rxd_tvalid;
  led0_g <= '1';
  led0_b <= '1';

  process(clk_25MHz) is
  begin
    if rising_edge(clk_25MHz) then
      reset_in_reg <= reset_in;
    end if;
  end process;

  reset_expander_inst : entity work.reset_expander(rtl)
  port map (
    reset_in => reset_in_reg,
    clk      => clk_25MHz,

    reset_out_25MHz => reset,
    reset_clk_25MHz => clk_25MHz,

    reset_out_50MHz => reset_50MHz,
    reset_clk_50MHz => clk_50MHz
  );

  clk_wiz_0_inst : clk_wiz_0
  port map (
    -- Clock out ports
    clk_25MHz => clk_25MHz,
    clk_50MHz => clk_50MHz,
    -- Status and control signals
    reset => reset_in,
    -- Clock in ports
    clk_in1 => clk_12MHz_in
  );

  hb_instance : entity work.hb(rtl)
  port map(
    reset  => reset,
    clk    => clk_25MHz,
    hb_led => hb_led
  );

  axi_uart_wrapper_inst : entity work.axi_uart_wrapper(rtl)
  port map (
    reset    => reset,
    clk      => clk_25MHz,
    axi_clk  => clk_50MHz,
    axi_nrst => not reset_50MHz,
    rx_IN    => uart_rx,
    tx_OUT   => uart_tx,

    axi_str_rxd_tvalid_OUT => axi_uart_rxd_tvalid,
    axi_str_rxd_tready_IN  => axi_uart_rxd_tready,
    axi_str_rxd_tdata_OUT  => axi_uart_rxd_tdata,

    axi_str_txd_tvalid_IN  => axi_uart_txd_tvalid,
    axi_str_txd_tready_OUT => axi_uart_txd_tready,
    axi_str_txd_tdata_IN   => axi_uart_txd_tdata
  );

  packet_handler_inst : entity work.packet_handler(rtl)
  port map (
    reset => reset,
    clk   => clk_25MHz,

    axi_str_rxd_tvalid_IN  => axi_uart_rxd_tvalid,
    axi_str_rxd_tready_OUT => axi_uart_rxd_tready,
    axi_str_rxd_tdata_IN   => axi_uart_rxd_tdata,

    axi_str_txd_tvalid_OUT => axi_uart_txd_tvalid,
    axi_str_txd_tready_IN  => axi_uart_txd_tready,
    axi_str_txd_tdata_OUT  => axi_uart_txd_tdata,

    -- BRAM Port A controls --

    -- Write controls --
    m_axi_write_word_offset_port_a_OUT => bram_axi_write_word_offset_port_a,
    m_axi_awlen_port_a_OUT => bram_axi_awlen_port_a,
    m_axi_awvalid_port_a_OUT => bram_axi_awvalid_port_a,
    m_axi_awready_port_a_IN => bram_axi_awready_port_a,

    -- Write data --
    m_axi_wdata_port_a_OUT => bram_axi_wdata_port_a,
    m_axi_wlast_port_a_OUT => bram_axi_wlast_port_a,
    m_axi_wvalid_port_a_OUT => bram_axi_wvalid_port_a,
    m_axi_wready_port_a_IN => bram_axi_wready_port_a,

    -- Write response --
    m_axi_bresp_port_a_IN => bram_axi_bresp_port_a,
    m_axi_bvalid_port_a_IN => bram_axi_bvalid_port_a,
    m_axi_bready_port_a_OUT => bram_axi_bready_port_a,

    -- Read controls --
    m_axi_read_word_offset_port_a_OUT => bram_axi_read_word_offset_port_a,
    m_axi_arlen_port_a_OUT => bram_axi_arlen_port_a,
    m_axi_arvalid_port_a_OUT => bram_axi_arvalid_port_a,
    m_axi_arready_port_a_IN => bram_axi_arready_port_a,

    -- Read data --
    m_axi_rdata_port_a_IN => bram_axi_rdata_port_a,
    m_axi_rresp_port_a_IN => bram_axi_rresp_port_a,
    m_axi_rlast_port_a_IN => bram_axi_rlast_port_a,
    m_axi_rvalid_port_a_IN => bram_axi_rvalid_port_a,
    m_axi_rready_port_a_OUT => bram_axi_rready_port_a,

    -- Day mux controls
    day_sel_OUT => day_sel,
    data_len_bytes_OUT => data_len_bytes,
    day_done_IN => day_done
  );

  blk_mem_wrapper_inst : entity work.blk_mem_wrapper(rtl)
  port map(
    reset => reset,
    clk   => clk_25MHz,

    -- Port A controls --

    -- Write controls --
    s_axi_write_word_offset_port_a_IN => bram_axi_write_word_offset_port_a,
    s_axi_awlen_port_a_IN => bram_axi_awlen_port_a,
    s_axi_awvalid_port_a_IN => bram_axi_awvalid_port_a,
    s_axi_awready_port_a_OUT => bram_axi_awready_port_a,

    -- Write data --
    s_axi_wdata_port_a_IN => bram_axi_wdata_port_a,
    s_axi_wlast_port_a_IN => bram_axi_wlast_port_a,
    s_axi_wvalid_port_a_IN => bram_axi_wvalid_port_a,
    s_axi_wready_port_a_OUT => bram_axi_wready_port_a,

    -- Write response --
    s_axi_bresp_port_a_OUT => bram_axi_bresp_port_a,
    s_axi_bvalid_port_a_OUT => bram_axi_bvalid_port_a,
    s_axi_bready_port_a_IN => bram_axi_bready_port_a,

    -- Read controls --
    s_axi_read_word_offset_port_a_IN => bram_axi_read_word_offset_port_a,
    s_axi_arlen_port_a_IN => bram_axi_arlen_port_a,
    s_axi_arvalid_port_a_IN => bram_axi_arvalid_port_a,
    s_axi_arready_port_a_OUT => bram_axi_arready_port_a,

    -- Read data --
    s_axi_rdata_port_a_OUT => bram_axi_rdata_port_a,
    s_axi_rresp_port_a_OUT => bram_axi_rresp_port_a,
    s_axi_rlast_port_a_OUT => bram_axi_rlast_port_a,
    s_axi_rvalid_port_a_OUT => bram_axi_rvalid_port_a,
    s_axi_rready_port_a_IN => bram_axi_rready_port_a,

    -- Port B controls --
    bram_addr_b_in => bram_addr_b,
    bram_data_b_in => bram_write_data_b,
    bram_data_b_out => bram_read_data_b,
    bram_port_b_write_enable_in => bram_port_b_write_enable,
    bram_port_b_enabled_out => bram_port_b_enabled
  );

  day_mux_inst: entity work.day_mux
  port map (
    reset => reset,
    clk   => clk_25MHz,

    day_sel_IN => day_sel,
    data_len_bytes_IN => data_len_bytes,
    day_done_OUT => day_done,

    -- Port B controls --
    bram_addr_b_OUT => bram_addr_b,
    bram_write_data_b_OUT => bram_write_data_b,
    bram_read_data_b_IN => bram_read_data_b,
    bram_port_b_write_enable_OUT => bram_port_b_write_enable,
    bram_port_b_enabled_IN => bram_port_b_enabled
  );

end rtl;
