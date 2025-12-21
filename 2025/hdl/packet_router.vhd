library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.packet_types_pkg_hdr.ALL;

--TODO read full packet into BRAM and then pass it to handler to process,
-- otherwise every process will have to implement the same receive logic.
-- Similarly, set up an output BRAM for reply packets. This way the packet
-- router can do the CRC checks on inbound packets and append the CRC to
-- outbound packets.

entity packet_router is
    port(
        reset: in std_logic;
        clk: in std_logic;

        axi_str_rxd_tvalid_IN : IN STD_LOGIC;
        axi_str_rxd_tready_OUT : OUT STD_LOGIC;
        axi_str_rxd_tdata_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        axi_str_txd_tvalid_OUT : OUT STD_LOGIC;
        axi_str_txd_tready_IN : IN STD_LOGIC;
        axi_str_txd_tdata_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        axi_str_txd_prog_full_IN: IN STD_LOGIC
    );
end packet_router;

architecture rtl of packet_router is
    component packet_handler_internal is
        port(
            reset: in std_logic;
            clk: in std_logic;

            axi_str_rxd_tvalid_IN : IN STD_LOGIC;
            axi_str_rxd_tready_OUT : OUT STD_LOGIC;
            axi_str_rxd_tdata_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            axi_str_txd_tvalid_OUT : OUT STD_LOGIC;
            axi_str_txd_tready_IN : IN STD_LOGIC;
            axi_str_txd_tdata_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            axi_str_txd_prog_full_IN: IN STD_LOGIC;

            done_OUT : OUT STD_LOGIC
        );
    end component;

    COMPONENT axis_register_slice_0
      PORT (
        aclk : IN STD_LOGIC;
        aresetn : IN STD_LOGIC;
        s_axis_tvalid : IN STD_LOGIC;
        s_axis_tready : OUT STD_LOGIC;
        s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_tvalid : OUT STD_LOGIC;
        m_axis_tready : IN STD_LOGIC;
        m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
      );
    END COMPONENT;

    type t_std_logic_array is array (0 to C_NUM_DESTINATIONS-1) of std_logic;
    type t_std_logic_vector_array is array (0 to C_NUM_DESTINATIONS-1)
        of std_logic_vector(31 downto 0);

    signal PACKET_HEADER: T_PACKET_HEADER := C_PACKET_HEADER_INIT;
    signal MUX_SEL: unsigned(7 downto 0) := (others => '0');
    signal MUX_ENABLE: std_logic := '0';
    signal DOWNSTREAM_DONE: std_logic := '0';
    signal DOWNSTREAM_DONE_ARR: t_std_logic_array;


    signal DOWNSTREAM_RXD_TVALID: t_std_logic_array;
    signal DOWNSTREAM_RXD_TVALID_REG: t_std_logic_array;
    signal DOWNSTREAM_RXD_TREADY: t_std_logic_array;
    signal DOWNSTREAM_RXD_TREADY_REG: t_std_logic_array;
    signal DOWNSTREAM_RXD_TDATA: t_std_logic_vector_array;
    signal DOWNSTREAM_RXD_TDATA_REG: t_std_logic_vector_array;

    signal DOWNSTREAM_TXD_TVALID: t_std_logic_array;
    signal DOWNSTREAM_TXD_TREADY: t_std_logic_array;
    signal DOWNSTREAM_TXD_TDATA: t_std_logic_vector_array;
    signal DOWNSTREAM_TXD_PROG_FULL: t_std_logic_array;


    type t_rx_state is (
        RX_STATE_IDLE,
        RX_STATE_WAIT_DOWNSTREAM_DONE
    );
    signal rx_state: t_rx_state := RX_STATE_IDLE;
