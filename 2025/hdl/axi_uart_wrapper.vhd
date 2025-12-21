library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- AXI LITE responses:
--  OKAY (0b00):
--    Normal access success. Indicates that a normal access has been successful
--  EXOKAY (0b01):
--    Exclusive access okay.
--  SLVERR (0b10):
--    Slave error. The slave was reached successfully but the slave wishes to
--    return an error condition to the originating master (for example, data
--    read not valid).
--  DECERR (0b11):
--    Decode error. Generated, typically by an interconnect component, to
--    indicate that there is no slave at the transaction address

-- 115200 baud from a 50 MHz interface clock
entity axi_uart_wrapper is
  port (
        reset: in std_logic;
        clk: in std_logic;
        axi_clk: in std_logic;
        axi_nrst: in std_logic;
        rx_IN : IN STD_LOGIC;
        tx_OUT : OUT STD_LOGIC;

        axi_str_rxd_tvalid_OUT : OUT STD_LOGIC;
        axi_str_rxd_tready_IN : IN STD_LOGIC;
        axi_str_rxd_tdata_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        axi_str_txd_tvalid_IN : IN STD_LOGIC;
        axi_str_txd_tready_OUT : OUT STD_LOGIC;
        axi_str_txd_tdata_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        axi_str_txd_prog_full_OUT: OUT STD_LOGIC

  );
end axi_uart_wrapper;


architecture rtl of axi_uart_wrapper is

    constant c_AXI_RESP_OKAY: std_logic_vector(1 downto 0) := "00";
    constant c_AXI_RESP_EXOKAY: std_logic_vector(1 downto 0) := "01";
    constant c_AXI_RESP_SLVERR: std_logic_vector(1 downto 0) := "10";
    constant c_AXI_RESP_DECERR: std_logic_vector(1 downto 0) := "11";

    signal init_complete: std_logic := '0';

    signal interrupt : STD_LOGIC;

    -- uart IP
    signal s_axi_awaddr : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal s_axi_awvalid : STD_LOGIC := '0';
    signal s_axi_awready : STD_LOGIC;
    signal s_axi_wdata : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal s_axi_wvalid : STD_LOGIC := '0';
    signal s_axi_wready : STD_LOGIC;
    signal s_axi_bresp : STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal s_axi_bvalid : STD_LOGIC;
    signal s_axi_bready : STD_LOGIC := '0';
    signal s_axi_araddr : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal s_axi_arvalid : STD_LOGIC := '0';
    signal s_axi_arready : STD_LOGIC;
    signal s_axi_rdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal s_axi_rresp : STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal s_axi_rvalid : STD_LOGIC;
    signal s_axi_rready : STD_LOGIC := '0';

    -- from tx fifo to 32 to 8 converter
    signal axi_conv_tx_tvalid: std_logic;
    signal axi_conv_tx_tready: std_logic;
    signal axi_conv_tx_tdata: std_logic_vector(31 downto 0);

    -- from 8 to 32 converter to rx fifo
    signal axi_conv_rx_tvalid: std_logic;
    signal axi_conv_rx_tready: std_logic;
    signal axi_conv_rx_tdata: std_logic_vector(31 downto 0);

    -- from tx 32-8 converter to uart transmitter
    signal conv_uart_tx_tvalid: std_logic;
    signal conv_uart_tx_tready: std_logic;
    signal conv_uart_tx_tdata: std_logic_vector(7 downto 0);

    -- from uart receiver to rx 8-32 converter
    signal uart_conv_rx_tvalid: std_logic;
    signal uart_conv_rx_tready: std_logic;
    signal uart_conv_rx_tdata: std_logic_vector(7 downto 0);

    signal rx_fifo_prog_full: std_logic;
    signal rx_rresp_reg: std_logic_vector(1 downto 0);

    -- endian swapping
    signal axi_str_rxd_tdata_OUT_internal: std_logic_vector(31 downto 0);
    signal axi_str_txd_tdata_IN_internal: std_logic_vector(31 downto 0);

  type t_tx_state is (
    TX_STATE_INIT_INTERRUPT,
    TX_STATE_INIT_INTERRUPT_WAIT_RESPONSE,
    TX_STATE_IDLE,
    TX_STATE_WAIT_READY,
    TX_STATE_WRITE_DATA,
    TX_STATE_WAIT_RESPONSE
    );
  signal tx_state: t_tx_state := TX_STATE_INIT_INTERRUPT;

  type t_rx_state is (
    RX_STATE_WAIT_INIT,
    RX_STATE_IDLE,
    RX_STATE_WAIT_RADDR_READY,
    RX_STATE_WAIT_VALID,
    RX_STATE_PROCESS_READ_DATA,
    RX_STATE_WAIT_CONV
  );
  signal rx_state: t_rx_state := RX_STATE_WAIT_INIT;


