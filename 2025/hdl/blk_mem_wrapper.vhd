library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.aoc_top_pkg_hdr.ALL;

-- 1024 deep at 32 bits wide (minimum supported by axi controller IP)
-- 4096 deep at 8 bits wide
--
-- 32-bit AXI interface
-- 12-bit address, addressing byte offsets

entity blk_mem_wrapper is
  port(
    reset: in std_logic;
    clk: in std_logic;

    -- Port A controls --

    -- Write controls --
    -- Start address of write transaction, in words
    s_axi_write_word_offset_port_a : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    -- Burst length of write transaction, in words/data beats
    s_axi_awlen_port_a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axi_awvalid_port_a : IN STD_LOGIC;
    s_axi_awready_port_a : OUT STD_LOGIC;

    -- Write data --
    s_axi_wdata_port_a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_wlast_port_a : IN STD_LOGIC;
    s_axi_wvalid_port_a : IN STD_LOGIC;
    s_axi_wready_port_a : OUT STD_LOGIC;

    -- Write response --
    s_axi_bresp_port_a : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bvalid_port_a : OUT STD_LOGIC;
    s_axi_bready_port_a : IN STD_LOGIC;

    -- Read controls --
    s_axi_read_word_offset_port_a : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    s_axi_arlen_port_a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axi_arvalid_port_a : IN STD_LOGIC;
    s_axi_arready_port_a : OUT STD_LOGIC;

    -- Read data --
    s_axi_rdata_port_a : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rresp_port_a : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_rlast_port_a : OUT STD_LOGIC;
    s_axi_rvalid_port_a : OUT STD_LOGIC;
    s_axi_rready_port_a : IN STD_LOGIC

    -- Port B controls --
    -- TODO
    --data_a_in: in std_logic_vector(31 downto 0);
    --data_a_out: out std_logic_vector(31 downto 0);
    --addr_a_in: in std_logic;
    --write_valid_a_in: in std_logic;
    --write_ready_a_out: out std_logic;
    --read_valid_a_out: out std_logic;
    --read_ready_a_in: in std_logic
  );
end blk_mem_wrapper;

