library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.aoc_top_pkg_hdr.all;

-- 1024 deep at 32 bits wide (minimum supported by axi controller IP)
-- 4096 deep at 8 bits wide
--
-- 32-bit AXI interface
-- 12-bit address, addressing byte offsets

entity BLK_MEM_WRAPPER is
  port (
    RESET : in    std_logic;
    CLK   : in    std_logic;

    -- Port A controls --

    -- Write controls --
    -- Start address of write transaction, in words
    S_AXI_WRITE_WORD_OFFSET_PORT_A_IN : in    std_logic_vector(9 downto 0);
    -- Burst length of write transaction, in words/data beats
    S_AXI_AWLEN_PORT_A_IN             : in    std_logic_vector(7 downto 0);
    S_AXI_AWVALID_PORT_A_IN           : in    std_logic;
    S_AXI_AWREADY_PORT_A_OUT          : out   std_logic;

    -- Write data --
    S_AXI_WDATA_PORT_A_IN   : in    std_logic_vector(31 downto 0);
    S_AXI_WLAST_PORT_A_IN   : in    std_logic;
    S_AXI_WVALID_PORT_A_IN  : in    std_logic;
    S_AXI_WREADY_PORT_A_OUT : out   std_logic;

    -- Write response --
    S_AXI_BRESP_PORT_A_OUT  : out   std_logic_vector(1 downto 0);
    S_AXI_BVALID_PORT_A_OUT : out   std_logic;
    S_AXI_BREADY_PORT_A_IN  : in    std_logic;

    -- Read controls --
    S_AXI_READ_WORD_OFFSET_PORT_A_IN : in    std_logic_vector(9 downto 0);
    S_AXI_ARLEN_PORT_A_IN            : in    std_logic_vector(7 downto 0);
    S_AXI_ARVALID_PORT_A_IN          : in    std_logic;
    S_AXI_ARREADY_PORT_A_OUT         : out   std_logic;

    -- Read data --
    S_AXI_RDATA_PORT_A_OUT  : out   std_logic_vector(31 downto 0);
    S_AXI_RRESP_PORT_A_OUT  : out   std_logic_vector(1 downto 0);
    S_AXI_RLAST_PORT_A_OUT  : out   std_logic;
    S_AXI_RVALID_PORT_A_OUT : out   std_logic;
    S_AXI_RREADY_PORT_A_IN  : in    std_logic;

    -- Port B controls --
    BRAM_ADDR_B_IN              : in    std_logic_vector(11 downto 0);
    BRAM_DATA_B_IN              : in    std_logic_vector(7 downto 0);
    BRAM_DATA_B_OUT             : out   std_logic_vector(7 downto 0);
    BRAM_PORT_B_WRITE_ENABLE_IN : in    std_logic;
    BRAM_PORT_B_ENABLED_OUT     : out   std_logic
  );
end entity BLK_MEM_WRAPPER;