COMPONENT axi_uartlite_0
  PORT (
    -- system
    s_axi_aclk : IN STD_LOGIC;
    s_axi_aresetn : IN STD_LOGIC;
    interrupt : OUT STD_LOGIC;

    -- write address channel
    s_axi_awaddr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_awvalid : IN STD_LOGIC;
    s_axi_awready : OUT STD_LOGIC;

    -- write data channel
    s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_wvalid : IN STD_LOGIC;
    s_axi_wready : OUT STD_LOGIC;

    -- write response channel
    s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bvalid : OUT STD_LOGIC;
    s_axi_bready : IN STD_LOGIC;

    -- read address channel
    s_axi_araddr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_arvalid : IN STD_LOGIC;
    s_axi_arready : OUT STD_LOGIC;

    -- read data channel
    s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_rvalid : OUT STD_LOGIC;
    s_axi_rready : IN STD_LOGIC;

    -- external signals
    rx : IN STD_LOGIC;
    tx : OUT STD_LOGIC 
  );
END COMPONENT;

  -- 8 to 32-bit converter for RX traffic
  COMPONENT axis_dwidth_converter_8_32
    PORT (
      aclk : IN STD_LOGIC;
      aresetn : IN STD_LOGIC;
      s_axis_tvalid : IN STD_LOGIC;
      s_axis_tready : OUT STD_LOGIC;
      s_axis_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_tvalid : OUT STD_LOGIC;
      m_axis_tready : IN STD_LOGIC;
      m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
    );
  END COMPONENT;

  -- 32 to 8-bit converter for TX traffic
  COMPONENT axis_dwidth_converter_32_8
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) 
  );
END COMPONENT;

COMPONENT axis_data_fifo_cdc_32x64
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_aclk : IN STD_LOGIC;
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    prog_full : OUT STD_LOGIC 
  );
END COMPONENT;

begin

axi_uartlite_0_inst : axi_uartlite_0
  PORT MAP (
    s_axi_aclk => axi_clk,
    s_axi_aresetn => axi_nrst,
    interrupt => interrupt,

    s_axi_awaddr => s_axi_awaddr,
    s_axi_awvalid => s_axi_awvalid,
    s_axi_awready => s_axi_awready,

    s_axi_wdata => s_axi_wdata,
    s_axi_wstrb => "1111",
    s_axi_wvalid => s_axi_wvalid,
    s_axi_wready => s_axi_wready,

    s_axi_bresp => s_axi_bresp,
    s_axi_bvalid => s_axi_bvalid,
    s_axi_bready => s_axi_bready,

    s_axi_araddr => s_axi_araddr,
    s_axi_arvalid => s_axi_arvalid,
    s_axi_arready => s_axi_arready,

    s_axi_rdata => s_axi_rdata,
    s_axi_rresp => s_axi_rresp,
    s_axi_rvalid => s_axi_rvalid,
    s_axi_rready => s_axi_rready,

    rx => rx_IN,
    tx => tx_OUT
  );

-- 8 to 32 converter, RX side
axis_dwidth_converter_8_32_inst : axis_dwidth_converter_8_32
  PORT MAP (
    aclk => axi_clk,
    aresetn => axi_nrst,
    -- FIFO input side
    s_axis_tvalid => uart_conv_rx_tvalid,
    s_axis_tready => uart_conv_rx_tready,
    s_axis_tdata => uart_conv_rx_tdata,
    -- FIFO output side
    m_axis_tvalid => axi_conv_rx_tvalid,
    m_axis_tready => axi_conv_rx_tready,
    m_axis_tdata => axi_conv_rx_tdata
  );

