library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
--use work.pkg.buf_type;

use work.packet_types_pkg_hdr.ALL;

entity aoc_top is
    port(
        reset: in std_logic;
        clk_12MHz: in std_logic;
        --dmx_rx: in std_logic;

        hb_led: out std_logic;
        led0_b: out std_logic;
        led0_g: out std_logic;
        led0_r: out std_logic;

        uart_rx: in std_logic;
        uart_tx: out std_logic
    );
end aoc_top;

architecture rtl of aoc_top is
    signal clk_25MHz: std_logic;
    signal clk_50MHz: std_logic;

    signal axi_uart_tvalid_loopback: std_logic;
    signal axi_uart_tready_loopback: std_logic;
    signal axi_uart_tdata_loopback: std_logic_vector(31 downto 0);

    signal game: std_logic_vector(7 downto 0) := c_DESTINATION_top;

    component clk_wiz_0
    port
     (-- Clock in ports
      -- Clock out ports
      clk_25MHz          : out    std_logic;
      clk_50MHz          : out    std_logic;
      -- Status and control signals
      reset             : in     std_logic;
      clk_in1           : in     std_logic
     );
    end component;

    
    component axi_uart_wrapper is
    port (
        reset: in std_logic;
        clk: in std_logic;
        axi_clk: in std_logic;
        rx : IN STD_LOGIC;
        tx : OUT STD_LOGIC;

        axi_str_rxd_tvalid : OUT STD_LOGIC;
        axi_str_rxd_tready : IN STD_LOGIC;
        axi_str_rxd_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        axi_str_txd_tvalid : IN STD_LOGIC;
        axi_str_txd_tready : OUT STD_LOGIC;
        axi_str_txd_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        axi_str_txd_prog_full : OUT STD_LOGIC
  );
end component;

begin
    -- active-low RGB LED
    led0_r <= axi_uart_tvalid_loopback;
    led0_g <= '1';
    led0_b <= '1';

    clk_wiz_0_inst : clk_wiz_0
       port map (
          -- Clock out ports
           clk_25MHz => clk_25MHz,
           clk_50MHz => clk_50MHz,
          -- Status and control signals
           reset => reset,
           -- Clock in ports
           clk_in1 => clk_12MHz
     );

    hb_instance : entity work.hb(rtl)
        port map(
            reset => reset,
            clk => clk_25MHz,
            hb_led => hb_led
        );

    axi_uart_wrapper_inst: axi_uart_wrapper
    port map (
        reset=> reset,
        clk=> clk_25MHz,
        axi_clk => clk_50MHz,
        rx => uart_rx,
        tx => uart_tx,

        axi_str_rxd_tvalid => axi_uart_tvalid_loopback,
        axi_str_rxd_tready => axi_uart_tready_loopback,
        axi_str_rxd_tdata => axi_uart_tdata_loopback,

        axi_str_txd_tvalid => axi_uart_tvalid_loopback,
        axi_str_txd_tready => axi_uart_tready_loopback,
        axi_str_txd_tdata =>axi_uart_tdata_loopback,
        axi_str_txd_prog_full => open
        );

    --dmx_instance: entity work.dmx(rtl)
    --    generic map(
    --        g_ADDRESSES => g_ADDRESSES
    --        )
    --    port map(
    --        reset => reset,
    --        clk => clk,
    --        dmx_rx => dmx_rx,
    --        out_buf => rx_buf,
    --        valid => led0_b
    --    );

end rtl;
