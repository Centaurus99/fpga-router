`ifndef _CPU_PIPELINE_VH_
`define _CPU_PIPELINE_VH_

typedef enum logic [2:0] {
    R_TYPE,
    I_TYPE,
    S_TYPE,
    B_TYPE,
    U_TYPE,
    J_TYPE,
    CSR_TYPE
} inst_type_t;

typedef struct packed {
    logic valid;

    logic [1:0] PMODE;  // Privilege mode

    logic [31:0] inst;
    inst_type_t  inst_type;
    logic [31:0] pc;
    logic [31:0] next_pc;

    logic [31:0] alu_a;
    logic [31:0] alu_b;
    logic [3:0]  alu_op;
    logic [31:0] alu_y;

    logic wbm1_stb;
    logic [31:0] wbm1_dat;
    logic [3:0] wbm1_sel;
    logic wbm1_we;

    logic rf_we;

} stage_t;

`define opcode(in) in.inst[6:0]
`define funct3(in) in.inst[14:12]
`define funct7(in) in.inst[31:25]
`define rs1(in) in.inst[19:15]
`define rs2(in) in.inst[24:20]
`define rd(in) in.inst[11:7]
`define csr(in) in.inst[31:20]
`define shamt(in) {27'b0, in.inst[24:20]} // 只有SLLI, SRLI, SRAI使用，
`define imm_i(in) {{20{in.inst[31]}}, in.inst[31:20]}
`define imm_s(in) {{20{in.inst[31]}}, in.inst[31:25], in.inst[11:7]}
`define imm_b(in) {{20{in.inst[31]}}, in.inst[7], in.inst[30:25], in.inst[11:8], 1'b0}
`define imm_u(in) {in.inst[31:12], 12'b0}
`define imm_j(in) {{12{in.inst[31]}}, in.inst[19:12], in.inst[20], in.inst[30:21], 1'b0}
`define uimm_csr(in) {27'b0, in.inst[19:15]} // 只有CSRRWI, CSRRSI, CSRRCI使用

`endif
