library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package packet_handler_pkg is
    type T_RX_STATE is (
        RX_STATE_IDLE,
        RX_STATE_PING,
        RX_STATE_RAM_OFFSET,
        RX_STATE_WRITE_RAM,
        RX_STATE_WRITE_RAM_WAIT_READY,
        RX_STATE_READ_RAM,
        RX_STATE_SEND_REPLY
    );
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.packet_types_pkg_hdr.ALL;
use work.packet_handler_pkg.ALL;

entity packet_handler is
	port(
        reset: in std_logic;
		clk: in std_logic;

        axi_str_rxd_tvalid_IN : IN STD_LOGIC;
        axi_str_rxd_tready_OUT : OUT STD_LOGIC;
        axi_str_rxd_tdata_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        axi_str_txd_tvalid_OUT : OUT STD_LOGIC;
        axi_str_txd_tready_IN : IN STD_LOGIC;
        axi_str_txd_tdata_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        bram_write_data_a_OUT: OUT std_logic_vector(31 downto 0);
        bram_read_data_a_IN: IN std_logic_vector(31 downto 0);
        bram_addr_a_OUT: OUT std_logic;
        bram_write_valid_a_OUT: OUT std_logic;
        bram_write_ready_a_IN: IN std_logic;
        bram_read_req_a_OUT: OUT std_logic;
        bram_read_valid_a_IN: IN std_logic;
        bram_read_ready_a_OUT: OUT std_logic
	);
end packet_handler;

architecture rtl of packet_handler is
    signal PACKET_TYPE : unsigned(7 downto 0) := (others => '0');
    signal PACKET_LENGTH: unsigned(15 downto 0) := (others => '0');
    signal PING_PAYLOAD: std_logic_vector(31 downto 0) := (others => '0');
    signal RAM_OFFSET: std_logic_vector(31 downto 0) := (others => '0');
    signal payload_counter: unsigned(7 downto 0) := (others => '0');
    signal reply_done: std_logic;

    signal rx_state : T_RX_STATE := RX_STATE_IDLE;

    type T_REPLY_STATE is (
        REPLY_STATE_IDLE,
        REPLY_STATE_SEND_HEADER,
        REPLY_STATE_SEND_PAYLOAD,
        REPLY_STATE_WAIT_IDLE
    );
    signal reply_state : T_REPLY_STATE := REPLY_STATE_IDLE;
