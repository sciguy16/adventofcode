library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity blk_mem_wrapper_tb is
end blk_mem_wrapper_tb;

architecture rtl of blk_mem_wrapper_tb is
  constant c_HALF_PERIOD_25_MHz : time := 20 ns;-- 25 MHz clock, 40 ns period

  signal clk: std_logic := '1';
  signal reset: std_logic := '1';

  signal data_a_in: std_logic_vector(31 downto 0) := (others => '0');
  signal data_a_out: std_logic_vector(31 downto 0);
  signal addr_a_in: std_logic := '0';
  signal write_valid_a_in: std_logic := '0';
  signal write_ready_a_out: std_logic;
  signal read_req_a_in: std_logic := '0';
  signal read_valid_a_out: std_logic;
  signal read_ready_a_in: std_logic := '0';


begin
  uut: entity work.blk_mem_wrapper(rtl)
    port map(
      reset => reset,
      clk => clk,

      data_a_in => data_a_in,
      data_a_out => data_a_out,
      addr_a_in => addr_a_in,
      write_valid_a_in => write_valid_a_in,
      write_ready_a_out => write_ready_a_out,
      read_req_a_in => read_req_a_in,
      read_valid_a_out => read_valid_a_out,
      read_ready_a_in => read_ready_a_in
    );

    clk <= not clk after c_HALF_PERIOD_25_MHz; 


    stimulus: process
      alias uut_bram_write_enable_a is 
        << signal uut.bram_write_enable_a: std_logic_vector(0 downto 0) >>;
      alias uut_bram_addr_a is 
        << signal uut.bram_addr_a: std_logic_vector(8 downto 0) >>;
      alias uut_bram_din_a is 
        << signal uut.bram_din_a: std_logic_vector(31 downto 0) >>;
      alias uut_bram_dout_a is 
        << signal uut.bram_dout_a: std_logic_vector(31 downto 0) >>;
    begin

      wait for 40 ns;
      wait until falling_edge(clk);
      reset <= '0';


      wait until falling_edge(clk);
      data_a_in <= x"00000000";
      addr_a_in <= '1';

      wait until falling_edge(clk);
      assert uut_bram_write_enable_a = "0";
      assert uut_bram_addr_a = 9x"00000000";
      assert uut_bram_din_a = x"00000000";
      assert uut_bram_dout_a = x"00000000";

      wait for 5 ns;

      data_a_in <= x"a0a0a0a0";
      addr_a_in <= '0';
      write_valid_a_in <= '1';

      wait until falling_edge(clk);
      assert uut_bram_write_enable_a = "1";
      assert uut_bram_addr_a = 9x"00000000";
      assert uut_bram_din_a = x"a0a0a0a0";
      assert uut_bram_dout_a = x"00000000";

      data_a_in <= x"00000000";
      addr_a_in <= '1';
      write_valid_a_in <= '0';

      wait until falling_edge(clk);
      addr_a_in <= '0';
      read_req_a_in <= '1';

      wait until falling_edge(clk);
      assert read_valid_a_out = '0';
      wait until falling_edge(clk);
      assert read_valid_a_out = '1' report "a valid";
      assert data_a_out = x"a0a0a0a0" report "a data";
      read_ready_a_in <= '1';
      read_req_a_in <= '0';

      wait until falling_edge(clk);
      assert read_valid_a_out = '0';
      read_ready_a_in <= '0';

      wait until falling_edge(clk);
      wait until falling_edge(clk);

      data_a_in <= x"00000000";
      addr_a_in <= '1';
      wait until falling_edge(clk);
      data_a_in <= x"11111111";
      write_valid_a_in <= '1';
      addr_a_in <= '0';

      wait until falling_edge(clk);
      data_a_in <= x"22222222";
      wait until falling_edge(clk);
      data_a_in <= x"33333333";
      wait until falling_edge(clk);
      data_a_in <= x"44444444";

      wait until falling_edge(clk);
      write_valid_a_in <= '0';
      data_a_in <= x"00000000";
      addr_a_in <= '1';

      wait until falling_edge(clk);
      addr_a_in <= '0';
      read_ready_a_in <= '1';
      read_req_a_in <= '1';
      assert read_valid_a_out = '0';

      wait until falling_edge(clk);
      assert read_valid_a_out = '0';
      
      wait until falling_edge(clk);
      assert read_valid_a_out = '1';
      assert data_a_out = x"11111111";
      
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      assert read_valid_a_out = '1';
      assert data_a_out = x"22222222";
      
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      assert read_valid_a_out = '1';
      assert data_a_out = x"33333333";
      
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      assert read_valid_a_out = '1';
      assert data_a_out = x"44444444";

      wait until falling_edge(clk);
      read_req_a_in <= '0';
      assert read_valid_a_out = '0';
      
      wait until falling_edge(clk);
      wait until falling_edge(clk);

      std.env.stop;
    end process;
end rtl;
