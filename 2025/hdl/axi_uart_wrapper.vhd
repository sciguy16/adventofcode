library ieee;
  use ieee.std_logic_1164.all;
  use work.aoc_top_pkg_hdr.all;
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
    RESET    : in    std_logic;
    CLK      : in    std_logic;
    AXI_CLK  : in    std_logic;
    AXI_NRST : in    std_logic;
    RX_IN    : in    std_logic;
    TX_OUT   : out   std_logic;

    AXI_STR_RXD_TVALID_OUT : out   std_logic;
    AXI_STR_RXD_TREADY_IN  : in    std_logic;
    AXI_STR_RXD_TDATA_OUT  : out   std_logic_vector(31 downto 0);

    AXI_STR_TXD_TVALID_IN  : in    std_logic;
    AXI_STR_TXD_TREADY_OUT : out   std_logic;
    AXI_STR_TXD_TDATA_IN   : in    std_logic_vector(31 downto 0)
  );
end entity axi_uart_wrapper;

architecture RTL of AXI_UART_WRAPPER is
  signal init_complete : std_logic := '0';

  signal interrupt : std_logic;

  -- uart IP
  signal s_axi_awaddr  : std_logic_vector(3 downto 0)  := (others => '0');
  signal s_axi_awvalid : std_logic                     := '0';
  signal s_axi_awready : std_logic;
  signal s_axi_wdata   : std_logic_vector(31 downto 0) := (others => '0');
  signal s_axi_wvalid  : std_logic                     := '0';
  signal s_axi_wready  : std_logic;
  signal s_axi_bresp   : std_logic_vector(1 downto 0);
  signal s_axi_bvalid  : std_logic;
  signal s_axi_bready  : std_logic                     := '0';
  signal s_axi_araddr  : std_logic_vector(3 downto 0)  := (others => '0');
  signal s_axi_arvalid : std_logic                     := '0';
  signal s_axi_arready : std_logic;
  signal s_axi_rdata   : std_logic_vector(31 downto 0);
  signal s_axi_rresp   : std_logic_vector(1 downto 0);
  signal s_axi_rvalid  : std_logic;
  signal s_axi_rready  : std_logic                     := '0';

  -- from tx fifo to 32 to 8 converter
  signal axi_conv_tx_tvalid : std_logic;
  signal axi_conv_tx_tready : std_logic;
  signal axi_conv_tx_tdata  : std_logic_vector(31 downto 0);

  -- from 8 to 32 converter to rx fifo
  signal axi_conv_rx_tvalid : std_logic;
  signal axi_conv_rx_tready : std_logic;
  signal axi_conv_rx_tdata  : std_logic_vector(31 downto 0);

  -- from tx 32-8 converter to uart transmitter
  signal conv_uart_tx_tvalid : std_logic;
  signal conv_uart_tx_tready : std_logic;
  signal conv_uart_tx_tdata  : std_logic_vector(7 downto 0);

  -- from uart receiver to rx 8-32 converter
  signal uart_conv_rx_tvalid : std_logic;
  signal uart_conv_rx_tready : std_logic;
  signal uart_conv_rx_tdata  : std_logic_vector(7 downto 0);

  signal rx_rresp_reg : std_logic_vector(1 downto 0);

  -- endian swapping
  signal axi_str_rxd_tdata_out_internal : std_logic_vector(31 downto 0);
  signal axi_str_txd_tdata_in_internal  : std_logic_vector(31 downto 0);

  type t_tx_state is (
    TX_STATE_INIT_INTERRUPT,
    TX_STATE_INIT_INTERRUPT_WAIT_RESPONSE,
    TX_STATE_IDLE,
    TX_STATE_WAIT_READY,
    TX_STATE_WRITE_DATA,
    TX_STATE_WAIT_RESPONSE
  );

  signal tx_state : t_tx_state := TX_STATE_INIT_INTERRUPT;

  type t_rx_state is (
    RX_STATE_WAIT_INIT,
    RX_STATE_IDLE,
    RX_STATE_WAIT_RADDR_READY,
    RX_STATE_WAIT_VALID,
    RX_STATE_PROCESS_READ_DATA,
    RX_STATE_WAIT_CONV
  );

  signal rx_state : t_rx_state := RX_STATE_WAIT_INIT;

  component AXI_UARTLITE_0 is
    port (
      -- system
      S_AXI_ACLK    : in    std_logic;
      S_AXI_ARESETN : in    std_logic;
      INTERRUPT     : out   std_logic;

      -- write address channel
      S_AXI_AWADDR  : in    std_logic_vector(3 downto 0);
      S_AXI_AWVALID : in    std_logic;
      S_AXI_AWREADY : out   std_logic;

      -- write data channel
      S_AXI_WDATA  : in    std_logic_vector(31 downto 0);
      S_AXI_WSTRB  : in    std_logic_vector(3 downto 0);
      S_AXI_WVALID : in    std_logic;
      S_AXI_WREADY : out   std_logic;

      -- write response channel
      S_AXI_BRESP  : out   std_logic_vector(1 downto 0);
      S_AXI_BVALID : out   std_logic;
      S_AXI_BREADY : in    std_logic;

      -- read address channel
      S_AXI_ARADDR  : in    std_logic_vector(3 downto 0);
      S_AXI_ARVALID : in    std_logic;
      S_AXI_ARREADY : out   std_logic;

      -- read data channel
      S_AXI_RDATA  : out   std_logic_vector(31 downto 0);
      S_AXI_RRESP  : out   std_logic_vector(1 downto 0);
      S_AXI_RVALID : out   std_logic;
      S_AXI_RREADY : in    std_logic;

      -- external signals
      RX : in    std_logic;
      TX : out   std_logic
    );
  end component AXI_UARTLITE_0;

  -- 8 to 32-bit converter for RX traffic
  component AXIS_DWIDTH_CONVERTER_8_32 is
    port (
      ACLK          : in    std_logic;
      ARESETN       : in    std_logic;
      S_AXIS_TVALID : in    std_logic;
      S_AXIS_TREADY : out   std_logic;
      S_AXIS_TDATA  : in    std_logic_vector(7 downto 0);
      M_AXIS_TVALID : out   std_logic;
      M_AXIS_TREADY : in    std_logic;
      M_AXIS_TDATA  : out   std_logic_vector(31 downto 0)
    );
  end component AXIS_DWIDTH_CONVERTER_8_32;

  -- 32 to 8-bit converter for TX traffic
  component AXIS_DWIDTH_CONVERTER_32_8 is
    port (
      ACLK          : in    std_logic;
      ARESETN       : in    std_logic;
      S_AXIS_TVALID : in    std_logic;
      S_AXIS_TREADY : out   std_logic;
      S_AXIS_TDATA  : in    std_logic_vector(31 downto 0);
      M_AXIS_TVALID : out   std_logic;
      M_AXIS_TREADY : in    std_logic;
      M_AXIS_TDATA  : out   std_logic_vector(7 downto 0)
    );
  end component AXIS_DWIDTH_CONVERTER_32_8;

  component AXIS_DATA_FIFO_CDC_32X64 is
    port (
      S_AXIS_ARESETN : in    std_logic;
      S_AXIS_ACLK    : in    std_logic;
      S_AXIS_TVALID  : in    std_logic;
      S_AXIS_TREADY  : out   std_logic;
      S_AXIS_TDATA   : in    std_logic_vector(31 downto 0);
      M_AXIS_ACLK    : in    std_logic;
      M_AXIS_TVALID  : out   std_logic;
      M_AXIS_TREADY  : in    std_logic;
      M_AXIS_TDATA   : out   std_logic_vector(31 downto 0);
      PROG_FULL      : out   std_logic
    );
  end component AXIS_DATA_FIFO_CDC_32X64;

