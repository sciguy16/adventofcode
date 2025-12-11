library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


library work;
use work.packet_types_pkg_hdr.ALL;

entity packet_handler_internal is
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
end packet_handler_internal;

architecture rtl of packet_handler_internal is
    signal PACKET_TYPE : unsigned(7 downto 0);
    type T_STATE is (
        STATE_IDLE,
        STATE_HEADER
    );
    signal state : T_STATE := STATE_IDLE;
begin
    process(clk, reset) is
    begin
        if(rising_edge(clk)) then
            case state is
                when STATE_IDLE => 
                    if (axi_str_rxd_tvalid_IN = '1') then
                        axi_str_rxd_tready_OUT <= '1';
                        PACKET_TYPE <= unsigned(axi_str_rxd_tdata_IN(23 downto 16));
                        state <= STATE_HEADER;
                    end if;
                when STATE_HEADER =>
                    state <= STATE_IDLE;
            end case;

            if (reset = '1') then
                state <= STATE_IDLE;
                PACKET_TYPE <= (others => '0');
                axi_str_rxd_tready_OUT <= '0';
                done_OUT <= '0';
                axi_str_txd_tvalid_OUT <= '0';
                axi_str_txd_tdata_OUT <= (others => '0');
            end if;
        end if;
    end process;
end rtl;
