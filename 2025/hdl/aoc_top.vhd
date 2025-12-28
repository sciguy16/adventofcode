library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.packet_types_pkg_hdr.ALL;

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

  signal bram_write_data_a  : std_logic_vector(31 downto 0);
  signal bram_read_data_a   : std_logic_vector(31 downto 0);
  signal bram_addr_a        : std_logic;
  signal bram_write_valid_a : std_logic;
  signal bram_write_ready_a : std_logic;
  signal bram_read_valid_a  : std_logic;
  signal bram_read_ready_a  : std_logic;

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

      bram_write_data_a_OUT  => bram_write_data_a,
      bram_read_data_a_IN    => bram_read_data_a,
      bram_addr_a_OUT        => bram_addr_a,
      bram_write_valid_a_OUT => bram_write_valid_a,
      bram_write_ready_a_IN  => bram_write_ready_a,
      bram_read_valid_a_IN   => bram_read_valid_a,
      bram_read_ready_a_OUT  => bram_read_ready_a
    );

  blk_mem_wrapper_inst : entity work.blk_mem_wrapper(rtl)
    port map(
      reset => reset,
      clk   => clk_25MHz,

      data_a_in         => bram_write_data_a,
      data_a_out        => bram_read_data_a,
      addr_a_in         => bram_addr_a,
      write_valid_a_in  => bram_write_valid_a,
      write_ready_a_out => bram_write_ready_a,
      read_valid_a_out  => bram_read_valid_a,
      read_ready_a_in   => bram_read_ready_a
    );

end rtl;
