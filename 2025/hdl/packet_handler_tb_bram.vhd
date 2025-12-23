library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.packet_types_pkg_hdr.ALL;
use work.packet_handler_pkg.ALL;

entity packet_handler_tb_bram is
end packet_handler_tb_bram;

architecture rtl of packet_handler_tb_bram is
  constant c_HALF_PERIOD_25_MHz : time := 20 ns;-- 25 MHz clock, 40 ns period

  signal clk: std_logic := '0';
  signal reset: std_logic := '0';

  signal axi_str_rxd_tvalid: std_logic := '0';
  signal axi_str_rxd_tready: std_logic;
  signal axi_str_rxd_tdata: std_logic_vector(31 downto 0) := x"00000000";

  signal axi_str_txd_tvalid: std_logic;
  signal axi_str_txd_tready: std_logic := '0';
  signal axi_str_txd_tdata: std_logic_vector(31 downto 0);

  signal bram_write_data_a: std_logic_vector(31 downto 0);
  signal bram_read_data_a: std_logic_vector(31 downto 0);
  signal bram_addr_a: std_logic;
  signal bram_write_valid_a: std_logic;
  signal bram_write_ready_a: std_logic;
  signal bram_read_req_a: std_logic;
  signal bram_read_valid_a: std_logic;
  signal bram_read_ready_a: std_logic;
begin
  packet_handler_inst: entity work.packet_handler(rtl)
    port map(
        reset => reset,
        clk => clk,

        axi_str_rxd_tvalid_IN => axi_str_rxd_tvalid,
        axi_str_rxd_tready_OUT => axi_str_rxd_tready,
        axi_str_rxd_tdata_IN => axi_str_rxd_tdata,

        axi_str_txd_tvalid_OUT => axi_str_txd_tvalid,
        axi_str_txd_tready_IN => axi_str_txd_tready,
        axi_str_txd_tdata_OUT => axi_str_txd_tdata,

        bram_write_data_a_OUT => bram_write_data_a,
        bram_read_data_a_IN => bram_read_data_a,
        bram_addr_a_OUT => bram_addr_a,
        bram_write_valid_a_OUT => bram_write_valid_a,
        bram_write_ready_a_IN => bram_write_ready_a,
        bram_read_req_a_OUT => bram_read_req_a,
        bram_read_valid_a_IN => bram_read_valid_a,
        bram_read_ready_a_OUT => bram_read_ready_a

    );

    blk_mem_wrapper_int: entity work.blk_mem_wrapper(rtl)
    port map(
        reset => reset,
        clk => clk,

        data_a_in => bram_write_data_a,
        data_a_out => bram_read_data_a,
        addr_a_in => bram_addr_a,
        write_valid_a_in => bram_write_valid_a,
        write_ready_a_out => bram_write_ready_a,
        read_req_a_in => bram_read_req_a,
        read_valid_a_out => bram_read_valid_a,
        read_ready_a_in => bram_read_ready_a
    );

    clk <= not clk after c_HALF_PERIOD_25_MHz; 

    stimulus: process
      alias reply_done_internal is
        << signal packet_handler_inst.reply_done: std_logic >>;
      alias rx_state_internal is
        << signal packet_handler_inst.rx_state: T_RX_STATE >>;
    begin
      reset <= '1';
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      reset <= '0';
      wait until rising_edge(clk);


      -- packet header
      wait until falling_edge(clk);
      axi_str_rxd_tdata <= x"00020008"; -- WRITE RAM, LENGTH 8
      axi_str_rxd_tvalid <= '1';
      -- wait for UUT to clock in the data on a rising edge
      wait until rising_edge(clk) and axi_str_rxd_tready = '1' for 10 ns;
      wait until falling_edge(clk);
      assert rx_state_internal = RX_STATE_RAM_OFFSET report "rx state offset";
      axi_str_rxd_tvalid <= '0';


      -- BRAM offset
      axi_str_rxd_tdata <= x"00000000";
      axi_str_rxd_tvalid <= '1';
      -- wait for UUT to clock in the data on a rising edge
      wait until rising_edge(clk) and axi_str_rxd_tready = '1' for 10 ns;
      wait until falling_edge(clk);
      assert rx_state_internal = RX_STATE_RAM_OFFSET report "rx state write ram";
      axi_str_rxd_tvalid <= '0';

      -- data to write
      axi_str_rxd_tdata <= x"12345678";
      axi_str_rxd_tvalid <= '1';
      -- wait for UUT to clock in the data on a rising edge
      wait until rising_edge(clk) and axi_str_rxd_tready = '1' for 10 ns;
      wait until falling_edge(clk);
      axi_str_rxd_tvalid <= '0';

      -- issue a read to verify the written data
      --TODO assume that the write succeeded and implement the ACK, then the read
      -- packet. Later, implement this part of the testbench using port B on the
      -- bram
      wait until falling_edge(clk);
      bram_write_data_a <= x"00000000";
      bram_addr_a <= '1';
      wait until falling_edge(clk);
      bram_addr_a <= '0';
      bram_read_req_a <= '1';
      wait until falling_edge(clk);
      assert bram_read_valid_a = '1';
      assert bram_read_data_a = x"12345678";
      bram_read_req_a <= '0';
      bram_read_ready_a <= '1';
      wait until falling_edge(clk);
      bram_read_ready_a <= '0';
      wait until falling_edge(clk);


      --wait until falling_edge(clk);
      --assert axi_str_rxd_tready = '0' report "tready";

      --wait until falling_edge(clk) and axi_str_txd_tvalid = '1' for 10 ns;
      --axi_str_txd_tready <= '1';
      --assert axi_str_txd_tdata = x"00010004" report "header";

      --wait until falling_edge(clk) and axi_str_txd_tvalid = '1' for 10 ns;
      --assert axi_str_txd_tdata = x"12345678" report "payload";
      --assert reply_done_internal = '0' report "done internal";

      --wait until falling_edge(clk);
      --assert reply_done_internal = '1' report "done internal";
      --assert axi_str_txd_tvalid = '0';

      --wait until falling_edge(clk);
      --assert reply_done_internal = '0' report "done internal";

      --wait until falling_edge(clk);
      --assert axi_str_rxd_tready = '1';
      --assert reply_done_internal = '0' report "done internal";

      wait until falling_edge(clk);


    std.env.stop;
  end process;
end rtl;
