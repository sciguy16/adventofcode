library ieee;
  use ieee.std_logic_1164.all;
  use work.aoc_top_pkg_hdr.all;

entity axi_uart_wrapper_tb is
end entity axi_uart_wrapper_tb;

architecture RTL of AXI_UART_WRAPPER_TB is
  -- 50,000,000 (50 Mhz) / 115200 Baud rate;
  constant c_cycles_per_bit : integer := 434;

  signal clk           : std_logic := '0';
  signal axi_clk       : std_logic := '0';
  signal reset         : std_logic := '0';
  signal uart_loopback : std_logic;

  signal axi_str_txd_tvalid : std_logic;
  signal axi_str_txd_tready : std_logic;
  signal axi_str_txd_tdata  : std_logic_vector(31 downto 0);

  signal axi_str_rxd_tvalid : std_logic;
  signal axi_str_rxd_tready : std_logic;
  signal axi_str_rxd_tdata  : std_logic_vector(31 downto 0);

begin

  AXI_UART_WRAPPER_INST : entity work.axi_uart_wrapper(rtl)
    port map (
      RESET    => reset,
      CLK      => clk,
      AXI_CLK  => axi_clk,
      AXI_NRST => not reset,
      RX_IN    => uart_loopback,
      TX_OUT   => uart_loopback,

      AXI_STR_RXD_TVALID_OUT => axi_str_rxd_tvalid,
      AXI_STR_RXD_TREADY_IN  => axi_str_rxd_tready,
      AXI_STR_RXD_TDATA_OUT  => axi_str_rxd_tdata,

      AXI_STR_TXD_TVALID_IN  => axi_str_txd_tvalid,
      AXI_STR_TXD_TREADY_OUT => axi_str_txd_tready,
      AXI_STR_TXD_TDATA_IN   => axi_str_txd_tdata
    );

  -- in the simulation time, call it 1 clock cycle per ns
  clk     <= not clk after 1 ns;       -- 25 MHz clock
  axi_clk <= not axi_clk after 0.5 ns; -- 50 MHz clock
  reset   <= '1', '0' after 8 ns;

  STIMULUS : process is
  begin
    axi_str_txd_tvalid <= '0';
    axi_str_txd_tdata  <= x"0000_0000";
    axi_str_rxd_tready <= '1';

    -- reset <= '1';
    -- wait for 1 ns;

    -- reset <= '0';

    wait for 20 ns;
    assert uart_loopback = '1'
      report "tx should idle high";

    wait for 5 ns;

    -- send one data word
    axi_str_rxd_tready <= '0';
    axi_str_txd_tdata  <= x"01234567";
    axi_str_txd_tvalid <= '1';
    wait until (axi_str_txd_tready = '1');
    wait for 2 ns; -- sampled on slower clock
    axi_str_txd_tvalid <= '0';

    -- wait for it to appear on receive side
    wait until (axi_str_rxd_tvalid = '1');
    axi_str_rxd_tready <= '1';
    assert axi_str_rxd_tdata = x"12345678";
    wait for 2 ns;
    axi_str_rxd_tready <= '0';

    -- 115200 baud is 8.68 µs per bit
    -- with a 50 MHz clock, that's 20 ns per cycle, so 434 cycles per bit
    -- 8 bits is 3472 clocks, or 4340 including stop/start bits
    -- 4 bytes is then 17360 clocks
    -- wait for 200_000 ns;

    std.env.stop;
  end process STIMULUS;

end architecture RTL;
