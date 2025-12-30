library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
  signal bram_addr_b_in: std_logic_vector(11 downto 0) := x"000";
  signal bram_data_b_in: std_logic_vector(7 downto 0) := x"00";
  signal bram_data_b_out: std_logic_vector(7 downto 0);
  signal bram_port_b_write_enable_in: std_logic := '0';
  signal bram_port_b_enabled_out: std_logic;

  signal verbose: boolean := false;

  procedure wait_edge is
  begin
    wait until rising_edge(clk);
    wait for 2 ns;
  end procedure wait_edge;

  procedure wait_eq(
    signal value: in std_logic;
    expected: in std_logic;
    message: in string
  ) is
    variable clock_count: integer := 0;
  begin
    if verbose then
      report "wait for: " & message severity note;
    end if;
    wait_edge;
    while value /= expected loop
      wait_edge;
      clock_count := clock_count + 1;
      if clock_count = 10 then
        report "condition not met after timeout: " & message severity failure;
        exit;
      end if;
    end loop;
  end procedure wait_eq;

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
    m_axi_rready_port_a_OUT => bram_axi_rready_port_a
  );

  clk <= not clk after c_HALF_PERIOD_25_MHz; 

  stimulus: process
    alias reply_done_internal is
      << signal packet_handler_inst.reply_done: std_logic >>;
    alias rx_state_internal is
      << signal packet_handler_inst.rx_state: T_RX_STATE >>;
    variable counter_byte: std_logic_vector(7 downto 0);
    variable counter_tdata: std_logic_vector(31 downto 0);
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
    wait_edge;
    axi_str_rxd_tdata <= x"00020084"; -- WRITE RAM, LENGTH 128 + 4 = 0x84
    axi_str_rxd_tvalid <= '1';
    -- wait for UUT to clock in the data on a rising edge
    wait_eq(axi_str_rxd_tready, '1', "packet header");
    --wait_edge;
    axi_str_rxd_tvalid <= '0';

    -- BRAM offset
    axi_str_rxd_tdata <= x"00000000";
    axi_str_rxd_tvalid <= '1';
    -- wait for UUT to clock in the data on a rising edge
    wait_eq(axi_str_rxd_tready, '1', "BRAM offset");
    axi_str_rxd_tvalid <= '0';

    -- data to write - 32 words
    for word in 0 to 31 loop
      --report "word = " & integer'image(word);
      counter_byte := std_logic_vector(to_unsigned(word, counter_byte'length));
      counter_tdata := counter_byte & counter_byte & counter_byte & counter_byte;
      axi_str_rxd_tdata <= counter_tdata;
        
      axi_str_rxd_tvalid <= '1';
      -- wait for UUT to clock in the data on a rising edge
      wait_eq(axi_str_rxd_tready, '1', "txd tready for word " & integer'image(word));
      assert axi_str_rxd_tready = '1'
        report "tready not asserted for word " & integer'image(word);
    end loop;
    axi_str_rxd_tvalid <= '0';

    report "WAIT FOR WRITE ACK";

    -- wait for TVALID on ack

    -- ACK header
    wait_eq(axi_str_txd_tvalid, '1', "txd valid for ack");
    assert axi_str_txd_tvalid = '1' report "WRITE ACK header valid";
    assert axi_str_txd_tdata = x"00030008" report "WRITE ACK header data";
    axi_str_txd_tready <= '1';

    -- ACK payload = BRAM OFFSET
    wait_edge;
    assert axi_str_txd_tvalid = '1' report "WRITE ACK offset valid";
    assert axi_str_txd_tdata = x"00000000" report "WRITE ACK offset data";

    -- ACK payload = BRAM WRITE OKAY
    wait_edge;
    assert axi_str_txd_tvalid = '1' report "WRITE ACK okay valid";
    assert axi_str_txd_tdata = x"01000000" report "WRITE ACK okay data";

    wait_edge;
    axi_str_txd_tready <= '0';

    wait_edge;
    wait_edge;
    wait_edge;

    report "SEND READ REQ";

    -- issue a read to verify the written data
    -- packet header
    wait_edge;
    axi_str_rxd_tdata <= x"00040004"; -- WRITE RAM, LENGTH 128 + 4 = 0x84
    axi_str_rxd_tvalid <= '1';
    -- wait for UUT to clock in the data on a rising edge
    wait_eq(axi_str_rxd_tready, '1', "rxd tready");
    assert rx_state_internal = RX_STATE_RAM_OFFSET report "rx state offset";
    axi_str_rxd_tvalid <= '0';


    -- BRAM offset
    axi_str_rxd_tdata <= x"00000000";
    axi_str_rxd_tvalid <= '1';
    -- wait for UUT to clock in the data on a rising edge
    wait_eq(axi_str_rxd_tready, '1', "rxd tready");
    assert rx_state_internal = RX_STATE_SEND_REPLY report "rx state read ram";
    axi_str_rxd_tvalid <= '0';


    report "WAIT FOR READ ACK";
    verbose <= true;

    -- wait for TVALID on ack

    -- ACK header
    wait_eq(axi_str_txd_tvalid, '1', "txd tvalid");
    --wait_edge;
    assert axi_str_txd_tvalid = '1' report "READ ACK header valid";
    assert axi_str_txd_tdata = x"00050088" report "READ ACK header data";
    axi_str_txd_tready <= '1';

    -- ACK payload = BRAM OFFSET
    wait_edge;
    assert axi_str_txd_tvalid = '1' report "READ ACK offset valid";
    assert axi_str_txd_tdata = x"00000000" report "READ ACK offset data";

    -- ACK payload = BRAM WRITE OKAY
    wait_edge;
    assert axi_str_txd_tvalid = '1' report "READ ACK okay valid";
    assert axi_str_txd_tdata = x"01000000" report "READ ACK okay data";


    -- data read back - 32 words
    for word in 0 to 31 loop
      -- wait for UUT to clock out the data on a rising edge
      wait_eq(axi_str_txd_tvalid, '1', "txd tvalid for word " & integer'image(word));

      counter_byte := std_logic_vector(to_unsigned(word, counter_byte'length));
      counter_tdata := counter_byte & counter_byte & counter_byte & counter_byte;
      assert axi_str_txd_tvalid = '1'
        report "READ ACK data valid word" & integer'image(word);
      assert axi_str_txd_tdata = counter_tdata
        report "READ ACK data word" & integer'image(word);
      --wait until rising_edge(clk);
    end loop;

    wait_edge;
    axi_str_txd_tready <= '0';

    wait_edge;
    wait_edge;
    wait_edge;
    wait_edge;
    std.env.stop;
  end process;

  blk_mem_wrapper_inst: entity work.blk_mem_wrapper(rtl)
  port map(
    reset => reset,
    clk => clk,

    -- Port A controls --

    -- Write controls --
    s_axi_write_word_offset_port_a_IN  => bram_axi_write_word_offset_port_a,
    s_axi_awlen_port_a_IN  => bram_axi_awlen_port_a,
    s_axi_awvalid_port_a_IN  => bram_axi_awvalid_port_a,
    s_axi_awready_port_a_OUT  => bram_axi_awready_port_a,

    -- Write data --
    s_axi_wdata_port_a_IN  => bram_axi_wdata_port_a,
    s_axi_wlast_port_a_IN  => bram_axi_wlast_port_a,
    s_axi_wvalid_port_a_IN  => bram_axi_wvalid_port_a,
    s_axi_wready_port_a_OUT  => bram_axi_wready_port_a,

    -- Write response --
    s_axi_bresp_port_a_OUT  => bram_axi_bresp_port_a,
    s_axi_bvalid_port_a_OUT  => bram_axi_bvalid_port_a,
    s_axi_bready_port_a_IN  => bram_axi_bready_port_a,

    -- Read controls --
    s_axi_read_word_offset_port_a_IN  => bram_axi_read_word_offset_port_a,
    s_axi_arlen_port_a_IN  => bram_axi_arlen_port_a,
    s_axi_arvalid_port_a_IN  => bram_axi_arvalid_port_a,
    s_axi_arready_port_a_OUT  => bram_axi_arready_port_a,

    -- Read data --
    s_axi_rdata_port_a_OUT  => bram_axi_rdata_port_a,
    s_axi_rresp_port_a_OUT  => bram_axi_rresp_port_a,
    s_axi_rlast_port_a_OUT  => bram_axi_rlast_port_a,
    s_axi_rvalid_port_a_OUT  => bram_axi_rvalid_port_a,
    s_axi_rready_port_a_IN  => bram_axi_rready_port_a,

    -- Port B controls --
    bram_addr_b_in => bram_addr_b_in,
    bram_data_b_in => bram_data_b_in,
    bram_data_b_out => bram_data_b_out,
    bram_port_b_write_enable_in => bram_port_b_write_enable_in,
    bram_port_b_enabled_out => bram_port_b_enabled_out
  );
end rtl;