begin
    process(clk, reset) is
    begin
        if (rising_edge(clk)) then
            case(rx_state) is
                when RX_STATE_IDLE =>
                    if (
                        axi_str_rxd_tvalid_IN = '1'
                        AND unsigned(axi_str_rxd_tdata_IN(31 downto 24))
                            < C_NUM_DESTINATIONS)
                    then
                        MUX_SEL <= unsigned(axi_str_rxd_tdata_IN(31 downto 24));
                        MUX_ENABLE <= '1';
                        rx_state <= RX_STATE_WAIT_DOWNSTREAM_DONE;
                    end if;
                when RX_STATE_WAIT_DOWNSTREAM_DONE =>
                    if (DOWNSTREAM_DONE = '1') then
                        MUX_ENABLE <= '0';
                        rx_state <= RX_STATE_IDLE;
                    end if;
            end case;

            if (reset = '1') then
                rx_state <= RX_STATE_IDLE;
                MUX_ENABLE <= '0';
                MUX_SEL <= (others => '0');
            end if;
        end if;
    end process;

    process(all) is
            variable sel: integer := to_integer(MUX_SEL);
    begin
        if (MUX_ENABLE = '1' AND reset = '0') then
            DOWNSTREAM_RXD_TVALID(sel) <= axi_str_rxd_tvalid_IN;
            axi_str_rxd_tready_OUT <= DOWNSTREAM_RXD_TREADY(sel);
            DOWNSTREAM_RXD_TDATA(sel) <= axi_str_rxd_tdata_IN;

            axi_str_txd_tvalid_OUT <= DOWNSTREAM_TXD_TVALID(sel);
            DOWNSTREAM_TXD_TREADY(sel) <= axi_str_txd_tready_IN;
            axi_str_txd_tdata_OUT <= DOWNSTREAM_TXD_TDATA(sel);

            DOWNSTREAM_DONE <= DOWNSTREAM_DONE_ARR(sel);
        else
            DOWNSTREAM_RXD_TVALID <= (others => '0');
            axi_str_rxd_tready_OUT <= '0';
            DOWNSTREAM_RXD_TDATA <= (others => (others => '0'));

            axi_str_txd_tvalid_OUT <= '0';
            DOWNSTREAM_TXD_TREADY <= (others => '0');
            axi_str_txd_tdata_OUT <= (others => '0');
            DOWNSTREAM_TXD_PROG_FULL <= (others => '0');

            DOWNSTREAM_DONE <= '0';
        end if;
    end process;

    packet_handler_internal_inst_reg : axis_register_slice_0
      PORT MAP (
        aclk => clk,
        aresetn => not reset,
        s_axis_tvalid => DOWNSTREAM_RXD_TVALID(C_DESTINATION_TOP),
        s_axis_tready => DOWNSTREAM_RXD_TREADY(C_DESTINATION_TOP),
        s_axis_tdata => DOWNSTREAM_RXD_TDATA(C_DESTINATION_TOP),
        m_axis_tvalid => DOWNSTREAM_RXD_TVALID_REG(C_DESTINATION_TOP),
        m_axis_tready => DOWNSTREAM_RXD_TREADY_REG(C_DESTINATION_TOP),
        m_axis_tdata => DOWNSTREAM_RXD_TDATA_REG(C_DESTINATION_TOP)
      );

    packet_handler_internal_inst: packet_handler_internal
    port map (
        reset => reset,
        clk => clk,

        axi_str_rxd_tvalid_IN => DOWNSTREAM_RXD_TVALID_REG(C_DESTINATION_TOP),
        axi_str_rxd_tready_OUT => DOWNSTREAM_RXD_TREADY_REG(C_DESTINATION_TOP),
        axi_str_rxd_tdata_IN => DOWNSTREAM_RXD_TDATA_REG(C_DESTINATION_TOP),

        axi_str_txd_tvalid_OUT => DOWNSTREAM_TXD_TVALID(C_DESTINATION_TOP),
        axi_str_txd_tready_IN => DOWNSTREAM_TXD_TREADY(C_DESTINATION_TOP),
        axi_str_txd_tdata_OUT => DOWNSTREAM_TXD_TDATA(C_DESTINATION_TOP),
        axi_str_txd_prog_full_IN => DOWNSTREAM_TXD_PROG_FULL(C_DESTINATION_TOP),

        done_OUT => DOWNSTREAM_DONE_ARR(C_DESTINATION_TOP)
    );
end rtl;
