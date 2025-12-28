library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- 512 deep at 32 bits wide
-- 2048 deep at 8 bits wide

entity blk_mem_wrapper is
  port(
    reset: in std_logic;
    clk: in std_logic;

    data_a_in: in std_logic_vector(31 downto 0);
    data_a_out: out std_logic_vector(31 downto 0);
    addr_a_in: in std_logic;
    write_valid_a_in: in std_logic;
    write_ready_a_out: out std_logic;
    read_valid_a_out: out std_logic;
    read_ready_a_in: in std_logic
  );
end blk_mem_wrapper;

architecture rtl of blk_mem_wrapper is
  signal bram_write_enable_a: std_logic;
  signal bram_addr_a: std_logic_vector(8 downto 0) := (others => '0');
  signal bram_din_a: std_logic_vector(31 downto 0) := (others => '0');
  signal bram_dout_a: std_logic_vector(31 downto 0);
  --signal inc_addr_a: boolean;

  signal bram_write_enable_b: std_logic;
  signal bram_addr_b: std_logic_vector(10 downto 0) := (others => '0');
  signal bram_din_b: std_logic_vector(7 downto 0) := (others => '0');
  signal bram_dout_b: std_logic_vector(7 downto 0);

  signal write_valid_b_in: std_logic := '0'; --TODO make port
  signal addr_b_in: std_logic := '0'; --TODO make port
  signal data_b_out: std_logic_vector(7 downto 0); --TODO make port
  signal read_valid_b_out: std_logic; -- TODO make port

  COMPONENT blk_mem_gen_0
    PORT (
      clka : IN STD_LOGIC;
      wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

      clkb : IN STD_LOGIC;
      web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      dinb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) 
    );
  END COMPONENT;
begin
  -- Three operations:
  -- 1. Set address
  --   * Load address from the data in line into the address register
  -- 2. Write & increment
  --   * Write from data in to the bram and then increment the address
  --   * Performed automatically on a data valid in pulse
  -- 3. Read & increment
  --   * Read data from the bram and then increment the address
  --   * Data valid out is asserted when data available. Address is incremented
  --     on receipt of READY pulse

  increment_ctrl: process(clk) is
  begin
    if rising_edge(clk) then
      if read_ready_a_in = '1' or write_valid_a_in = '1' then
        bram_addr_a <= std_logic_vector(unsigned(bram_addr_a) + 1);
      end if;

      if addr_a_in = '1' then
        bram_addr_a <= data_a_in(8 downto 0);
      end if;

      if reset = '1' then
        bram_addr_a <= (others => '0');
      end if;
    end if;
  end process increment_ctrl;

  data_out_connect: process(all) is
  begin
    read_valid_a_out <= not bram_write_enable_b and not addr_a_in;
    if read_valid_a_out then
      data_a_out <= bram_dout_a;
    else
      data_a_out <= (others => '0');
    end if;

    read_valid_b_out <= not bram_write_enable_a and not addr_b_in;
    if read_valid_b_out then
      data_b_out <= bram_dout_b;
    else
      data_b_out <= (others => '0');
    end if;
  end process data_out_connect;

  data_in_connect: process(all) is
  begin
    --read_valid_a_out <= '1';
    bram_din_a <= data_a_in;
  end process data_in_connect;

  -- priority encoder - ensure that only one port can write during any
  -- given clock cycle
  write_enable_ctrl: process(all) is
    variable write_valid: std_logic_vector(1 downto 0);
  begin
    bram_write_enable_a <= write_valid_a_in;
    bram_write_enable_b <= write_valid_b_in and not write_valid_a_in;
  end process write_enable_ctrl;

  port_a_ctrl: process (clk) is
  begin
    if rising_edge(clk) then
      --bram_write_enable_a <= '0';
      write_ready_a_out <= '1';

    end if;
  end process port_a_ctrl;

  -- 512 deep at 32 bits wide
  -- 2048 deep at 8 bits wide
  blk_mem_inst : blk_mem_gen_0
    PORT MAP (
      clka => clk,
      wea(0) => bram_write_enable_a,
      addra => bram_addr_a,
      dina => bram_din_a,
      douta => bram_dout_a,

      clkb => clk,
      web(0) => bram_write_enable_b,
      addrb => bram_addr_b,
      dinb => bram_din_b,
      doutb => bram_dout_b
    );
end rtl;