architecture RTL of BLK_MEM_WRAPPER is
  signal bram_enable_a       : std_logic;
  signal bram_reset_a        : std_logic;
  signal bram_write_enable_a : std_logic_vector(3 downto 0);
  signal bram_addr_a         : std_logic_vector(11 downto 0);
  signal bram_din_a          : std_logic_vector(31 downto 0);
  signal bram_dout_a         : std_logic_vector(31 downto 0);
  signal bram_clk            : std_logic;

  component BLK_MEM_GEN_0 is
    port (
      CLKA      : in    std_logic;
      RSTA      : in    std_logic;
      RSTA_BUSY : out   std_logic;
      ENA       : in    std_logic;
      WEA       : in    std_logic_vector(0 downto 0);
      ADDRA     : in    std_logic_vector(9 downto 0);
      DINA      : in    std_logic_vector(31 downto 0);
      DOUTA     : out   std_logic_vector(31 downto 0);

      CLKB      : in    std_logic;
      RSTB_BUSY : out   std_logic;
      ENB       : in    std_logic;
      WEB       : in    std_logic_vector(0 downto 0);
      ADDRB     : in    std_logic_vector(11 downto 0);
      DINB      : in    std_logic_vector(7 downto 0);
      DOUTB     : out   std_logic_vector(7 downto 0)
    );
  end component BLK_MEM_GEN_0;

  component AXI_BRAM_CTRL_0 is
    port (
      S_AXI_ACLK    : in    std_logic;
      S_AXI_ARESETN : in    std_logic;
      S_AXI_AWADDR  : in    std_logic_vector(11 downto 0);
      S_AXI_AWLEN   : in    std_logic_vector(7 downto 0);
      S_AXI_AWSIZE  : in    std_logic_vector(2 downto 0);
      S_AXI_AWBURST : in    std_logic_vector(1 downto 0);
      S_AXI_AWLOCK  : in    std_logic;
      S_AXI_AWCACHE : in    std_logic_vector(3 downto 0);
      S_AXI_AWPROT  : in    std_logic_vector(2 downto 0);
      S_AXI_AWVALID : in    std_logic;
      S_AXI_AWREADY : out   std_logic;
      S_AXI_WDATA   : in    std_logic_vector(31 downto 0);
      S_AXI_WSTRB   : in    std_logic_vector(3 downto 0);
      S_AXI_WLAST   : in    std_logic;
      S_AXI_WVALID  : in    std_logic;
      S_AXI_WREADY  : out   std_logic;
      S_AXI_BRESP   : out   std_logic_vector(1 downto 0);
      S_AXI_BVALID  : out   std_logic;
      S_AXI_BREADY  : in    std_logic;
      S_AXI_ARADDR  : in    std_logic_vector(11 downto 0);
      S_AXI_ARLEN   : in    std_logic_vector(7 downto 0);
      S_AXI_ARSIZE  : in    std_logic_vector(2 downto 0);
      S_AXI_ARBURST : in    std_logic_vector(1 downto 0);
      S_AXI_ARLOCK  : in    std_logic;
      S_AXI_ARCACHE : in    std_logic_vector(3 downto 0);
      S_AXI_ARPROT  : in    std_logic_vector(2 downto 0);
      S_AXI_ARVALID : in    std_logic;
      S_AXI_ARREADY : out   std_logic;
      S_AXI_RDATA   : out   std_logic_vector(31 downto 0);
      S_AXI_RRESP   : out   std_logic_vector(1 downto 0);
      S_AXI_RLAST   : out   std_logic;
      S_AXI_RVALID  : out   std_logic;
      S_AXI_RREADY  : in    std_logic;
      BRAM_RST_A    : out   std_logic;
      BRAM_CLK_A    : out   std_logic;
      BRAM_EN_A     : out   std_logic;
      BRAM_WE_A     : out   std_logic_vector(3 downto 0);
      BRAM_ADDR_A   : out   std_logic_vector(11 downto 0);
      BRAM_WRDATA_A : out   std_logic_vector(31 downto 0);
      BRAM_RDDATA_A : in    std_logic_vector(31 downto 0)
    );
  end component AXI_BRAM_CTRL_0;

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

  -- increment_ctrl: process(clk) is
  -- begin
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
  -- end process increment_ctrl;

  DATA_OUT_CONNECT : process (all) is
    variable bram_write_enable_a_bit : std_logic;
  begin
    -- read_valid_a_out <= not bram_write_enable_b and not addr_a_in;
    -- if read_valid_a_out then
    --  data_a_out <= bram_dout_a;
    -- else
    --  data_a_out <= (others => '0');
    -- end if;
    bram_write_enable_a_bit := bram_write_enable_a(0)
                               and bram_write_enable_a(1)
                               and bram_write_enable_a(2)
                               and bram_write_enable_a(3);
    assert (bram_write_enable_a = "0000"
      or bram_write_enable_a = "1111")
      report "BRAM attempting narrow write: " & to_string(bram_write_enable_a);
    -- data_valid_b_out <= not bram_write_enable_a_bit and not addr_b_valid_in;
    BRAM_PORT_B_ENABLED_OUT <= not bram_write_enable_a_bit;
  -- if data_valid_b_out then
  --  data_b_out <= bram_dout_b;
  -- else
  --  data_b_out <= (others => '0');
  -- end if;
  end process DATA_OUT_CONNECT;

  -- port_b_addr_ctrl: process(clk) is
  -- begin
  --  if rising_edge(clk) then
  --    if addr_b_valid_in = '1' then
  --      bram_addr_b <= unsigned(addr_b_in);
  --    end if;
  --  end if;
  -- end process port_b_addr_ctrl;

  -- data_in_connect: process(all) is
  -- begin
  --  --read_valid_a_out <= '1';
  --  bram_din_a <= data_a_in;
  -- end process data_in_connect;

  -- priority encoder - ensure that only one port can write during any
  -- given clock cycle
  -- write_enable_ctrl: process(all) is
  --  variable write_valid: std_logic_vector(1 downto 0);
  -- begin
  --  bram_write_enable_a <= write_valid_a_in;
  --  bram_write_enable_b <= write_valid_b_in and not write_valid_a_in;
  -- end process write_enable_ctrl;

  -- port_a_ctrl: process (clk) is
  -- begin
  --  if rising_edge(clk) then
  --    --bram_write_enable_a <= '0';
  --    write_ready_a_out <= '1';

  --  end if;
  -- end process port_a_ctrl;

  -- Toggle the enable signals for the two BRAM ports based on which interface
  -- is active
  -- transaction_ctrl: process(clk) is
  --  variable next_status: T_TRANSACTION_STATUS;
  -- begin
  --  case transaction_status is
  --    when TXN_IDLE =>
  --      if s_axi_awvalid_port_a = '1' then
  --        next_status := TXN_A;
  --      elsif
  --    when TXN_A =>
  --      -- if
  --    when TXN_B =>
  --  end case;
  -- end process transaction_ctrl;

  -- 512 deep at 32 bits wide
  -- 2048 deep at 8 bits wide
  BLK_MEM_INST : BLK_MEM_GEN_0
    port map (
      CLKA      => bram_clk,
      RSTA      => bram_reset_a,
      RSTA_BUSY => open,
      ENA       => bram_enable_a,
      WEA(0)    => bram_write_enable_a(0)
        and bram_write_enable_a(1)
        and bram_write_enable_a(2)
        and bram_write_enable_a(3),
      ADDRA     => bram_addr_a(11 downto 2),
      DINA      => bram_din_a,
      DOUTA     => bram_dout_a,

      CLKB      => CLK,
      RSTB_BUSY => open,
      ENB       => BRAM_PORT_B_ENABLED_OUT,
      WEB(0)    => BRAM_PORT_B_WRITE_ENABLE_IN,
      ADDRB     => BRAM_ADDR_B_IN,
      DINB      => BRAM_DATA_B_IN,
      DOUTB     => BRAM_DATA_B_OUT
    );

  AXI_BRAM_CTRL_INST : AXI_BRAM_CTRL_0
    port map (
      S_AXI_ACLK    => CLK,
      S_AXI_ARESETN => not RESET,

      -- Write controls
      S_AXI_AWADDR(11 downto 2) => S_AXI_WRITE_WORD_OFFSET_PORT_A_IN,
      S_AXI_AWADDR(1 downto 0)  => "00",
      S_AXI_AWLEN               => S_AXI_AWLEN_PORT_A_IN,
      S_AXI_AWSIZE              => c_AXI_BURST_SIZE_BYTES_4,
      S_AXI_AWBURST             => c_AXI_BURST_TYPE_INCR,
      S_AXI_AWVALID             => S_AXI_AWVALID_PORT_A_IN,
      S_AXI_AWREADY             => S_AXI_AWREADY_PORT_A_OUT,

      -- lock, cache, prot unused
      S_AXI_AWLOCK  => '0',
      S_AXI_AWCACHE => (others => '0'),
      S_AXI_AWPROT  => (others => '0'),

      -- Write data
      S_AXI_WDATA(31 downto 24) => S_AXI_WDATA_PORT_A_IN(7 downto 0),
      S_AXI_WDATA(23 downto 16) => S_AXI_WDATA_PORT_A_IN(15 downto 8),
      S_AXI_WDATA(15 downto 8)  => S_AXI_WDATA_PORT_A_IN(23 downto 16),
      S_AXI_WDATA(7 downto 0)   => S_AXI_WDATA_PORT_A_IN(31 downto 24),
      S_AXI_WSTRB               => "1111",
      S_AXI_WLAST               => S_AXI_WLAST_PORT_A_IN,
      S_AXI_WVALID              => S_AXI_WVALID_PORT_A_IN,
      S_AXI_WREADY              => S_AXI_WREADY_PORT_A_OUT,

      -- Write response
      S_AXI_BRESP  => S_AXI_BRESP_PORT_A_OUT,
      S_AXI_BVALID => S_AXI_BVALID_PORT_A_OUT,
      S_AXI_BREADY => S_AXI_BREADY_PORT_A_IN,

      -- Read controls
      S_AXI_ARADDR(11 downto 2) => S_AXI_READ_WORD_OFFSET_PORT_A_IN,
      S_AXI_ARADDR(1 downto 0)  => "00",
      S_AXI_ARLEN               => S_AXI_ARLEN_PORT_A_IN,
      S_AXI_ARSIZE              => c_AXI_BURST_SIZE_BYTES_4,
      S_AXI_ARBURST             => c_AXI_BURST_TYPE_INCR,
      S_AXI_ARVALID             => S_AXI_ARVALID_PORT_A_IN,
      S_AXI_ARREADY             => S_AXI_ARREADY_PORT_A_OUT,

      -- lock, cache, prot unused
      S_AXI_ARLOCK  => '0',
      S_AXI_ARCACHE => (others => '0'),
      S_AXI_ARPROT  => (others => '0'),

      -- Read data
      S_AXI_RDATA(31 downto 24) => S_AXI_RDATA_PORT_A_OUT(7 downto 0),
      S_AXI_RDATA(23 downto 16) => S_AXI_RDATA_PORT_A_OUT(15 downto 8),
      S_AXI_RDATA(15 downto 8)  => S_AXI_RDATA_PORT_A_OUT(23 downto 16),
      S_AXI_RDATA(7 downto 0)   => S_AXI_RDATA_PORT_A_OUT(31 downto 24),
      S_AXI_RRESP               => S_AXI_RRESP_PORT_A_OUT,
      S_AXI_RLAST               => S_AXI_RLAST_PORT_A_OUT,
      S_AXI_RVALID              => S_AXI_RVALID_PORT_A_OUT,
      S_AXI_RREADY              => S_AXI_RREADY_PORT_A_IN,

      -- BRAM interface
      BRAM_RST_A    => bram_reset_a,
      BRAM_CLK_A    => bram_clk,
      BRAM_EN_A     => bram_enable_a,
      BRAM_WE_A     => bram_write_enable_a,
      BRAM_ADDR_A   => bram_addr_a,
      BRAM_WRDATA_A => bram_din_a,
      BRAM_RDDATA_A => bram_dout_a
    );

end architecture RTL;
