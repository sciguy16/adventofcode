// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Sun Dec 28 08:27:39 2025
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
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
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
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
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