-- 32 to 8 converter, TX side
  axis_dwidth_converter_32_8_inst : axis_dwidth_converter_32_8
  PORT MAP (
    aclk => axi_clk,
    aresetn => axi_nrst,
    -- FIFO input side
    s_axis_tvalid => axi_conv_tx_tvalid,
    s_axis_tready => axi_conv_tx_tready,
    s_axis_tdata => axi_conv_tx_tdata,
    -- FIFO output side
    m_axis_tvalid => conv_uart_tx_tvalid,
    m_axis_tready => conv_uart_tx_tready,
    m_axis_tdata => conv_uart_tx_tdata
  );

  -- TX data FIFO
  axis_data_fifo_tx : axis_data_fifo_cdc_32x64
  PORT MAP (
    s_axis_aresetn => not reset,
    -- FIFO input side
    s_axis_aclk => clk,
    s_axis_tvalid => axi_str_txd_tvalid_IN,
    s_axis_tready => axi_str_txd_tready_OUT,
    s_axis_tdata => axi_str_txd_tdata_IN_internal,
    -- FIFO output side
    m_axis_aclk => axi_clk,
    m_axis_tvalid => axi_conv_tx_tvalid,
    m_axis_tready => axi_conv_tx_tready,
    m_axis_tdata => axi_conv_tx_tdata,
    --
    prog_full => axi_str_txd_prog_full_OUT
  );

