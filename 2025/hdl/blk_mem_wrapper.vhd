library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity blk_mem_wrapper is
	port(
		reset: in std_logic;
		clk: in std_logic;

		data_a_in: in std_logic_vector(31 downto 0);
		data_a_out: out std_logic_vector(31 downto 0);
		addr_a_in: in std_logic;
		write_valid_a_in: in std_logic;
		write_ready_a_out: out std_logic;
		read_req_a_in: in std_logic;
		read_valid_a_out: out std_logic;
		read_ready_a_in: in std_logic
	);
end blk_mem_wrapper;

architecture rtl of blk_mem_wrapper is
	signal bram_enable_a: std_logic := '1';
	signal bram_write_enable_a: std_logic_vector(0 downto 0) := (others => '0');
	signal bram_addr_a: std_logic_vector(8 downto 0) := (others => '0');
	signal bram_din_a: std_logic_vector(31 downto 0) := (others => '0');
	signal bram_dout_a: std_logic_vector(31 downto 0);
	signal inc_addr_a: std_logic := '0';

	signal bram_enable_b: std_logic := '0';
	signal bram_write_enable_b: std_logic_vector(0 downto 0) := (others => '0');
	signal bram_addr_b: std_logic_vector(10 downto 0) := (others => '0');
	signal bram_din_b: std_logic_vector(7 downto 0) := (others => '0');
	signal bram_dout_b: std_logic_vector(7 downto 0);

	type T_PORT_A_CTRL_STATE is (
		PORT_A_CTRL_STATE_IDLE,
		PORT_A_CTRL_STATE_READ_REQ,
		PORT_A_CTRL_STATE_READ_WAIT_READY
	);
	signal port_a_ctrl_state: T_PORT_A_CTRL_STATE := PORT_A_CTRL_STATE_IDLE;

	COMPONENT blk_mem_gen_0
	  PORT (
	    clka : IN STD_LOGIC;
	    ena : IN STD_LOGIC;
	    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	    addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
	    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

	    clkb : IN STD_LOGIC;
	    enb : IN STD_LOGIC;
	    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	    addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
	    dinb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	    doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) 
	  );
	END COMPONENT;
begin
	port_a_ctrl: process (clk) is
	begin
		if rising_edge(clk) then
			bram_write_enable_a <= "0";
			write_ready_a_out <= '0';

			if inc_addr_a = '1' then
				bram_addr_a <= std_logic_vector(unsigned(bram_addr_a) + 1);
				inc_addr_a <= '0';
			end if;

			case port_a_ctrl_state is
				when PORT_A_CTRL_STATE_IDLE =>
					if addr_a_in = '1' then
						bram_addr_a <= data_a_in(8 downto 0);
					elsif write_valid_a_in ='1' then
						bram_din_a <= data_a_in;
						bram_write_enable_a <= "1";
						write_ready_a_out <= '1';
						inc_addr_a <= '1';
					elsif read_req_a_in = '1' then
						port_a_ctrl_state <= PORT_A_CTRL_STATE_READ_REQ;
					end if;
				when PORT_A_CTRL_STATE_READ_REQ =>
					data_a_out <= bram_dout_a;
					read_valid_a_out <= '1';
					port_a_ctrl_state <= PORT_A_CTRL_STATE_READ_WAIT_READY;
				when PORT_A_CTRL_STATE_READ_WAIT_READY =>
					if read_ready_a_in = '1' then
						read_valid_a_out <= '0';
						port_a_ctrl_state <= PORT_A_CTRL_STATE_IDLE;
						bram_addr_a <= std_logic_vector(unsigned(bram_addr_a) + 1);
					end if;
			end case;

			if reset = '1' then
				write_ready_a_out <= '0';
				read_valid_a_out <= '0';
				bram_addr_a <= (others => '0');
				data_a_out <= (others => '0');
			end if;
		end if;
	end process port_a_ctrl;

	blk_mem_inst : blk_mem_gen_0
	  PORT MAP (
	    clka => clk,
	    ena => bram_enable_a,
	    wea => bram_write_enable_a,
	    addra => bram_addr_a,
	    dina => bram_din_a,
	    douta => bram_dout_a,

	    clkb => clk,
	    enb => bram_enable_b,
	    web => bram_write_enable_b,
	    addrb => bram_addr_b,
	    dinb => bram_din_b,
	    doutb => bram_dout_b
	  );
end rtl;
