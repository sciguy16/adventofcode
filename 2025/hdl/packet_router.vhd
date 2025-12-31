library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.packet_types_pkg_hdr.all;

-- TODO read full packet into BRAM and then pass it to handler to process,
-- otherwise every process will have to implement the same receive logic.
-- Similarly, set up an output BRAM for reply packets. This way the packet
-- router can do the CRC checks on inbound packets and append the CRC to
-- outbound packets.

entity PACKET_ROUTER is
  port (
    RESET                    : in    std_logic;
    CLK                      : in    std_logic;

    AXI_STR_RXD_TVALID_IN    : in    std_logic;
    AXI_STR_RXD_TREADY_OUT   : out   std_logic;
    AXI_STR_RXD_TDATA_IN     : in    std_logic_vector(31 downto 0);

    AXI_STR_TXD_TVALID_OUT   : out   std_logic;
    AXI_STR_TXD_TREADY_IN    : in    std_logic;
    AXI_STR_TXD_TDATA_OUT    : out   std_logic_vector(31 downto 0);
    AXI_STR_TXD_PROG_FULL_IN : in    std_logic
  );
end entity PACKET_ROUTER;

architecture RTL of PACKET_ROUTER is

  component PACKET_HANDLER_INTERNAL is
    port (
      RESET                    : in    std_logic;
      CLK                      : in    std_logic;

      AXI_STR_RXD_TVALID_IN    : in    std_logic;
      AXI_STR_RXD_TREADY_OUT   : out   std_logic;
      AXI_STR_RXD_TDATA_IN     : in    std_logic_vector(31 downto 0);

      AXI_STR_TXD_TVALID_OUT   : out   std_logic;
      AXI_STR_TXD_TREADY_IN    : in    std_logic;
      AXI_STR_TXD_TDATA_OUT    : out   std_logic_vector(31 downto 0);
      AXI_STR_TXD_PROG_FULL_IN : in    std_logic;

      DONE_OUT                 : out   std_logic
    );
  end component PACKET_HANDLER_INTERNAL;

  component AXIS_REGISTER_SLICE_0 is
    port (
      ACLK          : in    std_logic;
      ARESETN       : in    std_logic;
      S_AXIS_TVALID : in    std_logic;
      S_AXIS_TREADY : out   std_logic;
      S_AXIS_TDATA  : in    std_logic_vector(31 downto 0);
      M_AXIS_TVALID : out   std_logic;
      M_AXIS_TREADY : in    std_logic;
      M_AXIS_TDATA  : out   std_logic_vector(31 downto 0)
    );
  end component AXIS_REGISTER_SLICE_0;

  type t_std_logic_array is array (0 to C_NUM_DESTINATIONS - 1) of std_logic;

  type t_std_logic_vector_array is array (0 to C_NUM_DESTINATIONS - 1)
        of std_logic_vector(31 downto 0);

  signal packet_header             : t_packet_header      := C_PACKET_HEADER_INIT;
  signal mux_sel                   : unsigned(7 downto 0) := (others => '0');
  signal mux_enable                : std_logic            := '0';
  signal downstream_done           : std_logic            := '0';
  signal downstream_done_arr       : t_std_logic_array;

  signal downstream_rxd_tvalid     : t_std_logic_array;
  signal downstream_rxd_tvalid_reg : t_std_logic_array;
  signal downstream_rxd_tready     : t_std_logic_array;
  signal downstream_rxd_tready_reg : t_std_logic_array;
  signal downstream_rxd_tdata      : t_std_logic_vector_array;
  signal downstream_rxd_tdata_reg  : t_std_logic_vector_array;

  signal downstream_txd_tvalid     : t_std_logic_array;
  signal downstream_txd_tready     : t_std_logic_array;
  signal downstream_txd_tdata      : t_std_logic_vector_array;
  signal downstream_txd_prog_full  : t_std_logic_array;

  type t_rx_state is (
    RX_STATE_IDLE,
    RX_STATE_WAIT_DOWNSTREAM_DONE
  );

  signal rx_state                  : t_rx_state := RX_STATE_IDLE;