-- RX data FIFO
  axis_data_fifo_rx : axis_data_fifo_cdc_32x64
  PORT MAP (
    s_axis_aresetn => axi_nrst,
    -- FIFO input side
    s_axis_aclk => axi_clk,
    s_axis_tvalid => axi_conv_rx_tvalid,
    s_axis_tready => axi_conv_rx_tready,
    s_axis_tdata => axi_conv_rx_tdata,
    -- FIFO output side
    m_axis_aclk => clk,
    m_axis_tvalid => axi_str_rxd_tvalid_OUT,
    m_axis_tready => axi_str_rxd_tready_IN,
    m_axis_tdata => axi_str_rxd_tdata_OUT_internal,
    --
    prog_full => rx_fifo_prog_full
  );

  async_assignments: process is
  begin
    axi_str_rxd_tdata_OUT <=
      axi_str_rxd_tdata_OUT_internal(7 downto 0)
      & axi_str_rxd_tdata_OUT_internal(15 downto 8)
      & axi_str_rxd_tdata_OUT_internal(23 downto 16)
      & axi_str_rxd_tdata_OUT_internal(31 downto 24);
    axi_str_txd_tdata_IN_internal <= 
      axi_str_txd_tdata_IN(7 downto 0)
      & axi_str_txd_tdata_IN(15 downto 8)
      & axi_str_txd_tdata_IN(23 downto 16)
      & axi_str_txd_tdata_IN(31 downto 24);
  end process;

  process (axi_clk, axi_nrst) is
  begin
    if(rising_edge(axi_clk)) then
      -- TX_STATE_INIT_INTERRUPT
      --  * Enable the interrupt on received data
      --  * Assert the init_complete signal to the RX process
      -- IDLE
      --  * wait for data on tx fifo
      -- WAIT TIMER
      --  * Send packets out at time intervals
      -- WRITE_DATA
      --  * Master asserts VALID as soon as data is available
      -- WAIT_READY
      --  * Wait for uart core to assert READY to indicate
      --    successful transfer
      -- WAIT_RESPONSE
      --  * wait for uart core to assert valid on the response channel

      s_axi_bready <= '0';
      conv_uart_tx_tready <= '0';

      case tx_state is
        when TX_STATE_INIT_INTERRUPT =>
          s_axi_awaddr <= x"c"; -- control register
          s_axi_wdata <= x"0000000" & "1000"; -- enable interrupt
          s_axi_awvalid <= '1';
            s_axi_wvalid <= '1';
          if (s_axi_wready = '1' and s_axi_awready = '1') then
            init_complete <= '1';
            s_axi_awvalid <= '0';
            s_axi_wvalid <= '0';
            s_axi_bready <= '1';
            tx_state <= TX_STATE_INIT_INTERRUPT_WAIT_RESPONSE;
          end if;
        when TX_STATE_INIT_INTERRUPT_WAIT_RESPONSE =>
          if (s_axi_bvalid = '1') then
            s_axi_bready <= '1';
            tx_state <= TX_STATE_IDLE;
          end if;
        when TX_STATE_IDLE =>
          if (conv_uart_tx_tvalid = '1') then
          conv_uart_tx_tready <= '1';
            s_axi_wdata <= x"000000" & conv_uart_tx_tdata;
            tx_state <= TX_STATE_WRITE_DATA;
          end if;
        when TX_STATE_WRITE_DATA =>
          s_axi_awaddr <= x"4"; -- TX FIFO
          s_axi_awvalid <= '1';
          s_axi_wvalid <= '1';
          tx_state <= TX_STATE_WAIT_READY;
        when TX_STATE_WAIT_READY =>
          if (s_axi_wready = '1' and s_axi_awready = '1') then
            s_axi_awvalid <= '0';
            s_axi_wvalid <= '0';
            tx_state <= TX_STATE_WAIT_RESPONSE;
          end if;
        when TX_STATE_WAIT_RESPONSE =>
            if (s_axi_bvalid = '1') then
              s_axi_bready <= '1';
              if (s_axi_bresp = c_AXI_RESP_OKAY) then
                -- Byte was queued successfully
                tx_state <= TX_STATE_IDLE;
              else
                -- TX FIFO is full, try again
                tx_state <= TX_STATE_WRITE_DATA;
              end if;
            end if;
      end case;

      if (axi_nrst = '0') then
        init_complete <= '0';
        tx_state <= TX_STATE_INIT_INTERRUPT;
        s_axi_awvalid <= '0';
        s_axi_wvalid <= '0';
        conv_uart_tx_tready <= '0';
      end if;
    end if;
  end process;


  process (axi_clk, axi_nrst) is
  begin
    if(rising_edge(axi_clk)) then
      -- RX_STATE_WAIT_INIT
      --  * Wait for TX task to assert init_complete
      -- RX_STATE_IDLE
      --  * Set read addr and assert VALID
      -- RX_STATE_WAIT_RADDR_READY
      --  * Wait for uart core to accept read address
      --  * assert READY on read data
      -- RX_STATE_WAIT_VALID
      --  * wait for VALID on read data
      -- RX_STATE_PROCESS_READ_DATA
      --  * read in the data and push to data width fifo
      -- RX_STATE_WAIT_CONV
      --  * wait for data width fifo to assert ready
      case rx_state is
        when RX_STATE_WAIT_INIT =>
          if (init_complete = '1') then
            rx_state <= RX_STATE_IDLE;
          end if;
        when RX_STATE_IDLE =>
          --if (interrupt = '1') then
            s_axi_araddr <= x"0";
            s_axi_arvalid <= '1';
            rx_state <= RX_STATE_WAIT_RADDR_READY;
          --end if;
        when RX_STATE_WAIT_RADDR_READY =>
          if (s_axi_arready = '1') then
            s_axi_arvalid <= '0';
            rx_state <= RX_STATE_WAIT_VALID;
          end if;
        when RX_STATE_WAIT_VALID =>
          if (s_axi_rvalid = '1') then
            s_axi_rready <= '1';
            rx_rresp_reg <= s_axi_rresp;
            -- only lower 8 bits are used
            uart_conv_rx_tdata  <= s_axi_rdata(7 downto 0);
            rx_state <= RX_STATE_PROCESS_READ_DATA;
          end if;
        when RX_STATE_PROCESS_READ_DATA =>
          -- if read was successful then assert TVALID and wait for TREADY
          s_axi_rready <= '0';
          if (rx_rresp_reg = c_AXI_RESP_OKAY) then
            if (rx_fifo_prog_full = '0') then
              uart_conv_rx_tvalid <= '1';
              rx_state <= RX_STATE_WAIT_CONV;
            end if;
          else
            rx_state <= RX_STATE_IDLE;
          end if;
        when RX_STATE_WAIT_CONV =>
          if (uart_conv_rx_tready = '1') then
              uart_conv_rx_tvalid <= '0';
            rx_state <= RX_STATE_IDLE;
          end if;
        end case;

      if (axi_nrst = '0') then
        rx_state <= RX_STATE_WAIT_INIT;
        s_axi_arvalid <= '0';
        s_axi_rready <= '0';

        rx_rresp_reg <= "00";
        uart_conv_rx_tvalid <= '0';
        uart_conv_rx_tdata  <= x"00";
      end if;
    end if;
  end process;


  end rtl;
