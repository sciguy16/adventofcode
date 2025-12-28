// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Sat Dec 27 21:30:59 2025
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
    wea,
    addra,
    dina,
    douta,
    clkb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [8:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     4.94295 mW" *) 
  (* C_FAMILY = "spartan7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
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
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[10:0]),
        .regcea(1'b1),
        .regceb(1'b1),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 27472)
`pragma protect data_block
8z/dipZm4UREdpGPudRtEkJBlrNP+4BgnHCcBxM53x/jWcY/noti8q6VhDOwwN3WgrNMnUCKreb+
5YwnUT2tgsZ6eT5fDbyo8l8t71hmUIlY6v53LVcx5YMM/7nwPnwl7m3tHvNVvL7Scdxf10Suo6hF
/QwfjxNHfiriffJv0vPOgYcHdzgkvc+ONun1YVxlhWK4HWwndQRuboaCxQnjPh9XyiRgRabr4/bz
ExxbayktCIrjuSXBohosg3YGnyYEHm+rNdOlom+ENZCdfZ23H+7QcxCgSo36GKUUeMy6p5W6I8Lc
GS5eFTF9XLbJLOhvMP/mpDZLHhfM0937GiEVgu6oA4nKV96d+YSoPOyqJQqKQTjdbVWr9t3ySWch
D+e2R8SbzaPQiAUD5QTswsCaeq8iZpDA7UglGKilBjCQYfCRBnVfqem5uDkK7rGd8TdfzhOoc/lC
s6/YA1S8EU4MSkjKFZrSQutrq2Bao5pxjYiXutZHo8xuDPZCGSyBbgmdIO7kOFfPZXglB4Rdfnsc
x55Lgizr/IScNBoVWxDvNqNWsRPluCUpGh2Q929fo9YbKOH2z7fLCfakox7GW+sdESz1dDUnS8sf
2a3iuQpSD5yl2NDErhY/pInam0xLp8ulNX7rubqhRJqRq2HhgdKViwNq2/DqMOJ2eh5uUH08gFnC
Y9fXiLgdsb2koMVCSBkerBn8sxNA4GJhlXWJkx7fGjOAUyhlmnkNJo8uzLQToOpDGvp1ZvJzErSu
s1D1WAlfc3yv73TQOiR0NZePrSDb9FW2XpuBQKRs2YGnTFRLS84wMfbU2xHIAsECV6FJTWsbTFL2
fuPkk6RKZbFp5xZpl7tCePdCTOuQtNOCWfAU5H4rTan/MW4uitRxa97EZiLLbZ80WLY2EEbFsL+n
r4yVid5vE+nGzr0i/debDvBc5l7soBETEZ1so3PzYP6Rq+k0pDRvgj7aRbz2Tbjfyuci5CN+IlPv
cWaarktXXrD20jh+NqMoc2Oa0AZC2+iYx1kXJjeImsfQwPpV9czF3VZsvHJ5yo/EjlSDVP40dYzI
xplGd66AtyCl38eyX/K570OoSQf3bS7PsFu397FE7pMRcyvn2mXmtrS4100JPazPzAX9eMYzqju5
9lyiHPhpwZAayqCQsbqym/pjLdr+z4bk5D7z6HEBAqwjx0Er8TCZWNQmfE1d/vuonApkhEbWChRB
VFLaQxC3rGtfmJ9WWRG9hfv/GuxZvdnS10YIPkxQe50olcYQLgW2dfYyMsgSlLpzIsIj3EhsjH28
XKjQij+J9SGT9eW/KF2EYVv+xwYyLD8dcdtlZ/53OEI59C5Ch+O9L0macshsiX2WUTXIEj0u9UaT
ruF41bSMXfLMIg61pGXX0/BSh2efmFrTHtVliOKiqWwQyt1oAFyl5nVRiGlMa0JaMPoVb9CE7l6z
by5NbNLTRdlCwT07iL9302OZVU1xae+f4r+2WsJenIrF+WGVv1F5Qg0jrQ/DpBdk2CYtIIcYe9Fz
KiNqildwLbCLpRGugeq0VOP6wn+BkwY53Mxtq1B3olaCvqwohhBVNr5WkMLopGnlDN6n6bvSAaOD
5nayQERxMMDWZIJOlF62pmLNmqgZV0NQdsR79BJEW3rbdZb9Z06aiqbmmADzCgl13m9klbvjApBk
AOuaAa13Ptd6r5qBTJByRR6xP+s0yFBprYC5pHnDsDdSKu12X9XFUQ5kGKQPGLzu1eXD4KRjx9wy
JoAkLDz97SW3HdlTQ5zx2NF3agyH9Ultcu1NQQzbDpMc3MyLCR+BKO4F6UNIQfwX9XcD0Kyew98N
SYCrj8II2xqUOc5vzL2gbLmLFtB7eR2r+HedC6m3E6ZnMqpht14yJabvnJwJBfyJjWo327hy2jlm
+zrhr3Zxq4AH3qKybQmTuLEbtXpdvjGlLxIiY1EVun+LCU5vAhBYOfucPd0R5nxdynnbUgBaK8Uo
ONl1Tg9slCJ7s0fp46hCHISYeQtB11dj14b1VgPaN2x6Qux2TeMTz4fHjNQjCipo0GZSbEgQ4nYL
zwV0PQYnyGGEJwF66mgCm46SW/QM5diDvHHyveu3IgKP4L78+oo8y5qwtdVuhG+UDluEaZAVMmN+
iTJnVWcSWyZWjsJIPhDQ8n53ZiohqHBVnGPfldq7tEWgJPPcKkRMLy0IoB4DNOeHitRg5NfG7Hth
IMv71AUX7jevre57++jzvwIfVndlk70oiDG/Je9gL9dtzypqrWccQrE6GljaUWgV4qUxDeh94psA
jTtt3i/VNFLsGnAwjw1ewJ+rulIbGPZmLqsbDOwx9/bs/uBnCb2GToe+78azdYC8GScFq2cb2hfB
Q2qNkmkCcrFNcrAuZHpHsfmnlCapBFjsGtDMmo+6SLKlYCVFNtpItrjRTjVQsrODpBbk+jZaYnHL
TruJJid3PZCaJZZic2ZfxDE0go8YLT4tWTYcY6F0zKNEoBZADjzfLfI5NtoEHN9EAHyGUoQFxc6y
zxUPEdVVy9Gv2loNo3YqaqYZ2ZhxuXAZP1tPssmowEahTQOFBBo18SMgetjX94j0RkFp7/EnjlDN
I9n7/Uz8HazOn5Hit3vNcwb/gOCxpNn82RcyZLMGqHbetaYaAHj7kG7ZCX1kBWUIhRN11kS4xQCo
vSrTfhzrgySs9PN4w6IAfmMDBiT4NQBbF9wlZzWxJHUnSA5LSk5JQZvH2jCoTtUOCu5lL+N+YAZw
0cRmmn4Zipm9v5iMEhl1PvHt3t0iux7D0+FXo5nF+4ovXAXNQw6YMM2iyDmrK5BcRibbX3ST45sj
nNkhydqY0NL91EzwAIhxu4wet6PYcBUKCtkuZPS1zZ8RS6i1++eq9HR1IsMINNUYlxm0ARtcwQ5w
Vr+FhOhl4gBIefRrZoqiBKJQrRWPDcAJPMO0DCw2lc70cHrJmfA/pcAxpDI12ItRAPaxDVw8ispq
rgayFcI3Nw5Puc4x+zf9+7vg++WlzpX6YvJSi9Lp3mI027oCc1Vgff/NvXYuURlhBdfkRsSDTppU
cC4NRlh+VjSJXxc6DklY0t5o6ZkT4pqdQ4Q16gW2JrNt7q4wjkHpH+jMhjlFE9APvMy9m+wAdxQi
3TpKK0nkLUHG8MmG3oU5vLB+lQMg0xbe+CsyNzkZcYswMxBuKWVIugggevk1a8nX5xSQQBI0Fo7q
xsOyvCbM/P3q/sktUooE9j7ei6rDsPGNUB71hf76j0/0Ew7D9VDFP/ueuPI5wzEQEgILgTThLCiy
AMgH9VtKH7CJ507o6X5NApvWgSYpYsFYi/LMp7fJI523ujuN1RqnEgl0D0/KuUCmvvTSccrS+/zB
paLcFFCnNhJPAJJM6OZ+jqs1XJ1a3augkylJPqTNGPoqXQrzl7YkN86Uu3kEusCj9AC4UH235OiX
Rta2N690/qzN7sP3o4uchj/fsTuFYemxwpEUTZiqEbIwRmrG+F96kZ9bAYDjHkanwIURE332Y7eF
fHCwe5vz/2ij1d49LINQPVkB2ugM/sUEz68rUh7y2tCZ1cMYXjmyEmn07oTwZRABhudx/wREWodQ
5GFhrFET5KuAB7PwZlQNw5CmwnyLEBnb5jDe3TKtZmn2BPwjuvKicUZOns9Uef0mjTXh2iJk5y7f
iN3aN7qM/rAlka5YExOQ/+MDttKUSJaX2zwxau2ya4+W+xaW36moB3iUNFcufEbN2X+k7quf2koU
JZ+iuWpSv/fvwhXTtXj56vaxlhzaoBG4A+sfPwPjCWDBuGwLtANIPPLmLEgAUp9FUCbKZwQHC3TV
WXd5m3OfakxY1J/tXAygLpz5nrnx/aHISSzu5tOOvclRA0qry2uCNztR2P0OnKiZRbZmtRHuk6eu
B5zf5LXH3nVhFL3NAAxaOQxt0rfYpiHI8/lM0u0EWbHbGD3lMgZEiiLKDCACO+q+KHsp0Vh/7/dA
8hVudGOOICR3qDo0wdAJpxPb6oYBgf6vKhUwA4Vj8p3D0swfe+hiOMPyJ9rRmHrPm3So8TyXq8ec
MD0Ne3sSnM3fiZXXtzDB0szylC2sVJbAifSTdRCOG99KyDMO1Wol9WChn/IjYOe048IC/GqB9NTE
bdtbSUdgwfGBTpKYyA+lBRZfHy94k6SqX9/FtK1OvbO8aFAFdJJhefKmsZTn+dUcX/Qv1dx1Yd7M
4pDCHm5I24iQIkSryxQXGEYZJ0CUa+CfTHxkkVIkxatB/TDUIlnPF8Dsov7KxKfP/hrdhXziw/Fo
HefmJ5dwaex/a85bg1jS3oXsBro3eiis2AhN1xiaqCHU4t9DBfkUtKhcRHe0zdpzOoZ9uYcxcV2v
RptEErZrpwxZd8W3xh1D5QMP0EbLo+IK1JSX+AJMMJLZYyw8IpoFweq7RqeD1UhTvjl9C2TchG0X
wczlrMuNdl8XdfDz8WjU32Tq//1L/+98hFx4nUScmFIzvgbfnNt0x2YK5prmL38ZjQYsx9ArXWJN
qZm0Zsf/Hl4J5v7WH/7PrIqMs/5PNb/iyCH/sSPQJ43mUJDWB0jEKyv5YKRC1jai6ntAcwO8RjeW
seioLKy/Gmlsc6lXDI6RACiFMvPWxMruo8WM91I83QPbvsEVePR5LK+4SPQ5Bx2wBDmU2NRO27cT
xusbgcZ8O6SEK64ftdaraXVmWG3ZoxghxjNb6kvWNbperhA+eMy61YZpxlw2GRgqQPJq9+n6cYOr
3Catqj+9+0Ban5eShs3X2Evq7N+Cg+4xUCz/oNvjPsvOp8uOYDmRaAFBR+Zk4EMfsY8Tm2Xk8kjy
vSKMBRVWAkXBl6gC4e5ch6d33gB473IWZ+9vsK5BxWyv2kjc42aNr9xuavSdn+9pyr1dYXRSfKIR
kTZq+7lHgv/GuKHDG1KF/h6Gv51dM4Tzp4M4Ey75GHJ4Kj5Ip0GRxoJ7LK4fILLQeDg8/rLrdkQ6
vq4F6lMCKfyYug7CNrJFGboHZsQdJL3DoH6vZ+ut/pVOtwGKc5erY5XVOANJINay2YtzcNgZ2aNN
IUFgRMaHdVwwGplFamk5s6As/ZMIOKqnu/vXlJmzBPtzXHS1ILFCgD2fu2DW9kyP9tJqBKUZtc9t
075H3Xd+xJlYvTgroJGxhP7oqs/FfwgSTsNvjE3sctJwosTfBgGGvLkaBY5HxxMgViHaa8hu6N3O
TK33LDGzbjpZ8AWgjQ7AHV4V5uGBvWjD0DRp/pgpywYAiW+zPuAEPrYnSqGqU9axwn+fK9rTc8Mk
e/qP1xo1pysWxNT/JML03n201zAdAXPUCIj2lX33YU//W5IrMPnDgZYBz14CiNBpQcJFC3X+x2PZ
IIDpLC4AYt2PeNOq9uY57JfhPiv5/fA3rCHhrvSn7c+aNC6qnvgyQYKJynoK+YHXnV7hMV9Ajt17
NA8VTeNTyHZZDeSZEewdig8v+NfH79kXPIn3N3qmcjlLj6hv4kVjTkC+Y1qQ0Gs5oi6JHF71GQQS
70+w5uAsjsSJP2qWemC8OcSVPb3rguBRZFh8ZQqlkPYHqkZNdc1j6R/swVLBEFqt8GHm1JIjzl2J
XIllCpNyPP5fxwkgZxDT3Ne6mVKS660UaNdmVlybypUIktJHhpie45FlPI/ZWDOWFJIYiUBEL56O
sEYNlu79y6zWCBlt7udqCSA/KoDOSJ20PUIDHdkYlatZJYdg01PpyE6Tm6uKNbo49dy2i3P+MSqe
TQvNRAo9kHredvAQkGVBwb9HE9PI3sciMGaINeMY6JqJZPmBG79KoA//AbDpMH6Lpxq3YGadBVDX
s6E+S6CCkdNQkuIqkdVagfSARudQABpVacTE+Y9nNU3KrjAlJa8KCfQupeRLKpvB7XiSOhYy0RR0
pUa1k74L5lEtZ2vOG7fFFUIszNhu+VY3xKa34bovMCvfZlGHJXAj5rnpCl9fmti/Y2ZJ4+al9Gie
ZhdeHaT5sYD8/su2iCZUlDwyEZOR3ol84FxddRBxYkO7Wcs+ORHuElut/Ig2AONou5sGZu/G00GD
zyIMrEmFvq3AaZOY0r42n6m3p07u/KHFQFfo8KqsdtdrZEZYCy7eUQNR1N8NOAknxbvRTEf2F+tf
NiJBo7kZV34ppJ+Oj5utHWH1ME/vuDPIy9onp/DP2OmD0rtQ+1Mk5TtV9N9CNHpQt4rZUL3opDFO
PTGxKhrqS5IbrbzTiN5TxD68af6DFxwQuXXTzcOK4fXvapVSo62/lAZG3WD5v9VuNEM8V8dtnxev
KzIUQR4FTJdj90M8Fur3ElYeJrA99FfPcqovRUGXp53KmCaipmG4QMpQJdV+UEwihDUHe94VaPvx
2p46OxKXTEzT0cS9b83AqV/l+dmpL10ej+Kk1HtygSs53Rx3rQlnWMEXMNl3ucH7gKatG1a/l3cJ
oT+mkueIbKagKF1zpS8hfwAb1nbHyt3ZdWCLZ0lNxxRj3KgY4PDU8hGVUUF55J2lo73ufP8FCTxF
92EV/mZx1JSYfGfBoepIFReDm9l7IU/yXmIH15a3LvXcmCIrwR1bxyL46AbAOGyE5++qm1VFeZi2
nWLPP21QHeir6xSng1hXLGiBAlPdp6IkY8/WSLGUP/7lsez6whnGHe6FSWmTuZurnksDbWhfZGSg
O/t75XHH1VR3Gnm3lskcnyK3FKOcFaC3M0GOPwFJuduVZNq4yZ5xi6YjPUBueCzXQPhxC0Hymr2C
AW8PD4iBVRKhgNuy33Bj4q2X57lcIrHdsUAljanbe403UiFAB8feaBzGeE723Q13yj+3/J+fPJlx
dnAnigKiXYQmmRUeHklGhfKKc/yDtswQYwuaBWVdsYDMeSV7reqS7BxFcRx2XIYeYwjn3NLv+W1y
TtRDHTPXBHAfTWXd6WN1bYLeRv1DtXy6XnTiHGQuGphoBgjVKRHsyaBSLvcIod1+aI/gBj6rC5nZ
b61GUQs9sw4DBDwDTw0XdiGs2w8TfeMkShXOd5d1lR8XIEuHGDpDrYQ4Io5caQN+DFWqaEt1AHCn
9b149ysrHpSY/h2l7u+EoK+PXoGyvUcoW5gsoOP4j1FvlMot512HhfuUzOF5tGYghautYe6UXLVS
deqJd1Gc44E0XyXDS6jQ7KsVRLDVkARRjWqBW2a8j1rMyREKz24bzkeLEyOO6Sd9xT37Sa3fTCEl
orUtWolOua9eHDrAUQC53O61CSG7zGVns1PfMBf2PhgANksBmT5ysb8kJPou1sezYGrfFxvPUhNg
j/EyN467BxwaOu/pj7hAznzkXOmWMg5B3bv9EU7PSddMQM1D8C/xgBVzv+LfFyFwpaBbsLVjS4NG
dcMWIuCy/XRivaanRpkCOgew2lN97wSGvSl9eI79ERo3Yy4yL9OX7yg+7qDYcptxsRrqdiGMnxHA
iinzLqBvS8CXeEuWGyzJ5U2p8kTv4cA1YB+BBAeEMRDfEuFIjhtYabDpPzehFrSxWrImz0TNJWl9
6NL5LtPLhC5Wx6s70VShncB6Rwj9/cYCHuk2n0938SyE72aIpdmEd2wZHskmpnKBtJpL2MM7cU2e
pNYtdogZ1n8vWuuK3X4Xoy/N0ju42uZ5lkVkhyuOCav6i1hQksu9YBRYiCGiZ7C2YqjuMjtRZP/W
IZn2dE1DzFKLFM5+T8+MBPt5KIxW4gBlelqJnFlabyQjq3NqDl81NsB0LUD4cZ6+Mbmxw1TqhDfS
B2JiglKcwRIL+mH4uy6/ZPaBchSErJAIFbl1PxAqCR5pMurakL3LgQGuzSer3u0k42qWRGyeL0QI
vyk9LZpvK3JLzIXfmcErWpAoc1n4V2OVJOv+1ZQbVoWo967bp8o9lAJhC3wFQ3w6o85zcKg4mtkv
b6XRfspeS1YlKAezx8uSfePojAN7CKVWbU8a1fJ3RLgM4m5jGsvQXsvO76SsWSfWsBPrnyE4fx2U
gnaBNHtUXTeRZOBRCauJe25amjLGJmoe4tKuFn0tDIXkS7aZZ2JRNzCrGvFBXn70vj9vp504TFh4
w6uO3UknCxXBGfQ7LXI3QOMT/ahx0q8pMFBx/vG4Gx7mEN+Arer7xsNQcLM9spflIDFynv8Ta3Qz
6pMBoMU6M51qFVLbb9kJ9W075Kz8lo3/4H7jOdH2lw5209XWNzj6YVPvKRQQv2Z1jPMblK0lMTHL
iKW2xkla/pYLDpvEuMClye3VRDXcxIt8ibzMRIuSgKwOIB0S9YGQ3X4ar7hY1EYon+K/PbpLIuVW
EhvpVM5Ow720o2woyAh5FNaMXxTGa46yY9lp9ODSFznQxLHc5zWFwjit8xDiKNmpwpmELVnJy8A5
uATBcYStIfEntHZpJOMRAu0c5wnMZOCQAMVZ1NSF9mqWiodSESFz59tSKU+c8QOZSBVL+GyVBktq
c0k7D85yXJhIXd88MtBMNqP+GRjRLvPXPMA6DOsUa8BpbWk5IJo4rdUBaFj9EYWVScJRn02IGdF3
v3yyIBs26mstN4egRF7gmmbhqzt2lp+T3QKVANVGuWzIU4ZsC+uaclMnM6gGJG3l2ulWoHPhDVSU
HSwZKAd+ILvyysnS76DWJWWuPDPZWmCaS/VcNx2722hvF218L8DoAinJV/NY1JPgL22xf+P/BOfl
jU+nERjO+Q4T29GbCKKUmu9dnDMqDlIaKmDoRiosu74caMZkFL3F4Ds27TPDOkrvD2iUV/YynmXP
lXUvMPBACppFYK53HaFpBYUIGwbCRJmIyvFqbSLpWMg+zSlPZX26wYQbHh/t+eqDWgWAodMDRHcC
7rwKPqgDtitYH7q/rTBPjdP9wrVpxhAWa8RwAZjQUXHOaZq5xc4ySbHX84RxskirvCMkPFsHxdXT
w9XLraq6EO52LGPNHWEFXSXHQRnubwk8gCjMLd4lW5FSXxOcEdzTRLJBGC8mUacyRYm0k7/kiRGa
EpDWYRI+7BdO181Et/FPSvo393n5zWwPbM5Co+qB3cl4rwsim0Ie2Jmd1zLbKy+j+owOJTFBDYNW
E5Qw4S0PKOh9rjPD/bwNER1V1KK2GLtGMGjkKahTS0HBSZVtKszZziquhNyVs1bnqNQrXV2deRm8
SvN+Ou0arjVjPCAxAwqkQZk/rzgWvPOm7S+Czjqxn+/hpMdaNLzVi/OXJYhjUYTzkDWzNJEBVM1m
jGT3oUoIZwwoCtUDEzN3aTk5A4aRG9KoXtnAe19zgAiIffzHT9MoxZi0Av9JEBIO+3b30xHQ7UKt
viuaEDDGxyo0dx8OSg+Cy0Qq6Pl0iztkkmtRKhBYu2ak0SuHAwt7pLzcm6DWqk6KrS8pzHjP9plv
xrE+vSaI/mt6vUb7Yv6HkB5AqZwsW1smsfQ/TUK6qK++0EGofJmpbby+YQLEKNlMkDdxUgMQ/2ne
+CxN6Up7ZoVBMjIKP36tucDJfsHR1Nu0565uIPgb9KmrxtcvTKdnratPs+uUBfUyBreaa1Tb63Eo
JM8hxa3sITs5htG+6LAOXMeFUlk3Ibv3MVr8GC0M8vU+5xF3W4xQLqpRnBjaEZlKZACR6IdnLtXP
CxrMPNTgRq7SzXBz2CceJL0F01AX/K9ef7hZh0+cdaPD4oLE/UtwXqLHW49u74kJSzUcuc5XnVhd
27UDi485tULxhAoyHmGLPBa7K4EAuwZANwee0Lqc3Nvp7Mm8wNv2wJatslDfwq/mVjqkxFjTwa2H
hDHibLMhrQGnadCUxJPlpnAw8woUcF2xxcqRSGuNJv8CJuqdsuV4Mczbk3hdzIIesc813MPd5Qrl
V7izUsMA3TehtyB6pzo8hCn2bzKB2bG6HItbHHGtCw9yChzOuxa6eZgmlf867vQ9fiAg3Wo82taK
QvtYH9FQt5nCJvKJQhHEmT2RKFK6DNTlZjXYZc9rLPi+wGskrPOOrDW5DuGklBccq5veO4Kb/B0Z
8UvL2bM8xSJFJxkFIbOS5bwVgSa9L9TCADTbnikFV4VIeJMOzHmhjTvUIotxIFs39lk5Gl6fMsYT
+8NgV9OAKb1sdSpvb5IuVge0Poo0UlOUyNsm0vSS7e+ltoSIwrySZh/QeR1fXO1TDdIkuH1tC3Df
kCF2PD6qpr0MbUqg/mlqxGhXkasWhNbPLPeFJBb6ETDbRlfrjMGoy93w8zzua+qmf8MOW3WSS+DZ
kEnS8Z7PUyOnTVZXBAUnSFF/ghrkUb/2Z56jNPYGWF86W9EtfMoJ9CkBaA3iQzPGR61qJQhyKTEH
QEqvSR6n0e6Do9jTzo8cmwQBv8Plm+/sC2FEml2WYKPuWdcYP8GBC3Y68xNNC5b19Hv+ODTQUGMe
tXYcBtEShbJ16reQxwDFMrw64T3On94HCVyQytpWYY0uwhFpXZ9DRT2e31ZzkneuTTjFwHOh4YtS
f6TOXIpY1yBlxKORJuuUuHFnaIRykU0+HFk2Wdoh41i7+CYwqHFuekZ4d3o5ff3fcPJ2LHBJRTTa
Mq1x5HbxldlUfxNqJc8srzFpwc9ijbEVKowFuOt1HH+hNiCPJ31kKgJg7zSLSCg/f3BTAmcH7h+j
fpnCfMXUkkkBYsEniPDKWz2JgeIVsBCQlP87Hu+WtBGzstjDNIdtp0XxHBjnCsJ6mg0hG8PgM+CU
Fno8DBUKr4Tk7SHRhx4Y4DSnboC1fyXF56W+kEGDSti/y6MSfVh8f1AXAPWX88tbZm+5AIyGMX2E
sc5mFEwA+hSW01PhaHUxvBAdMzBLU8CCvbYmgwNxX7Hz+68ppc/74u/ccuxwCyfE60jldGQkW+aX
fD70LHy0cWHZZ9MXpYu9yj11NYoJuS3j1WOEdopQrxUt7jChoPJcPJVaHBGJlYWZmezoDkutZVA4
w0rltnMfWdiEF45cY6I6m46qSvZWwsKUu4WBwc7iSg/kLfJMLlJJaJEh1Fl0uw0RcAjGw0QQr90w
MyrXIhMeFz+dw4bS2G8smzlwWBhiqqxTFf1M+dJK1YCAJqhSrsQkyOuOGrE7bKp6XAj42hRNlqfU
xu+Lksi+k73WQb0/tqGKvK7Bdva4y5I8W8StCaKFC2beVdr4VNP+lnjVwY7xKAZIiaZ5TmQUseew
8mexMcrrp0IrU7UctQ699HSXSbpTMUuj5+b2TDb3dg1i7q+r33nkPw5RgG2ruomKHd5Zn5Gso6F9
Zj9BOln/kLDhGkrfm3AgaT5ToX9hL8fL5s2Ts1aUyyqOdt+SDZJS9b0+JbM/Cgo8Fkp2BGMt6k1l
8pSPia3YgqLTH6w7XMIXGfJ09jad6bTp2mHCKhpYhExEXXfhtIb7KwVFUZG3y9BlKuah5JDeVwqW
uyv9lXKbGO0lECk6x5AxK/pYxh2X4cJDpDS6rar6rFNtmqRVsTldpFD76BM1SWOGhneAMuCYuoob
TVRgiW8e5HBXyHX6ntq2agmdm1AycGRzOsZO8odDWyh2Nzq16/urmYGiPFo9YhJrzH9JkkT5aK2k
mnQQaj934UD81f4RB2UzLA3tg+nsdYea3KlhCRD6MTbVVEsbAfHponW1CXwnl2uctMo0SmVbJ/Td
vmFs8Os8c8zmLeeRX7fj8wLpD35xXrrpFYCw90P3DQ7yiDa+vHdtOXqFp0b8RvlANWr9w7I+fkHe
stTaxIjr+51kscPKFhV3fkKxKJFYhb0Y2eceusfd0QOmaX9VVro2Vk+xKeyfHu9BeMCBfR4f04AI
eCv077FfM1HgnnYDdqaadxcb4xIzUBgxJ2WeaYtd4nYNnSj99nVkZr8OKQgSt98T2lJURVjb6uKK
sKWtY66ZFFBZuek9I43a+HugU16tNp3u1r1kSMB/b3XNahjwYN0TokDNA51gaXK9/f6Yg6RJ0ZZH
lAZsfT9TE24Smq3EITaP8fELlVTe14+/RhpqQ2zIoYaVJYNZpO7VUnc4DfpXPElaCHoiuLrlARJJ
3JzKJx82uk/9jLq10yoMw01qKzj3DocDofw1XXyOljm8lK7IG5u1KSmMVkyvXVRaIJjEeirw5w3K
A6c+5TKzlVfknRRhwXJchYyH1LYvcuxEniBUPyYkqAktpw2JtGbuL8EsJl8Fq07rOyOm+QXieU0P
wq1wG53KUupoqVx9f7ZTARsL068iZnhX7zSRMr/iCZixMFLN4ZxS0+G5Lvvb44l5qBTA49potCeA
OmkvRVC0NPhGSAScEBrF1RbTr2lHM1x9PB2RCyytTq75bMBTD7oCUkOHr1NoLV4zUw6sIQLoCznQ
tu57HfMM2Z/Wp5eMQXoz24aNSgFmNgrR6b0g+YaNvCeaXJr1c/Gg1ucl/BdJMyJ3XaxSVTs9I7HU
qAyD2LcavRRVbB+VB4wGpX/QXBalvXQBdMUyOJ6o46ARAnM7Pcb24tdyPXJDzNK+gFTqvpn8LSiS
FIgH/hMOFtj2BHFCNGO9HR7xYi7i0R3mrx1rwV7sa6fcbTJHwf1nIKmhB5QJrmnD0TehLzGSd145
ufInlVjClrsyuxRauth9b/JhNjHJkdro/KF7OzsgZEDczadlXaM79peTWlewjx0f+04rgbhbG/Zj
FIgbT/MQWeUg+faRNOEE8U9WBunCv4HHX8wVNt8zlzI/+A0iw3WF+rKSnO/+7BUDfOmgsW5ljmhS
kDOT1dz6BamQ1Isiw1MUlfe8WxtKsqJejKCEWj69LU9DKwD8td+5fc0q6p5UgqrMoLhEN+nlU10z
naPiY3nSDkLIHHSSOVRgNo9/FERYsTAudVS5DC6euF1HHobPo7jyvjiyB/JeG0NEPOaN+/fwimzA
qI75H36HUoRrRl0r3KFclMzHEO9me/8WNZOptza+FG7kXcHKPhKVJzSrn8irzeH1E/tLcJgdU3Wi
OwJyFPwCNQH+yQv2OwxjU4X58na+TR3IH2lp9rzAbeOci0NRPOKXWvVV9ZDnlc7p2WnOnGSNiRQW
CZPfgNr0onpVE6q3sXoRdIUvPz4hpX/1r0iuQTB70bFqhfStAnxFIyYPyo87I7Nq5RZgaxlphjgJ
1Gy3MzRvxDYuMTCh0SBfItZTM1YuKBKtu1OHiPXZ6s/fi0MS/71o+YndcR8fvvlYdhV3+VL7exlK
Tf13ruDbF08oOOFNLH42SeDdsCnNZp1CfK/4mzXCp6Jhb6VOe/LjMOlcuHuZT1U/0yB25zs++rJV
/YV9vV6UoPO4pb4eh0VX09jaLi5GX42obpLo6/uMMM2wt2pOIv5dGUcaRIETTJB6rXsLhhiFqkrz
yte0vQT7CJL6xPd3uOuTUCVnF84aKfklZ36Xve4vIoUCm/sI9z1m7staJdPLTi2J0pWzvIUk1I6O
5whNjigYKlp3tRyBKdqhYZ1lN/B1pyi3UhU8uEfE2RphLAflqPjclTl7/ES7/uHLfoZXETDvU0rD
y+ung8jBvsxatD/FOBj7fPwquGidVD7QEHh6wwPCqZsDjzCSmMErty7nC9wjqAF3ZrzlNxdzDBeI
1hiTLod7+pc4NjeMXGMATowI8aEA48p4jpyp0pdpvIE9xPQng/TbBvQa4eDiYQQVjoQ9thvK8Zdc
ff6wVZfGgZFPwWEynP1wUe0kDFKYK3oVW32ZQE935KvttbkMr44fOhAC4/gE9lFqeHefcAdGdvAi
kg4ur59Yxp5gbOfqby87aKBVWrBEotOze8Eu/Xybj6W4ufF9wlcaAHMfglPces0Ay00WpxDLAQMg
lk1e61E+yp8kb763n/3vKd+HcvfEv6CDaujL4PMh/M6wS0mKKrR0uwlXxBtRuS5qCyRZ6ygMKGwK
YyXed/p0WrBwaQvMNkEWVUxh7gHhTpqU8V+jePYPIVQC3RlcWQ8iZ/RKDzEnKtLW1jYi9pp71WN/
6wEEQH9kX22aEq0IcBFBNA0epFRMPrsTbmrXLEUYXASXS5gTCWgpeHRuwtbV4hCAzw1i92Pmsw37
hnHb8vxPscePyNenx+rEw0htayEWzt3zGdQ0XK1Rd3aF2EthL6WWDSUXVBHiqQz4Gz7W8Fho/UkN
MyFs89do7ZruiuaAL35dKHeB6wk8Ion6+RUrtnc6LxeOMWnm2GMqc+7FLPgJSRigBT7bjAOsYIcm
k8QWFJQLZ05RUyoTg5XjLYXFGGsyGE8ZCoVJgjAAqx5yca1dj5KkSEUiIAvZArSS6k09+K21dWkN
dWeKv7+KrScVc0WzRl/N4WGOFvCYX1rW55ONAJhstAdyaZ+7s2AY54KqoTSGqD5bT6x2ERQWyL8B
xPn8PPqJBU+uKQgZdNx6zW6QOEIDfp8L3d3MxVo6dq7efhvhUgMrzNrtmF+inLpDpcd7YVGXDayK
mYsQA7za8MrLHqLptcSKTAM3AJnFvkTNt5IyKOyRwsASsdbdMOpsdY84LmygqES7y8nYN7JQxzVU
jBNuj9dhsvozJVTKPjn/zRWM2kqSeZHcVaTxm8DV1eEKcK1mU+ztDxLBf1OALD19VGfAobQxyQWW
TjajKQ8plkXULrenji+L/ArhaLQ90Y2D7bNgFqCnrrDqHiGWdXiMvoKs9b/9vRzID45mrjBN4zOX
yKishQAMaWIrWltoRLwGFEf298n16i7o8b84queHP8FEfH9xi9CH3yDqj2rTTzuU+4I8k0cpz4t3
h0M85INCas+Gjg2b5FdbrVPIZ0tINJSJT8tckpLB97Q0Qc+04sa8mYPtYXVi+YaRyDaH2BH1cFLi
lQJYONCkWGehLaucz+vZu7+D+PLZUJifJDzOzmae8q+QxaRX7bmAB8wh8PcXIce6eL4Ij1hFMH6E
31NAdW3UXD+/lCCDczSZThMPMfTOCx2RKR8gPgmZ1B5iLZGRuUvvJ0PRugnyyk/BlOkpomI/muS/
0+p5hQOkAf72r3TlyoDLhFlnYoSPrL0AAl+8PVw5GzlycTMc0jHGrIt07j/jVR4ac/D/KB6qdjtp
LWxTW0GlgLkEjF3ZHbG3lm4MBMao4oodV09NKBM3YxHRKB5VTWAe8uWTEaLG1kCNlx1KyUlx5N6W
vJ7qj+Gkqi+lm0pK38z+TUAR6pOvYdhDCxXWJ0MbuB7Et7CLhbxzdLNB/2LHLI6er4KMRhFMKpG3
KzvBxl1h7XozjsqlPsqUOgWgsIe60YWRpUXcuRVQFCrGvyYz99WeSEc0GuP2drLBYc4gSLI+5I0R
9crk3g2cXqG1aRm/bEEi6wZgoieBcU6Sp8LedZlvfoS6IKhT7DIED7AKnpUDgrZe4rE6neuwnJ6H
k2ZbDusRwrxV+Ahy0izbLX15Y4Ig27FAvZ7JSB/Zb0QtNrsW4nKNEWdRZBFRvf5qvszzS3g9c6j7
0GoVxdTXNZ4akOf/oQs/ace/ox01UNgdor+jBnLYh6XcHDGAo0bFS7qpkYjIaN9YZk23gdquWl2h
i4QpyRt5yfNQgLg5yInCx5OCUIGYBwfYaeY7ZvgOVTgspelsCBTYjwbXPH5cRo2tSo2ci3+TS9cc
IHIPmBWRpQj42dEUOZ8wSOGlDkrInW8a7o1azf6Nn17ZseZAX+esf6IA6f1da7X5XSfZng55+W5a
iWjsw3EpJet96VF9TuMkzxbG3Uten/Wy7sHj3nmmA9jbYjNMZ+3mKg8LgrMPVowYZ9ApqyBc5xTU
iVb6sq2JFoXqct4P/W6u4Ev41B7DW67eLpEVJQotofK3u0mqktFuyGmz1MzNO8iy1t8NshpNTC45
x7dZlKI4NDFuvH+80UsWVKz2HKOzhhc2MgjErzEzkT0o9lef/1Jc/NoezGHruDChUU/cfWiNzlVk
PMya9Iq4ifNp+Zh2FSo978OrB0yrQmwdbF2aAhgNF+h7kim8GW32UHnCdFbkWpjQCtJwWSDnbB9l
FYI4/oWXmEYMc/klvQKNb2Mg+Qfm2i96YDf+YQ7tn3UvDiPWw8ToyObBiqrgjPCUOPRCqjeH2DnH
HWMURfu6e1fhqK5AUouli9/VHB2+pTult7WpyhHUcu2EENNEFQS9kEGB0NDxF2nYw5nD6yA5izot
96/93I6D+rcvZyfjy7AwxlMrFo3GADL1ANNZVkkEf8opLBLBMMn7F6qkLRdOBgq7CPkL1OYoAQID
p4zO7qal5BqTol0qAnduxwMRRk/44dh54KYMcNDXouczUvzo9DCqF06CJp/sKgStlrAQG/JQ1Eqg
DP++YZ5SgUz62XOFO0WhiXc7sCe0MVTwylbOy620TpmfRtqQoJw1DCxAwRezZjbLbyMJHCHaVTzv
Rl5+DVC1fvM6NowkS0v7JAdG76f7w/gVxYuXYSMA309wDSUbolF6HT2hswj3rNSI1xk6DmAQCNtP
UtMhUdYIF7Ccl4LcLFdKLjijAtREipRjY3U6V2xleLToislSN8DRAsvUc3fDUEep+6dSEzo1t9AZ
DRwNibn+NioJTZPANjclEG+61TyYnIHj+9+76oeqXfUJAGDe5KiP0MGd5QXWLKx1VhTCOaHgXSNb
G+cN/ffSklp2g82Y5jPrsCstWZF4g1x3eSX7+xzOi4bazmujhE+4SOV2qS19tKIfthRubNQgIE+U
GF9JmhfQBxA2sZaTYM8+HcqVE6jkqEG3y6DmQrFNz2vbgRwYG0QDKepBXytCmlT4CD9+aOOA0M2Y
5lMGhqDMNgRh/ltxBREFN3gUdNbT+jfIKXKa9T17X6ZfBwcUlGj2VqJxhMPvz2MDuRX9RqkWD94v
oAynwqzB7RS0ZET3cdwAerFJkhd4mkSDhur14+RhF0Qie3J8B5ZTUTjSSVad2wuWJH9eRNKW6KtT
TvUCq9culy8AZCrQK5TUJrGfIfP6ZgC6KgsuyKuEYXEeAl2kaTm9kQ3XKGCh8kwSBu69bi8CjO3F
YiL1mdWPFpUlYk/v1ZDNpu7fUROdSPn0yt49bLI2XzA/4M0FgjY2sfCyhAySE8ZNB3GRCgzH3h+2
x0NglPZ++CPd/f3KudHadQc2yHD8gsTS139WBeUZR2vIV3ivFjqXtStHOX+XAKUQ20z7G+gFL5k2
AVz4yua3lkeFJlG4HCbyytjJOuGG+CjhIXA4rhjZiGvN4MWAyzYL0nIW/EGAPQHsssWv2dqdB+ax
v1uvK3UnzjXY+FfQisWZeczoWkJbmxYWhBgSaih04rDxKb79L4Bu111RuUOesByKBmFVjLkYkDKD
NVnA4WBI0viFBidKg3WGnfAVv0g87n8+r6PHhc5Ao2euxah7ITNTLWAdst+U6ebbmHCfPedRhYNC
omBB2mg01nvJptahQtTPu9Lm0hus7dQNhMjP/cai5DdK49MGUFzl+xAicIRIerDosSQFL424oMZx
jopxMl7TNAth0R9wx4mo2RyRuXIDsezj7vpiMXEsx+hZDwswAek+Mn/FuahFP/+LsOoCFngTdiJB
Zi+rzOBaFCQZCEkbadSHWeDaYYMC47nfQfxBHIo5zYPXFJiWy2/rXjpC5GI54frP9pu6P6PplXN/
HXyKxJRL2OR1a54jXV1Y34+cxAMUvWY107gCIQClBbOCie9z50VSWfMk+egxdBjW8x4WSThDOW5G
iSSLthw3/ITmOVv/vDKOEetU+am9956yw7QJmTUlxWViqsc9hwXb4IiVErHYX5+7/4S0Td/9Z4oq
cwf7aHHSn3Gi28tV6z8xI3pdHEJiR9txXA4OwcYTuuaNGM/SOQ6+z5nn4ZDzbteuXxwGOLnThmXR
cY1364KFBJNLu9uvUevSORjzZXx7J/kFcRr6qbz/PW7K4VXM8luzBQO2B+7UsG3durZXHCSkFt3R
HR3BpuIkxa9EE4wO8s84CVd6Rw6Ld2pQlgpBe8BKIEvZAddcKYbcNt5HimkfkSOe88AddvIX19Vy
c7GejGJKwjZVokrO5veSa+WkBGWjQ8grZIukwwGmCp9NlC8RzoUj56Zce+PQaNG3lA0YNLo0rE1v
nUH+ewCutz/R+ryWrE281daRj99Pf8IWGIs4ORkd2PvbIE+T/YvQyfBarK0usunSx4lWHd7pEeKz
1rWbUA8F7Zx6Y8uWAV5fU4NKOfex1LdBCZjA5ZtIwUdP7L9k3xtG/yDx0n6BrZrZrhscLokraKpG
VjAS2hH6hzCuVrIRrEon8zx29KesIJAi5KzoHZyzO30xwTk5hPATE5hI5+zszIfl5A/FtgXRpp7t
VVDL2HUgRhoDgrKJNwIvOn7WlcvAHTqNmQUEYvtXFrVqDNLg1dTJmpbOVsulzOJNd2j7js/SYpwm
UV3X62gEoSUbrIYSAWqYSJqAGTgjQN7OqkPVbw7sX3RSvFUQDjcYSTT1WP/keiBI/jE5CLApvLi9
9DaFXPHqCuutymv1FW72/zHQAX/TcQZQrexvpqjKYnTsTFxfTghcuWKtJX4fpSYQH5wZP4dC/iU7
dvd8H/PL1TmlQuKxd+Vdy21rdL9ILAEGkfXCxumKvJQ9LB26uVcnbzfFP2TuJg/z74hzcJFJXfvk
bVX2nAwpJmM2tmdf/stI8O3KC9jUJsrhiXLkebBxg9IhkV+/gM7LR5Xm7KkW53GlFv8fFuh8RpGu
XwMjkRJ2p4j/r5zbnSbVpFK7n8OivwguVPtIszCTrIBi1cafguV+zhUlCmf9mRJnqbNDG5bagv6/
l5Bsr5+a5l7KMu4/YTl520kDydVfCwwWMdYCzUdQVX0CM0gMc55OupBHMXF7JIpqldrm4bhKOI0x
OacsSip7QYAmXlP/5fIR7m6vDVCNJ9G4RKDMgROeVh3qvyXcxVT9T7XjQ50zohStNhdJh7fHunWk
ZqmAVQH0x8Qh3mUheo7v6ZjXqAN40SuTrVriC4dI4YpqkUm60ETEM+JMeiXNiYAI4Yi2Z2aQPqv4
CpwxPKA3WrqHVCbYQYzsmferEE0u9Uu9LV7tPwUVMTae8NZwMkjVhXAdhf/DNvyhBOYtqv7QLEJS
ko0yG4wBE8FJTQo8IHEm9xxfzITIioglFmKBY3MzZVUbkl1mK7Mp/tKkjknZalh13mPIwYjk8B1i
zfvbXfC1+5MGZhQEoafKun+ML6ejxtokJI52k5BFrpJFJ7zCzC2rNhEkKv8PSjc0ki6NOO1imhcI
cw5iIH4uXZ7qLkcTPGG9jmyF3FU3wjCjf45LLSuV1JjQpaaRZrcWWc2/X6RW1s7PYPh+3MO0P5FG
Ej01oBSZHjv2wSJXpfP4QimEt/Evg4JriM+XDiAjGiR+jZ45nePtxJjoFpRv7jAw+B/dccwYMV6E
iLYuBU+vuzj1A/dbNlwQuV6mhWcz74RV3yiCpsbWfGegKEwkZt/CEr49qpZTF4A8HBdIECHXmgdN
hS7tguiBQWywKea8nbc29Mt8LqC+mKyZHdm3p0Itk8Wh58xknfrn5j0g6vncd81Ko4f3FtnltqMi
wOjMGjcRcgxXr28JujwJjtQmS0CMvAVZ2dChy+T8pzr9W8KX+BV8KNkLYKexcfX4z1KO5T8lQk4K
jtfHCzRIbjcAa8pAMWfV7mHj+rTp2riPWG3orls52muxulZ2lWi3176pzU9yF9NV9Jr8lSgYsByo
YVUV1Mhd+76NuIDWCq/UmXPX872eMX+0+9gW5V1AgsmPjOeILaMZ7ErukxMT3k1S2wB4QQl6HCEP
UYnescblKoMloKOhlf1MCgtdIH7icRa/CAcjwowdN8OC9JpuScizPktImbhUr1EFWN0fS+esF6ql
JrvMr/rqI2LLHHDSyJaRAIAPbbhjl8CYxBTTR0CtXeggaBAo88M2Qj2yBS64fAlmCpVyGTYDN2uC
4tB3BI55ZhqutC6kE1uCkqGbdSMDdQUGmPNKuswcYHT5riW6kgJP0KFnGE7y4jMec5w0kl3j1tZi
gv6mEzjTy3QUYit7MgaJzHqdMGUL4fefwSqNwu/2xyttiSXUDzsT/fW7TtSr7ns1Spaxdh/gkufb
1CWda1lOvsaTfaZ+pLKEegIUnCNvaNBOxU7IoP3POZCf9F2r/YR6XBFJAKcrd6J1LGzUKgbv3Die
a3ZSR1qRq/8Cz5Txo6n4T2ig4iDSv0FKI/tHuz37+gTDlq6zKKR3VhxEQ8WxlriW1xt9fGXdQYVs
ffRJEf+stWxG0K8aMdGAwOjWbF/Vs2abIGee0JzOJSkSDpP0j+XSJz+Ral2lB+82hNtbi24UWsQ+
Xo1R1cN4iBDN9RTXg+kjuGgByCsCJCTkI/10UDqXkhYlZoOR4v0CTjsRi5kJXMx7eB9cQdpx5bm6
IEg9dfWhA2X8G+az8DBeL5rgJ/QXpd9DqZ82Mr4m37HTuZHpZgFbQPNBTpMQO4H5Qu4AZwDeLDYe
2NcyiP1sXvZ7M4Zm5NOKr8SpoyzZFUu7spnUUmkJxoSS5xnfKXKcP2XMKh2u8zYaKb6OGApGMrfd
pGwMukDylF36LtBZoLByQkEfRdGJ2b+oqF2lkR3Y9EABLkrqXKsrSM31kXw81w3Dk36+qpyqffYX
MjMFFzgKl6pohznUTL6k5OiE5nBoY9UFtoPsqvxTVOIngXXXYd4L9s2is2hAurvqdAoXAj/wn9oM
6b8lcsSJiIpgy+g+gGuq2UxwtfOcwCHsd0nZWU0N7WKHDlwQzA141YO76lcK/ApIx3QHZR+B1Szu
kL6RGftV7PQmVBqyR/C5QCGkDihRJLtia65ABD2F/jZTGbdt2HYdWx9SNOl+W38jNBzDJ2+XGJvE
Y+9LV/tiiPLUiVzAGgoVgtorkS0wf2X+ILP/T70ECLQWpqBeIOFM4B9P00cfHPzaUYK2TOPKnCme
wML7YLHEzqA2dSit+KAmk82uGs4LsxoxmP+0IvWXRXshCaQ8PaUGN8c/6LjcUvutmIbdtKDU3xB9
x7X9STSOjNd48PulEX6hjf4ZOQAb2h3driSLLWJE3Gz6xh0CAVoWhDrNuT8NF1DerA9XKp6OGZq1
OR5d5G/gNOyldmI+9eUrGwlemhXZPJfl0+XpqqT2QeP7mwX33BQygtGuzplkYnHoipTyDnl5I1zh
PQWruidULOIonvpdSZvy+EpPREGfj2WEASp2h9mqK5H5LPdCKJR7ZE+aYPZmtr6qH5MdGGgEQVWi
0ULwpqEYr0JL9N+hva0Z2qZU+Nw8vrbbbINRDi1xTjmiCCMUB4a9Hu33oC90C2+R9DcGPXkgjS84
bnO7S4V7DTRO0zYyqoR6hHIZ1BIysBHvpYtqM7FPvJwW0hqTzNrYShqY4y3BUaBpfpTC4gqvziwo
OaxHe/d9evz5jqqHsxR1zJyGdOVo7j6wZYEtKCT/I3FTXXyD6MuzXPZy1LtdEpvvs1j68bzcIqDM
akbHaM3nkf3qywU/uoZqXswOrJp+Xt3T46MxvgGYwCBjDsHZV6uOGxJLGH3SxtdwJ3tIV4jBShGE
HYHo1HVGqdNFc1///6M6aNQFlxBOq1IBv8sM2yNxIRY2kvjJ++7Ogo/WMJJR3iQxnYDMiqAcCZS8
q/cmwUvibOchs7+1TxzZyI26cNnzxx+OGgYiKktWSA44yq8SkEK9DVy3Rlbr8xAWzf1XeDy+Fq/t
GRQigVNtrh+iSxGD5bF0fd6uTJSM52uSE7VpDbds0C+Hh7TuITIiB/c3zyztPaANFN/ebEG9CrN9
NRanD8bqVwfaXgXKkFmh0yb/28p7uSfsescKnC4PHPPC1C5053vMNgjEtYTA5TTrmlgk7EqBmMD4
U6hutJvCr8io4WMfa6veI1qqSuMxDPMWRp2xmTum1b22zsw6cjTLIne0yO8FRwCaJcJcFRAWIube
qzxCOe9kJdgl11FvmW9ZrRXuWS6+aWHhJJR8duSUc+SC+IPwrv6mKS7MAumk6ZNtddUZjIHWbNEB
g1FpXetrzCQ6u5ZK5uY5J4wsoSCkMPCE5ZyIwgOBdztAA+OA7fmWEfMHJ3N+mjLj1Scv2qt0LW/0
Tu2dxvqCU/jyA+XitIS1keZAjhaBaagXCQfOSfZDbD8sQ4tFXCcyhD/e+SjC8ZyFNkX5hYXDWDjB
GNIS7J+vyrI4ZQc/Ij4CA3JPaOBnC2EB3HN2QpOiPJ0eXXNWri/FgXvFizXBZg5TVCA6/kM1Gifq
zzqpwZTmcruI6tLRyl6Ci8oJNAB13BXh8Z+O2Ax3uCVY83lz2z8/OWGQ0+c8hdXdCSl9G8kTBi2u
rP+dpwJGJpxdEdvLSqgwcDhhUm6BA8CyXGsKeQW3B+JQT7UbU6UZJaqFQX6pSgT25ssRvkragUdF
WQYUprDr6hRUT3x/rj4hqctXPrAsxqs9Vk7etOKJIRKnRD4VuzkuG/wfGTA0WApb2271F7uFPkbe
F/FbCn9A1o+JP0qhs3jmI6FubSQL/VrbTfFbSKEwcsi5FuB3RcBr/GbjiKZOhW8GyAcnaEsTDyPe
k0bltIFTHReYDRXTsDhUulPHUEV8PGt33zDFHsUzKYRWwZaAcKWxiXCyAaFOhR7MwUYb6WXldt1V
KJbmDgnEb2epDlIuSeQ/qbJsOI7scFGamgcPuHj4IHobVC2Pf9KMISU4sbPrrhjZ501LSswh9dDX
JVlRM/2p3h3xi5zpajimO0LzumthNVcUG8GQMg5ZxFvZI4TnCxyBX8iVvmgvznyZNNgM/ydC/JFA
4WLpk6ctBP/9Kkzvn5We60HRvigCVh5BBeJarvpVrJ7u02kPezftKxcX4arjTSss5oVA6iRU7+Jo
UcLTyBqKErayR3G1A991mydMfMupZVLYXdtur+ed/NSLey9WCCcUFL2elIVD57+W0wjPH5Vk3Wqh
vpC+3hZL41OOFiKtCmdR/G5TNBJRSxnDQQR0zNGm1cSsPBiqQq9DbcNFTjMPBH8i+rFZq4A4kplw
Kzz9S6CEa5k99B+hmyDIuvW/+sUI59AwOEXRP13dpu+jcjZsrq/TRu8MBaMQs0ipXyqTfcv/a88B
JWYFpQpNnF8xBAvlQAvDGgznkzDt71SdmJtj5LOE5NiRRRS0m6S2YHMapquFx7/aaxQixcTl4dJc
ISRCx6SM2M00qO7Jm9AysS7FSZzcWmaK0EDzpF9feBTcG4jN3OzxzcPNvLKpJIi2tElxGiMCOCBO
H4xWyouB4sI10Gj0QGp2bLCjSqYLxId/Rt+30LzbbwkwbnNBtikryXIF+TnN4S6SevVzPoXYQK5T
ZxIqJAMo5CjBaXAOjDkLPWBoCcmLOv5PWgVwfer0vBhxZ7Ss7BlV973TQ8bIz9gencmwrsb3/d7t
Wc2JoyrZH0mD7x46qjwq5968qicT2qZcJEzkgmsAQGsOOvYpd2hpObgamy2FRp1YXWMim4W0VtzD
LLS5UDXoRrSxFkzBrUYGRrp+zzEuVFlzx5p5L/ylpTBIFVrF2Drq3ji2U+rJI+VLLUF6TdBcmNt4
ofA+FXZINWSXsOA2LE+H1CMfSxt3xjQugRu0EORZ6rDb/296MA6Ot/PEWF2Guz0wM/H9ZF+y+mxd
8v/xAWBjxCqvg593kSBcYSxaxd1zU4PQ5lfdupeYaVbeAVf9cinT4SyHG3sfGswDfTxVlD2NBORr
9NjdeRfFEasw3lVtcyCQ44wwhzysUg+zFG6xZf72sqkpNIX7IAlf+5FrPwoCr+saPyfgOcgAVYkg
pwjCCeSxGrllHxqFnPkXM/WTTQsLO+4EUESkg0EM1aXGgPvrNB+Ptq2ALjepZ7ZsVO2tEgaKSOsN
wrbyGEJKoXM4unwrm5vqqlNnf9RbtBzvm16x0globbw44a6/jsp6M+yDWBkGq+cn7yirVvGTtdoW
Od18pc7uICUHYramfwPhMGMRmzGrBbFqvU5ArMTRUyeTiECRwxlwUy43JRenaVp9Stp6VgEtEZ65
d9o5XDdjnKfU/Mv1iixA2DHlMbyYyhiMInvb1gyyn3CpDo88LqBe/c6xPPOWgudPQjblGApPiH4d
QzT+OemKjJtZuOMya36WqW3oLYHLJU9CUFMZkR1a/Mw8WDY4wgv0YdVqC7iIC1zlXgSFx/mq1EE1
w2mEwl8UfSj/ru5LxOA9P7eQBQo5U3M81VgyqfdH63KtdlIHmCwJ9vI2d5sGvpK2pvVOdkTvcoaR
wOB5n2t6j8eoSIqnrgwZJTvzoOcqx0q17cKtffDDn9ZQIL16vPX1LW9OO9O8SfHH8mE/8IURON5l
YtL4AC/LxMIvAH4DOIaYXutqzC2iZ5UPPHM2i1zO6uNcjYNcY1X7nNU+Wq+70Rojt3woAAMJ2Cc9
QMe6DGupGgrPMHXiznUrMJJt7ET7MvXkeLw7D7sAF9+Mq80WCRbBzwIHtpwxkNe0WYxnUHr6EDQQ
lFhWSqHowRiLZIi1rYSVNneotIT/0PIRuW/LIfcIi1F0zv3TUbD1GjwnMffqcYzQHbT5ugHmjpHL
sq44hzA9kWoRSGtP3BEcfBQkT6zCMGMvchEdMTcnvRRNAAXKGtvVQ0M3GPwp1SNxQ0L7/ClbVSzw
HCJ+6wSLOaraylTv9a9tvW+eb874qNgyAdW9PO17y9HqOPxpQLIa/Oj1uv+yKdezccboCzdPrc45
rPsTbFValcZ3IFWl0etG6R30thCdfQ9UtJHEyX/vZH4JC2QlXecASdc5yEdcU356OIBKiXU3hTO3
qmxOCeFerXR7JowIImDvBXkamMOPxua/YuIrr68NRaY0Fx0jaNYB0cbAA3RMeq/NKcG8DJIijMU7
e9Oi8Sxar+REUzMASqXTmTuASDqwFNtxCMOUic/TDV73JlI5kKgoIVWd61BxWmJ95X0vdMJzcZrz
4p9N9/LvSOBsRfQZ8BHt//bsp64ZyMjIR1TMdkKCysSdTAACCV2RQPxKykgiOC7S2jfJFUsFcIbS
RSSrVeLQdp/uvEXec5Dw7u/iaAdIMPaLb5SlYl5Ixg2Bwgf9fFavDiHsF+AzdlsklnaH0DxZ0+T6
rd6saXkwvz4fW0Sp8Rpfav8p9PkdQIeXSxWY4wQbGbrm694HCfTV5kIXmEYrFQz3T82Z21jfqN6U
QgoqGZU08oEevO/8EXXuVrlP2+lp0RSIDkTyPGg760i76WMZ/N7C2qu+RJATF+8yOu1SgAnALwFT
EGa0UBRHDm/+2dWwAJ27UPdpqEPVOw9hn9d5qEGL4CpDIeyH8Hsg+Gzs4z+lEpgf5R9cDZr+TyGQ
F0XTJA8ccVyhEwUkt36M9NnnJUcZ0IcpCyLSh9F3OcLTPOH7hYwbEe4kuEFmU/fnyYaLGppPqDVf
aHvUXCxlE/5gfWgN5W5DkRsATnSxshi88d2cwH26QB8uuA/MiJCQEU4wGi23srkULHamaz1guAQz
TaOBzP3k9eYebXWnuO0HNm3jKxkF0uvzx6f5Ccbtis7DtiW2tM1qhNFClWFyXi9QPjPELkYsNF0Q
j/nYLpinKutDK70Sl19RdOY/RuJisr9tRQM97fILkV3FZgjvhk3BU3Z02M1+bfsdnhI2mjbljIe6
uWvK9xG2YzAWIqGesLIry4zv7NzAcb5FWfCvl1Q9qfhXUY4n4eB1SeDb04ggNXPy86on/DcMaTo7
Yc/GJtf/8Fo1LQkiYGFry3439IB/EuoEr0yvwMTUgwgIlqciqXjBxwXAadg70ke4vccOE5rvkFcg
EDtrSmQbS/oyNS+S3noNkXOJ30we2NWMCaHR3LtQDwHr10kmxQuwJd47EglyVKv+WGQqQHoujPi5
0JPmMRN7RqR26EeiUcLYegwBmZidDK21c1RgnA1UKHd2n9hIovqSxhBsHMJ7XN0zXpk72F6RNXk6
fexWH10SHGNAQCuzH+sQv4utckgcQmdrcgwbnwV8UIs6S/G76ArOkdSi5+XlyqsHqKF+CNcWhbPf
QgOhCYpXaitXGcEV1uotnXGo3UlDiazUH+nCZ5s+3QBv2To2i9/RzOtrc5p2MNsu/2RA19PKAO//
2Osk9P9qOaqurHvfFyp59wGPgW2h52jlf46s2kQBR3R2IknylYZPoZDGmFRFpF+5ZuO4qKqpnnhK
BcpfYypq99tD5InLdkaFL61FQRHHVGviTQTrUscZnGt99jcz98YRd4x+zlrHQPtWcv6oAHTjd+dZ
Wh6Vuvs4DG4mTW34bT142XJlGqNWROzAI3V3OyL4C6ZuPPgARbUq7odnwsqgbLoMxcQY7J8uGLt7
zsq9/b2dbdvdq6bOGT3eX0IWEeY1f+9xWtmBkxOpXA68uuKHjv9WknYGOXESf2jaSGyRCWN3YBFN
quOWtCuwxPsPe1eD3UpvqldfOA7Z8oX7hHASGP93SRHVLEw55jSmF+X99g2BZ34CYAb9MNDrwQaz
CgP5E0NroUDXB9NCysO10IjB6NTRLKEe6QmFzYyDwCf2wnTvKzbEi1Nrpjm00qUrZKsbv0JiW1ge
GYNLsTEkF50s+APIUKZ17tOyoTmur6QRy6bvCC8ACxp/BUQ3onKTxMsHVzJLSCCkipO12d/0nJP+
jQmaR/bKiTxWaQjK7dWfRZpq54MU2F5WP7o6PW861OSu9rsdwDQpzF50Rt+rSCM9i+JVNn+SLdkd
+I9nx2pxcZj5LWaZmy6B97tIIEKoBSLgqMA24esLmgvf32yh/+TYoqA9Z8dau0KDQovBs7FkLM1s
df4hbd4wwZjTZazUHxusYLEpTzMRvRwtHqzE4Lh+y74umQL4HWjqQWtPwDRsvqRQZZx/OBlZKXSw
+YFYfvC8OWBaiqRlehg1Sk7f1VzPQycXqK8m34YbXrI+D9ksuMzJP8+DNdxoOqCDXjcDUg1ZEa+F
CP88jy3cfEkAfnvyyEqE/AS3GgRmWrwgQ5zOGBwugtKwvluVmCLmuqm7nF/VpZIInpZMNm57dark
DTGC6Elr6+qXbmnuIwhi7SXH5HYXofV8OLB87H8D+gv1qg8Viyeil+utDHH49sTzCn8xCf9q0KWA
VSVbumxvLCwteImuTXgWgAAh5y/Qs/KLbNsTJ61dW8OOUfCN5rnAObGhKzdfMyCpJiYmpqsObHlM
2R5LxFIeKVSWset7GZn6uypvMat1qqQQAFN3x0+hAx3MDuCEtij31m1kzzcOV2Ufr3Mm8vrvm5l4
Fft2wPqM/1V2W0d1Y/G3Vn4NhQYd0/OBg9tU4kut7het+N8sLV6Iv0F8RrShNg3dwdkTdbBURBo9
zRqhI9mTo7RSZXbJy4rsudT5ooG8SJKX9cdF2OmTItDS1m+GcQU3jtGM7+e7RGPVklzwQNSnHdoi
wTtCBoWGvofLTW+pa1wz47QH73tfa4d6aSa/q3JTdvAaLL+80WgvaFRiAxVfwbtkPwe21BdPDebS
ibjZTSvK12cW4McHsW6AyiJTFPaVWD3TwTiPFRFG4jYmMFbc/I8hEev90T4vTuKkpA7uKwJ8tADG
iHU96naHk9OzKm5hWOGxnD7q5YeVEHmGBo1OsBIa684rIY+xYSHbe6js/Fvz4w09kCMimI/JoHNG
OWLCat2k3gk3O5jOPXagbth0wtFXRSLWS8uesGeVR2dfI3CyyZu/TbZ1vjGNBK2ec1NQphEJta69
H5hnBXPItvqHgQeXxFWvqCKb7Besx7L2Qk+Gpr4EKdtt7oto3TECuqpNGxD/LTAQGvYYOmd/zAWZ
X+5fFLgYJjuIhGjCvbQLlpfjRql3qClIgn9DNW9KpAraic7VJPQ0UO8ZL0ws7inJKpWZXPDyflVM
NKtVqsPaiS3QmDs5DUzKlabXiChyvm9xNnnsxEB8Kj6RkDlyZMhU3aasWeM0CuTEe3ptbbD8fUDz
7ujAEmqMkr3UxoOTCucx4VKhYGcB+eqX3BNr5Cf2YzowMq3Alz47E/UiHhFJQ98YUQlblakkVNVn
PdWoIZjHGhv5LN+oxTJDT48wgmJsnwlYrQ/4MgYMxL90TlRjiut00EJbivk/9B2yX+ZTzr/8Nd26
6/8K90UBafup1i0aGt2dkW4slTg31ZGOuhg3NNcMsi3HR2uhcroGIoANVrOeSk/897w+G0vOguZO
ihz3JhPOkaogKggwMwtZV2jV3DrD1+CvBPyU+xucZPHKWH32fSO7eXlIlu2bJVT3wxxyGmdgdHxD
BntZF9gx7F1qoo1CjC8SKySP/2lunIq2vn7ggoz5RjhL7INOWyXY2n2GDZbFfsTa9mYBwMhLsXZJ
W1Lkeg090GRKpq4ZH+A5QB8c7EY+p5yn2qrGIYR2Ay5IlJFzYGw5FN7NaucDfUFn1iy5QFtjDb2j
IsP1PNOyUu0jLCGk3I/aLLk3KlxPgzmuf2JBI3mXyVrIQfZNterS8oRgZeotPqzH8uRXfRUlQW0W
DUwFKamF6ze1Rdz+v4mFDl4mrZU0iwNiRTzGZd4EXI0j76OIDTWESLfgN4gs43aN2DQfTktHUNCg
HaT9zehYlscn3MYiIg5IpcnWoFi5gbnZLmoGc7JzONG/+WNfW5KOXvinbatyU2r6K1aoK2LKrqxx
bCjmTNvD6iCX9D8ynoVgBtOZ2qjNNhRa6wnwhoPsFn0UDMVNrfNpjxy+eVDpO1x+PVbHhQp0ihgq
XBzW/TWkKo19P2ZJLXQnLqvOxQc00ph9hj/rVzqQ3m3+Tmk8Uw+PoPN3K2+fzQnRfHkD5i9fR6zm
5lRng2YAMdSHtG4AS3GjV0GKFPt+reLXcOlQ14tKzDsIDIB/d8JIh6LUw1odbBv+Z1yCNfvPIEt4
pZE9tlUtT9394Vf6QmNYjAIKl/H9gQG5skft++oGXhJLOwCFP0ZAh/w+Wpob/CJAx50Lam+OSHzX
uexgWwWnpTU/Q4XZai2/BGH8bXt95qvw/2cHhtVGXXzAFgMKZGOkiuKG//ng4Qvl8aldqxjZ5HUX
TcJeoE7wxHiQGmXMBEvK9ulaFgGH8SVnqvI9QZLoo+odK7VaixRxTBOWDrdPj1FMXYzY7WtcaM9B
uEu7KwHmH7GfxMhlSqxjmdjtg3TQIFixG5SzupNSCA6lHoY5V3DWDTf59TWuhiiV0tUiHqUgHmXz
YjSok3jZ3HW0fJ82fEyBHJVdZAI5C2OU1ibmMkfBcSYIDfas3XrJ8gHn9hxZIxoWEjL6bjem4PzT
Xy/0IG3798eV7090gl+DbPG54UFGNz6AeTfhYefdfarDe712n01/MdX3NI5l4te+jcgP+dluStJH
8ZG2L0wDwQl4Sd7J5umZJGnlYmRF/YWKcm7EJ3IktcS22GIXPrvc6vY53M+N3Rqk8Ex5cZXquJTE
Njyj6w25q5I+fTX2CIyCOcrCBH5GxTJcJLx3vkVU2+lqUvv+Akp1yuGn+kN36B6ZDr+AGicL3K/j
ws6l789ynu2NF5HkmqPDWyDT4MtUAWRClbABiGFZ9G9+nAMKg412CbEGyMNvs0daj1HBgaQDk9rb
k4HJuzOaVIeFjeM0pdzbTdSwGdhTDf7uIgVDliNCi0ixdLcoRrvZVXduEBB1mNsjTJlxYwmtZ//Q
hf00jObQgjt/qepUPf6PdAnsuFBloB9XN2gTABwAMUPoCikyctibvaJ70KXGe4Juf4jb9STydpvc
dzkxuirF2sptxdUXOVuqZgHPJMxypkLK5gwJISOJ5tRIJ4qCu9jWqDlvPNsP0AwqpWHd68M5eErl
VuGnXqm8UzW4GjQDxIU4lPp2SfDyatZn8WitFTqicgPA5hOnWPl3C93GJCf0EUX6P4rm9pVW8gIK
ZDNSGhN92vf28O3pEQ/1P51Z6hiBfNVF1Ajo6+sPEoBvhNCv6AINIgNgfwKwURKxwG2k0OYNj8zd
TuBeUp7sZTh10vrsyFh0RUxDC1elje+VqKygiTXpA4XIAbvR8z6jjOWtarm1nN5X73mPbcSYonz9
RnOgdDHOtY+d1dEdregMqJtbcDo/ZEBxf7FNmI7niWht/BTnNO+FySiyBJJHtbIm/gzDTdeu58jt
WlNUu/nXP2WAVqTZrnmai8vrd88pfvghLoFy4FxIOpmeIQEzpjESxKQspFxfnZSsBgOcBGdXC6yy
ujWl0E/4yJnXCOiRRW+7uTX6keZvq5K2o19aBg2R9pAF+DLS6puSlh6qLrHeElwjWHYuVZ2jOgXJ
/PKF82EhgoEXlMCmS8qpzFY7zca6WKI8gCMNlDMjxNKsWarZFhy8oke0ydCPvLlcm8+da2nk7OQR
s54+0eGeJNnU4DQhmddG1exnBHAUZYbYUo4FoxV64Wg0uCUKaUaP/CgfS8AaGMmPvLxYNLUzDz/g
uvYMtxP23d8xnYFjBdKnutB7cQmvWjhA0ErCgGMpjrusPdf17cf84vk42CBbiYU019/C7PPmTQt7
1npC4Nt/qULuLRGe1zr3FR/FNztgYxI8zrw0SDnWbZah6V3yVyT4eEv6mx0C1YOQXQBB7VhiGENS
1jAFmfYz8DVJF8mYiUOvMV11Lwr66OVSY1krHa6xIaQJf3+Z5LUMGf4rgnBb0pKMs0Rgm/J4q6Ak
yupJAq3sIbO5SxcXbIHApU0WECCi8U4Fy5rZ+Afpy4qcaRMkJj5W+hDcIasJiHi2wCMFsEe3zKU2
1bXAyYWwLQIFMAHRK3WscDTPHAGOEszCBpRnvagkQasefUGA26kCebb3d2mY4kYc4aMCsi2rMba1
ZxbVZuzbASSCC2FRIuLbqBOLCw7JVSrIW3y2mNl/SMkq7LRRfjegksyYDpSfc9O7DFf2iZJIvfkJ
+hJPZYQiILaL5mvibFcPIaZu4stFgHpgo8tEo+eYqSjU/cBvTdqu9gCh36i2rzK+cyaSNUMMPeF0
S3ACkGhyp3IcJgXIJcsf48rsci8b8rp587Zk0ncj/YM3tBwsPUvbr3AV0Ol6QI3OK5MOBGKJiHgD
dnsEO4QecJRrAC0b8XIse9Et5e8WnNX1mbf3N8HZaXrWBA4Es0yhk5+zpMfdxJXWCzzmvlQPR/VE
vdDrogjOURtKukC5r7xUzbAJRSAh3iNKh3uOf5FmFmxfBECWD5Fe5m8C5hW8Uc6HXpkwW+xO9OuX
Fb8LKDolrYhGOakYz56EWmUHoJy2e/bn4X2m53GHxrpSuNE/pRfIvRjFSe+DCXm2AjWBig3IW/E3
vf4iBm/TwUAJBKx8ZuhMwLsAopboCIyebbOGaNU9vUP4SCoY8GWH1lX3bdZpQSeW80cXmEqTArIU
VnNLoMV+MsEpyoja8+Dw3Ie6w+sWi1BGY83EcldyIzwPFQSLczlwbayUyQJCcI0vssCfM8TicrFr
nDg0s7FFaalJpo+QIKN64L23PVu8gH2MtYW6JIS/TxHgpJZmjR5GLBqXrIAslzdsuY2+nVeg2TxK
iONfUXnP4HBTbKKNdFKJDOQUryLbCIMUsMOPkQROM6Pb4C80EXUQIFm+OhA6EuGs5ptX4EA9IVhX
bpGALMRA3PcBer75562BFpmywj8AwFMV7cTpqIuRpL+RY4Jj4HKTr+MA4pulQl065hnnsXF6P52t
1G3UcpgRxAsF8K4k8lQIypTdEjJzwwjWcOg52Uy0aHQpdl86nZuRZp9ER/DCtVzeHKa1sZeKsj6L
QpPfAfk698z1eoufX/E4cB1LyBuz2TSWqgMQB/Cvs5QQ2UTeDLix2TNDVl9shhdzmrLTl1dtPCJf
ymvKEIgwB4ABogcaT9hZTPJoT2fUtYddunMoCfKsnTX+xisbGSJPbOL5xVr2XkgP3dBEiwTSQ1iC
doK7N3fgReBst0CFOHWCzVa4el8v8uYjdq/niszjVLgMwdXcyknaNH0LjvvbKyoulgVuvF37YjR/
klLu7AeFv2tL7rW4P56MTxHZfkN+IQZFBNC8WE4z1HVJVkLt8lUkHxg4wNvGAt3z0shvgsSZJ3xq
AotakO+wONiGPL4FWB76OHu8UsBKyMbv7gpZLkmM0TgNd5ECUa4lCYD6lRf0IFvTHZFi9VPDvQg/
s7la/e1Bbv4X/vMLMCvyNbhualdAb5ztXP9G0if9DipeAqjRn7Yx/i9ePUX+8pF1AUL0HOhBSAtj
xJvPvRssUZze5N3veV6H1lrFw6B2l7eKQM2301pE2rYGLJPo/bqUAo381VRQ+EG9zUd9cMNmQC6M
K4pNRp+xT/hS83BnU4tHm3U/ZtCDUbeVeG8GKXjux7HWNsKZj6mkTOASHT8FyeSBQ59FbosQn6ni
5A7z1Xtr+HhM/ma14i0CKcgKn7LzKGIDkC31dAL2hkOL3PENFJThPHAYmLwJ7WqE5vwSVW9/ilcR
juLXr9dzbwWqO0L7cE38kVJOyrpVgmLdisIBHMvq+/tUL/A21X4yCGjyaaqmHzEs3ldyEjxFoS7q
rC9y1cKCAB3QAr8IHlZoNwiR0PIkKMd5diMfFPZ1P0RbnVw1lG/9lWx1VMNS+Zi/Qh0tNdXyB320
kk6UsmHkDocaQMXDEr+07vc9QH2kjqzpB3my4FmxlhAC1D8XS2Kh8vpSUjc0VaYjxPm/ivS9B8VK
XoPz0ek/Emy5kMAeqSzjO8RkdWR8QaVs8nSeUoZ+6twDg9yGoTBc0+ZZ+6r1Deq7P8rXCl41t3zY
mFQyoRwCAjOwl+1ZVp0xvqpQEH01A/2CGhuVxvlJu30onJfLVYBqqr2LiO9s9GEGSCQ5uOrVoiOW
c7VKd7h9j7bui/q3c+oYzd1J2cQstJSuKiLmw6NeX6bN3kbk/MFYfZAUqgmjiUocyCxf6S5UE5dX
kX8kNd42EM9wYibMzwKsWh1zk1eL/2/yB/cfJAu5qginJzRUDbXltsQvoLsvxmq2TQZG9qQZEelW
MrIJEvHPXB6HWj7hqfH01uVfgCgT0+ZGWI5OYf1uZsRAg/84ZmfnTxlmOWlsNbBQz3iVceEHZLkC
kCZz5esvODS7Uk6T1/EMCt4uuXSW2+CcdtyevmO/6YVvQq97BT/mPoo+6kHkRT8LDnhDYJxrijOe
9prG6G8BHKCiVis6VerXJ95MdkAGBZfB2oBxVeWZVuFZzyjW6za7fSjZMTAIH82PKcScIDmtIcxw
LPZKlKok0vlNszkcylhA8AzkqJGwWnEGLLvMZog1EqF9Q+avqse7kqHDxTaFr6MCa5CRlYN+t9b5
LzClFT+CrgDVGLeomerJbwjuLXnpBSC0bRCrkOTFpuSWK8bug3yhtHT6ir6RdKDxp3UK3K4jf6i1
vfoAyKUhiqrMp6cU3nJcZX+Np/DeaJUcNGyZGKOxvW2kuBckNa1nPtdcWkoUCExFvD6Kh4/xNUHy
+8OyBwEhQRrGRd2bPkjm4GFLudHzTv3oWJX8S8hiW5yPD3DrcSFqlpGfBMep3gHYC52m8wx55FHq
PfiNS5H+aQAo3eT+caVyAXVQxGRxa8gZ/9tonICt4hqZpLVCRGdTgQT90VSbKLkYsx8sJe0nDCI0
vbP7BhDAL8GgLFI+79cJuPn15cgbQb0ov2+dEpaB5lFxCXIJoGjipDCD/k2KINqBFRWiHQojQPA7
O+3OrT7nc8lC8p/vaVQ840+qxfkif7LRUyYVu6VzokBvFsTTDsmKmstfSBewjBdBjp2Zv5OiLyGI
JAq2FBSMY8kg9R+lcqnZR3p6uMWEvHYFbeOhzjK3HwRGx5shFCTeuv9Um4pUrzqgueOduloselLd
BTqwra8K2O/CkbDWjRLxKO8spogstgKowWJu1g5X216W6IaDbB59tqTVlEzAK2HQ2bxWaPOQTrtX
ptVLs9kaO6kdrUsl0tzyeI/DXhRj1Pv39un/81B/qfZo2IWAUjoMQibOJBZ1ZyHC6syam7mu+fE1
+qnJI3VWgcOx4QboKhUY+1QTIx0s3gmkuRA/30f2wpnNyCcgk7bIacoJHfA8/Ukjaicl+BYKWDZm
Cpvf6ygAd6ATOGh6lptoI6lFxBLfCPq/hIwZ+klRAVqLjWT4jpTW1j4th6nl0Voak2+gzsmkEHls
mq08nL/gF9Dv7MY8OVm1FnGJX+bdtnspaGJtrA/mLcNE4P9DgJH3OxnjoDOC85Jl6WvWirshVd5F
26Tco0eouAFKDZ4vRz0UDstC2+LNQbHUCTvLPiWehsVzRVZv1LLY717n9BJbUMT7jKZTGRnITcga
rIwVYxPh5vfFvU1wKVPeif6llIkb+xh7TDKsiUPUhgJTtehWPHVUrC1pAik2zuMJ9N1JLCEB980K
4Im5YJ1FFgUTuNuvDBpkeMewlTlMJzBxSSQLoKf6Uiyx/I7+762iOl6wzzbX5qwYvQYbzQplngvC
eP/Odp5ooRfrePBGNuRSSPhO4D6ilce0wrfR05t85O5pJx3Rr5UyQ9THMFKe2u0vr6RaSnYBqLMu
6nH97yCbo7crNtJpQ+Hu56I+vY0hLH2/RV9d4hkql72dlKYhuXgdI0RwBzaORPYVkrmF1E2YHHSS
LUnwSWQjIFPHgvldGHgYgvO8W1n9ll0qUHoXPN8PAU4KZ0PTSL7tyuwKq3dA7VhP9bIKeHq3yGIe
EA/P2PTQcqbkeGeY6tvTTQzRZXmzu31JlDxGhsnl1i+u3oRzf69lhMBPpy7XMfgeQPJO0lVrOgs8
6o43ifhGKioYpVKn1xbdx4DJuqpam94RWaEfeyc7QRwi+o/1p9d2ajBckHUqtqC6Rvx5bFx0Ubeg
JqwblGy8K7YyuyFNCpm6UFyn1T7mEUnXRJrxt4JdxR9WPF3o1vM+F5IvJXF7AmvDPXgkcMYk4036
yG5tRNBxo5XgehoP04DkPzQPHk9UnJlRHKdh90Xxr+ZbM1cohde9s9dpV3N18bsPhmbWqu3+JfUq
KZkC6msfKQrb/Gx6wHeei9enpvcIdwjUH7SiisQw6oruiHKenD0DhMNt1Uq6mhfLZRHQLqEQfOYw
ZNjQnehzsEQMAgdGvrLrIbh8PCBRBvwnj27PmYAnE/G4yC8wtfH2q4G9xAidUvOf6Nc+ML4f8d4m
MowiE9F6DZivbVXoYjl0Nww87yvVDQTNSJOYmNr+x9rSushyY91ugn+kr9V/1oof+wN+curOjppy
OwTQys1I2r5Mn3pXZzk0vIzfqBWnJ4/UX39IQktSE3MUYciT9WOoHkOHS0hAHYJaJ7oxR2SybuEs
Rfg+T+qyu7FrZWsd1eJK+UILHwiL3GkSdROAmrhb0ryonmFpwCO/0y6l2dgydqry6ZU5Ea6myKUU
//3w57pAZEPpQJdXDW+1XcV8aLzXrgoQm4cWA0WVVZ6+2ldFpTw8B0v9n6UG2mfq9aaL2UpzSRRO
m6u5sVOdRpxtfq+YEBVJgPKHSEQ4QTJaUgSxtMWewEkVqHKn+rT76AVB3hTNcAZO/u0QYmGJyItn
1YvRDgEsmozRguefYgDMzKemXq2xogUIM/GN7djGM+nWyq1U+20yY1texkUs9b6jBevbvWiE3pUg
oRKHB2nqaUSKTdj6zFMzhz0H673rKR7Al7zuXyzVnADUggxpwIxibCM0vZ+VZ4n50cx9kc7rPmIu
E/82sWgSCEcN1vNVkgupL1h/D7i3X+m5CTcr+hYnXJopV+pw9p0dyQN9GGhYkBtMzgreFeHClq9s
fWDwGfmSm09z/62BvvNEtOoVdRhH7wXuOQRJrMfWDfScb0KTeoHF5aFPIMnk5tLo0iChO1sv1lRs
mFrqvC1FCUw0tgY8jyHb7K0zrut3vcAIzE8CkM+FCsvjPc3ySl2AUCXPdIz8zE7NGK1teuS4D/8q
0c3ipdY6RiUCuUeze+LPzNmyE96i0cXOVJ4Qrc8j9M0qbkghGPaWIzkVg+aECztQvdsdnMtF1aDd
2rx4ZPA+4P4FZj6qOGZDGVPfWXok0gFFTOE+PIJZ9ulAcnXYupGGW5mxt/MJZKvn8XtQx+jl+SQa
dbbaIQtzkFidISAOYXpGkhkLljZsgbYvvLh+xzDRmYzVxhPuiH382E6KzzpwWErROo7GJfLDMCGW
A/dXgQTENfx1MiGcII44H/FmmpiE6g1XDSGHZbKAAuXkbQ+4AQbFuo+BA9r6raqkJn1LmGi0f9lG
r8feFZj7CZ5P2DwsD15/5QkQmNXiK7qY1oY+jqjOib8aB6Vr7N3ji2pOeQ5oLmewooU4SF7g18Vo
sG5z93YTU77+FE8EzD0GgX2i81KuF3++cdOKXxWxvfT5kI/RyiBOpty7v32XbtQr31og2z0xkasz
KGGW9TFNiL4I7caWi1vXGgFi6v27ulkScEcGgYUs+urIyFBBDh1QJoQGfLEK8SMDrmOa7NsZFZCb
s0p/xSeHl60K18+BNn33HIx3SjDkDEKsIDZo626ZoiKpKGeWjCzYjCyUrVmrRYEmWT15E2iXhphF
F6P44uzpHSX4yRMqO/nWyYNI3DMOieHN7XVbj7Thm+gZateb3n2Kbx224Fi/UVm4LVihvJ8MEwlm
7qYwAlXSsxp3ybqND2fj57hFwWlkHJuUL2l3KVH0cSEnE+0HiKRmE/RqXjkBvISL2sJLGf3ChFyb
cl3PfPZVSaA0gxE0cDaVz96c0DDXMj/KSx59JjMKIttH5pT9BG7keNHTJbAAvE2Wi/VerH82lJPg
HemYhNr9tsON6MwYiH4SPnKdMPXr5ZvbrbT7pop9akhp80K8d+p8iE86XyG51lZFRI61iv6RC72s
fKzghCmAPVP8DKdA0nlOH3zv776+xZjL9FPy59YcZukJZlzM4S5PX9gqxbtXRWultwhF5ms//J7b
Ugv9wQfV8r7Q3CbtXoCUb7nK1MdhwIfbOTla+GRhk76ChsE9fco4nLj3zWh3rqW2ToUWIxl9e5yR
kai2VCkiMnbCdvounMWdslLeofuKqwelrUAxlMe0mOW2EBQi0W/RFF1or5EcuvwICsbnbl1OG9MA
uynydAq965pOST1g/HsLYxga/1BLaCzd4mFPX2zWJH9c9IKKyScYyDjV/qILEb4jMrN95juNIDXd
N+GZKZnZQQCUGSFnhA0q2I7m25du5PIx5rYXPRqRq4Dm4GitnkISeiB7ABArW2sL8D75TSYZaw==
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