architecture rtl of blk_mem_wrapper is
  signal bram_enable_a: std_logic;
  signal bram_reset_a: std_logic;
  signal bram_write_enable_a: std_logic_vector(3 downto 0);
  signal bram_addr_a: std_logic_vector(11 downto 0);
  signal bram_din_a: std_logic_vector(31 downto 0);
  signal bram_dout_a: std_logic_vector(31 downto 0);
  --signal inc_addr_a: boolean;

  signal bram_clk: std_logic;
  signal bram_write_enable_b: std_logic := '0';
  signal bram_enable_b: std_logic;
  signal bram_addr_b: unsigned(11 downto 0) := (others => '0');
  signal bram_din_b: std_logic_vector(7 downto 0) := (others => '0');
  signal bram_dout_b: std_logic_vector(7 downto 0);

  signal write_valid_b_in: std_logic := '0'; --TODO make port
  signal addr_b_in: std_logic := '0'; --TODO make port
  signal data_b_out: std_logic_vector(7 downto 0); --TODO make port
  signal read_valid_b_out: std_logic; -- TODO make port


  COMPONENT blk_mem_gen_0
    PORT (
      clka : IN STD_LOGIC;
      rsta : IN STD_LOGIC;
      ena : IN STD_LOGIC;
      wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

      clkb : IN STD_LOGIC;
      enb : IN STD_LOGIC;
      web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      dinb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT axi_bram_ctrl_0
    PORT (
      s_axi_aclk : IN STD_LOGIC;
      s_axi_aresetn : IN STD_LOGIC;
      s_axi_awaddr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      s_axi_awlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axi_awsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_awlock : IN STD_LOGIC;
      s_axi_awcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awvalid : IN STD_LOGIC;
      s_axi_awready : OUT STD_LOGIC;
      s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_wlast : IN STD_LOGIC;
      s_axi_wvalid : IN STD_LOGIC;
      s_axi_wready : OUT STD_LOGIC;
      s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_bvalid : OUT STD_LOGIC;
      s_axi_bready : IN STD_LOGIC;
      s_axi_araddr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      s_axi_arlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axi_arsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_arlock : IN STD_LOGIC;
      s_axi_arcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arvalid : IN STD_LOGIC;
      s_axi_arready : OUT STD_LOGIC;
      s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_rlast : OUT STD_LOGIC;
      s_axi_rvalid : OUT STD_LOGIC;
      s_axi_rready : IN STD_LOGIC;
      bram_rst_a : OUT STD_LOGIC;
      bram_clk_a : OUT STD_LOGIC;
      bram_en_a : OUT STD_LOGIC;
      bram_we_a : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      bram_addr_a : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
      bram_wrdata_a : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      bram_rddata_a : IN STD_LOGIC_VECTOR(31 DOWNTO 0) 
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

  --increment_ctrl: process(clk) is
  --begin
  --  if rising_edge(clk) then
  --    if read_ready_a_in = '1' or write_valid_a_in = '1' then
  --      bram_addr_a <= bram_addr_a + 1;
  --    end if;

  --    if addr_a_in = '1' then
  --      bram_addr_a <= unsigned(data_a_in(8 downto 0));
  --    end if;

  --    if reset = '1' then
  --      bram_addr_a <= (others => '0');
  --    end if;
  --  end if;
  --end process increment_ctrl;

  data_out_connect: process(all) is
    variable bram_write_enable_a_bit: std_logic;
  begin
    --read_valid_a_out <= not bram_write_enable_b and not addr_a_in;
    --if read_valid_a_out then
    --  data_a_out <= bram_dout_a;
    --else
    --  data_a_out <= (others => '0');
    --end if;
    bram_write_enable_a_bit := bram_write_enable_a(0)
        and bram_write_enable_a(1)
        and bram_write_enable_a(2)
        and bram_write_enable_a(3);
    assert (bram_write_enable_a = "0000"
      or bram_write_enable_a = "1111")
      report "BRAM attempting narrow write: " & to_string(bram_write_enable_a);
    read_valid_b_out <= not bram_write_enable_a_bit and not addr_b_in;
    bram_enable_b <= not bram_write_enable_a_bit;
    if read_valid_b_out then
      data_b_out <= bram_dout_b;
    else
      data_b_out <= (others => '0');
    end if;
  end process data_out_connect;

  --data_in_connect: process(all) is
  --begin
  --  --read_valid_a_out <= '1';
  --  bram_din_a <= data_a_in;
  --end process data_in_connect;

  -- priority encoder - ensure that only one port can write during any
  -- given clock cycle
  --write_enable_ctrl: process(all) is
  --  variable write_valid: std_logic_vector(1 downto 0);
  --begin
  --  bram_write_enable_a <= write_valid_a_in;
  --  bram_write_enable_b <= write_valid_b_in and not write_valid_a_in;
  --end process write_enable_ctrl;

  --port_a_ctrl: process (clk) is
  --begin
  --  if rising_edge(clk) then
  --    --bram_write_enable_a <= '0';
  --    write_ready_a_out <= '1';

  --  end if;
  --end process port_a_ctrl;

  -- Toggle the enable signals for the two BRAM ports based on which interface
  -- is active
  --transaction_ctrl: process(clk) is
  --  variable next_status: T_TRANSACTION_STATUS;
  --begin
  --  case transaction_status is
  --    when TXN_IDLE =>
  --      if s_axi_awvalid_port_a = '1' then
  --        next_status := TXN_A;
  --      elsif 
  --    when TXN_A =>
  --      -- if 
  --    when TXN_B =>
  --  end case;
  --end process transaction_ctrl;

  -- 512 deep at 32 bits wide
  -- 2048 deep at 8 bits wide
  blk_mem_inst : blk_mem_gen_0
    PORT MAP (
      clka => bram_clk,
      rsta => bram_reset_a,
      ena => bram_enable_a,
      wea(0) => bram_write_enable_a(0)
        and bram_write_enable_a(1)
        and bram_write_enable_a(2)
        and bram_write_enable_a(3),
      addra => bram_addr_a(9 downto 0),
      dina => bram_din_a,
      douta => bram_dout_a,

      clkb => clk,
      enb => bram_enable_b,
      web(0) => bram_write_enable_b,
      addrb => std_logic_vector(bram_addr_b),
      dinb => bram_din_b,
      doutb => bram_dout_b
    );

  axi_bram_ctrl_inst : axi_bram_ctrl_0
    PORT MAP (
      s_axi_aclk => clk,
      s_axi_aresetn => not reset,

      -- Write controls
      s_axi_awaddr(11 downto 2) => s_axi_write_word_offset_port_a,
      s_axi_awaddr(1 downto 0) => "00",
      s_axi_awlen => s_axi_awlen_port_a,
      s_axi_awsize => c_AXI_BURST_SIZE_BYTES_4,
      s_axi_awburst => c_AXI_BURST_TYPE_INCR,
      s_axi_awvalid => s_axi_awvalid_port_a,
      s_axi_awready => s_axi_awready_port_a,

      -- lock, cache, prot unused
      s_axi_awlock => '0',
      s_axi_awcache => (others => '0'),
      s_axi_awprot => (others => '0'),

      -- Write data
      s_axi_wdata => s_axi_wdata_port_a,
      s_axi_wstrb => "1111",
      s_axi_wlast => s_axi_wlast_port_a,
      s_axi_wvalid => s_axi_wvalid_port_a,
      s_axi_wready => s_axi_wready_port_a,

      -- Write response
      s_axi_bresp => s_axi_bresp_port_a,
      s_axi_bvalid => s_axi_bvalid_port_a,
      s_axi_bready => s_axi_bready_port_a,

      -- Read controls
      s_axi_araddr(11 downto 2) => s_axi_read_word_offset_port_a,
      s_axi_araddr(1 downto 0) => "00",
      s_axi_arlen => s_axi_arlen_port_a,
      s_axi_arsize => c_AXI_BURST_SIZE_BYTES_4,
      s_axi_arburst => c_AXI_BURST_TYPE_INCR,
      s_axi_arvalid => s_axi_arvalid_port_a,
      s_axi_arready => s_axi_arready_port_a,

      -- lock, cache, prot unused
      s_axi_arlock => '0',
      s_axi_arcache => (others => '0'),
      s_axi_arprot => (others => '0'),

      -- Read data
      s_axi_rdata => s_axi_rdata_port_a,
      s_axi_rresp => s_axi_rresp_port_a,
      s_axi_rlast => s_axi_rlast_port_a,
      s_axi_rvalid => s_axi_rvalid_port_a,
      s_axi_rready => s_axi_rready_port_a,

      -- BRAM interface
      bram_rst_a => bram_reset_a,
      bram_clk_a => bram_clk,
      bram_en_a => bram_enable_a,
      bram_we_a => bram_write_enable_a,
      bram_addr_a => bram_addr_a,
      bram_wrdata_a => bram_din_a,
      bram_rddata_a => bram_dout_a
    );
end rtl;
