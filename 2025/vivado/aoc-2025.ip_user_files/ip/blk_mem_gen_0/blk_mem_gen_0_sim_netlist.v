// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Tue Dec 23 11:21:49 2025
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
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [8:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 28016)
`pragma protect data_block
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
fYkpdElxnQzbWoX7JLat1olZyez4GsYGiAkAPrI=
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
