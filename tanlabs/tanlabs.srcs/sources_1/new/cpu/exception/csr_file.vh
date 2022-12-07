`ifndef _CSR_FILE_VH_
`define _CSR_FILE_VH_

// 0x100
typedef struct packed {
    logic [31:19] pad4;
    logic SUM;
    logic [17:9] pad3;
    logic SPP;
    logic [7:6] pad2;
    logic SPIE;
    logic [4:2] pad1;
    logic SIE;
    logic pad0;
} sstatus_t;

// 0x104
typedef struct packed {
    logic [31:6] pad1;
    logic STIE;
    logic [4:0] pad0;
} sie_t;

// 0x105
typedef struct packed {
    logic [31:2] BASE;
    logic [1:0]  MODE;
} stvec_t;

// 0x140
typedef reg [31:0] sscratch_t;

// 0x141
typedef reg [31:0] sepc_t;

// 0x142
typedef struct packed {
    logic Interrupt;
    logic [30:0] Exception_Code;
} scause_t;

// 0x143
typedef reg [31:0] stval_t;

// 0x144
typedef struct packed {
    logic [31:6] pad1;
    logic STIP;
    logic [4:0] pad0;
} sip_t;

// 0x180
typedef struct packed {
    logic MODE;
    logic [30:22] pad0;
    logic [21:0] PPN;
} satp_t;

// 0xF14
typedef reg [31:0] mhartid_t;

// 0x300
typedef struct packed {
    logic [31:19] pad4;
    logic SUM;
    logic [17:13] pad3;
    logic [1:0] MPP;
    logic [10:9] pad2;
    logic SPP;
    logic MPIE;
    logic pad1;
    logic SPIE;
    logic UPIE;
    logic MIE;
    logic pad0;
    logic SIE;
    logic UIE;
} mstatus_t;

// 0x302
typedef reg [31:0] medeleg_t;

// 0x303
typedef reg [31:0] mideleg_t;

// 0x304
typedef struct packed {
    logic [31:8] pad2;
    logic MTIE;
    logic pad1;
    logic STIE;
    logic [4:0] pad0;
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
    logic [31:8] pad2;
    logic MTIP;
    logic pad1;
    logic STIP;
    logic [4:0] pad0;
} mip_t;

// 页表项
typedef struct packed {
    logic [21:0] PPN;
    logic [1:0] RSW;
    logic D;
    logic A;
    logic G;
    logic U;
    logic X;
    logic W;
    logic R;
    logic V;
} PTE_t;

`endif
