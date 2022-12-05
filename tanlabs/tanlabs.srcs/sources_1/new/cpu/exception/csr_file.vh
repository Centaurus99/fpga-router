`ifndef _CSR_FILE_VH_
`define _CSR_FILE_VH_

// 0x300
typedef struct packed {
    logic [31:13] pad1;
    logic [1:0]   MPP;
    logic [10:0]  pad0;
} mstatus_t;

// 0x304
typedef struct packed {
    logic [31:8] pad1;
    logic MTIE;
    logic [6:0] pad0;
} mie_t;

// 0x305
typedef struct packed {
    logic [31:2] BASE;
    logic [1:0]  MODE;
} mtvec_t;

// 0x340
typedef reg [31:0] mscratch_t;

// 0x341
typedef reg [31:0] mepc_t;

// 0x342
typedef struct packed {
    logic Interrupt;
    logic [30:0] Exception_Code;
} mcause_t;

// 0x343
typedef reg [31:0] mtval_t;

// 0x344
typedef struct packed {
    logic [31:8] pad1;
    logic MTIP;
    logic [6:0] pad0;
} mip_t;

`endif