begin

  AXI_UARTLITE_0_INST : AXI_UARTLITE_0
    port map (
      S_AXI_ACLK    => AXI_CLK,
      S_AXI_ARESETN => AXI_NRST,
      INTERRUPT     => interrupt,

      S_AXI_AWADDR  => s_axi_awaddr,
      S_AXI_AWVALID => s_axi_awvalid,
      S_AXI_AWREADY => s_axi_awready,

      S_AXI_WDATA  => s_axi_wdata,
      S_AXI_WSTRB  => "1111",
      S_AXI_WVALID => s_axi_wvalid,
      S_AXI_WREADY => s_axi_wready,

      S_AXI_BRESP  => s_axi_bresp,
      S_AXI_BVALID => s_axi_bvalid,
      S_AXI_BREADY => s_axi_bready,

      S_AXI_ARADDR  => s_axi_araddr,
      S_AXI_ARVALID => s_axi_arvalid,
      S_AXI_ARREADY => s_axi_arready,

      S_AXI_RDATA  => s_axi_rdata,
      S_AXI_RRESP  => s_axi_rresp,
      S_AXI_RVALID => s_axi_rvalid,
      S_AXI_RREADY => s_axi_rready,

      RX => RX_IN,
      TX => TX_OUT
    );

  -- 8 to 32 converter, RX side
  AXIS_DWIDTH_CONVERTER_8_32_INST : AXIS_DWIDTH_CONVERTER_8_32
    port map (
      ACLK    => AXI_CLK,
      ARESETN => AXI_NRST,
      -- FIFO input side
      S_AXIS_TVALID => uart_conv_rx_tvalid,
      S_AXIS_TREADY => uart_conv_rx_tready,
      S_AXIS_TDATA  => uart_conv_rx_tdata,
      -- FIFO output side
      M_AXIS_TVALID => axi_conv_rx_tvalid,
      M_AXIS_TREADY => axi_conv_rx_tready,
      M_AXIS_TDATA  => axi_conv_rx_tdata
    );

  -- 32 to 8 converter, TX side
  AXIS_DWIDTH_CONVERTER_32_8_INST : AXIS_DWIDTH_CONVERTER_32_8
    port map (
      ACLK    => AXI_CLK,
      ARESETN => AXI_NRST,
      -- FIFO input side
      S_AXIS_TVALID => axi_conv_tx_tvalid,
      S_AXIS_TREADY => axi_conv_tx_tready,
      S_AXIS_TDATA  => axi_conv_tx_tdata,
      -- FIFO output side
      M_AXIS_TVALID => conv_uart_tx_tvalid,
      M_AXIS_TREADY => conv_uart_tx_tready,
      M_AXIS_TDATA  => conv_uart_tx_tdata
    );

  -- TX data FIFO
  AXIS_DATA_FIFO_TX : AXIS_DATA_FIFO_CDC_32X64
    port map (
      S_AXIS_ARESETN => not RESET,
      -- FIFO input side
      S_AXIS_ACLK   => CLK,
      S_AXIS_TVALID => AXI_STR_TXD_TVALID_IN,
      S_AXIS_TREADY => AXI_STR_TXD_TREADY_OUT,
      S_AXIS_TDATA  => axi_str_txd_tdata_in_internal,
      -- FIFO output side
      M_AXIS_ACLK   => AXI_CLK,
      M_AXIS_TVALID => axi_conv_tx_tvalid,
      M_AXIS_TREADY => axi_conv_tx_tready,
      M_AXIS_TDATA  => axi_conv_tx_tdata,
      --
      PROG_FULL => open
    );

  -- RX data FIFO
  AXIS_DATA_FIFO_RX : AXIS_DATA_FIFO_CDC_32X64
    port map (
      S_AXIS_ARESETN => AXI_NRST,
      -- FIFO input side
      S_AXIS_ACLK   => AXI_CLK,
      S_AXIS_TVALID => axi_conv_rx_tvalid,
      S_AXIS_TREADY => axi_conv_rx_tready,
      S_AXIS_TDATA  => axi_conv_rx_tdata,
      -- FIFO output side
      M_AXIS_ACLK   => CLK,
      M_AXIS_TVALID => AXI_STR_RXD_TVALID_OUT,
      M_AXIS_TREADY => AXI_STR_RXD_TREADY_IN,
      M_AXIS_TDATA  => axi_str_rxd_tdata_out_internal,
      --
      PROG_FULL => open
    );

  -- endianness swapping
  AXI_STR_RXD_TDATA_OUT <= axi_str_rxd_tdata_out_internal(7 downto 0)
                           & axi_str_rxd_tdata_out_internal(15 downto 8)
                           & axi_str_rxd_tdata_out_internal(23 downto 16)
                           & axi_str_rxd_tdata_out_internal(31 downto 24);

  axi_str_txd_tdata_in_internal <= AXI_STR_TXD_TDATA_IN(7 downto 0)
                                   & AXI_STR_TXD_TDATA_IN(15 downto 8)
                                   & AXI_STR_TXD_TDATA_IN(23 downto 16)
                                   & AXI_STR_TXD_TDATA_IN(31 downto 24);

  UART_TX_PROC : process (AXI_CLK) is
  begin
    if rising_edge(AXI_CLK) then
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

      s_axi_bready        <= '0';
      conv_uart_tx_tready <= '0';

      case tx_state is

        when TX_STATE_INIT_INTERRUPT =>
          s_axi_awaddr  <= x"C";                -- control register
          s_axi_wdata   <= x"0000000" & "1000"; -- enable interrupt
          s_axi_awvalid <= '1';
          s_axi_wvalid  <= '1';
          if (s_axi_wready = '1' and s_axi_awready = '1') then
            init_complete <= '1';
            s_axi_awvalid <= '0';
            s_axi_wvalid  <= '0';
            s_axi_bready  <= '1';
            tx_state      <= TX_STATE_INIT_INTERRUPT_WAIT_RESPONSE;
          end if;

        when TX_STATE_INIT_INTERRUPT_WAIT_RESPONSE =>
          if (s_axi_bvalid = '1') then
            s_axi_bready <= '1';
            tx_state     <= TX_STATE_IDLE;
          end if;

        when TX_STATE_IDLE =>
          if (conv_uart_tx_tvalid = '1') then
            conv_uart_tx_tready <= '1';
            s_axi_wdata         <= x"000000" & conv_uart_tx_tdata;
            tx_state            <= TX_STATE_WRITE_DATA;
          end if;

        when TX_STATE_WRITE_DATA =>
          s_axi_awaddr  <= x"4"; -- TX FIFO
          s_axi_awvalid <= '1';
          s_axi_wvalid  <= '1';
          tx_state      <= TX_STATE_WAIT_READY;

        when TX_STATE_WAIT_READY =>
          if (s_axi_wready = '1' and s_axi_awready = '1') then
            s_axi_awvalid <= '0';
            s_axi_wvalid  <= '0';
            tx_state      <= TX_STATE_WAIT_RESPONSE;
          end if;

        when TX_STATE_WAIT_RESPONSE =>
          if (s_axi_bvalid = '1') then
            s_axi_bready <= '1';
            with s_axi_bresp select tx_state <=
              -- Byte was queued successfully
              TX_STATE_IDLE when c_AXI_RESP_OKAY,
              -- TX FIFO is full, try again
              TX_STATE_WRITE_DATA when others;
          end if;
      end case;

      if (AXI_NRST = '0') then
        init_complete       <= '0';
        tx_state            <= TX_STATE_INIT_INTERRUPT;
        s_axi_awvalid       <= '0';
        s_axi_wvalid        <= '0';
        conv_uart_tx_tready <= '0';
      end if;
    end if;
  end process UART_TX_PROC;

  UART_RX_PROC : process (AXI_CLK) is
  begin
    if (rising_edge(AXI_CLK)) then
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
          -- if (interrupt = '1') then
          s_axi_araddr  <= x"0";
          s_axi_arvalid <= '1';
          rx_state      <= RX_STATE_WAIT_RADDR_READY;

        -- end if;
        when RX_STATE_WAIT_RADDR_READY =>
          if (s_axi_arready = '1') then
            s_axi_arvalid <= '0';
            rx_state      <= RX_STATE_WAIT_VALID;
          end if;

        when RX_STATE_WAIT_VALID =>
          if (s_axi_rvalid = '1') then
            s_axi_rready <= '1';
            rx_rresp_reg <= s_axi_rresp;
            -- only lower 8 bits are used
            uart_conv_rx_tdata <= s_axi_rdata(7 downto 0);
            rx_state           <= RX_STATE_PROCESS_READ_DATA;
          end if;

        when RX_STATE_PROCESS_READ_DATA =>
          -- if read was successful then assert TVALID and wait for TREADY
          s_axi_rready <= '0';
          if (rx_rresp_reg = c_AXI_RESP_OKAY) then
            uart_conv_rx_tvalid <= '1';
            rx_state            <= RX_STATE_WAIT_CONV;
          else
            rx_state <= RX_STATE_IDLE;
          end if;

        when RX_STATE_WAIT_CONV =>
          if (uart_conv_rx_tready = '1') then
            uart_conv_rx_tvalid <= '0';
            rx_state            <= RX_STATE_IDLE;
          end if;
      end case;

      if (AXI_NRST = '0') then
        rx_state      <= RX_STATE_WAIT_INIT;
        s_axi_arvalid <= '0';
        s_axi_rready  <= '0';

        rx_rresp_reg        <= "00";
        uart_conv_rx_tvalid <= '0';
        uart_conv_rx_tdata  <= x"00";
      end if;
    end if;
  end process UART_RX_PROC;

end architecture RTL;
