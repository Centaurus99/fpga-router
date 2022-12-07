`ifndef _EXCEPTION_VH_
`define _EXCEPTION_VH_

localparam EX_INT_S_TIMER = 5;
localparam EX_INT_M_TIMER = 7;

localparam EX_INST_MISALIGN = 0;  // Instruction address misaligned
localparam EX_INST_FAULT = 1;  // Instruction access fault
localparam EX_ILLEGAL_INST = 2;  // Illegal instruction
localparam EX_BREAK = 3;  // Breakpoint
localparam EX_LOAD_MISALIGN = 4;  // Load address misaligned
localparam EX_LOAD_FAULT = 5;  // Load access fault
localparam EX_STORE_MISALIGN = 6;  // Store/AMO address misaligned
localparam EX_STORE_FAULT = 7;  // Store/AMO access fault
localparam EX_ECALL_U = 8;  // Environment call from U-mode
localparam EX_ECALL_S = 9;  // Environment call from S-mode
localparam EX_ECALL_M = 11;  // Environment call from M-mode
localparam EX_INST_PAGE_FAULT = 12;  // Instruction page fault
localparam EX_LOAD_PAGE_FAULT = 13;  // Load page fault
localparam EX_STORE_PAGE_FAULT = 15;  // Store/AMO page fault

`endif
