// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
// Date        : Sun Dec 21 11:38:32 2025
// Host        : nanaka.davenet.rocks running 64-bit Debian GNU/Linux forky/sid
// Command     : write_verilog -force -mode synth_stub
//               /home/david/gits/adventofcode/2025/vivado/aoc-2025.runs/clk_wiz_0_synth_1/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s25csga225-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_25MHz, clk_50MHz, reset, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="reset,clk_in1" */
/* synthesis syn_force_seq_prim="clk_25MHz" */
/* synthesis syn_force_seq_prim="clk_50MHz" */;
  output clk_25MHz /* synthesis syn_isclock = 1 */;
  output clk_50MHz /* synthesis syn_isclock = 1 */;
  input reset;
  input clk_in1;
endmodule
