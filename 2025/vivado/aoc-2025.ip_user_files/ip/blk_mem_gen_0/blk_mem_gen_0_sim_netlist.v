// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Tue Dec 30 11:14:55 2025
// Host        : nanaka.davenet.rocks running 64-bit Debian GNU/Linux forky/sid
// Command     : write_verilog -force -mode funcsim
//               /home/david/gits/adventofcode/2025/vivado/aoc-2025.runs/blk_mem_gen_0_synth_1/blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s25csga225-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
   (clka,
    rsta,
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
    doutb,
    rsta_busy,
    rstb_busy);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *) input rsta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [11:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [7:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [7:0]doutb;
  output rsta_busy;
  output rstb_busy;

  wire [9:0]addra;
  wire [11:0]addrb;
  wire clka;
  wire [31:0]dina;
  wire [7:0]dinb;
  wire [31:0]douta;
  wire [7:0]doutb;
  wire ena;
  wire enb;
  wire rsta;
  wire rsta_busy;
  wire rstb_busy;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [11:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "12" *) 
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
  (* C_DISABLE_WARN_BHV_COLL = "1" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     4.94295 mW" *) 
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
  (* C_HAS_RSTA = "1" *) 
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
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "4096" *) 
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
  (* C_WRITE_DEPTH_A = "1024" *) 
  (* C_WRITE_DEPTH_B = "4096" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "spartan7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_0_blk_mem_gen_v8_4_12 U0
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[11:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(rsta),
        .rsta_busy(rsta_busy),
        .rstb(1'b0),
        .rstb_busy(rstb_busy),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[11:0]),
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
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
YqH9kwIC39+qbZg4PSfFsXuB9k9wnuxNryS/CfnEri6Ci9fSC6fsrQ/T/hnt3u/yolbJ8DJa1Qu6
Qnm24A9jLbA+fu3Nsmm6/rM6a4vU6OfVl/gTFd/CiWDutv6Dhn6Lim4uUNPahoOR/A2Yc4Zo2tdI
kMLO9gn9WlH2l3O2oXs=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XJYO2VHd/cnMxQd3i7/2qRhl57dl+doEKuhAunQyv3vpGRG/jlNxj8PqrgLoF0HMdqE3qJUVE/oq
kBSapqjVjLDMOrNGQ+Tc6VGsKMZH8FE/TXHQJ/IM5Iuiu2eozEwwVUomF+7cfqn+9OsVsqCONQ1M
g0oRlangiqasJDhhMfnlGGqwAwmgWRGQA6dmhTuua1s8zdvIv540zY6p5au8cAKVhqyyKK7wbxEE
SGuFqX+NYoyRV+rfWCcWM+hJEmnWS8LNAKkd13YE2+17sPYzUdZ23DmTxXK6KlAxKFW27CBySUfg
qdNXp2DSs2KAQYih27pBNMuHfGbM/ATFPWFvxg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
lYoEi/e8HsDTz6N11EDe/B/iitERmeYndlCklmCluwgb0N4W80JUGVlkd7NlRZHRNhxaNBJPkcjC
n61nO0tb17NwsMwjbY5TF8JWRYTNw1JXCFacvQYrdKv4/7QNQEtwVGiCLxFhOA8aHlWMZIrc2fri
VRMVWaEBcPwCGorlVIM=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QEw9fEsWFbdX0OQLvYs/gl+zyEOW3ak9TdQVaq+0AXXOT3LIqF7wDxJ6ZBnlf9mNbdsUVH5tAz1o
H8u7ihJl1L3THEvugW+TS8hkvVbEA9rKO2vV15KAj4Lla7UdFT/xDfe79RFarlLI7yGrubjgdoRi
QWy//UKsffG7IWNwmoSuppWiWB4ZHJtkunNyIkm70JPGyZF62VxJg1MTT+5LUbZG5vZjjuHZud9w
xJaKv1tFP/x8RVqLU5gPOqGqTW7/nKO2S+450Vo4D9vAmBVVcXpaL1EbSmCvQ+qJmcQKtf9qYFRV
Zko08hbpHjPxstqvTDro01jRzB8592m4xU2TWA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TC7q853CWBPPJgbRfgDV1lmjUwSAtliljShAyNFg8sfRfwDzchthzoSPH1UCHV++E2JXacEKq1lB
UWsNP92U4Xh0/Gu+6esOI0pJb8I+TRTxyBN1I4cRQEfQHcwfhbSdeH3yX9OV3opLEqYmT37hWU+J
zCawYnxVESI0FtRzEXve9gdEWlrKKckrT/hp4mvxxOjvOkOSQBvy0elgUOqh6mEOZl+JnUbsR+Wm
CoZLE1eefMZy3FnVmyDNPv3JPXi88aLXMyimal0MYFkTiS4XJiGT3eAIMIbksehXY+eYi/KFpZWQ
GHpX+lG3UmiWWLwyPakFwKEHbrBc70AlJ2eV9g==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
j9nmCKgjPWNChPbpSW6EWLrMA6oCG2JGPoum8px09v0PEAh0DRXZi0J8HPzXUsZgOEMcKpA7X54u
YFcDDCLAQ+urha/eSPbQYHQh4yGCursxAQ1C6LEyNQ2wJ0eLlO2bJeAl/gof06zqsYVM2lLJVNv5
wao1k2bmgPdfpfY3c9vPD0fSMuZPS41EoRS0cQhO5GTZnKdjxm6tEUL3GnTjB8ynSCIbCJUsMtAX
4FRHNa52gudx5B5fagR+lXgFhE7e++rWTJELr7SYB+r5Es8qZLTpCH8TrQxEkV0rY/+e4sAjNE2D
gHw8GD7VcUtc15B8y1BbVmh29qc8Nd3V2i/miA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UkCD6I/Vye4qNoNoa3hIexBXG3xyKUJPAHAjIo7UcNVCDXpMQiYEtPDqExZMfiPlJn2nswCYIfIJ
FYWqMCloKSQyyI/7yZ2EtbyWEklb/P5IyZyvGi6hhFUo/JFTb12b4bK0gZPr+bCDdlVQKTx5GVHz
wptdUJO2omSj8axVMPbLRRtVzlJIZ29dTJ2ATXVXAcBxPnFfHRAMnYYKLeeLExX61vQvpqrkLQHm
XG7hpVzJi56gYKAzxa2BLq072OCVpVS70bfWlhlSTVcSlCrUf+EcarEk4FD8+Ih2NCvrqremG6yn
TtcBn8Xr8M/6zhOYvLi6AD6eArDMKA8n+Ccv8A==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
A5y5QVZU8yjPexRVPioSiAGohCHD5DX5FVobuMyhcgQRExLUhPvnnS8HOtxTj/2IapEcz68gFMGG
Hpi+m725u85/om/Vze9pGIW9Mn328Kz2FIg3W5EvGstfGwY+48LiAGAmTR269JS4lJGVYWYOz7Xk
S8cEsFd2m7j8iyKtARJzD90+UdXq/cIIh725jC9i8nbgxB364zddvm1Z/DF3JRw1qFp6GGcuRai1
KNcJ1j8c9wtIgktpsteU3e5+bxHEw8NT3gWXUFYjm00NDq97Jals8Jjktmum2nQxoF7ivPacfEey
gnSF6jRMkTsZObzc30hAhs0CEtc33hZLhPLHSn8pQ0WyvKJLHdd5s2yckgTZtqxC1Sbwe7WEgNXe
ZMX3pIkz+aoXsAL7GBLyVBMVQcyMoF0w8QGAaTe8sqatABwPqXidYRqNROTf62IYcMpV89XYgaTv
EwIn/oni9KOFd2BFVxRZbFGGC4IjvigsTBUijI+Dk6kVnDh240clGcc4

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Omtp+lCaqUx7Z4qdFj2zrN8LpCkit2eX4hlMtig+ielGm/x4FSZkpjoFmiqdKFPi2eg0pg09MSai
XyGH68UzAR7Xrj8f1jlIoUmMKp4GcxfdqfTeuu7kWGOJEP6cvgTjSJFj2gawDv7f4yZcltnK2x0L
e4GW/rBTmGvZtKWb2ahjINLxPuh3dDaSaWdb+zVgbtyrI5FrjxBkq+aOxSjyNsqnCx1L0uWbxnkl
88NbXN3dTaECXHNm/fsleayM5hKis7kTv9BFajJMGy+BhQlmIYpE+F5zchnTTFUFJZCz1sX9Fc8e
HcY7irB8mR3ajdzjUZLBQEMktp096Nheq3U75A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hpeBLwN9x2ZFDwroYLlUe5GjjDepHik2l0c2s3/6S7JPCRkzQSyt2V1Ad/JewAs/QNp5SXSbYYB4
rQl0My1LDMF3xw43r0g2IbcyHVpPhGp0W5msuQdF67afnsRv90iJYWLMI3QkYGCTWAzl4HrLxFSg
3z8XZRK670IcxznOrlvgHmIKsvubZrBkuc1EynrVb9Nw16QnIx2rc4WgcEXeFf+4i1RoYLDd3gXK
NFCNMdtaRYUThunFP6Z4ViZ5UnDmKq+IMhd31jTaqIlWOBDxPI1+v5RJYxIyTbn4rxlKR2fNbl5/
z4OUjBTd+1GH3I2OXlqmAOvIhpe2Z2HH7nZu/A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Mt2RhTSUwEIEWeNARbyL+EdfS1UF6nPaL/fKl/7oO2gina93egwCWDLl1fbBtkfaPco0cu4MJ9K3
OraAsyHRlY+MNShmJ1LzAIA1LjZx4y55lu9dlQqSUXR7AW7wVbkg1864mK+hM/1XygU0jvebKNW9
B7xSER+asLO6pxi0mt7uC2PHxLPAYEszFhmnap82TtbDGdQ2qtyekY+ngs+N2fAdsblxVwJruiMl
e6XJ127M8N1mYwhWU2HtRpBOSnnKoHgD9fG51XK/rhk8DxT66QnX9uLPB+H25eDupBJGi1Y5o6x8
hOwZiSUVlBLh7brfzevh7+eRn+7es6wBas0+3w==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 33328)
`pragma protect data_block
IEYCtjDZHsSohBhl56wT0bk6N0matGtN7CPcANG54qDTdz05MljorsEkBlX0hyR47D4QQF8209Qn
1nE0w/ZefQaQJ3oyHgXJMcT+x6DIJxQ4mhy3uyHb3sYukl5cEBUnv9BRmlc31/TgHrT0iyd5SwWO
1RC4B5Q8p90bgwC1CzyJor7ufqzqGC5wtXdmgEVJJLcovZuL6U/g5ZsCHnj2h05YAo/WpbrkhpdY
NVIRm+HcGHU81KkS+eNTP/bo8PMTPqoH7hLJn1zyRmefyTyNTy7I1yiIKg1+uwr5nJ7ODRyOHzfX
wD6L9GtW9cICHcfA84mbRKEjnwCrOw3wHBcLXPOZCTMR34g5s2M0+zMhmE2o1EBEtF4CqgHjFx7G
ecPjYdC4T+i8QqoQill8wTEBmbPytRVJtG9dnaIYkbKNdneSNWvcg50UPAm4rad4iWpHTfwJB5Xd
Fxr/M99kYcrJR2Ij5JX45/SnSr0Al2gAP1Ql4YNLu4l6MfjB/DpALpDKGTTNnoCx5kKXMS3sAASb
EwKwPvKI533stdp0JiJYbg9bEl5SQKdF4weAErIAjtp4nIklP0IcjADPD0HuV7vJaTxb83yqpVCA
tvmnOAYFDWCvHQqWNl3NJJNVnuIvlbgvMA1YOA5dozqD6XcP0fey1B9V4W685TPzQAichX+oms2Q
IUrPA5o7O23nQ3EPEe9SP69gae0jBP4IRzGLrzusZc9nhhrGzAd8xexMx7tyG5SrTTWrZzjZsy6f
kqpiB8dhnyVVYW8iOYryRVrdJzHk27BbeeACE4kodgO/SBj7zKwrqsSrvh797jIh3F15XDGXf9zb
22B7b7mIOkh1aHJH3o1+X8x+VYGbsYP8J5soPfiDpYhZGgfVjeN6FntEkmfMfNG+XZqOAOqAZVUf
GV5oFywhMm/UItQTH9h+IR/O//euZfU4Vlz+/dM2l5Hqv0cQOQZL9/wY4WWQfLP5SvMPQZiW+sY6
dteZNFHoSnPGXrvdEduwRClIZ37jFpd5KrHcztSpa3QnV/Zsjrsbzh0XLuwNdWv/o7oK0DAxAdy7
vGv7/H0cPXVyR+8ysCXiZnpjTkplVaZxnHG01GCB04vnKZClgOeS+VASO31gXG5cAia3dSwhbQIz
nlg4t+i6gYImCAN3vZ5XswyI+Es/I0vDO3UAQ8ewqjUW5+M8caWhsP0fnrtOOy2AYca6ejDFHmDB
edNhLrrm0xBoUi67W4pTRtlUd+S/mmAX99NIqvMRVdvSAn/nen39Rw2nPSNOwBHRSzD3eqbNS69K
BXKVsRl7ihuJyUz+cStXKWzn1hU7jQT2kJgeD9Su/8A3qeFUtzq7LgH04P/I0Zd/iSNp5WK4/rnl
6o1zYFGfgyVcTT5AGOmptJG5B6xunhkBtqtP+zB6GGqU97L2ncGCwhXZfR5540YxRK4xrDPb53c0
2R/W82nr0ZE02CMSPbWCxUaxap6Zicb13kmSXcCuGAy9xbJOMM+fC5srqOgyjn0PKKnLm6o4xG2W
9OWcR8dXuYEPkE+uHqw1oCEVxBsCxATsC7qaPEiAFEUTVJAqKzvHaKBaOWC4dhuxRTZjg7WqfcdH
GmCfZPdW//wWAypVLTmeOxIZcQpMvlHTp4UZitKCQ/XsOr3vPgXtq007rBqFaCIcgxk1tISr9xZ2
W5kex4fI6KfH5FzxQ34T1mhkYBY+3E3RpNXX9kLt6AThPUDKlxNh6ENpzUJrOVMAP0W5PTmIYt7p
pSN6wekz/MBlAi7paRi7PXLcl2ekoPs6Eyt5YVvr8WdmYxU2wNWRXgCbH4htZ8I0wCzBVjFUUB90
0BZ0mOGufB14AM747xM6howGe4JkvLNt3cTToSzcidCBqAdQnTlBrxa/BokaXZwgn4BQZViOsbOV
g8HRPIs6Iy0CDPs6s5RRQh3IceT67u+L/tikw3QRl43q94bAX5XP5CpGGEBSywvUaXa4o5ccqDya
c5c6Q4dxB+ifMYM1exSor0I8VJwx9UCqQJhVOZE3tuUmiHriosVVlkUmUNfifoTukjK9o05NP26k
NF8F5qFooKlLysf++gPkQ2QfiCT1ngsukb0nU4Rsbp5fpH6mNuWdFSinWMMZrlPqONqCuWmrbWwe
UuPO0coDgWv3uy03YwVmX5G5iE6TbboL7/xuzLDG6k8tYHAY76GNSk+0ObwezTxtKtN0FHpmOKpi
v0ohbxnTQQSaCKY3LU87nAoaG422IXueAkhqM5J2wZltPJtgj7umZYgnHfQZ++yA6q9YFJ52jUTW
WL+EwIEW/m40pVU0oep91wWvPEYWbNtIKyimgrXfd85Yam2s53HUwP2ri1xCRwjkOXFsk9JQZgJ9
KNWpoZAwEtYETIrRFdRqFguDz6QLfes2m18+qGZfIOfMtCN7IdZxugMffOTuUDnw2QrGdUEIb4SB
XLr0tKAjTJO2xVM11U0+L8syrNDrLyMh7GHR0PBStviH755UwvW3BGMtjGCjRkoB8lcNvpJ01ovK
YzMDHRsZVe5NNBeFx7alt76fYgwOq9LWNm1VGQmPEnEcbqc4QHEDW3km8jXEjE2iuFAnpdATYZne
6rP41PWYose0fyya1surpWAyeMn2V1gXBKe+ovN1+sG5yPPugfejo90vWHUHOjHtfRM63Ev2YoKA
G3W2RJcXRgaQ5r+GQzFG+WlAxkTvojbUQ+S+j4Sp+r+630dKlegIJeg4wzTi9Xl9sU1w5uiopXXL
V4oKVQ1ThFY0IYoj5vG1dFHjefodqPuz1LkldPRU5RF2OL2WQP/NYlR/J+M+n7oqeSNoI7Ck6j4V
FbmKwRCn8MyIkCHh+fI8HCVtBONFAQlu3Z0IgbKtE4tHI+Vp1Mz/z8atiSuDhUnQOfXEAlBOB32M
f/aZR8pVNI1pmbdmn6t2otEaqJs+QWx4uT0znDRp25NfVblZIxR9GMj2USEI11rntAWJJqlqdvvq
SOSEjxkIp9kM2beEsRtFs/fZj5DEr7OvDyTQoq6EljCkURMgUOwYcDw6IXxEmptq7D7srEfS1Pgf
o144E/P2IDK/caNVStGYxw8zXpVb749XeTnIJTYWYDRqCmP9NiTeNgxJVKYr03ZLCYrh3/EFOFDh
i68KyRpIbxSVLHqkPbUKpsFQbcdSEqhftukNzYG8nwRT2H2zeSZPwbX45j+pouciC5Zcv205xcsS
UFaGemXoDT2GQs30xQb/ZLZzystKX4QZXBUo1Tc4OU1Iyzl9QQdasV4Y3Z/cDZmt8P4o14pqIzTG
emSrvJJl8hqosyChaTu7FZLeVpz9xx0kJqKP5vP1eEXq6jsNtXDz6uZmLGU/Ux2fJZerfuB6+S5h
7YoxayvIzAIWke74KC9Gx0GMuuRr9qb9WuCeAeMNbHOz9bjVFhlaBMcKO4labVSwTjiQPWpLKQh+
taPmyEsvX26x1pq06xNcI62u7NV28gdS2ZTRXsbPReKA69ziIToE38+NUGn+5r/Y+RkKOG98+a67
+4Z1vFvBylghgbc6mZ2OcKj4w9JzTavG0lDRHlNPdRmjRaN90dUPCbeasBeLcCOxDY2Lt5E5BWzX
Jo2EPruuA2YRR3y0ehhiQw6I1Ber90nGybdhChaJ1/e2vNEff2tlakO6jiq9lnY40dvF3GCJmZ+W
97UuBtj4UPV3HssMj2c8lcVdeQsoao+c3MLAeDjKooXjvmHXY9aK97I8RaeqBmoiAQqlaKIm3Yuf
bUSx6q3ERQiMjU3YiTzD5jX5jXBfMWJCz26E9yGJjxoaOGQnYX4kPDex68vGjtiUCx4r/IUFCUGR
OAEpAgIP5iGiNcCMYLrrDJVxD1ipPnELMDwi4cU7DCSCu5ig8RziCSaGyppTa3eNghvcKUBklZ6i
E/knASAbv55/N/xrLakt2WBnYcQGl+1WTEKAx/xTxLYiBXjxMgfjnn1Iox5D65j47ahWVJw1Ispk
qnoOuj1mQ8II1pSVdh7rguIddXrWxTCUkyZAlhhyPHK++Cl/d3i3YA4/ksGFDBhSSWJ8vW/CVUxV
QLFqoE5naDHGKZdYPZ7/kDmZxnjPL8c2g7sGVxOql36Xb/xiyyXeVht5HnBYKjkTFGiduXNPQlQL
n5VWnRPsZ7YsBI5huokih8TVHWYL789fEdGZY30y7+2nNX/AR3bYQK05y3H/YeyLrZ0ZOUoN9F7S
704QFOmyTlMp46p/Z0Dg1uKBH3Vi0SfCFbdqw1zocOrOMRUo/07ydsdZ5DUQIH3rzmfGJJfHYp/o
zEnh4dRXmKTOzOgigXKH6iwt9UKBDOIWfmrfQI3/lU/fE8cfCaoBavQPvZns4kKdsveLSGj3GiCk
IcYkp2QgVoGDavi1rTAzR53L8sACNBdjgyx6MBAq5oHvrSzYw9+7CNUEO3en97DU24Iwxbu382Fd
kMkbvKHdSIruLNZ5lg65X/2P9ErD9AteQFr3qy2lcHbccGin0xQ3QOLq5I/YcHRYO1Cgz80Rtojt
BVxkF6JFvVx4JFv5OheVeOEjJnQFoAw10h1s5K3JBcDLBAzh7g1CrXKuAFYkhYc+1mWoTguiWPnE
6n1q3qn22wrNFll5svW81XemH9XjOYZifkrny/CZMXiI+QQRcmoQn2JtXOgAVx06Wxxp2EHwzeK9
i0Htt6bsE/WV2Ovf9Ri1bkkFfvFDaIKD9SfZ8B7h6j3lDlI02c2lxn2+TuFE7uJaLDwxef++4Shh
ooIDllFJBkd8WSIehVF93CIfL8tVK8t6V9VMLgHmLgbQu4WeJb+Fl1zjhVATnLGGyHo+G05TlzLR
MT0u5SmccoJ1bq7U/f60H8me6QSPCLiFRmhQOWQ35s3fkgPRdPhf+3WjZ0Ke9OVz8K8OElIUzzdN
+V9wbVmwQnn+cwzfoI8DKBUbb8dmU24X7BVVSP8V7mzTs3QI807t1qpUPC03J9SXhVKEav/LBIsY
P8g3pDIX4zy3PkjtqeAsyIyZEEOTr1TUD1ymIEKFU+MrG0OQO5fJUE76d/V7lFZ7VgkGOqo0NdTq
PJGzLiDQCzSqUtIVg653l4ae5jtsodh1YaBdJXn4VV8Ugz8V1xasy9apz9qnAxFeYlyrx+1d5NsK
PffiIaKK2M6xKfGbdtJgE2gtLMxZsGaXTgI6z/zpM5niBIe3XtTqXE0eGbggPVNGfvpv7+zBMicF
wO3gpJMNZpDZItphwpS1hrg6OF3rK5zq1L8OBJsW66dsaTMLX8zYWRA7xot0Wvq4S1BD7JRjbhPZ
EXu9eOO+cWps9iKIps6kOiw7YYubxT+4FC7+Ba0LqDqFgiKymsC7SsfCPeLktdZxdTNmtlrY9qaw
NFOa3QTBspfGVRp6NmSBSQVPNk8oA+YBL+BrecNRz0bWK/87hrjhxuZjrtMjzIQBEexff+wpCq8E
CKhghzBrft7f7qvSnN6RNzZuXXGMZAjZIs4I0/eaN7+qLq8UYTRxDw0VakPRddKkWFuyeZp6GMEK
u0FIZtRiBIwTdLb9wal1RkkUb+bKp0xP0k9mCYCAQiCZKuPphNAwpn4B0L6YVtVMcPhVxvw/5OAk
c2i8TTuEi1663SPLMl/MIY+SYvK2TK8bCYQaajY6OozJh2cHu1kKBFxh1og8eI0dm+qv+nAiAAgI
JjsDH2V3Xerx8RBd7hVjActT/rk79qquZTiKPcNZYAVrPgMYeijEiiFbb9mu0FRuDQs+C6eNPY3d
Y+EjP5SJ2hkoZJJp9WkBMAqLwQ44MgNwEJGxdnXf8DQfwFgUMOQJpbrxn2+znDh+1lAWLZYWaeRX
8g8FQsSUnAvhlkrNpfHRTTcXoLFWeo6Zjub/GBcN7Np6nQIIl9ziu933O+y/4Sz68sz64tJIWGX/
qRmV8MmM1HqDdoINQ5Qz7QE7dNrJgPp65SPPTCkxM0rJuznbOnh4RYcgrNi7npzTKp4f8gI4M1T3
SbsSPqv04ZNHmUK7WBgdyDfcshXFyfve1jdwDUbWiENCbd/U96Ip9BnQX6J0vza5QnmbeG5KtNZb
H8wW2M3D1bnorRtZQ7T9lEnOyBscFfiSZelFtS9E112ee0OVV3gxY/OzJr5qYbht2SdR/tCeVlWJ
vJBInB66sc28x6m69CPAqdH9G7E884PhsHBFZJ3hFlXHiHCVhmhmLfLn/edTaGohiBAr0+FAcMX1
pGr7aB8vb56qmDuhaOnwjRoHOLMzwbZiOjD7hf1BWrCvozlosy1f3Nw/GGUykFC8cwG3eurq/hJB
D+RJLFTjKVkfOhBvq7NcX4ntDDi5NyEGXbEnOSSM7eStXonTGDUHlGrTTskemmpvEEX+8Dhi+mwi
BXcEHLIHApAqJ5IlRW2ywqlkSiovyS8rNG81WTiB52O21+zNBoK1EgINOCIjMsE92R/I6gOrf/Yb
/MjIQstJYiI1duhIImncJYt8ciB19Xhf5df0UjXMP1Da5JWIZjrxbbfMBX6nCqeKMGbNiBVI3N2v
4XF39b5ujIWkv52mdQV03kVSbFCnvwwgJDtdAokBZ3jbHiWAJ71XMx4ktqU5+RUH9M6k1/X9d7X9
eVxMcYx6Otl4CtTjb5+EwjK5zBNIXI+QrLcszUYuHjlTJOCy9RmfQYFLUVeuSxe+7GOLS6RVjv5N
LNjtf+6jGdmBw8Mjgh56L1/afSJu/Kg7wcx/aJzLiHgp0HI30QhhttVDc2zfKrLx/x19qbP913C8
xBUEo/Bc+kIcRyZ9bd702aWCINf1zdGorRQ90NS3uAUILwhGyN+d6Dkt4ZVpfY5wBWW1EYZxhI5P
09JtWNN9KSmJo0ej+z1Sw2YzTNZ7kSJfwPRVVpeMlqPU9JwaoNJgr1u52vuBEiTwL+cejpEL6ZkC
3LY7vvnxgW3eLKvk0Kxh6nZMAjtTByMB3JIwEf3rKfbrGi7OcuXBp4LYJ8Jhh7wMOfWkpvDGqilr
QxF2/lW4nzIMfObzhJ9R5wnQOaAxvhq5LZAR/XJ2n6hK+EWjKnWUHsuNueHxHjX7Dbi8U0edDBIT
JUiqA37/9ylLUZAW8twoBzDovncr+dLDyAGpCBPiCeutNiqoEvJb8icUH8NyVMgaehZ48rSjg4mR
VGBD1QoJANmNyxByRF5vznvi1/dEaPymMJPZWgYbuKyMSxpWgqzE/BGXSjAjZp0MowPqhKpZHqs8
iquaHSUaJObLfhwG3ZzY7pK0/UFSoseP8kGHLns9ClRVc0hoE85VTkc6Frb89GaYHrKhKsfe14WD
1QJIoQjvyY0uPwkw1W0EyI4GJA1TTIWchn/AYLUY9+QyyvBioym+mMCOFNnZJTB//1YfG3fUt7C1
un6mdjxv+PfyS6bvxq6rAInqK2dAhp5IEAjM5I7Ga9YLtsaHsTR6xCG97L/Re7rBV/zZ0BxWeCth
Lo5QkbuKBHSmAFHjMCM08SDVmrXq45MK/hKvdaAjJfFFKJLY7nxwAEOs9OWTAMRHbU7Ujl/1y+P9
n0lTgeZOazBcTWGD2AU0CLKTAWZDU6YjUwtHItbTSFA9KHSLsU2mr90AxtuEH+m+U9onOiFI8v2l
NF/hSMEGyf3geyYzSw5H+pyVhIgQtjbLWJZ7uVzzLA2QFHtxw9EaX90U8U0nymK8UHoZBW+LvK+a
zrY2ZHXtUNvBu9s6Juu7hshrv880126QW6mRFeIHze+IIHVhmR6sPHuLdClJqHHE9Bn6UTaq2ywd
slwO6soEOPPhBOAa3+zAQR5kPaJNvOeyXHb9DH8SU3KFvTtgx1wWXSRgetiEpymS+0hbmx2OzdIt
1ibxmcnDvfA+qSo8wgD29zC1IIol5xtPY328qIcQmYc8nNGmjVrSBHdB7AZYwOYTgRCaI4WapNHx
YsLT5s+pdodEYiOqXSI0haLcJ87ykMzj7ELAj6kBq1ZJr2sY1q/lQmPCcgqmJ2/IuI4XUFTskcWb
eadiGv3uCUshE8ZQarZUFiOOuN2eyQzP1qp1fPjeiws16TenHQ7uthAOT+ZNd+XaHaaN9i7O4RtF
C9n4buOEiWyLF/HlF4O8SZZlzx95yvn2LG9Z5u9hIpWFamFNtXpLBaxQC9VIszOhbKVqM298tbdi
ChKz20YcpQyRt1SFun50trp3GewQU0Uqy9M7yZRJ0PSnX1gmX3dxljab5l2hBrNQph6H8LUxIo5D
yAwV6qXgL+LeKkWmccqOM1cqCE7/hrt8/dqwznHnFnc1p3FgokrYOnMnZYU4zm0IfTk7RlyQMTxc
rQGiB0gs0/bInBasvFOKQdCKufLzY5uz6M2mmoaGKvKCuKucL9Ky5dkObno49i9ftnN3jGCb/aJg
2qBjGQuX61PKLwv3J+hDslsgtgm+WaKuhFnMLdNlEFY1Btv6QQLMOGUt6QXVJOg6GTkREoNqg/tr
hcR1JoOiH8WMLOFRAS72Q/1hK5HadmYJ3tOhqsFyJ5aSL0h0v9LqXAbJ0vpUfZSeOFZZ6isipwKc
5NLBFL36T87DWsTNoRg9Iu4g/fhAHCwSjz5+2s/TdOdpdagwnligLvHcrow2bfeX70dgBYfnxFEs
6jnk8K6I2cB0N+eS4XGSiepK3NrEZ/52kmLHnzNydy6iImtKC9KFkuV32wkY0MigI4iluhfdoCIC
lNwvybjuwb8yGSUDTSEnqpMiLpfJBwfhPDhLak+JocYrs7foWXeYnLY9+ybms+s2YHf6YqkcS6EC
64U2MGs28+rH9Pn82kqWxQQJ5CEyj3PiV65Q5OnyF1iOKeTSTHrcVeRvaTlESKEKbJ4PBVdy+Cc2
9ZSOyHC2qy13lNyLpfvNDuWu9/feBOVTnJJ65l2bnQWZacuo1bHf1X3+4UKQCchw0Nf6vNY4BS+z
MOJBNZbp7EYYKtOsTUjpuTyvl+aBYdc5x6z3z7V/Me+qo4DRBUgyMhDFtWV3eWGiuXF7Ct6SU/eN
ChB1nvGhAW0V/JqmSjxJsEXOfQQt94VNQvCI/3FCuEC7O4mqKAM1Ub6uIX2rnblOD++cXmsmlh9Q
z1RGq+vo19n/ummwIIWIg1TYzr6EAGP9HsovWGPrUyVaskCFgtQMuG4Wb73RBA48NO9fVIalvUag
60yYo42i9aLjW0WVcPAiVodcdIgDVObMaXyj1BQ0+cdtTq6jIToRPAFEPzyepwSN4rVGT9xXco9x
9STctmf86Aq06Muv3QFgHF7SzlxqN8Oaveg7IwS49AMrOd5xYLhqA4cRxSzRM/WwAjsViLV8kRZe
cjrVyKbzH7QaN/gVN5Xq+vy3iC8S7zHuEv2dS7gFWJVoVso3eXRGRneWhfDnSQl/IQgWEg7OykHv
Ofka9AL7+X6NF6ozxVMDgCXt1rlnRljMY9qf+DxT/xtZzheSSNgJLAzmWg6JXyGlwoH2LCwX3Xl3
qjtziS72A4GUZaqWEqBprtoBwjThgjdmUWXBuyyBCVIY89LE2GNKB5d4fLiuBeaxipLtJcw2xtDn
tdpHKUU0kzVIRCLOMCY5o76+HeD0Q7hpFoDr74hnvPhsAqC6mZToePSYHiWtmS7Z3qwplBS4KTYO
qVhl07naXkRpvakwMefSu5zTHQ0k776qKwlCWmrk7ZpLUkzX+FNcEOAc1ranpLcmbXQal7yrzwSh
KVdScOImrAepkpN0IwefSZ3+If6k6KJr4gkrCJnqy7Oia9xBaqU20pXWhCl+eEe6QcHrHthhvETB
H0LrVVgNUXGT+uER1tRH6tH6ZTqHtu1hQAqnOYzBEfme8hcyYILGw0IjrZ6SV03PU68MG2beR+w4
DTMmc3cJZwqAExuZY8OqUJqTzZOSg7Q/lHFF8wm8dE6k3QL2zYHb/i6Cb6jWXN/hkwdoVAv+EuuA
WTVGa8Wej5qJ3SmCkbZMgw8DKbb7Xz7PRTB8jspnuh5ib0U2LtXLgpdLsqJVdmapKlQwnkJbOnNd
KVjeLxFJC4y4FUSmMUZDNRAcyQ1XHd2BX1YmUczPNp2oElYo8dfxEc+Gn3oI0FV5YBaDR4K1E29J
I4Lmmym3GbFtbcFiqJCdzaOjNPwLq3LGkC/W2zJV6DJdm5lROC0fwMucAbh1apBBOrOJ3sO59JZ3
+azTZl+CFnlXGf5wCLKXmnRn1lYlBfBQCcYNFv8cgBqL23KwQC+3VIlvoA/ZY+bWJ0ElTjP6y6GU
MtLW6/xUHHppKoLzmY6jh7lL2M8vJpBnVir4U9wYQS2+uTS1Jfv9PzYqmNKIzoRIgApfFINOehvv
c0H6ttWX+XQP1HPs8v07LCbGIAbn1Npp6MOomiwEr4SVXSTLk1xZCJTQLPO2P8cSJcd5dGV0HGP+
jVPCz/YhfzQbO5vqEL25qLjhbXPSJ4vq2/HggdWgw/TQHgM4JeJpjgSu/53btLIUatTLnp3wHlJb
R3rnQo1ZHTBzAfEOLSrHKKe9mrus//qT1ZJQZJu7QctvN6/ev7rnnI5FkJnHmvLW64edNg29RdqK
JywIAodKAiOGgT6H5ClWUz1HJl2N7bR4S4WsTkvX4TRuf/NoRryQmF8VMJY+eNyTfY3bDd52Q4Ih
s9m5dwsIp1PGz7TsHTSMvs/UbZdQkA0vT+HMQ8HBz+li2Rtg1wNVCOdfqq/++4sbeNPyEiBo6y7c
yOVckATYlA9azCa6kxqZDTxldU2uc/253+/O0leuIJYcqEeP2eCSyXrAjv+B5LXItR4WFUGwjFyP
wyQZ832qr9LKkJF/d+YKYWyyN3Dj5QTYacVW9ap60nZhh+9nKPjDY1OAAxV8SXLMRcOArsN8rT/W
HJtVSJJcRhfnC5CDLQEkf8iAocoGS+gaXJrKGrEyVXvQItapVH/5UU4Ewo31Ki7mmp7v1HnYhjx4
UpqkiKgNvjGNfxfdjP9nBseCsGBm0pTxrNMGp0HRSWazMAKy08O1l4A8PeMtQLr/lBAbnLqUiIZF
4usfVkFMFMAF14OLDlojz0pKusNezav3VUzoz1OJgZuE54Nn8jP5ZLjafM+EXV9e73QY7MqY474L
TAJ2jvnhazXuHRCr7G1dlOuG2unb9DcIYhf/HupuOP/CTe1lj3DfJsr1b0iBpV67H1jB0T9LANlK
DLEWCpEpzHX3N5Z8b+p7CJoZNWTS5j4Pi3GQXzSApA0EMzu2sGKBCBvO2AmQRmuSROJztfVIYnKo
ArWm7J3gUUWBpU3Oq81gQEwQAVz+gAVEPGFh9pccqoBdP2SF3LM5YtEr6Ur4bV7Bz2FMVGSziByq
rkRPnvrHzgnh1jwbbY7J2bb52Y0CqA0GbGPXQ3VshzUr1r3PXUnaw263jS+hSJTc0Rp4u5KMuuXG
0yj3OMdb7z8/1XjTtqn8E0culWUDPAppIv4eF1LcpaE2icdSDE3GstW5znhRPdDqKLC3qBJtNxEP
Vu/eRdBQOq6xx72CmzYc0vTVKVCVEgpbR8A80vb0u1qV6dKmY7mnFEkdRYTMA+NSWCZ2PLz8IV5A
umxskWg1fHVKpvKITMUC2dQGLBjj0tcd8cGcIG3wlnKov2kxCdUahieXWV547FelI3HUCWXdOp84
QHHDseW3YqktGo8x6qB6g5ESuVGa4xZGmPXdhvSJquMQvTkMO+Y5QaRILZl+Gll/vzwlLzYzxVVL
tGXJ2ywtljDAE9CDxnSe72LwYtM/kTbY+1KXo2hadQ2R0SGhiuobXl+t9eAKq9Fs0CnsUyD4aDwZ
ZkGh0WstapvysJlNxviw0i6hTFIIMxf0Hfh//uDbu3hxadXe0s2E2vNB1NlOgUhUVKbCRUKLd19r
CX053YP5eSGZrf7WhjPGAQvoz333G8EIQzgZKBt2qD8yzfQ/LkyvHOnaSQle92TnS+7wxuDR9ux7
NKvEmz5Xa2KKo2q2p5NKBmed3ObfLwMJVr6YyY2g6maF/e1dUXwg9GvL4hRfxsKxW51BOV06maNe
wnOhgirypsnntqGS5ctNTbPH3U5VavS/lBeLvTHkk1ipo/Hmcng0NXj7C0Bhf1MkGeZDGtnJVoMB
FRh6ejHFwPKqEjYDU9H6MhU7f2s/hEL8J/dAehjg0Q6s7MYCcLStBD4cbSO4iYkokbd841+1fRoY
jf3kf6xlzTI1C094VjudRxLibJscrsz1gQxT2jn3t76BUmSkd2EGaBwPBj6usTTwcX2nzZ3HHjGM
Rekl5/F8gVvm2Gd5/vunQOT/PHg8o0oD0oTlG/ZMlJ4GLX+8eSv0jG+LvN7uxIDHGKBJPddUDLel
DithIdm0szF8R9wmzKlIhl4QOpRolKxTskdrzT99k58VM3ZWjASwiB+CEf65WCIqsoGdJGdS5RDA
lCrorM0P2tPDACSq+04m8sXI9YS5SjU/Zh46H6hwERqL3SzGmEs1ydYdvG3sOScAn8mej2loFcaj
IEglAQEOiaOJtfisO/RYjhZrjIoQoW1mF/P1P47Vuoe4dOf8a8795r5/tohSfUx/rEu5Ie794NgL
fVdxP+bmBr5+QNBBTLOdGCr31tTCzLcahz3gDL2urkdpzMfgZ9W1/qr1Nl9+GvosnRgTCvfQYS8i
Y/Tdz7w6BGMhLp+ceu0G8tkaZZH8yeO1wzbCF9DfFHsUC2ZGWmJu+uPNdvtBTZAr64PmYMGj006Y
UXVGxCmMCTpLP3MeB3U2iL4cTBODqHwyNIby8MTDyGu1qYKoa5e24kJuF8LOBAGoMOce9A+i62kj
J15QQCX4nSrrQWJOsPt5iQcDyzoD81T72/eJqXOapHqsel0c73bJy1/DvTR5YtcU+v2mXnM/IT/W
gfMXnj/Aje54rj9fLHmN4egYl4/z0MTfYrQa6wG4k9zDkExUhdaRYhJsDZ1VYCrYRjdwkzvDAT/p
Pd07l7ZQaRJgt8MfRiKAR5jPuQIEv7wlRL9Rara7twVCLi0f4ZqH2WsTf89LvorFkMbwtJCs216A
Za7Qu7KdixcJvdx2K2HeaRTg6rDNo8zLpd4XUiXChyYfKYUq8nC2y+tL8fPFf768Dcm72C9ax4Id
F2/LepKcyw3Ih7TyJUXsrykJHNzqexbz1GFDflolRJp5bLtNqSEWK1i9CrslefYXcuSNdqd3BkeD
9/AFePHoOAPFODRoId5NGNOz8SezQ7kfGFoadsQg/BlEax3LM40xrSXo+bq3WLI6PmbLY5RAS0At
WH9SSOZSz7+zyq5fMmGU8APKok2QvsFmIdI7Yr0yHw9W9JTVM8GjExkIuVWwgtbmQjJBOzlF7EHZ
EG/QNG4WNur95H/9HzCrZWd41ADRrcV2K2kJIa2mpX4fdkADKcnNxBwRNcpnvq2Xy5k5fE33j6yj
SHpNINfwi4PFtuKllk55n3b+I+LXtbxbIvguygR8dpZ6BC3eLfBnB2kD0uaE+7mRlkwfUcukfxYI
IH+ELJ7aQgqJI6f4A3BxjBWI5DpaTcT6rAHQBCi2mRSewlYiPgq+XJb7jlW0f0o/3wWZ7WmXDIih
sK0E0R/GHM7mQxm1YWDIudS1CHtYEzETOfaXdT3IpeowfsfrLRtFqrLHzJCQLHm4kQPhnE5bMtNE
GyytqCA9IwatxMyaiqqbDSDs09sj/m4/N36jzPBsZH8RWivhe7s4oWO2rDlsVvma3we+j5gVf3GB
v3KzC0yPwmBa9rMH7ZFljZt+D41RTqO3PAYgNsN3UP18pY6cLLMfzGAEOLsS4SULhL5863ZTiER+
Eb4Pl+rlVBvmU5kgZY/7548SgB+XM2RF7N+usD+uxpok3jWGjjvEIXhUdqR0Lc7XZOAEPhhkyUbW
VqD4YDkstwl42vU037zOnPfB3kPgEwNhFKK20cF52iFeMRwcZbJbvt79rlBRKC5VN1Lk9VMEgvzI
2ver89uLMDssy3ZGfDaRMxOZCB4JoVK/9/zOHeMAxHcO0MuJgcVewDzu9xExdHwoSr4wdOfR4IPH
MJ4ZmsTzQ8b7JsgJwyPGEFoy7zHi5KrdiQK6j0gwwDgjEoNzxV7e2Rnjx1oq+qShIkvz2aiqZxK+
Fk5ZtuaHHBalRe/8OHqfw4vZULJyUQ4ADwKgiCOHS+H77D/VSbsfS20q3ulX5K1R1TnCiuqfgW1r
7RgiT5FlS+PEYPKUi6DKyqGq6x7LmXcKMNX7VuBEk8WkSoRQf/PEv70KoYK+vNqt4kt7L0+ju/e7
YUCtqaer9X4bU45jd9p9J0UmC0R+RQuLleLoxf5mKpAxxAMZ5m1AboZxuy+JM6HzxaFfcA6oH/Ls
DCxv7tS55pGJtbBCJzvAHwDC41KdgzDADT15JJILKk2gvmTg5YrykfNpC4wLhgSPOjoX3y/YloSl
GPZsZjmMeN0cHg0Ypzw112+wmHmB1TuL4F0MQ+m8hBrJ6Qu5rfUcgs6VPddTs/wWnJ1E0U3NQQp0
mXdcUA+1kQuD+8315SW+9GQZCZYyQ0Oh7ZzcvL6vSg018BMUAjkMX/3KyfndjsIZ6Bp5fDp2SlTc
i7s+Abd9avmFrEhqLGl7Z8RgpTxgyk4Im8lgl9EJUZY+Lft21b7zxf5LvvpEgfdX5RqNWIe1J9I2
NtBJ8WNecEEF/vHv9c8kE7XV9OCrF4eCyo+WHu5+/ZdOuaSIDuqJrn9pyui8+CeFfmJATNVo0kYE
UyfVIY07xdNaWboRHpXOTFqGxKeRGCxMymG8iXQk1U16I/VZLEYTBfVFStNM1ddJNtidoT/cHuwn
GPmFHiyQZTA3dP69ELqXvbSGlAay7+DvVF8oXHWR7hPX+mxvh0otQpCQ1gDnpiBwYIRsNNf4ybT1
5Nt1SEgu0NpoTsqcj9cA1/urzHBTYNe2ukcv+Kz30hH+PaZ+E1XOMOIWCMmHKf/PUQJXNFL+8x6N
jki64O9Ou9SuKUjvq/2n+wxp3ocd8Sa293yKddFSO0lEZW3uFMgmzp44J4QBwsh/Ic3VArxm7Sf+
UgVp14YtDi3TYWmYJ5irUFgzfwZaCvLM1ndSjGTwU8KhaKMVKiRVNLoPxalSwsY3LvTQHXB4Mf2f
DFgNSnr+kMOvDP/h2O9HTMz31y0ECWRTOz2grywdR8vzJ0ZDjYSiT2n3gYz6uoSlKFK33KVQivt4
yYcxlDoLYtVj/pAFiXHU2F0NylUqxn5G50jevqUQrkB69siaN3EdKMnkLXl6XMMKucZqI+GuPhJL
HY1G3urkQv+5UDX+1+QUoFhM8/flJigyac/HgTFAzHB3NelsK1xSR7jZoR+ObljdL9T0cLoiIrqJ
xcR2LzEAfRxrTjWOmtOFEY7/8nNBo17AYQ3ndjVVSs49fVoJYNC3YBpFL+K2znQTtQWf4Bdka4AM
7XMJ8d2IwfPI+ghEZEZb+8FRSM3eQpPHTFcdsKM0ytuIgjc+hPDLPN+7qjG9QrRswp1lX9Giorh1
Zx3+jxr7OeK2MwC/jyA3fs56/SQqRQGai4N6jrJSGF8LqR9pvBZEvVxFwPU7dqEnKfoqsGipPfvz
/StxeF6uBENGkUDxbg7//W73VVTLi6TIRrype4/G+xQ1SMsdw9hWnqoqy7eYM1HEZF/TXO1DvPrI
dECySAWkELa0q+udpmal5gdRwDCksTPdCdwkroRNaEpfDB2THLXmHt1FsnExVYZoFap15D3+veVF
pT4KNeAV35QehHxGg5x/GP9Brvj4iCMN4CUlatolJKq8m7BhKrDSfeQMFY+gfukdfj6csVUuPeZn
NRXX6GpA5jAzv6caGMeeff98KwOvUJBl2Tn0BD2/AibJgGw/bssgKdZFcbkQx7h7uy77fKVDF5Rz
c5zVtjesO2/pDuttG3qyDZwZl21yAvls16yJ91fqkFPDhkS3GvWXXtcwlkLfElMFWQy4ks5iP0xm
TBq+lfq692M4bZ53p2ecFgrriRgvlyGD+Z6cMm/GL38zpZRJx2B3+YSzyEmNP0pOkL5xKNSWelKz
otJKgwpqM9l44VvSAJjBmE6EUGEq+vEFxfdqsaEMyUexZyhCcrd25IHtNLzeUKR+hNitFp2zvw+k
v6gOP6mcjRogAWVB3QXvT6NXXHvQK1/hofuhnDBDpLcCcUk0o/Td5oUlOZpL3hMDjdBnrMXsp+OJ
rSy2aoApVK7rdcWY6IB5q9ogU9LDUmYXwqeiRPU3KJWSF1Nxx45CNf3811G7PSzQYwC41jhrOXIt
IxrreyA64zWyo4sX9wYoRjGAKwpV7uWBX6fAIbxe2Ry24zPfQl2eineiX24mCRhOZZthb6djTcj9
bZpargpBsiaLswo23fFNl5KzcOOiA9t9F0KPVkBQX4ueeb6Wi+9OxxMsoGdfs3Kv3LuzMXG+MjJj
YcY8laQuDx3M2rXw4pRUlHisLlnwy0LBL9hnGAxEw6SDdj0d7XiSCE0SfsS+nFy65kfiwrr6LMV2
dVHpZeSFh4fJ93MQTU84MQV7g1ZtiwMkelxATTaM4lBTmuU0T/rS8zCddXJBwDdKGktHb3t2wlsH
T8VbRsGn9Ly8xIr0B1UalpK059UsUT413Cb8Bl6ZkDLLVnPEDuC83VWn4aZ9ZCHLtNRhRQrozD+x
6aZYRcvkEQfr5bBJRdVi55DSJibVqIPzTBP6bNOjMoRqkCg0A50LmtXlc57L16dnDBn4hMbE8690
au/kXWsu5sfsVeUeRp0gAGgvYrlTe4ay+iPLkc6rJ5sybK5T9PdiqKxhb8eiUYOO3dh9PehZFFlb
BB4rGtg38PW+CMH/Kzm62vUYD6B+r3ATzBBqtX7rdTWUpCQcjbfC8QdARHZeXhMtCHaTAroyHEVg
qZdU1QNFSl4NPfxmqXnjdyw4xdpxUciAkwATn1vYKZs3ABgv/ca1MhTE6s7ezzc3uPAIr5IKswUV
DPUcU8jHfa+imqhuFKJdn7zouAZHOp7YRua6ywWLT6LOw6vUSYNJRZFkIJnPnrATNr1Lds0Apva3
dYwyafb+DhmAswDGZHsQOZXdB+FbpQAXMbOPt49FBvRuw6WhqM0d33cu4ZEANpGnSnk8YEJt8X0x
mpCBWIUhusQEI6C6v+yO7cTwOHJfFZzBfLzc/inx3pZPJXg6SqX0PdlFvG1nHWobXXoEVwRdiSfS
Tpu+griyLnjKpRZyKnqGD6mClfxVQN2Szitqogi8r1FXQK7XwVBa8su69L3uI96v6FO6/D/fXY9q
RrvdryHLPekWC/0ogA0ATHQO4JkDMoBXC6ZPdkYOyxI0kTOaEjjKlQNtk9eTTu5sw9Am5I//lzmR
GgpXF1pOdN/LTYoT2n2wf2K7KIqo55tLjEwNCapBC8S8SevFDSgOQZodtZn7Ntcqvf49MvNKfeYF
zumFNGwj+/2oTJzVAo3IbqqyZM1A0ueK0MGgZ9dTbH938WXjQxFqvJUz3gcLxKB2dU2rmBN+O8gw
eQ3mS+tSzG1cSD01KR4JsIQImLCT/5TmD+nkxuGX+hv34BYYh/FsJEOiFjK6NE1oYPskH4v1/Kz9
eJEPf6yKoZhY3wwWJuzymX4tnx60mb9rZbQBPWq958G5DtLtq/BDEzJtkSS1k13nOZpL3YWvI5xN
RmDq4BFfVorxnAkhXiucQw0rWd6wLrDSGgyqRueH/5PdUAt5Xctr47BsLpte086C+sf5MjPnO6oH
ABTcIxbjY7pTF63FsMQhaAfBGSqdtcmGlHvD1Y6u8bPUwu1IBrNFGuzQ8sCMymduAgQtwCeYmjC9
VDyQSpJ5UoWHAQ/SQIYBPKuOn5nKMYZjMM536RXeYfgL7b9l32jZGXjB+o1Y1BOw496EO0P5Yrj9
I6YYlNs90rLg8ycYOyoV88D9UWxM5+63ldPRG3fJ6oOzIlwQjBLBv8JEqMyuDx31ueQLhYp6J1Ih
EjxFUePWscZ8Tzal/uf91VjiTepaYO1qM8RpcB2+/ujncB9VNzy0TJus8tnVgdVhA24E+ylhuknG
rebo1hcx+XRFwpwS6cBDFq1MGcPURQXuIv7oItYd0kl7z0WA7dVWx06/0qh5LEXHNg2SBMXPjXbU
/tUI/jPTd1AUZX2Xe4Oq2VnAlvTp9Ktop3PxZmCbBy+0YwIMgu5tEPRoF3xmDJ+N1sseuiZpCkCH
yCj4A9LSp8ihqElg54sq2oM6UWAAHqBnyJ930M5dOxjYR/+VvYlHbBmrEuU5I18HpisI8fxhx+6m
YeaVl/cZORqXXxHV+rDYq6zaSrBa+KC+ovbaND9eb6kU/3IoXpVcY9Rv+xGF2XNJaZgtSc4vt0kL
OUNoa7lws0nINf1Y7Ty6bvKv02h87xwhsfkld+7bcJGGyQKOZYEzovksyGgVYL0wkOjvPEg3N/MV
CO+a71XaUty3AuE6YNIdmegQpg0eerWyqURMnLSkkHh/TK0olKZj+KHhoSxZb6zM1udeq7N8nQyu
kvkr/KGwVgjdjSqSCrWusqYpxvIVaNEJds1Cya7cMyx+RMpDRcC7tK994pQrx4J3H098OiQKAXXJ
H5Sxr++7lbzAYv5Usuyx5JtgoRAkLwMceIE6cEOVe0N5tfspxzwOC2Be1k1diwIjwSVk20x/mUSl
71JYywIk3h/bh0Z4fOPofMZu6mGyyRP+4YqM8i1RTWnVwDK4FpyTRRYIvyIBTjYTj3B2cTknNTjT
GL2L3gBXKOwE7rqTBh/PQ7NxcM7grwOyDEam8lV3GFS97DsSQ9zkKQm2lqN8/scLftSnk6yM/eYF
NLtVHPspcqs2z15zFdGJPDxsRlmp9DzR3XCV+P+IVQuTK6gAPsL873npiLxCAdYRPBNWZi4OfwMy
BbGv3oHpoGiElgdtEYEWDLvMZl63sBlHKmnGrqlwZ3OJY60cihnn9PdDgURYX2G8QYKi9H/hbc0h
6j5yDNEvx7NB/kKKKjE9laXeHEGHMXawDdJ5odz2MUWFbRQQNp64FjO2OuwZqmvIOauBsVZyKwNx
JoRV/TavJgkhhl/fxHXPKBuWNQ7PFWeI4j7na8mzUIPqS/pkPn8Y+Z6MEaNy5wLm1O2l1pmEx8CI
zxvixV306RYOwzNbtC9CgRwUQvxs8YQ2cAMqOKaA4eR4wp4zilTtqaPy5noCYUowmDM2tUJKRLpL
+SY56jCJPrNuKahjx4JdeREf1BLA9CKC6l2OnJVe7R8nYl1VR60N3kHu3OlWwar9g3HJSXae02NW
FcR2bWcbo35Vs2Uyo+P/Xr+K8OZ7VLC8yok5LSxijIqwM/HzKXvMlDeSGEpff2Bx+HxuvbQoMf5v
rdnlxxMgBz2RAaQdHygaw83pAli9Z/HCESCOr82qhXrRB1TqXPoIN4e6XNew1sy0R9ReBSfaQxBp
zeDrBrfIpiuqX+cGK0fRvXvM3QNMSCidrF5XjcKSNGfhUDrLLawV/CR6exChBMSm4ta871U/aeg0
eVxBLLennLJXnOlgh4xVlxKG/OagnK3tD5WICSVqK1SFCWuxRagXj3BxPSu2yaP0sLj6PYup01zz
nl1SWs7LjeoxwSc3oCuJtuRfVt+1MsxmVOhpbaPY/0JyHV/lVggsD7jqToC9b4gfe5GvkbAMaCoI
aPSY/yHfRgaBdpEY42Lb18Iifc1fbKqj5wnTh9JtY2e7xKI3Bfcf6rjChVeK5GBj/+NnNaNqIGVU
Z63A0CUEgJu8ypzUghw2JUUYj98la5c95jj1ICyxVzwNozQYyY8EQDe0lVSreIAKh0kutZXWfHQp
Z9VpLQznvZvPtbDVYmyX3pYgoKLTeD/msrcZFrpacGRW6CnT5ai6lm7ZTUzU7nuV/Ko/i4Ifzrf6
Pw6WfcM5kwmZY3KE5Uf2v2f+bPoKhyOZNSEEx2vM9MUViHl3pJO5HqHtZ6g6t0RCJZ5jSxRoMOO0
eD879WfWlMcFdL/SK7DXv2h++OgfMDOOiB/Lin7+9wHWkl0cRNZLkcbH3xOSVvFWu3QsA4Gzzcv4
yvb7OI0iPd/B5zNQ+qZXQSC3bnQanHrwpxubda7d2wU2hZxbD9EZfTZARBLcSjLENrR8FJSvMrZA
oTQqXo5JJ5oVLX0hk6kl91ULflJGuepUAgMGZctg1sY6w6Hy8P32RxuGy7SlZ5+N3q+tb14yjC7z
g44ll4XujjN4oWbnOg+JUC0mmEmpIRjxrmNWjN8wxxLSRhhVk9sr8ga1PrbQ/8O7WmmUxI4NpOk8
G+9RKUlfSweAMA4HLjjfn+ASsRthTsYPhobV2m+DaQj7JNLVijBfEd99UhEDIrQQJWEJ5eausMcN
+A48XOSRVGo7MW27Q3eTlAijNkY1wa6DwlBeDQveAUuV/M8gsL213FdV5MVh/8cJzDGC8bzDpGm+
rcht1R8qxCkEeUc5in8fmVjV4zzH7W9hSz3wJxNkDng5w7Pi4951T0/dinuREUQ5B9+/hOz2qUpi
6mwe9xI/6v/i25DeboKHDcjxklT3Nq5CTjnAqNS4UBUKDqfpyqgJLXeBte2VdoGfPZib9BDO+XMv
7tEv8g2iL7WT4du7WmDG4em31dg13yfJM37HiGaESFO6hYyxabKFVBXtgOdIqlkbi6Q7zEDIkdJV
xVZNvpREFY2d5YPToVoo/tI6DJ05RKK0XXP0ys1FpNUo1uuKWtQwBFwi69HDWzbmKMcZrGRXiJPd
k0t3WaCxqpQFAQ/l7nLtoOA38NrG6xr4Hnn4iKzhItdCqE30v2OFvSIFLxI0lA0vxMuxPXyTaidl
a+zZ/CLdNutjvtJEYUd8RSI0zZT1251HMmjJPL+2n3S4P545nyBOeHsgy1RfxkOEokVPbSq9igsf
p/vL8KoT73GbTJjrhR07fxj0kIkVlHkSvD73ZEDMoDHvjnZXfF3ozgiIjpw6AXra2IyS1hXs1iHd
MTMd2Neu9nzBHBVPMuz3336XM5c+FJyh8fbRmi+l/CVCyi4Y7V+uezZMuB+DsoQr2Rt8fQrfX6eK
4V+yXt/P7gdJQmNldAZkNvrpddtxfsa/jfPDhcPBQ4kKZeICIGWGKDSjOt590OjVv/U/TjG/TClR
29FFPXdT8lXzL5H/LAFgefvYms8y+YDPum0GBZ/DcitWNp8NA/j2Kh9+HbroWr6W46UkVr38QxM2
KAVkW9/c1SNrCFW9RLYXNm3Ktbg7C0a+iwGKJBMRBrwRjSl7zP4FZwfi5BL4ixhiwKU8uf2AVq8c
VaSJckU3WaLO3KHkgkU+hZHWVlGQSpebcH9FLjAMLsltbS9DeQqagbLpwZnJTW4P/j0w6OfnA6BT
RjKHqKxsqtFgQd0JIzQcAbJ40b8o10Cf/G6aPYZs1Old1zrw1E23ueJtKilOSc7ZF2Vkz/osUa2p
empjHwfSTk8aaGi/Vzp4a+0gM/TcOkqyOODcWND3duRuqTP1V6sFHvoFlBHQIoFq4TIC33EIlJ1J
umD6ruqOjkEiAGDeXzsy30ZSCWyTzYsq9sdIT6pbhEkA7/1/4A1C5AfU0Hmr+rFgOT26ZPOWC0zo
L2quuv1nBA8cOdejKbLXPbmAkMBTd4j8N2W5E/rQ2vk0WHz5+1Q8r3o0zZr1umKImbPG5uHtrlOF
jrcHaBEI+TnXNrHDkvFqyO4DehUmw3DmJYl0vzFSRAhAnvj95qm6ySF9Q6oezwDpUu1pwpv51YiB
ZO+DQJFIFnfQ60RUayjwAA2CmusX7OOO2EN4O1+ghZjLWNYMWhJMaKiNLiSZ3tglbxUY0pjHj0aY
8jlvdh7tCQG4bpiZEg8jM3rbeCSe6nWzpvnXGlvcuEpQoi0J0hgNQxPvlfFblwbv2WbpawEZmQ7u
tP5lAM1jmOn4oB6V58yWKMr6vcXHjiPOdNaAMIrwbI/mIn0Ykr5t9KtOE1l6cPk32jtzTqkscvnU
e7xCrvKru5/G+mvSaZcm1JArCrXnyCNAKh2oEH7663k3qfJA2rIhm9tyxFnXUavtIHiTITJZYJWP
4bEinYgaVIP6sdXktQZkEHt53Utvho59oO2LaGIFplEVm+aQ2gIA0SLgW17OjKtutxgRQHV+86iM
OrEu+iqb+61nA5R9xP14ILSY02+Ji97t4/QXCRtSIXYm+BURNHz2w9gYc78y0vLEeAf8s9angH5Y
BkxMO4mbyUocw3SZEgiXe5bJ0HuQDF9VeAEiGdaP1wq7IiLJxlOjvUsjpaDv+UJgI8HY/aRxjm0/
8D+FkLUTUJYNA9F0UHPzxcxze68RML1OK5/Lm/H6cpDlnqGZnQOndrMWuByFM/UXk3y05gfF+UBX
KLTXwoWjpCvuQ+ACh4fYz+aVAqHMCW32kDRq4AVuJ6VC4V58CIOguT4wDNjFZU6O+fkZ1pGd0r2R
/wZr7yo0Pk6uNvuzAxUXsCNfYjoLrHOELO10EzW0XbUZUWsg6mvv0J6lJFr9bwGpFANy4oe2OoDe
KUEDc1qmijfALpt86OGN2Grokdz8DMCEUlB01twsC8C9/X9KuRPCC0W6pmcpveEImXwEGmbf7wqJ
+6cGaGlClY2QjEd/QyQ9fhPyCBVAb5b1SW0ihJypWnqcYhVRQIqT05VwMzIQj8mk3giujHQDMt5j
GwacHYGOprfeynCwkqCUsrvx94PwKmV3N10XpkKZPEW9BQ2hJ50E5yX6u1hjhf1dKX6/5N/Wji/k
CVl5NbZ9Nfsp+HM9JIB1SYQUL7HovY+NG0BI2NaojNCaGDVROAaMJwVhlnPBSY7RGnoYhetPCiNE
AnNwoZW/J+PLA3GL2fqaOBP2Jh8+YFyweLS4alMhvIKxdMkCQjU62Yic+guPy9yLJRWsGVYK9rvZ
xj11r5iMXMSmVmMElEEzoW6H4Fo9b91YglBCjwlDyeCxwyQqy3wwXQrB514TRzvxJ9P6ZFg0PqVl
72rBce9d9QYKfnc8wvpZfh23JHjn9M75XWACyAD+rAaOrJdyK9HZZ4556PX1Ss1rJCbMtjQPTXCu
BbN3hJIRrVmFdKEUSrWZGASI0H9ewcOHZnyxSBWMxd1R+a/qSh6idq9BStrrmpSP/x1s+lek+BbY
l54lXEfBKW7z+3lW4V+iu2PygZ5oD2TQXa7QIJWJiSWlggA+EeYwvxRlov6e9F91AMH2MfQRJmBK
7clm8m/xmPLcZVDCceGSUysvPgiUkZ92TafAbn5ci/mz+1yg4FYnN2J/+QEzVxAaO1rJ1ybRvCq9
ohrVfCnZaJB/CgjiLQ03OdaQP5A2iuao75BzHKn0RsS8lHY53amYxFXlk19os3TVx+ewQWG60H4y
74wIF5K4xg4ju+ioxWADE4W0HVuly5AFI7ffZb6MJviDgjWghrSeFnCHYhRkJ4vSO5c/G/d6uLYb
V0Dnqq0GrTAU1h1NqG2M1oH6xuxU7nVsmDgfR49s0FBtSZIHLcHISafXl3G1jf3Rw6U19ug40Pck
hSA/7OwH3/bAG1ETRO2puUjtKKQRUAepDu2eAkdghunhz/cGfYZnL+HEdRehj9bSE97Bo/Lza7Tu
0Puapi1gootqK3AfojsGPpf2DcBFAVInaSb/j968jxlbthriFCACHjZI8xNKogGAXDVxL8tX0hSp
Vxcmf0iw/ieobhgEKTyavUUjvoOmnSpofDtAqmCN/FuuS47TIJDKh7dQI6URhdO0/CHUK3jPrzsJ
RDEFNKDeGnM2JrCMKJHrjwXO1nEKRjuoRfZjQeaM9KafiCSESZtJo/+bscYTjYjFoMWpx9qkArjQ
6Jb3nmxDh0Xp1Wf5zokyyu/tXnOh1kog1HfwCD1nkRqsXUmo3X6AAtLs/a9iSZSJ5B7v0JtTxKx/
MWG0HvSjVMrTax5iIqdAjaKz3JdUZ9CMrADsEw3H7+kBQKxvxAiSOa3xJwcgDz4Wxj6y7pz9bJ26
TWwGFpBMDFbhf/R2PDoY9IINu/+DTt6dblX5Jw5mfu4CnEOXReu75VXqofRBFvhBSx0dd35VF4bP
pvOdwuCnmIdtCzFYxRDExQeo8PPoHf2Vry66a8Qh6/a31yaPwyD+993OtNHSxpfHQcnJAC/hCH5D
sAojn3Gi9fjlVgydS9I1p2s2nQkvrIHKtChCr1HHES3CWF3gxrHd0taVfW+KHqClfFpzUx3prtEA
TAX0rWjgBiLItZb2DSiUOZRptjY7owQtZvcBInGZP7SLP3XBer/CYqMGmJVuV/GHm6bRdia8jCum
d1K65MLKGsLkCgAptBbUeQjHmCbGFi0qYozqr4Fp7i+jS29u5/DvYQFzEVpHnTcuWIA1B2t6qpp+
1Ueg0SJWjz5nA2/wh6ZQwDAULd2zCqsk2dw0fybGwF/SVn59JcBzIpG+Lp07FudMb4xcJwz/+yUO
h2K5WBx3tNNHcf/qKHzpbw5wlT9/eO3TMsEriANQyvkvy3ID/uQ6QCW1mMnhkcv6e3Lat5KI1Zhq
15akrGB+B51F4AaabqZOlhQiSVMGO5oqg2aSV+V/UaneRS63H4ovINxrTzPP0b63nzZEaeCuPFSd
3MX3GskowvCxoyHW4MjUdn7RdHVp19S6NeVVGYPGfEv3trMntVOaZ+dqmFZKQSwtxlxkc3mR95z6
Y7F4LXIC4jQ+gtO1S5ikhCXcaDtTnXHXiYaBZy7U11+cFtefZv2qMf6uTgz9ZMNc+eqU8kMTP9BV
upvPRNtpOUwcNuuaWNoLZvB5HBfiYRuMigPDkSx0btg2RY5tf3d720Dgs2pQHGAxjVCQrr439aaG
+UXBaeVsEPK/gadFaeRnj4FTwi3dMTZwoIklci2Y7Y2dSREHmY+tH5T/Y4Wa6EhhX+UmXlgc4aBs
BpfxDFmHohr/5fLHh/bM/PfVoemwkMOJnpfgsHCTpqKHz8EP26cBb+4seom3i6d4CyAl0uI2ePdM
S3OOyoJN35lf0hUarcER2A1iE20fiDw6GTttPODbhyub+hYZtq7omzcZNFbO1uwr4shWerI04uCS
fvdtGiwBy9hFbtjtrWLypziqydMnIANaFw1xdSfLndvdmyD6aNVdErfmP6Bhe468THrRJMhv09mp
TbiCUb1Lo928FUifLcNR/Z6hwEcTsMMw86WwBmpoSTvI7ZluqVU630EhpqbxC8qaBsVllP7T6LmG
c+8+Tn2nHkJSrksZ/ffrMU8F96cRrJ120MX/jf0P65zLC++A+lxWhW7kU036XQWubNGjdHg8588W
HT4NS6K+XP39q/i+e/d5ywXQpM9NbG7sDMDjWJneiOvxkGDi2fi4uNVElwkpABqGVSCfqFDdad2G
xhiD9Kix3YYRR5zx7IByJrJGC9EhytaOpVU+/ENgb3cq6EDvovd4RceGa1NiWuU8jkdpQQSJZcSK
i9dQii+14uLKclXLaHzV7gy6+rHXLS/khzPxXNyFLGUDM35wgvch2KH2MUqWwa/Xm261qYN3TWLl
hRT4xEa/nQap59PT1Jhr0wHCdUJKC12xIzlMNkipdvQZQtrexjC7QL6ox9P9QPSO5YdxtBKy74zw
B3LD2yNkP8ppKfOc+Wzbu9rSZshFCKrWY2NRd1KsH7V+x1+XpJffKfDqD9R1hQszBk/pjLUC9NQF
VUgHw+7gqZ/xDDhQPr2C5s3xSF/LjtVYBjPYw4DX32j74hLFI8Wl9FNUhbX2XpY5ifFpORmalSkD
lE5q+unrnVDZLq46vJrtqhCCH8rB+HaadQMItK+EezKSRzXdmhUqUwKLc66o87+LmVFaK1EDBLC+
7gP/+K+FLIypY4L2KNYrc81tib/+/pQjV/HQBmdRvdM8kHSKpejmRtHTxZbJaCzKrHhWKDz8pPet
eP9eAG70fM8MxczRwuKdsdITopJqaZ0Nk3nvlAoGksXaZh02QZC5NP34J+hBwZsm1CPhA1xvxrdr
Z0vw6cM+Fzyh7G85q4nOIRYJPUFgF1TY4enqMSvXoY/9qKQ65G3eLcdS/08IFsPapj9g/aQqhQVG
B+TWGlfBTwUoCkBbjcKKkEjpTsosJ5A4oHZPYczdG6kSYQGfruWRmIVn7LqN8buCwG0/1sTZEx9w
BGNngsQPXX1ho97i/bqK7dqnkNL6O2aNYqC3V4/A9jaP9WiiBpr3KGh3c+ITAGB+sCAlfRZSXpA7
Toyxgcq4yk5xTLJ7M29uTWc4SuWmQl/gCyWUc2QD8MVJaPcy/uL3elzVk/U4MddCcjVUGx17pP7L
ldBlSXKQOpYEOuyuPQhwJrcn6+rPK1kskaG2YPlWy5hlbJrwCskx/tCLfidRsE+46cYE6SjPxaSI
z1ooScHIFD8djghZBhqAq9joZoN1JnbJ1z5EyYidokq2DQmb7lth4whj+C5VMEvQySHOmBaHxubX
VvTGCNU4KGZgmejnUL7mT6lu75JTWtYA/mjYsQgkDxWJIhZmVWl7uZ9ETjyAniKzlAMftIc+5dyo
hMW5JLpiQbSFPfssFghm+eXeeYfy3B5xasrE4I9mVxQaYjpmtN8SriehJVWKUnNs2i++4qO0mAQg
eB9AMcOJnKCRTkmczHFiNfrM17Fxe5lIe/qTTfTcAWv+T4+3Sfo4UGZ42T0cxfJ+psCW5CsUR2Ew
jX5rM5ZfuchiSLkB8ieivOOnY90lqvej9gamJtXDYHIhads+oHuZr/OL5hpAf52Um9XfPz7EwdDg
ndKF9M5oMfo0x4yjSWyZbRQElS8E6KiYDomOV6r0VfQl0i+lYNv53yEtu8zSTaHICrKEWJ2W3gJI
+AAYzHeJzFnjQ2lsdU6HLV8V8XOo6kx+DKjo51N0Mw5AbRe2iMHPY2mZtb3Bkg37EXUyTCGffeQv
DIO9ft0ShwgafuwEzYW37RszhUlA229DD/E/NPh7xCH16R/9pz4YTDkmimqHIwt/q0rUzEekskNK
t4W4TJB7jTi9KPtDI6TPvnV9nqDuXKAE2MpDGWKGVHY9twKRmNmjxOkc0MBc6cjwGfNg2Qev+5g2
Mgg3P1e6YSw2ZfSU2vJq5L7juofoY+dK8e04SpRGBKLNF4FX7MzjEdmbjsg5qN76CWzLA152xXRC
5iorvCcHKVJNAES4fIWmJcMY2emwMzscr7jCEw1aUB8e1i492zInxoNY/zz9GV6MVYCDeLhgO1yg
tXF7qGM6w8B9vJCg+WlmTuZ+JNlrI5D6YhFSAcRONzIlv5aD0CFzBGoh2WbGEAVAntdVs8eMzM/F
d+QTYnzsb+QTHmLyrw8xHGkrLAdT44E/BcmbI2+RuJUrtt0ZlAPcj8mipC4T5A+M7cY7fZOuCsna
xxEkKcnaqZ/kPy5Rr8Rkqn/QT3rks+Kejv824lTkF+3I6GoJbtpZtJMC2vdm1z958aXtzE0Flkx7
L1J/JE+nq1JPaepdQCKFUR9Fg52FXL1Xyl4+azX+9PcS2YSV3iRS7NjRKlrDW+RZjt/bEX1sB1BE
hu9+uyyAcfN15NQ0zIsWsrmLJiBRvDU1cmaD+mTo5IRQenpTepD9CTqCvZ3GyjcY4WmNrbL5hWZ0
HO4f0VdTee8v8jZ3mgN966W6cGm4qAYtBIniyBnOD7ZyDG/0uGrFF5vK9cTHni2iXk4tu3D0/1ND
0/1DEl+dFg6EdgCZ4K4jdfvUoOF3KpamvEWwhfeqZlt3SPwPWhW7dnyNppi97f5xJySlSlX0jEIo
IjhBRK5ZZypl1+guO7dsmFf9QK03nMzMjVQr9Zkud54lrMkuKoT8XCMTCtlxL3nwNd0T2ptoyw04
9Y60eVDmUH4FxdJ44I0JUhF+rIAZ5pOjPp1V8PllkCaJKQ6TQU220W1efDuCdEWxSsIH8W4+HYW+
imNwUw4/jsLasl0iHTosKDRKigBF1Eg7XNwtADziV7lubApVFE4uiPZita9qhxN0b4PD+Vr1FduO
3m+x5S7nHvaZxi5G928VLIs3OWm5TrdoCUn6CIWw6CGPWX7gKjxZ4wIjRD3Y4MRp35x28DQ9a98D
fFx+pNUz646nzyRfn2dzNBheC2ULBlTT4kZcuepbLUqL1EiwxZYaZ+ovUn8KZcmJAGk9L+wrY4wB
WqJn25WFyi+0E01FsvFHgkXtu6GhJbPPXgrgzu6rsn272hO+e2PpPyWbRbsBh0uP3sr33XQ2gA4K
+G99OBKSJt6//icPiZdHdlvrvVHHdvO1sLiqaQmw1LR1Z+j0iO8OlVE+quC9CgcFqObpQq+ZlSyc
/fiZobM1Dw9e1G23G0JtSsTteHNDOrNoj06qcTXZsi5qeqnESPhzkkfNWDt041734LIk8GVCwxl6
6MzCiQXz7hCn8cPyyfpYvTm23/BdBrUjK+aFJwZ/1HJz11/aLF5sGl0PowPEHAp+BU3Ox/1rgp9j
Chlv2EWw4+saw4XShUfOnND5VPyzsD1CEBKkGkj7aWACnKgEQCiDLR0otkCjKr0IZVYIrf3T7vFd
qheNjPKX8Ud06ba6FC8Rr09L9oZSSKN4YhmibjijYpHtp7Yw8L0OSV0up7X1z+TRZKpu+ow9iH0G
aaGe6voETLfOkAWXvy52i+BDvIwzSmXvamBWloM4/1Oyk7zU1zOYpg6HAEFWmmnOjpHV4cnhs5JX
kYaNVpPxJBA6MEWMDf4K7XgJm7VAU9kfeXcYhdvmY9Z2d9MEPT4uct4GGtTH7pz6xwTUcDSgNnqG
ZAOx36H1z8f7zongINhvFEcGGIwNmUZez3YRShRRtlWB+cotxhpu3ARLrnqQGXkWAVQTgUMjdq5F
7/duk9wv2BscGKXE+Fkf6Tk3WTUoOYSSYbeuFcxBWc+qx/vHmjYM11Zk9tjz2mXjstiW+Q4k4X9T
NDhaV0nDVc5L3gyfBzGcD5iaA7gbc98Y05WCFR9npIF6KZKGkzzdDSwt26GsDmFbspRYnAwt16rk
PQE9AhQch8Kx3kSFRDxjQyUhaZu9trPIZAF28cxYtHv5TkPPUuW4JlgTG6M7PpxRB99uSn2vx2zK
knS0PkgbLCPiYCVZMHPvxSs2UrFFdy2K17IszwD4yzpVD5sk+VfR93EjPUbzYSz7lmU+utez0HJn
uiXEthHCJhTN2WVhdvwF6Y7sF6PaDbFkL5VuwwflCRvnpUjbA1bLWauCnhsVO/WzxIdvVh8fk2AI
1zLlx8f7IOXZkDI2m38YRL9yBNHO2VWS4QgDGsj1Er4p5ouMKD/favs12oaLzGdJ8sMMYdGD1wHP
8Tq+5vCAysb9ggOuoKFGbEsHz+6uUtEsGg6/+TFupHKiDJ5VRS8SU08zwuxP5Yn5G+f49ebEjXzj
/BBc/GzvVHWKjok8xoYNegyHKyOkipe++36MGlfFD1AUh8yXHtz1RyFlVB9V1v0mtsmFSI9njY8P
k5kSvxYJdjeqC4HIBlSN6SoCUyC64ModcdShPTBUxa46OPx+DoFI587XVJhNRk2kHQKsgYXbJJQI
cb8oe6atFmgyMmUaHW9TBgW9PfkO3BwzGIidYMjLULimQXcYCPFi801Z1C6+48oB3N+/h3fgdGgS
V2BbkuTBsMHoEs0LKosaZnnBsMNPgH1egzKg4JkCZCbAANWZxjapuBNZRhltzE8zfv0FQXGS04bC
sbcQo/WokEwyX0MzSk1SIboOaS57cn+fo9CCdluCLL42Zn7qhskcF0qwEkEg1PkbFkFeBuWvxSXB
yhCdYDGb8m3VOd//0oG2L64PwPz7e8UbTT246lXq12HG27c1rpgcGT0nyEkLDJuzUvpB/kCGvEkK
cK4Uo9jsxpca8ZJYRKeLyouuGlz3gsoLaxKCyqdzbSftXFafTzB6c3fSQFl/Q6V83xl5Z2L2EwUu
kbJ7pdNPa1Q540KQFTEYAUWQ+OE+hIy/8eV6rbubGKbtDIs4ouR81qqpq+CcfpCBmePp/sXqoGha
7x2ey5vunWlhF9ilQk/Y5bB9kV9ViTujIglKY9EXPAW4iG6V0/1rvuivwciEmm0SfWXYz3acw0Do
hWIKBXZ9mqUGgZ9KQXVGeQYAUT0zz0vkLY18GJD4VRMuCGg8Iz3Igug7VwTwrqp0P4LhZSvQ3Usi
Oy0xa5LtMcHLpCDq3SKIJNYKUVe4xzMZh9Lv12/VzZeaPCvvqDhwbOW2c1LcVO2poBezjIWF+/dr
S/6DpBrfsYAbNmM+CKUX1Fppbjb9b9m4XH1y4X7uwQ+IgHBmHWJaSqdlRA4k5QdQbLpiUqjy5Y0b
4Ln+Bprf8th/AtnwkUkLSVNCuO3AOGnanqIKgbUMg1QMTL5tKMgxgRG7qXwgbbYKMI9yvUAduiWU
4aKI1DlCBvrIgj82PfYl/CSWdJ9G1YHbv4WliYsvaccoNVagGPxZGbIptHAUAWc4QEIlbUmkzovA
1sTQmhEtmdcHB5x6EDxFbpGFzvWi0IkZ5B57XIUmvqccu4C9YhNVPMfDlaB3H1AmrpFmfYWCDBt/
QktiTlBiJZHwvhbvNTzdtCD2TyQ4LmY++e0u7UqBtpZE7Rc6fDXRzW7FXSkSmEVxRBn9tw3GbIr8
oskZyGfDTGivQwY8ze/bW0Qgng/KNATXDRKWPQK+DLu8fQTNlVMSLqS0n0ep96HbJvz67Caie0/v
Q7cJesxCPq5ja/KfHmWuy3U8iirryOnSwpr5C1lnS4NKeVvb7+liC+NzNWt3u4s7uxWb5PWChGuK
qK0WRM+PtdhuCtGVQl+xax177TEYIK+PYGcd8wN7LN4NorMUPhUYOath9Bmh14x1AVmXt/6g422X
x2DvNfGlFtgGex0jPx2vVOUugTfjvHlhrTHaAQWKnqaAdtFQi9h92QbFUpp+yVdDrW5PLUBQPjdo
LNhLuaGXCKsXzB64L/jADFyvMPjQvNTkCDd4LB7o9HIw29BBLDG9q6LKxwADMCUMsddLweQCY/Fi
oADMBucH3nMHBRTU9KcK3SH0mBJsSP/i1h+Fa/NTGNZu0oEz+8ja5bRMwZPdGEybqvADB8HijfvS
ptKLv6Zgek5LAkr/HMSJMAgyCFbXpJ2aEDv0NyIGLChUdJP+Icr6hHuPm6SDis9j3izOS0VlNSZr
9IsxoGEvY7gN0THCzBMrmoqs3smDYHAp3rdv50B1W1qh7ckf+p2d7LInGWBP8gPQbuwM1yeLf6Pb
ahJnF/hUtUNC9+BIs//u79AaF/seG+UWZn3SPr5YUYYfiwXPROgfQHCQ23s7oWV97vRpDfKYjMvx
7Tpn3zi5XI1fisUNsOVvcPdEZN4h8d0f+TIYC9XTTG8Ryvf2h/12ntyWrJB8160JlbgTO4MXjzyj
l2Z54WZw62kZ7D0lx10c62QSsOjp/rrMEhdtBIveWvd7IfQOQFAIbxFpg4EuErAioSF6y31Zlkmi
Pj+g0q4helegrDkFmH4m0WxTPjYc/IVKbxoRp6wHmJe37q1BV5xSKdTxP72CST3uo8CO0icNmcBi
0w4tikR+64y5gt79wfc2etLdfEmwZjr7Y12rzwQI4/HxFaGcw9U3coeiYC2pn2YKsN0Giit3ULst
jKBujC9yKM3bHqJdDW+Kgahght+VN1ANJ8sJbQxRBtqNdNhzDx28+bo/jnj5N78t4XMw0Kw8ooyx
Otb7v+5NkVs75RsDUbmH+Pe9bdy9bfDrGLoLN/UBvgdrDki8qtF/U9VZo261+eJumymIxtk453HS
AjclGabTwm626G/TWlqOfTxg9lXt9XS2QdwXnnoxklFKZNU9LTHCg4NrnFW6oRIMxuJd0+SS8iya
Q0JLkjySMZajERPTBMItUjuXhC9A/DFAgQhArBkg0Y2uRAQUyNja6mjHokv0SDbsPlZEhnepdhAW
RpQYIfpE3s9Evu4cXEdbn7j2U6yrCxlqUx9HwUuYl6v6Z9t5a+C7qC4flVejw5BWSCM5MGNrFeZX
oK1eR/V+MhSOSX0h9FcFWDzB4pEgRpfOEiHGXVa6G6n2j7aG2CY+91/bGp99T4mYlJXcy2Q+5bQU
lHg4hT9TxTZxOP/+G5d3uMsn6LZREN+vIFmfNUku99t4gwtk0C1/hhg6vYpUogo5gigeyt1+oCXo
Wr7dSqhUWvXTYp/VfO+S0+6w3KIxg+nLpRdmQMGo0ZgJ/wIj/Z6dwdAcxSr1SGUqajUXK42N+BO6
y3b+Ura8JroA/DFlqavioXxbIRFAO+CFKfZfu+YR+VDuCm35AxGxgdPbgJipT4K5HG1vHThMqTv9
yADiS/pK/OVjaFvTJQY6WI29f3mgiOiB7UzZ/r31brP2sRrlWz8oehSKztx9w4cJAygWme/pWLs8
346Mwsm0R8SPCKfWJHKC9fQTJk+1gnPMThh/JvetrXCmqy05Hzyg4wEjvKbgXOpkBbCnEkOd3qFS
3Q65pFmP4jUW7zvIP9e5HT3pg43ZzguWajsE38/nqATRqRr4xYNh+8vECql22facmn3UABJETRRs
b5GknQOSiCDYiVNBsQc51rlZ/1dmVj6pacPraAJ232GXfh3sCHB9JmB8hbJYu2cGKd6hD9acX+yh
IkMQMFDhuUa/RYrjzfhXnhN0v+lljLgW3D1QsHeJXmynjnMntRvBmBn+J5IxfwZgfC86BM0dLaE8
JVwHLwYd/nPUp2o62bZzKAZcUZLRGcso/o1Ea8mWHRLu6wVCxiW4nFGO4kVs1QM/GIkn/jNUXUmE
iaPRJ6+GB2ipGNvvwWV/b6ZS+PVM7Yujuj7w2j7GlcDcfD00OxlKn2d42jOfOoHIgjlJpkToS3EV
LyK36ixjGXF4fFjYnInWDX/gksppzyt8x103/lh1g+EA2VPwlU4kZX6mA37uUWnp7vtuSSDlxzOM
iVMneFElA7rWX2n6+Bgq6uVmfrkmv/Tplq03gPsYd7YEGn0E09so67q9VAMnPO9RRq9qetcoMfUw
lBX+APbLXQovwozGieSEncB0fQqsHf5TKPlav6db/+99SapRhfmoN2hEbNtgSgaef6c9joxR/pQv
uNvlXt5o1TEhITzAobTpfwIET+PIS2utWWlVKFbbLSORGszlmuSge8L4w0ZfkDk5dXagArlytT5X
P2ISDOs00psXikNpHaus9LvTECV8872qplDQSs/+dKxZLurTpWlq32TMz6W9MoOT0yIp4kD7hdCW
ICOrIRdZhNTDDwpfKkxg3UFaE8/tKtCePq5MzT8arxw5tLrNNRF9d5JUJktrwU5n1VdSE4wsvryA
y7Pv8B8LphuylyL2rZPoMiXO1RtSWXVwzn09sss8VuTCTKlOYV10D8KG5iNOy9iy+zj4aY/U9CH5
p/dCW1pICsi8hl4wyd95zFBxm7dsqWiuoPKiLClk5yKkI93IH4dndngbHVWGe7AmvTLRxEITzuzY
uQO8W8eHq4+xbgJ6Rc/Vpx8dPs/cwAW88E0aFnJOAFAkXQcwOPUSGYqoH/QP/iwADOkUnk4PAijo
jFRWuqj9gu6+shbzmLfb8Qje8mbc8bnw2qHd1edPDsn45MJQQKpePMF1VM4Dw/mIiC1NdhNqBRVQ
5TSSZ8jyK2gGq+SaQCsLsANAVz2t2HOz/nLIxQBRruHBLrgQd2EhBzvqRQtYn7TnGpt2UK+Og2K/
XZowh6vtAsH2t8/PIpbuVSv4CV2T9gCGUESJa6+T/Lb7ZPKdGd4139mnV1yRcgB6Jt4Fs0utf48b
kDXXXURM/OoWUtJsRsJWk/ICEAnG/ii5e+9p9Hf7BMAGV4cBX0h5YuscKgQVvrItdp2gbd+5RlGn
+/cUckNzzYqBDNMMzJHXSQlq4EqtbvKoY4izeeaOHDxRRO0YmpmJn2E9wpXrhex0RoVAhy0tWQxR
OX/BaDK+IPv+79WwypYiCX+KP+HzGjIEE5fmXSDvQpKOq7aPvseCaj9V6QHdmbv11bdy49+5HvEf
kVlmBZf7TxUT8uDVhMea6UHy9vmJ6fCArXd1zwuy+TUAsZ3Yy04vIFkbnmJOmT+NjLqdLnBu/b0I
YiceJbSPSuKEKSWxmR0D+dUqLuQnXnXpC6ycuSEQlQBOdoUMv/9qsPmqNIUjcOqe0HT5KJsiPQ/Y
xzsmCtItsF+j971fNdvO7cNZTvlApb2rQgg/gIqGQN6B3jhFxx0+ICltD46kP3GyURuVSbpsfqYC
PWwANK6S4jnVLgNtbmez24D8I44TS4MuGG4HDb8ivs+kuuvncxlfYno/hlR2M6nPmlbcyU4SONq9
p+mutrKVNJmf77PuRFpFO/iCXO8uuY6hSj//IeiFBmjbpQ0e182i6IGdWs5M9mdHCi5HzxsCyJlg
vc5OCC+4tlpNb52w1S1rHh9iJ8KlTjAyb8wi9AtKRMDeme89Y1cNUEx63T0EXETFTzL/3956tmBR
S9y2tk/Ckm7Dk3dPDh7BgSqrotQBCfTBw7PCKVeEJBm5nxnZdqfxOJonJk0J+7FcuKW1sq80mCzf
yXgO+pRswRLdVf36sWQgeenMSbpBqLzH3qZl6TciA7sCZAgeckkuD/SnDMWwRkwdB8fv4Dvm3Geg
AgqhgWXRxQrKzUlcgj5vIDNDG7sjwGT4WEd9ALLsmG7TWcELdMztgCZhyuQKgEDcPerJ/yKj5utp
JJIIysU2A0XSyh99EcnhZ6ySkCuesjUPPyiyiWymoJJXAU8dK1JIPOv9ELOaXhX9bavvlxr5NyJd
koJX3Zo6YscjHYp++HbIjik6VUyP4o7XmW08vYq4UzBPTH9NV06C561s9V1mqIiUzzLx69WWZxDK
6PhV/Z5a/PaCsQZWSDn5w5qtkeeaXkgNcs9Ewhh0snvVdq6BDaefpz7gJfbpPcGveu9G4PIClHXv
WYH13clRc/rYtWjG9XyeH3s+xVPBW14PTP7ctpUOxdz+s27Ki6yjnwB1YwVeKROTCV8q8LuzErvH
KQVfU3N5WbODNOCnt//Vz+z4Zk4Q9YXUXLM1k2zRyfh5BZT2sZi9xJ0RgwfIwyYxj09Q8LrSLqQs
GE+17kNoJEZymvPbU8CPM1GiZqCev+gFbONL16O63NdN/JbgFVOjXyE9bK4Mfr8JNskofSthJTrP
akROfjOhHlC9ibBwEGl1mSjYyZCxu5U+pqABIb6ZaWqULlYf0epPxO8Ub7QU7y113f67pDLIkWhk
kip+gaBFjmXcQcNNXPPqdFw7vtQTG+XXLlsh0eS/2j2W37gDhiKxVrp4azdd44W14jJkp/0atYVP
c61OY55Y/YUKNAfdUGVgwRx6bL77ynn4BvZ7p4dgRDQ3+lrPJXVl9XQozm/BU5KYGd8Qu3Xd7L1Z
4n4sUuZ9GR966oDnjdWvc10TNTYp+WF5QH0S8a7IZZVzYu0QgvAQ2xFmZ8zI0jcbtIpdGwaW0lE5
UgmeAfdCFriw1XqlDy5QAp69ktFAr1GR8bDv71WaGUxgs5gQnD21LVn3PIMR2IXRHQRgQ/SbA5gk
UbDt6uxX2CyRjRnD+C0xINR2/qWoRh1EgIhONBDNJKo3ASjuEkainwSqbHG5tiPESKWCglkucphI
17zBDffr/73R3r8P8SVEFKa/7h2rWKOpnpb116uuNZ5OXqvK837D/IfXIifyGftffQ9AOUF3xZnT
CILa0JytFTRaqiu3FK6QqaSRI0EpEkMJwtbP8RLLcU2nSiuPmmeuh00tjRhuN9aPN+0RnjRxvBvg
ZQ/2tHfSDpXFwTer/wbtzGfZIkbpC2LT0pmBb34U1Nk9wqLFxvMmSKhlx4kBIHnqeG49pTt0xcDI
32xkmt/e+KSKA/H1tPJERhq6KxMYe6GaVm7dx/NU0Lbq+nnhKUncR/LbAs6ViEmpU/jPISEr6g/8
UV4mBPp6F9+4tyCx2pFdbPGtQyNdbKY276tloMVouDeZqCpFw+6FccmnuZi8b1375sPsf/o01t/n
Gi0UUHFMCpppQfzuRQYSu8IaW1m2vNTsyEjpvRWpxLkzq5rj9MUBF0zyRZ3AQxu5Wv70BN0G0mvh
achUllPbGEgNUUuAq1WEV51iUqD9xE81fBG5omXM84OszBoUeGdq+qpQDN6MAKuU2zYHadDudLw/
I7DIEc3k2gE3EnLx2uo8bCSzyV/2mr4QwpPfbQdur+BFe9pqjW5LQfuArMTxkiPMkxXFE5A2eOMM
t5SMcRTkZa/GnxUsquFfqQQaCIOUml5ESLzocPkWSMnezpmguW3wIYB8thmmCr5CxzOGINPa/f+5
GI55FaUu80TH9HzLxsGkKU1bn+CxSFlO/xt20fA9ocDg0rWB5n3eKknC8ddgik1+FpcgD8JVYTGi
rzOu1L66e8lWAbgPk6ANTW2Fr47cID7Ke9DqrUpf9ckiRqHpDSImDnkyHJ1UWs9VW4s8pE8FWqs/
pC8TxRiKx4egreGQpzKQzzI0LbtCvnLMz8SMtMjZtYPdf7tMOFKUmXm2Cd2MIEjcb/BvApdFl6gu
cgzSzuTOmujDcC67AS6JWCU36509bF8LXLutSzfQmCMdj8fVQFlJsProRC7iIzvY3JBf043+pyD+
r8RPaz39QAAPmBMDDcpEh5CqWweqaSDHTGyjYFKtdJMJJQa0aby9jqk5Ofn76YG1mvOWUE52Gskk
kuhPUtHnQYJUj5HwvSkKK+6mMVLrqxvdpsS2EI1BPjSQ1CFE77MXndw7fgM6a/Y5OxXMN3QKXROp
5VcdAWZZQFZHBk6zPvpscewFV1ZCetNnKbeD0riT2c0LsusjrMx8qJoe9MRjhbybLr8hHa8Mk/DV
tbD5U3IjyhRCW++WX11G0D9MFlNmGinxaztv2/n9c531WL64aWbEpZ7wlAKUTyc3Ci+XMEsZlxui
YRLTykYLWqEkBPwbsdcf+GQfpHr3lfP+MOvdJSg7TuvSZfBQ0S1VRM70wplYdINec6vzXPn0Zxmf
wfTe24J4NUcmI2mJ9l0CtGDmywIQm8pqE2Cw2hOYioVdqgwzBquh5TaMTYjHAsqKUmo65S62HG/h
HpI31xpAvnLVJL12r/dApXBOBSM9EZdtjkrnih52AyxrwMAVBsG2objIoe9bBsdKK4lmBq4ukXRB
7fj6BZUd6IXrt45h04f6Tges6yMxHatvAX3RYK5trMSi4SXG1Le+76EDD1shp5mMp7JQIeT069yX
LQQv8/fFLn2tNmATqkyjsmpUJXeU9u7On/JbKn1yyobVnQ5HA2BPzHTFVCG2ljmCNsiCtgdCcTY4
JwF1L2MyyXUkJz8RSTqF5UEiYWtT/vKOgDki/FZ0DCuIg6696F7CRcSmctVZ6brDIB2vtmDN8wca
1NJymc6rYM/JoidmL43DAthWBcZSwzCnXo7h002In9pGT/fEMx7SKVQY2R9ybfbtzCt9lb9+fwLb
fu0HJiRHRm3Z7MHMm9M3l2ZeKAB56aaM2D5v0GQrGgP5W6nGWgcPRv6HfbFNKmpeCfrDD4naz03n
RkOajXpvNQhbkQQNEhU1PWpRGoTGn6F0+x8Rq8x5d/2NMp7by2poTkc35WQpHnXW/y9Rnd6K1Za6
+ITo/PO1hyAySEAZeqemp1//tVdtd26VVBskb1bQnAq33Sk/VNKmvE9u4GyEveGv79fzTOybcS9g
tlrb0AVlDKjLj4FAp3+zFkC+Tnp1QKuHBALsSzGeaC4ZxxU3Yz67uEQvTzbfoNDIx7CQ3tfj5QB/
ZSG0OwKHEG1rJomhisCBN2HKbEdV6/cn2Ccu3CPEkr5hM/3tSZwaraAMdx4eX76JtoO1M4G8UD74
b0Saxw2MNSBdtoBJz9sOOMB+Bqk7fbfUZKKR8JDPsyxYpLFKtoYl9HFJb6WCGO9HH54Rc2RmuipH
4ddYLGWQvJb81nPSs7le8b61HQqOJ4AmXx+UC2o9Oy1td+6wTzovsd/9q4VgZj8hFLv15lXHc4TQ
tZsdoBpbGVtlz+lvtyjwdMcJ0MUDqM5hP5dkNO4neEHTDwLvup0GV0FWvY3mwjWrtLswnliEvCLP
IeimeufjOnvDTJFAYiyTjoJeLE6T9MRYCaXRSKBwFIajdAzY8TGR6Ab/SozDRKGWVEaWYio64smo
6mNEs5lguWBf3jx258olqlEmxKqw7bOMtD35WAofcXm3rvcttz03s2HRinGfrLHIO26MfNMnvxTR
YgVppqMNvsst8XT/pRnEg7wkoOYl/7oTpVL+5FVkMn/uNWqGmyjcf6i0solbdUu7CxaJUSkdRQz6
TEckbt1Vlkls9iVS13F1KDN8j9hcbd0EtRxLe9lzmrFQFaOhx1GIsypoYjkDxsgbvXX4te/boMCd
ov8rBbT5+wfehBi+BhLaUBLG553C46VSKlPuGBBVA1BdwSfGEryzqo9qMr06y70QCTGa97W67kLQ
hfo3v4+AbXkjUh3s4SpYgTdG4tFo5wpN3So4X5KpXCMvrzdhrbB9jvThWXWs4TEhE6WTUKnDjfHn
0btSWeZFKWn3s8sRd9fQKcr2FPWGNIfW6kFpITX89jZD5lsDW4g8SY/QvuMG13YXoBM6tKA139VE
qnqiRvFyIZh7NW3aZCVQcRg/dLDG7T3XLszWsKkPFUIlE+YdtJblnzjgN7Ffd8cLIN6z2SIUodfk
0k3qzWdBqkmT0uhg5q6T3U/1UeeC+qhYrh5g1grCf/FwhEjgRmoiXmBOoONVNpt/3FBceGBNLz/d
FRsJxXDafD9qQpo7N1OJy3jeJle6p1OTLFaUF655Ypab2DHC0Dfd5LEqhhjBWcxJjcqBJJb1ojhi
Jk/AKZSogpqUP9LhWnePdjOzrqSkgv4duvsOAeqBrAXAbyltJ6+Z+C9O6pnxL8orCH3eHmspPMQq
cP03p/MMSKa3ws1kVe1yDoGLaTD+eIMvXV6CBQ5Lmr2Pj6bj/EqqzZPgreYPVUAe7j2Mo7IYYy3B
+vt1ZWsLukiDLG6X4jo+oFz38pPdHcSHAf+qiMfgyTjJzmfhcfxTytJVowIuqFHqTpybTnWQcU3H
rca03RXdS6n/XNp8Rmhymu/bFCUA9UHma8j8daTjLeqtU5rJp7fmpsSmj7RhbvuUuKmV8eFtvx9D
9CktouizWdL3yVlF2WEYzKWHi9mLuZY7r6Bg/a1Kq0YNLR0wqEI58LRlup5KBlI0TsQ5dbGftlrS
xjbLOvPKBd6uSHHj2g4AOAfXwE6shACc39VXUVaFDRjrFqFmn9BRHNrYfVVfcN8v1rLSkJsWMN0e
jN1QvW5aRQV2bTi+dnLo4h32hJ6CJw8+hQERkCI9o9aN+S9rX1tMz8mxS+1k7dyb69ha/Kfx9PES
hwwVujokEsOpR4nHJlYpSySOP37cwAp16LdILcpqSH9p1nY2kVzl6fSV2bdy953mnt5LKG2vQqHH
myvKQtW3i638EYrWVAlzzYZmxHZmViaFszIe3SAAtYKdDGtJJ0XKb8VrmZbG7fY1QdsMkwlknI8Y
Cpfemafj2P7Lax/rQ7WAR8PWNNplfXaTh1+pkNGWpPHAcVUwSm96D2EN/p6oGvIRKeUsl4bOQ9eL
r9e4ElFjfs1dcEnisa5sORTyPrAklUq4adT42otC0iSL0c2B/n41lP5WFBQefVdJSLSETdylMjz9
FoP2qLIuyUS2m1qA5dWi3UKl/IxGe1phnUB71mIykEdV3Akvi5DMF9jeywqblt03TodEjNhS+UcK
iLq0zsfsW4Rv4J9Rt7iJY5az+06TCF3IvCoKmAeg+HWCP/l5ffpvLnzXilkTxX5JKalPHpb/lIrr
TrK3vgY9eAt6Xneo56KwVTpC0h+T+gtRn5s7H4aaXntrbebUlt6/iR43l3LQCpX56//z5Owu/iVb
qtDvs1375HNxx6MUXhiUOUGKLLGv8eP2fbpLePp6B8ddxUYFFfEqpIuW5fqoMcjyoJLemjhB6Vko
a7OHTpB/8gigRuF7JSrZBPxLpomERFoNAY8tNJ5086D6fwn1hOmNBpGYLmSRu8q6ii/SHIYnYKDs
qcfzYaGJTWkVkzRyJ1BEbQZcEpmOj3VhH9OszdcTUd8zKFKAHEAlplSeJdaGvvV9zFno0KzSWFPh
kqiebpwcfvgrFg0+awyoQUT+xgmX8Q7PBM5ZlOUi8mT46MqEYaWjj+sCZy6dfXQJnkaURpf9oViR
90ybvRzuLV7b7ObLjBae7WEw25B0Rwud3igIJD1roDjHLEhz4C98hyE7j0I4OEo5MK3Nkd8Dq3y0
WyG2DpMRm7k16PErV/hcxLpRSkygwdvo/MVpHAXATVohr/sB2TtQTJEnduHeqR/eeb6KWaRhYNIm
9SJtb5V+o9JAxkPcEo4Pliv3PDmevf0T5Rsc20Y3LgjknN1FcxNG3CUDPsyyCj5Wpznha8mpRNbg
EOr3+Rhh6GBYGxlDj7m/aIrwOEVEAwz8hKLiW0XrI9ayE/iGXGxWEwpXlc+FLUC5PG4KpLSqYOtZ
4rvkeRF31VaZeGjYq4JCNzObwR0I8XGgrvm3LzvcaXBKumxu4OM8MdXRxmyF+r0CRKWs7spBnMoH
hrWgRLJ9YCyuGemtw5LFWUDOyatCpSWS37smzN1jlWojoshIqfeQwkY9AnhbWP+zSgXOMJsYa/ur
XY/0bAaFLZjsfCPEqqwlOTzvxp7alva2mcvX7QzJ308BU/0vxHa2e7Fm8qudNJh5AoWrsHHBkUjW
vln2NoMEB6f2hek2LjEuOPhL+6ylSuNLXzFRc6PeOr3FDEE2Un7Rw3lzB/zkDW//3GGQ0g5OEO+s
Xe7fNGflcNjxGozpOHizMaByUJvUUb3ZeH2ESgQJL3iHE01Jgd5OXJc0+1i5w4Bf/wqd0x2JBViQ
WIz0NUWX29AfNrxC+QdNCstlpHLpnSwJfjrqwOsThKpnOGGN2rKxq/w/8z8OeI0JZ+M4noA6HVSQ
BJyaugg0jT3riqiLExFSbwLY+gthKsZUu7vab/zYilCQMSXvTvNu8fBgY1UD7/AkjkLAH6rICpfY
o2M036Bv21jmaIeQpzjQGHGmqrRS4mU0C6nLhIcITVi7VNHT6VoTRBz203p2+2/tHoRPwoR7izSu
AC+v/m1wxOHxSgQF9Lb9/TsvYSnTh5GcthSyTGF5X2RDcRbFPFN268sYvyxXHHPiMSXN2CFm78d8
DnHbTyYMEV3iPImSdIhsZdd/FkJGrKAWomRjn5VYMBNlZJn6QI11i/vSoAaaJTPsNwjZ4T4luhDM
v5IuZWYc3bC6jnqEWd86fBEP9mXf9MH0AXQo1Dt6fq2IV55IsZOE3jYkYEQNS/wVzn+ILmT73GGB
JZeXXUUP4K45VLkpBjCGdaJ0L+uWfuag84RGjrInc2XxXDevLuh25IL78bKMAvpDCFIFN3giL5PT
8lm6Hr74idPm58bieCIBNwYCd5zrvYGQNktc6ulCYjhSgNYpN2lqy9jmYP34TpMBHNsIVBjrriMO
OCDD3S1x1rz2+7DJen9q9+SrULnDlgNaU342399BBJLw6gO5z/6vduR3y0MtcIyDIXnGeZ49CtB9
uSWgbrHolpFmAX4koqFKe6Te5FmrsHO2u8HoNIW92w+tgOSHX4Keudxc/7rK1AApjaH5VbGGzPpA
3ikJt5VaVhlJOZKVH22A8XtuVBteQcHrZRKVKi7Lnb3dqVoSYDgC2CCBtzgQrxbnvnfmy0O7VVvF
yRihMSiSBLXwvKFs1shb2zC9IPf9WUCY8Xn8IqvR+R6YoTVyD+WLL+opMvggwYzCk9ovBUVdacdY
AhPnUswcHBntmjIZxot2RcLdopL9QotOPTnKO7BfjtWJsi98VvlQ8torUL7yvkBMJIL7o1M1U7gx
XbFQd4R6P5bxOF24yJL3Zkjww3B4GDXPoyKIYh1G9zUqPLOSv+0JZmOkeJ6LsUtn7nZlJxc/tMLl
lV8DOynkbEN7hambiQY9DtcGspE0QgJpffrsIb7skq99yiJQbNkHOcoTXb7akEg4T2dUZn6PVn0J
vuCUIZZDfuxoUAn8FQ43VxKMm5J/ea1U2wWlnUvFapbjc0LFI0h6nzwgz4mKQCkNaO0vlbMjM9yg
467g+sGp6MRC9kvGk/BDjx3wBU9LNAEJpiwg8jfx3uSll4g9Qvp1Y6d5346ceVyVJrsgU28tCpGq
hEUxiRvk7QT5VLU9rnybxrN5IR0zMAUhy4tqLwNzvZhM9HfAG/LRGod1K6BqGo76fsT5Wq7rTtmM
etAaDMHHWkcICw8yLjSAxWjt2vs7hUZPp8zDObeJwlMDJ+rEbpybflA1zHTVHzz+1VhZM7W+uFEz
wkrVm3qhmphbcVmYTUnlzKgCwUSpIvDpk+4q4Ov5IQLdlLQ1vmFT0UupZU2PP5L4bpWqeKAAlSi1
ObJWb0/T770XfuElH3lHlhybU9OyWbkx16CT9BLblfbPmw7Q53EkCYVGjlXwCmfL1BdRJn4DVDoC
03JpOJnKgHo8cFWlZBBZRcNId1SRzciOWE623PNXh7NmrgkTmMSItNZkUfYp64OjQjKBdUmdWeWs
UYmLOGVsQi6lJIm5dJfDgP0oa3AhqY5FBvPsjreQe5UacDBG5cF1sz+OL9R58EocEu9uNENMiqT3
oz5xwiaCtpmxmnOQznhumdh6EF8C+qGbV/WT7HL7h0PbFUHooXQTnvCUqNYbQjn/arZ6BvLMM47j
rNEJcGJGpj0vCiao25W+hCHI2e1aSLuEbfkpnXymbiCpO2/zIEeFZusnX52YzWtp9hNi2fCaI5zy
XjCsDDHQUEOIlabassqWdeq2p1PpCRpEmbteQMZleUXfR127Nn+7CbFMrGLdjJ0ltoxw1LVLqw61
1pxaCKh9U9mra7m0r+6LWm47l2KeKD9Y0NBJfXzArQ/zoCrCWQtsjK5XCTmRVNBoySNwqpt7UEx+
UwQAemVWL0JqfPyKzsmmykrR4Lad4d5ffg06OJZHC8uui1kUxlitEJ5WxK6llIP2Yn/77OgHXSPQ
SYnvWlr0M8wFyHiFSmgFOwqS/h3H1pUTAD3i6Sw1pOYxgekEyK/AdIa3IR2iam3/uRtLApG5eP5D
9Rkuy8Pp+2O4TN2cvJVbMBTMWEEZi/SqzhgHdjjh2rocrUNNJmtlWSN6sTZBPnR6MhYZqxyWCDuK
DwPesDmGEqxZFOBv/oQNtrpbnk/HY318FKQv63wWUIhKeK+YncGAeisCWhg/eJ41a6ws/OIpCm6e
EtxHXOYdl9hFcyRlDA2aTirbrdGLNAYVZukpqVKpu9x1123ajqT79Kuqva0f9RgvH0q2fUYgvEvz
SgMeGOZSAJ8MBLA2Ia+F4b0FzFCd2/14OvxWMXvFnUqipDb4340CqV4qqwjd3iQDjl1+Ssr1QWkI
xvX/ZhrvT8MXrAhXgjBHQ6mVuiGnQW5VYPVXdbRAaIY64u4f9VVipB9220YtAYBSxAogZJC6DVf1
tN6J+uKHUxljIoSjXGIXGmI+H7HOAgedwwjMawjfMeTOwF6/RVvoUOmtWgfPDKttMVpZebxyOVnp
xbtbGaI78d99oXDrOD4cyuk4FIt+UADydEkfUbKti+FRCmFgnu33DXsDEosN4rq02lZzJwC4rsqY
wb1YEO52YELkd+qv4V4OhfoulyEVlkw9pLvWx/AjoXvy+bl5BSXAiMyThC/Ll2sWZvHNQ+NhOIh/
aUnonuvcN21ZhOOtCiroxD+TtveL4NKO8arfc9Ob4m4HOsNla1vM29kPRDEz/me/YdnEUkEBP/mg
c4RIhB9TmvVdljchk5R6vsBH/KudYQt6NDg0cVhqZ07Hwmmp6oeNqUHCvRt3bWDtDBSh1tDEfLf+
lo0FfDgpsdH5qZ8Nuh3rwX0/jZMpzb8cKkB7Wp95lFlildN2r27SjRp1s5JZ9XqSjBKpr71kFPcw
9C1Hqku8Lt3GQBQfsPuwzUNKI27ViJAa7dkWpQgh8CtejEn0YOilQ44uHipORh5M6ZaCaVbhae7X
lDtM00JdGlTIFs2ymBXRHopgr8EdRzCOI4ETVp8nfRkRag7Qli+C89oBLqzUskjeVxTCFzpuzw9w
qiFYF8QUY+hivnhMnfz0CEiJsJz7DgNn5Sbit9dM+9j/oswpeXmJzPPaoXw1yjVrvaxKn0QQusPk
ixK2j1wbyJEhY8661DdpDhh1l06OQ4/KzelAJJmtdfRza7porRaWMiaePex0YeouyKG5zqwhBaNV
ZF2FskPjwp6PZTyJhfwvL4K5ZTaqE0rIMOwPQuZrLK0c+jAD2CLTX0ABR7TFCohG00axbWXjWOwC
ocpV41rHIHFrZqXbomCn5qRx3MMWwZ5JglQpu0y7y4cXU3VnYVbLzfhiFsHxMGyiBtZV5bkq2NiX
hfbl/A98JCijbm+jn+U4DsywamGF0ora/mCvdRlN9TvkVhJeOgm/oKA/hcKJkDTj+l5Whhsqyz/N
greqkXlJyaNnR/ncZ21xFnFr0lJonpp6Lg71VQvGlNZunKz2yoq7AS5ilZJ+vZiU0ERzCKISSzGY
Vx2OUMKQuX7r+dLOwHVmb492gutdliptP146tFnNKN+ukEzgtV/0jXVJhiQytVzeXVvI+d75DjEL
3rEoSBCL/BCLANwqwThuYOPDPppNp4VLzJ60CmdBH7V7wQKJA0zfNtZ+dHQE2I728HHmjLaTPRxu
/whnTQcYGDggyKEfFLNR6lo2iVRPhYvI/lSaW9en965CvSqBMO3rFQB0lIw96aK/cvDyPGvI+jSz
5QnN2YSJSPxPbZHl4UDhyPfMAWXnT00KkvP4lLa2vIKlOCTUWGRzie5zrppFNlerLavJs9YNaNRM
CFgFEXADPVfhwHD5YlzUS+lgN6ottCIa8RyJvxXAOMnJdZQxdQ0JVRmKuxcCHcrZTQ3XGDqcIn0L
9KSXti6eC/8gsF5AF11hSaWsC6pPy+9QGR4CBswy/fYBc4INMSjJxQ==
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