begin

  process (CLK, RESET) is
  begin

    if (rising_edge(CLK)) then

      case (rx_state) is

        when RX_STATE_IDLE =>

          if (
              AXI_STR_RXD_TVALID_IN = '1'
              and unsigned(AXI_STR_RXD_TDATA_IN(31 downto 24))
              < C_NUM_DESTINATIONS) then
            mux_sel    <= unsigned(AXI_STR_RXD_TDATA_IN(31 downto 24));
            mux_enable <= '1';
            rx_state   <= RX_STATE_WAIT_DOWNSTREAM_DONE;
          end if;

        when RX_STATE_WAIT_DOWNSTREAM_DONE =>

          if (downstream_done = '1') then
            mux_enable <= '0';
            rx_state   <= RX_STATE_IDLE;
          end if;

      end case;

      if (RESET = '1') then
        rx_state   <= RX_STATE_IDLE;
        mux_enable <= '0';
        mux_sel    <= (others => '0');
      end if;
    end if;

  end process;

  process (all) is

    variable sel : integer := to_integer(mux_sel);

  begin

    if (mux_enable = '1' and RESET = '0') then
      downstream_rxd_tvalid(sel) <= AXI_STR_RXD_TVALID_IN;
      AXI_STR_RXD_TREADY_OUT     <= downstream_rxd_tready(sel);
      downstream_rxd_tdata(sel)  <= AXI_STR_RXD_TDATA_IN;

      AXI_STR_TXD_TVALID_OUT     <= downstream_txd_tvalid(sel);
      downstream_txd_tready(sel) <= AXI_STR_TXD_TREADY_IN;
      AXI_STR_TXD_TDATA_OUT      <= downstream_txd_tdata(sel);

      downstream_done <= downstream_done_arr(sel);
    else
      downstream_rxd_tvalid  <= (others => '0');
      AXI_STR_RXD_TREADY_OUT <= '0';
      downstream_rxd_tdata   <= (others => (others => '0'));

      AXI_STR_TXD_TVALID_OUT   <= '0';
      downstream_txd_tready    <= (others => '0');
      AXI_STR_TXD_TDATA_OUT    <= (others => '0');
      downstream_txd_prog_full <= (others => '0');

      downstream_done <= '0';
    end if;

  end process;

  PACKET_HANDLER_INTERNAL_INST_REG : AXIS_REGISTER_SLICE_0
    port map (
      ACLK          => CLK,
      ARESETN       => not RESET,
      S_AXIS_TVALID => downstream_rxd_tvalid(C_DESTINATION_TOP),
      S_AXIS_TREADY => downstream_rxd_tready(C_DESTINATION_TOP),
      S_AXIS_TDATA  => downstream_rxd_tdata(C_DESTINATION_TOP),
      M_AXIS_TVALID => downstream_rxd_tvalid_reg(C_DESTINATION_TOP),
      M_AXIS_TREADY => downstream_rxd_tready_reg(C_DESTINATION_TOP),
      M_AXIS_TDATA  => downstream_rxd_tdata_reg(C_DESTINATION_TOP)
    );

  PACKET_HANDLER_INTERNAL_INST : PACKET_HANDLER_INTERNAL
    port map (
      RESET => RESET,
      CLK   => CLK,

      AXI_STR_RXD_TVALID_IN  => downstream_rxd_tvalid_reg(C_DESTINATION_TOP),
      AXI_STR_RXD_TREADY_OUT => downstream_rxd_tready_reg(C_DESTINATION_TOP),
      AXI_STR_RXD_TDATA_IN   => downstream_rxd_tdata_reg(C_DESTINATION_TOP),

      AXI_STR_TXD_TVALID_OUT   => downstream_txd_tvalid(C_DESTINATION_TOP),
      AXI_STR_TXD_TREADY_IN    => downstream_txd_tready(C_DESTINATION_TOP),
      AXI_STR_TXD_TDATA_OUT    => downstream_txd_tdata(C_DESTINATION_TOP),
      AXI_STR_TXD_PROG_FULL_IN => downstream_txd_prog_full(C_DESTINATION_TOP),

      DONE_OUT => downstream_done_arr(C_DESTINATION_TOP)
    );

end architecture RTL;
