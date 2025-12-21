// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
// Date        : Sun Dec 21 20:11:44 2025
// Host        : nanaka.davenet.rocks running 64-bit Debian GNU/Linux forky/sid
// Command     : write_verilog -force -mode funcsim
//               /home/david/gits/adventofcode/2025/vivado/aoc-2025.runs/blk_mem_gen_0_synth_1/blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s25csga225-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta,
    clkb,
    enb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [8:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [10:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [7:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [7:0]doutb;

  wire [8:0]addra;
  wire [10:0]addrb;
  wire clka;
  wire [31:0]dina;
  wire [7:0]dinb;
  wire [31:0]douta;
  wire [7:0]doutb;
  wire ena;
  wire enb;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [10:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [10:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "9" *) 
  (* C_ADDRB_WIDTH = "11" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "1" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     4.2961 mW" *) 
  (* C_FAMILY = "spartan7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "512" *) 
  (* C_READ_DEPTH_B = "2048" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "8" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "512" *) 
  (* C_WRITE_DEPTH_B = "2048" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "NO_CHANGE" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "spartan7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_0_blk_mem_gen_v8_4_7 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[10:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[10:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[7:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2023.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jLV29U0rrfMIZhYJzdoUrPoqB9eHQ5NXmWyCdqnN3Wgm+GU4C3zthrN1m4QGiaj0thPCIynZbX+0
7yjtkv+T5ByJ6NhiofAwWseGLvPXlYu6ERAPvi4SAYpF2VUqQHtPAbPmnPubGdDRgIEpeobF7hsz
rEcpEru1pyiScUriyuo=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
vsoizVrOONWw/DhjRLEYrtRmtji+Ok63CbpSg/l9VnoKAi8tAzqRbQ57atGB2N6IGGbKHkbK2Uzh
EHgWvYZeyt4hE+bpQX91vc9PNxfjQMGzPoFD3jCWk30EmEk+AND39eWx+DhJ8xhFuucoOQ2GwyAk
B+Mjs15naPE7DvlHel8hnD4dfSdYhGKp96oozu8JeBto8aHG6poOuYkxSwaut7NCI+mabCkMxtMp
RrydgmRuTvhRTbJMyx5CxFSZTRDrS5aU1vaRlnMiqKCI7g2KY9pemYaJsFeVodBuo6IyKGynyEhs
wr+VtUhQDtaVhMkwB95WwmMoDk9F2L5Au1I+TQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
W081dPMCWhKs5YlQD7n3zvf7+PTcnb8eFWxoVs8+zHLkxDMA1klITbsfztGYvJFce8Yao5XQLLqZ
oUE5Pq2arq+zwICFUcLjdMsmP1WmL82znHOPHm83zNwrxWMloHkySAqzFbgJeHa973uZqj0M8ydc
sYmzCYVlGVjt0QX0xqA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Zpc3MmdLWaVOv+S4z2POuoyslYoAbWc+Npxq2UyQRtDwf566IId3uwAetolMAgfLo/G3ezuSOXMn
8NznS37h9XvmVrxA50SAux68P87WgkLtiUYqM3CMBKkxNlZ/TR8WzTuQyFdvzkOE9lp8HC7LXnk5
RDsnOM+su46FW7ysY01COslo9Xc7rhs6WFqx29+Xcqk8+ZMLSzaJfuwZdNmJFS3Q1vhlq3ZeYqMl
wMieB731KsPxjxp7VKNHpTbgFryC2isqc4ohBDOt52M/Bz4B/rIpFeHfZ7X3jWSiKtSuBsDN2NXf
EMjfAT248dlK7NxJ+NBNPhS5sLxTiGyQhta57A==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rPMYqnkKhJKV1wltOfDrKos9ZbucaoX3WGTuqsdLkGpcKObzslHBwlGrKtWV7bZYmS2SM+QuEMfa
CE+tCUdsSiprp+n5BuSQlJa6BJ8mlqccjoo/JLw2QEmUhyMXQ3TLGomGGoZdeTmMPXhUBAOyLPea
Ddc8mgtTN8Kpy117GOTXDKP+IKJqW01fLrPJpgEhFiJCbyElLgtCRWmI94gX+y4XNVS0Cd1YwNw6
4nHgnEdC7fXARDKcYO3VsWC/pdzPQgursXloNLrVYa6i2xr+8E1V0+nSWwNYQZP7XUIVqXKMU8Ea
bT4acXrRCF/5tJJ5B9JparYI0zxXSbaakn1dIw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2022_10", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mfroTgL8g2pyIXQ/mGO9YHm19cd5mOlJ++qpusOYeVxGmkIhvF4aKx+AyIUz2yGGAeCtOzIasHty
pyqKgZhibSqxcpHgR0m6GOxXXOXJiHaK8NzxUzXeRJovcBI/WjtDhXeb1LRMI1J97jVBtJPJQH0Y
fGOD7jWvkvQwxnrZdyLp6kPWgSIcavHHDbO7iJv4gnyGp6W3/FCDo2RKWNLoW+SNjSdLZ6YRP8a+
ldaGU8TYvJ03KWlmik7repuN6AwxCjg2KeQ+x1sBAEXzROXomuSbvX3ZAo8UiIKAQY1SJumHLG3L
QI/S4Wbl1Hz6LDTsttMwP480gq6+tb6s1E4oWw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QJIabgm8dx/gVHbOQFwt8maOKVHFgkpZTPR6dzD8fqoGo9M9oGPTqBqchtPZWgv2UYFF2KEUSlV4
L3SDXBKrLs+NsAVTcICaEMiEi6j82zj/C1LsPkQfS8RLrg0ab8lbDMb5YqJ7lkHs3iM65x2iN1Mf
66cTgCbkAdl3rDpab75btpTQt5ZKiq5CSY3RZfyIW0uWbTGTELm6liuRKM9+K8BQwTU7A+FFFQBA
/9eJwQYzNNA/iwoYJ2WTPd6pBlzXriNLu9M+/2bYicNBSuH1PBR9v2ESrTB6k7EiV1zvBXV9NuG/
sFt4MumWMuSNwP2W38bQATxxW/l0IrmaXGOC/w==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
lhKf/Vgj6pHpme1ji4HVe36BU8pMkam/2I9lFeyOiBnIbzgdEGfLJBcEvkL33A7s0hxa6LFbHnkT
upgMpPjmIghBz3xUQ13vpiY152thFec6qvlcdg1r+GTmnBOSFl6g/OfZ3eFUhfsve6ZjQHpXnKFo
a55hN2+eP1EG9+VxGeM7XkHaeFhEIry52qtnmg072KEFIwRiGs2d/TJ4AqupuIdIiP1kTN9k+oqa
2ta1vdtqPY0dDHqrf+5YSd0CejkhQeCqg/bauLP3755SwdOPRgooG5ANT8hUpTiFMFXtU+GC9NSp
evJtMHUy1NbgMmhFHO+w3URLEdjSaBxZPD7YLdWkF65jY526tJzoek+BzEKoBaGfCaY7O1nHKXm+
89k3rPUy0Xo4/0nHpno+N/Db09heJPbnGsCwN/l+KnR6Lz8kvWziBjZe0ijOkKI+T12y3T1VeOtY
H/aqtNlQt1mhFwrbw6ezaAiDPVbCQXnly6b4tbb8+nFsxWOGIGAfLozB

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PNsQ8uEcQYrl+GaDuBaq1tQ5br5aAdaqHnyrc0NVu/JnQUk53jaiLx8Oz5fNACvWelUUk2/C+P5I
b2rbU1bb/dC6TqC5J1N0yoMYRYw58u4Lrl8Kgqgt9Rlph5Qgzzfxp+oblXF/pO4mRyAXpZhpNkFT
0Ar9BUtPOTOtJ9/g53SRnZ6GjxzfeD+25J4fcXBNo2gCTgUkwiLSsJRwTB/cJmn+dZPwPdIOHEP9
TkfDK+OrbLYO3T+DFBTCMRNH2NB1J9sc5s+nPU8iYnjgPTo6HoGW+LIlCz6yNJMZzJzoeW708utc
0fJXkT7vLDVh7olvy3V9AAY8Do0YR1kiZlhVhQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zAz8RnGHFebkJFAS+gjC+mXHW7m7We+JgSmIz15mS01u/4+9Ng0sJfkeXOClmVPTQ2Mp2Yuv6/6f
ehzUTcANilWsqLM6Q1FToCPNX/NTqodlcHirGM7b5R9yevouNT/aqH12nmbunBQmBHmehNutdCjG
r6Z7kZgeZ2ZE7MMOF0rTy1XHEPkqgMNTRoS8R/pPWPTW4/j+bn3aJj0Q/fTz4Gi3mbSUKWs2fREQ
UKiuolNJkN6DiDvhlVYHUyytXNJG44ikmBXehoQQRLapkYaxnQmMRT1ok9uY6pKoy71CtvJ3Mt2x
EQv1GU2i4qQyAOwa0mkEohWXduicU6tDz3zQwQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TK3eE9V+v1z2P1KjG4GrjhA1n3qDOpNzLGXdtjnjhF0QBFPSuhC+nmNqTPOb3p2a9r5KD0miY3Cd
+KpjH6Ao09E2/LD2Go4aLQh6vP+9BldlSKEwCGfx2NjBQrXWVH21lQR7IRjOvyTOclpd7SgtUJLw
dvebETyLiKr9C6RfnIBeptuCA3iJlXfwkh6I0JfzD5WBizQkotioZmmrXv5105pCXQ4Ta1WThFsA
2ll9dZeSjEDHUxxhfyfjryv9m4VL89ZDU/rGITsdptwB1BC1jLqmPDymY05lyECnjA6NIR5GGfI4
K2y2f4GfikKoN5r9IOvFzw963Wm82ZZPtXOKGg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 27952)
`pragma protect data_block
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
rXsUyZaN6hqDQM55H+fjKxSHAfiKMQ==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