begin
    process(clk) is
        variable v_packet_type: unsigned(7 downto 0);
        variable v_ram_offset: std_logic_vector(31 downto 0);
    begin
        if rising_edge(clk) then
            axi_str_rxd_tready_OUT <= '0';
            bram_addr_a_OUT <= '0';
            bram_write_valid_a_OUT <= '0';
            bram_read_req_a_OUT <= '0';
            bram_read_ready_a_OUT <= '0';

            case rx_state is
                when RX_STATE_IDLE => 
                    axi_str_rxd_tready_OUT <= '1';
                    if axi_str_rxd_tvalid_IN = '1' then
                        v_packet_type := unsigned(axi_str_rxd_tdata_IN(23 downto 16));
                        PACKET_TYPE <= v_packet_type;
                        PACKET_LENGTH <= "00" & unsigned(axi_str_rxd_tdata_IN(15 downto 2));
                        payload_counter <= x"00";
                        with v_packet_type select rx_state <=
                            RX_STATE_PING when C_DESTINATION_top_TYPE_ping,
                            RX_STATE_RAM_OFFSET when C_DESTINATION_top_TYPE_write_ram,
                            RX_STATE_RAM_OFFSET when C_DESTINATION_top_TYPE_read_ram,
                            RX_STATE_IDLE when others;
                    end if;
                when RX_STATE_PING =>
                    axi_str_rxd_tready_OUT <= '1';
                    if axi_str_rxd_tvalid_IN = '1' then
                        --axi_str_rxd_tready_OUT <= '0';
                        payload_counter <= payload_counter + 1;
                        PING_PAYLOAD <= axi_str_rxd_tdata_IN;
                        if(payload_counter = PACKET_LENGTH - 1) then
                            rx_state <= RX_STATE_SEND_REPLY;
                        end if;
                    end if;
                when RX_STATE_RAM_OFFSET =>
                    axi_str_rxd_tready_OUT <= '1';
                    if axi_str_rxd_tvalid_IN = '1' then
                        --axi_str_rxd_tready_OUT <= '0';
                        payload_counter <= payload_counter + 1;
                        v_ram_offset := axi_str_rxd_tdata_IN;
                        RAM_OFFSET <= v_ram_offset;
                        bram_write_data_a_OUT <= v_ram_offset;
                        bram_addr_a_OUT <= '1';

                        with PACKET_TYPE select rx_state <=
                            RX_STATE_WRITE_RAM when C_DESTINATION_top_TYPE_write_ram,
                            RX_STATE_READ_RAM when C_DESTINATION_top_TYPE_read_ram,
                            RX_STATE_IDLE when others;
                    end if;
                when RX_STATE_WRITE_RAM =>
                    -- forward data words to RAM writer
                    if axi_str_rxd_tvalid_IN = '1' then
                        bram_write_data_a_OUT <= axi_str_rxd_tdata_IN;
                        bram_write_valid_a_OUT <= '1';
                        payload_counter <= payload_counter + 1;
                        rx_state <= RX_STATE_WRITE_RAM_WAIT_READY;
                    end if;
                when RX_STATE_WRITE_RAM_WAIT_READY =>
                    -- wait for RAM writer to assert READY
                    if bram_write_ready_a_IN = '1' then
                        axi_str_rxd_tready_OUT <= '1';
                        rx_state <=
                            RX_STATE_SEND_REPLY when payload_counter = PACKET_LENGTH
                        else RX_STATE_WRITE_RAM;
                    end if;
                when RX_STATE_READ_RAM =>
                    rx_state <= RX_STATE_IDLE;
                when RX_STATE_SEND_REPLY =>
                    if reply_done = '1' then
                        rx_state <= RX_STATE_IDLE;
                    end if;
            end case;

            if reset = '1' then
                rx_state <= RX_STATE_IDLE;
                PACKET_TYPE <= (others => '0');
                axi_str_rxd_tready_OUT <= '0';
            end if;
        end if;
    end process;

    reply_process: process(clk) is
    begin
        if rising_edge(clk) then
            reply_done <= '0';
            axi_str_txd_tvalid_OUT <= '0';

            case reply_state is
                when REPLY_STATE_IDLE =>
                    if rx_state = RX_STATE_SEND_REPLY then
                        reply_state <= REPLY_STATE_SEND_HEADER;
                        axi_str_txd_tdata_OUT <= x"00010004";
                        axi_str_txd_tvalid_OUT <= '1';
                    end if;
                when REPLY_STATE_SEND_HEADER =>
                    axi_str_txd_tvalid_OUT <= '1';
                    if axi_str_txd_tready_IN = '1' then
                        reply_state <= REPLY_STATE_SEND_PAYLOAD;
                        axi_str_txd_tdata_OUT <= PING_PAYLOAD;
                    else
                        axi_str_txd_tdata_OUT <= x"00010004";
                    end if;
                when REPLY_STATE_SEND_PAYLOAD =>
                    axi_str_txd_tvalid_OUT <= '1';
                    axi_str_txd_tdata_OUT <= PING_PAYLOAD;
                    if axi_str_txd_tready_IN = '1' then
                        axi_str_txd_tvalid_OUT <= '0';
                        reply_done <= '1';
                        reply_state <= REPLY_STATE_WAIT_IDLE;
                    end if;
                when REPLY_STATE_WAIT_IDLE =>
                    axi_str_txd_tdata_OUT <= x"00000000";
                    if (rx_state = RX_STATE_IDLE) then
                        reply_state <= REPLY_STATE_IDLE;
                    end if;
            end case;

            if reset = '1' then
                reply_state <= REPLY_STATE_IDLE;
                reply_done <= '0';
                axi_str_txd_tvalid_OUT <= '0';
                axi_str_txd_tdata_OUT <= (others => '0');
            end if;
        end if;
    end process;
end rtl;
