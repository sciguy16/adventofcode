library ieee;
  use ieee.std_logic_1164.all;
  use work.packet_types_pkg_hdr.all;

entity PACKET_HANDLER_TB is
end entity PACKET_HANDLER_TB;

architecture RTL of PACKET_HANDLER_TB is

  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';

  signal axi_str_rxd_tvalid : std_logic                     := '0';
  signal axi_str_rxd_tready : std_logic;
  signal axi_str_rxd_tdata  : std_logic_vector(31 downto 0) := x"00000000";

  signal axi_str_txd_tvalid : std_logic;
  signal axi_str_txd_tready : std_logic := '0';
  signal axi_str_txd_tdata  : std_logic_vector(31 downto 0);

begin

  PACKET_HANDLER_INST : entity work.packet_handler(rtl)
    port map (
      RESET => reset,
      CLK   => clk,

      AXI_STR_RXD_TVALID_IN  => axi_str_rxd_tvalid,
      AXI_STR_RXD_TREADY_OUT => axi_str_rxd_tready,
      AXI_STR_RXD_TDATA_IN   => axi_str_rxd_tdata,

      AXI_STR_TXD_TVALID_OUT => axi_str_txd_tvalid,
      AXI_STR_TXD_TREADY_IN  => axi_str_txd_tready,
      AXI_STR_TXD_TDATA_OUT  => axi_str_txd_tdata,

      BRAM_WRITE_DATA_A_OUT  => open,
      BRAM_READ_DATA_A_IN    => (others => '0'),
      BRAM_ADDR_A_OUT        => open,
      BRAM_WRITE_VALID_A_OUT => open,
      BRAM_WRITE_READY_A_IN  => '0',
      BRAM_READ_REQ_A_OUT    => open,
      BRAM_READ_VALID_A_IN   => '0',
      BRAM_READ_READY_A_OUT  => open

    );

  -- in the simulation time, call it 1 clock cycle per ns
  clk <= not clk after 1 ns; -- 25 MHz clock

  STIMULUS : process is

    alias reply_done_internal is
        << signal packet_handler_inst.reply_done : std_logic >>;

  begin

    reset <= '1';
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    reset <= '0';
    wait until rising_edge(clk);

    for clocks_between_header_and_payload in 0 to 2 loop

      report "clocks=" & integer'image(clocks_between_header_and_payload);

      -- packet header
      wait until falling_edge(clk);
      axi_str_rxd_tdata  <= x"00000004";
      axi_str_rxd_tvalid <= '1';
      -- wait for UUT to clock in the data on a rising edge
      wait until rising_edge(clk) and axi_str_rxd_tready = '1' for 10 ns;
      wait until falling_edge(clk);
      axi_str_rxd_tvalid <= '0';

      for clock in clocks_between_header_and_payload - 1 downto 0 loop

        wait until falling_edge(clk);

      end loop;

      -- packet payload
      axi_str_rxd_tdata  <= x"12345678";
      axi_str_rxd_tvalid <= '1';
      -- wait for UUT to clock in the data on a rising edge
      wait until falling_edge(clk) and axi_str_rxd_tready = '1' for 10 ns;
      axi_str_rxd_tvalid <= '0';

      -- wait until falling_edge(clk);
      -- assert axi_str_rxd_tready = '0' report "tready";

      wait until falling_edge(clk) and axi_str_txd_tvalid = '1' for 10 ns;
      axi_str_txd_tready <= '1';
      assert axi_str_txd_tdata = x"00010004"
        report "header";

      wait until falling_edge(clk) and axi_str_txd_tvalid = '1' for 10 ns;
      assert axi_str_txd_tdata = x"12345678"
        report "payload";
      assert reply_done_internal = '0'
        report "done internal";

      wait until falling_edge(clk);
      assert reply_done_internal = '1'
        report "done internal";
      assert axi_str_txd_tvalid = '0';

      wait until falling_edge(clk);
      assert reply_done_internal = '0'
        report "done internal";

      wait until falling_edge(clk);
      assert axi_str_rxd_tready = '1';
      assert reply_done_internal = '0'
        report "done internal";

      wait until falling_edge(clk);

    end loop;

    std.env.stop;

  end process STIMULUS;

end architecture RTL;
