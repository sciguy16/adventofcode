library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.packet_types_pkg_hdr.ALL;
use work.packet_handler_pkg.ALL;

entity packet_handler_tb_bram is
end packet_handler_tb_bram;

architecture rtl of packet_handler_tb_bram is
  constant c_HALF_PERIOD_25_MHz : time := 20 ns;-- 25 MHz clock, 40 ns period
  constant c_TIMEOUT: time := 8 * c_HALF_PERIOD_25_MHz;

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

      report "SEND WRITE REQ";

      -- packet header
      wait until falling_edge(clk);
      axi_str_rxd_tdata <= x"00020084"; -- WRITE RAM, LENGTH 128 + 4 = 0x84
      axi_str_rxd_tvalid <= '1';
      -- wait for UUT to clock in the data on a rising edge
      wait until rising_edge(clk) and axi_str_rxd_tready = '1' for c_TIMEOUT;
      wait until falling_edge(clk);
      assert rx_state_internal = RX_STATE_RAM_OFFSET report "rx state offset";
      axi_str_rxd_tvalid <= '0';


      -- BRAM offset
      axi_str_rxd_tdata <= x"00000000";
      axi_str_rxd_tvalid <= '1';
      -- wait for UUT to clock in the data on a rising edge
      wait until rising_edge(clk) and axi_str_rxd_tready = '1' for c_TIMEOUT;
      wait until falling_edge(clk);
      assert rx_state_internal = RX_STATE_WRITE_RAM report "rx state write ram";
      --assert rx_state_internal = RX_STATE_WRITE_RAM_WAIT_READY
      --  report "rx state write ram wait ready";
      axi_str_rxd_tvalid <= '0';

      -- data to write - 32 words
      for word in 0 to 31 loop
        --report "word = " & integer'image(word);
        axi_str_rxd_tdata <= x"12345678";
        axi_str_rxd_tvalid <= '1';
        -- wait for UUT to clock in the data on a rising edge
        wait until rising_edge(clk) and axi_str_rxd_tready = '1' for c_TIMEOUT;
        assert axi_str_rxd_tready = '1'
          report "tready not asserted for word " & integer'image(word);
        wait until falling_edge(clk);
      end loop;
      axi_str_rxd_tvalid <= '0';

      report "WAIT FOR WRITE ACK";

      -- wait for TVALID on ack
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      wait until falling_edge(clk);

      -- ACK header
      wait until rising_edge(clk) and axi_str_txd_tvalid = '1' for c_TIMEOUT;
      wait until falling_edge(clk);
      assert axi_str_txd_tvalid = '1' report "WRITE ACK header valid";
      assert axi_str_txd_tdata = x"00030008" report "WRITE ACK header data";
      axi_str_txd_tready <= '1';

      -- ACK payload = BRAM OFFSET
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      assert axi_str_txd_tvalid = '1' report "WRITE ACK offset valid";
      assert axi_str_txd_tdata = x"00000000" report "WRITE ACK offset data";

      -- ACK payload = BRAM WRITE OKAY
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      assert axi_str_txd_tvalid = '1' report "WRITE ACK okay valid";
      assert axi_str_txd_tdata = x"01000000" report "WRITE ACK okay data";

      wait until falling_edge(clk);
      axi_str_txd_tready <= '0';

      wait until falling_edge(clk);
      wait until falling_edge(clk);
      wait until falling_edge(clk);

      report "SEND READ REQ";

      -- issue a read to verify the written data
      -- packet header
      wait until falling_edge(clk);
      axi_str_rxd_tdata <= x"00040004"; -- WRITE RAM, LENGTH 128 + 4 = 0x84
      axi_str_rxd_tvalid <= '1';
      -- wait for UUT to clock in the data on a rising edge
      wait until rising_edge(clk) and axi_str_rxd_tready = '1' for c_TIMEOUT;
      wait until falling_edge(clk);
      assert rx_state_internal = RX_STATE_RAM_OFFSET report "rx state offset";
      axi_str_rxd_tvalid <= '0';


      -- BRAM offset
      axi_str_rxd_tdata <= x"00000000";
      axi_str_rxd_tvalid <= '1';
      -- wait for UUT to clock in the data on a rising edge
      wait until rising_edge(clk) and axi_str_rxd_tready = '1' for c_TIMEOUT;
      wait until falling_edge(clk);
      assert rx_state_internal = RX_STATE_SEND_REPLY report "rx state read ram";
      --assert rx_state_internal = RX_STATE_WRITE_RAM_WAIT_READY
      --  report "rx state write ram wait ready";
      axi_str_rxd_tvalid <= '0';


      report "WAIT FOR READ ACK";

      -- wait for TVALID on ack
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      wait until falling_edge(clk);

      -- ACK header
      wait until rising_edge(clk) and axi_str_txd_tvalid = '1' for c_TIMEOUT;
      wait until falling_edge(clk);
      assert axi_str_txd_tvalid = '1' report "READ ACK header valid";
      assert axi_str_txd_tdata = x"00050084" report "READ ACK header data";
      axi_str_txd_tready <= '1';

      -- ACK payload = BRAM OFFSET
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      assert axi_str_txd_tvalid = '1' report "READ ACK offset valid";
      assert axi_str_txd_tdata = x"00000000" report "READ ACK offset data";

      -- ACK payload = BRAM WRITE OKAY
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      assert axi_str_txd_tvalid = '1' report "READ ACK okay valid";
      assert axi_str_txd_tdata = x"01000000" report "READ ACK okay data";


      -- data read back - 32 words
      for word in 0 to 31 loop
        -- wait for UUT to clock out the data on a rising edge
        --report "wait for tvalid on falling edge" & integer'image(word);
        wait_valid: loop
          wait until falling_edge(clk);
          if axi_str_txd_tvalid = '1' then
            exit wait_valid;
          end if;
        end loop;
        --report "tvalid on falling edge" & integer'image(word);
        assert axi_str_txd_tvalid = '1'
          report "READ ACK data valid word" & integer'image(word);
        assert axi_str_txd_tdata = x"12345678"
          report "READ ACK data word" & integer'image(word);
        wait until rising_edge(clk);
      end loop;

      wait until falling_edge(clk);
      axi_str_txd_tready <= '0';

      wait until falling_edge(clk);
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      wait until falling_edge(clk);
    std.env.stop;
  end process;
end rtl;
