`timescale 1ns / 1ps

`include "cpu_pipeline.vh"
`include "exception/csr_file.vh"
`include "exception/exception.vh"

module cpu_pipeline_id (
    input wire clk,
    input wire rst,

    input  stage_t in,
    output wire in_ready,
    output stage_t out,
    input wire out_ready,
    input wire flush_i,   // 当前流水线需要 flush
    output wire flush_o,  // 请求当前和之前的流水线 flush
    output reg [31:0] flush_pc_o,  // flush 后的 PC
    output reg flush_branch_o,  // branch 的 flush 单独给出, 优化时序
    output reg [31:0] flush_branch_pc_o,  // branch 的 PC 单独给出, 优化时序

    output reg [4:0] rf_raddr_a_o,
    output reg [4:0] rf_raddr_b_o,
    input wire [31:0] rf_rdata_a_i,
    input wire [31:0] rf_rdata_b_i,
    
    output reg [11:0] csr_addr,
    output reg [31:0] csr_wdata,
    output reg        csr_we,
    input wire [31:0] csr_rdata,

    output reg trap_in,
    output reg trap_out,
    output reg trap_type,

    output mepc_t epc_w,
    output mcause_t cause_w,
    output mtval_t tval_w,
    
    input stvec_t stvec_r,
    input sepc_t  sepc_r,
    input medeleg_t medeleg_r,
    input mtvec_t mtvec_r,
    input mepc_t  mepc_r,

    input  wire [31:0] M_Interrupt,
    input  wire [31:0] S_Interrupt,

    input stage_t exe_mem,
    input stage_t mem_wb,

    input wire[4:0]  exe_rd,
    input wire[31:0] exe_alu_y,

    output reg [31:0] btb_pc_w,
    output reg [31:0] btb_next_pc_w,
    output reg btb_jump,
    output reg btb_we,

    output reg fencei
);
    reg  stall;
    wire flush = flush_i | flush_o;
    medeleg_t edeleg;

    assign edeleg = in.PMODE[1] == 1'b0 ? medeleg_r : 32'b0;  // 是否将异常委托至 S 态

    assign in_ready = (out_ready && !stall) || !in.valid || flush;

    assign rf_raddr_a_o = `rs1(in);
    assign rf_raddr_b_o = `rs2(in);

    // 数据前传
    logic [31:0] rs1_data, rs2_data;
    always_comb begin
        if (exe_rd == `rs1(in)) begin
            rs1_data = exe_alu_y;
        end else begin
            rs1_data = rf_rdata_a_i;
        end
        if (exe_rd == `rs2(in)) begin
            rs2_data = exe_alu_y;
        end else begin
            rs2_data = rf_rdata_b_i;
        end
    end

    always_comb begin
        stall = 0;
        if (in.valid && (in.cause || `opcode(in) == 7'b1110011 || `opcode(in) == 7'b0001111)) begin
            // 中断 / 异常 / 特权 / fence / fence.i / sfence.vma 指令, 等待流水线清空
            if (out.valid || exe_mem.valid || mem_wb.valid) begin
                stall = 1;
            end
        end
        if (in.valid && (out.rf_we && out.valid)) begin
            if (`rd(out) != 0) begin
                if (`rd(out) == `rs1(in)) begin
                    stall = 1;
                end else if (`opcode(in) == 7'b0110011 || `opcode(in) == 7'b1100011 || `opcode(in) == 7'b0100011) begin  // R / B / S
                    if (`rd(out) == `rs2(in)) begin
                        stall = 1;
                    end
                end
            end
        end
        if (in.valid && (`opcode(exe_mem) == 7'b0000011 && exe_mem.valid)) begin
            if (`rd(exe_mem) != 0) begin
                if (`rd(exe_mem) == `rs1(in)) begin
                    stall = 1;
                end else if (`opcode(in) == 7'b0110011 || `opcode(in) == 7'b1100011 || `opcode(in) == 7'b0100011) begin  // R / B / S
                    if (`rd(exe_mem) == `rs2(in)) begin
                        stall = 1;
                    end
                end
            end
        end
    end

    always_comb begin
        btb_jump = 0;
        btb_next_pc_w = in.next_pc;
        btb_we = 0;
        btb_pc_w = 0;
        if (out_ready & in.valid & ~stall & ~flush) begin
            btb_pc_w = in.pc;
            case (`opcode(in))
                7'b1101111: begin 
                    btb_we = 1;
                    btb_jump = 1;
                    btb_next_pc_w = in.pc + `imm_j(in);
                end
                7'b1100111: begin
                    btb_we = 1;
                    btb_jump = 1;
                    btb_next_pc_w = rs1_data + `imm_i(in);
                end
                7'b1100011: begin
                    btb_we = 1;
                    case (`funct3(in))
                        3'b000: btb_jump = (rs1_data == rs2_data); // BEQ
                        3'b001: btb_jump = (rs1_data != rs2_data); // BNE
                        3'b100: btb_jump = ($signed(rs1_data) < $signed(rs2_data)); // BLT
                        3'b101: btb_jump = ($signed(rs1_data) >= $signed(rs2_data)); // BGE
                        3'b110: btb_jump = (rs1_data < rs2_data); // BLTU
                        3'b111: btb_jump = (rs1_data >= rs2_data); // BGEU
                    endcase
                    btb_next_pc_w = in.pc + `imm_b(in);
                end
            endcase
        end
    end

    assign flush_o = flush_branch_o || trap_in || trap_out || fencei;

    always_ff @(posedge clk) begin
        if (rst) begin
            out <= 0;
            flush_pc_o <= 0;
            flush_branch_pc_o <= 0;
            flush_branch_o <= 0;
            trap_in <= 1'b0;
            trap_out <= 1'b0;
            trap_type <= 1'b0;
            epc_w <= '{default: '0};
            cause_w <= '{default: '0};
            tval_w <= '{default: '0};
            fencei <= 1'b0;
        end else begin
            flush_branch_o <= 0;
            trap_in <= 1'b0;
            trap_out <= 1'b0;
            trap_type <= 1'b0;
            fencei <= 1'b0;
            if (out_ready) begin
                out <= in;
                out.valid <= in.valid & ~stall & ~flush;
                if (in.valid & ~stall & ~flush) begin
                    // 来自 IF 的异常 / 中断
                    if (in.cause) begin
                        out.inst_type <= CSR_TYPE;
                        trap_in <= 1'b1;
                        epc_w <= in.pc;
                        if (in.cause == EX_INST_PAGE_FAULT) begin
                            tval_w <= in.pc;
                        end else begin
                            tval_w <= '{default: '0};
                        end
                        if (in.cause.Interrupt) begin  // 中断
                            cause_w.Interrupt <= 1'b1;
                            if (S_Interrupt[EX_INT_S_TIMER]) begin  // 进入 S 态
                                trap_type <= 1'b0;
                                flush_pc_o <= stvec_r;
                                cause_w.Exception_Code <= EX_INT_S_TIMER;
                            end else begin  // 进入 M 态
                                trap_type <= 1'b1;
                                flush_pc_o <= mtvec_r;
                                if (M_Interrupt[EX_INT_M_TIMER]) begin
                                    cause_w.Exception_Code <= EX_INT_M_TIMER;
                                end else begin
                                    cause_w.Exception_Code <= '1;  // Unknown interrupt
                                end
                            end
                        end else begin  // IF 段异常
                            cause_w <= in.cause;
                            if (edeleg[in.cause.Exception_Code]) begin  // 进入 S 态
                                trap_type <= 1'b0;
                                flush_pc_o <= stvec_r;
                            end else begin  // 进入 M 态
                                trap_type <= 1'b1;
                                flush_pc_o <= mtvec_r;
                            end
                        end
                    end else begin
                        out.alu_a <= rs1_data;
                        unique case (`opcode(in))
                            7'b1101111: begin // JAL: x[rd] = pc + 4 and pc += offset
                                out.inst_type <= J_TYPE;
                                flush_branch_pc_o <= btb_next_pc_w;
                                flush_branch_o <= btb_next_pc_w != in.next_pc;
                                out.alu_a <= in.pc;
                                out.alu_op <= 4'b0000;
                                out.alu_b <= 32'h0000_0004;
                                out.rf_we <= 1;
                            end
                            7'b1100111: begin // JALR: x[rd] = pc + 4 and pc = x[rs1] + offset
                                out.inst_type <= I_TYPE;
                                flush_branch_pc_o <= btb_next_pc_w;
                                flush_branch_o <= btb_next_pc_w != in.next_pc;
                                out.alu_a <= in.pc;
                                out.alu_op <= 4'b0000;
                                out.alu_b <= 32'h0000_0004;
                                out.rf_we <= 1;
                            end
                            7'b0110011: begin // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND, ANDN
                                out.inst_type <= R_TYPE;
                                out.alu_op <= {in.inst[30], `funct3(in)};
                                out.alu_b <= rs2_data;
                                out.rf_we <= 1;
                            end
                            7'b0010011: begin
                                out.inst_type <= I_TYPE;
                                if (in.inst[31:25] == 7'b0110000 && `funct3(in) == 3'b001) begin
                                    if (in.inst[24:20] == 5'b00001)  out.alu_op <= 4'b1001;  // CTZ
                                    else if (in.inst[24:20] == 5'b00010) out.alu_op <= 4'b1010;  // PCNT
                                end else if(`funct3(in) == 3'b101 || `funct3(in) == 3'b001) begin // SLLI, SRLI, SRAI
                                    out.alu_op <= {in.inst[30], `funct3(in)};
                                    out.alu_b <= `shamt(in);
                                end else begin // ADDI，SLTI, SLTIU, XORI, ORI, ANDI
                                    // 这里面的指令在R_TYPE种的相应指令的funct7也为全零
                                    out.alu_op <= {1'b0, `funct3(in)};
                                    out.alu_b <= `imm_i(in);
                                end
                                out.rf_we <= 1;
                            end
                            7'b0000011: begin
                                out.inst_type <= I_TYPE;
                                out.alu_op <= 4'b0000;
                                out.alu_b <= `imm_i(in);
                                out.rf_we <= 1;
                                out.wbm1_stb <= 1;
                                out.wbm1_we <= 0;
                                case (`funct3(in))
                                    3'b000: out.wbm1_sel <= 4'b0001; // LB
                                    3'b001: out.wbm1_sel <= 4'b0011; // LH
                                    3'b010: out.wbm1_sel <= 4'b1111; // LW
                                    3'b100: out.wbm1_sel <= 4'b0001; // LBU
                                    3'b101: out.wbm1_sel <= 4'b0011; // LHU
                                    3'b110: out.wbm1_sel <= 4'b1111; // LWU
                                    default: begin // 未知指令
                                        out.wbm1_stb <= 1'b0;
                                        out.rf_we <= 1'b0;
                                        trap_in <= 1'b1;
                                        trap_type <= ~edeleg[EX_ILLEGAL_INST];
                                        flush_pc_o <= edeleg[EX_ILLEGAL_INST] ? stvec_r : mtvec_r;
                                        epc_w <= in.pc;
                                        tval_w <= in.inst;
                                        cause_w <= EX_ILLEGAL_INST;
                                    end
                                endcase
                            end
                            7'b0110111: begin  // LUI : rd = 0 + imm
                                out.inst_type <= U_TYPE;
                                out.alu_a <= 0;
                                out.alu_op <= 4'b0000;
                                out.alu_b <= `imm_u(in);
                                out.rf_we <= 1;
                            end
                            7'b0010111: begin  // AUIPC : rd = pc + imm
                                out.inst_type <= U_TYPE;
                                out.alu_a <= in.pc;
                                out.alu_op <= 4'b0000;
                                out.alu_b <= `imm_u(in);
                                out.rf_we <= 1;
                            end
                            7'b0100011: begin
                                out.inst_type <= S_TYPE;
                                out.alu_op <= 4'b0000;
                                out.alu_b <= `imm_s(in);
                                out.wbm1_stb <= 1;
                                out.wbm1_we <= 1;
                                out.wbm1_dat <= rs2_data;
                                case(`funct3(in))
                                    3'b000: begin  // SB
                                        out.wbm1_sel <= 4'b0001;
                                    end 
                                    3'b001: begin  // SH
                                        out.wbm1_sel <= 4'b0011;
                                    end
                                    3'b010: begin  // SW
                                        out.wbm1_sel <= 4'b1111;
                                    end
                                    default: begin // 未知指令
                                        out.wbm1_stb <= 1'b0;
                                        out.wbm1_we <= 1'b0;
                                        trap_in <= 1'b1;
                                        trap_type <= ~edeleg[EX_ILLEGAL_INST];
                                        flush_pc_o <= edeleg[EX_ILLEGAL_INST] ? stvec_r : mtvec_r;
                                        epc_w <= in.pc;
                                        tval_w <= in.inst;
                                        cause_w <= EX_ILLEGAL_INST;
                                    end
                                endcase
                            end
                            7'b1100011: begin
                                out.inst_type <= B_TYPE;
                                flush_branch_pc_o <= btb_jump ? btb_next_pc_w : (in.pc + 4);
                                flush_branch_o <= (btb_jump ? btb_next_pc_w : (in.pc + 4)) != in.next_pc;
                            end
                            7'b0001111: begin  // FENCE / FENCE.I
                                out.inst_type <= I_TYPE;
                                case (`funct3(in))
                                    3'b000: ;  // FENCE = nop
                                    3'b001: begin  // FENCE.I
                                        fencei <= 1'b1;
                                        flush_pc_o <= in.pc + 4;
                                    end
                                    default: begin // 未知指令
                                        trap_in <= 1'b1;
                                        trap_type <= ~edeleg[EX_ILLEGAL_INST];
                                        flush_pc_o <= edeleg[EX_ILLEGAL_INST] ? stvec_r : mtvec_r;
                                        epc_w <= in.pc;
                                        tval_w <= in.inst;
                                        cause_w <= EX_ILLEGAL_INST;
                                    end
                                endcase
                            end
                            7'b1110011: begin // 特权态相关指令
                                out.inst_type <= CSR_TYPE;
                                out.alu_a <= '0;
                                out.alu_op <= 4'b0000;
                                out.alu_b <= csr_rdata;
                                fencei <= 1'b1;  // 需要重新取指
                                flush_pc_o <= in.pc + 4;
                                // TODO: 判断 PMODE 是否有权限
                                unique case (`funct3(in))
                                    3'b000: begin
                                        unique casez (in.inst)
                                            32'h00000073: begin  // ECALL
                                                trap_in <= 1'b1;
                                                trap_type <= ~edeleg[EX_ECALL_U + in.PMODE];
                                                flush_pc_o <= edeleg[EX_ECALL_U + in.PMODE] ? stvec_r : mtvec_r;
                                                epc_w <= in.pc;
                                                tval_w <= '{default: '0};
                                                cause_w <= EX_ECALL_U + in.PMODE;
                                            end
                                            32'h00100073: begin // EBREAK
                                                trap_in <= 1'b1;
                                                trap_type <= ~edeleg[EX_BREAK];
                                                flush_pc_o <= edeleg[EX_BREAK] ? stvec_r : mtvec_r;
                                                epc_w <= in.pc;
                                                tval_w <= '{default: '0};
                                                cause_w <= EX_BREAK;
                                            end
                                            32'h10200073: begin // SRET
                                                trap_out <= 1'b1;
                                                trap_type <= 1'b0;
                                                flush_pc_o <= sepc_r;
                                            end
                                            32'h30200073: begin // MRET
                                                trap_out <= 1'b1;
                                                trap_type <= 1'b1;
                                                flush_pc_o <= mepc_r;
                                            end
                                            32'b0001001_?????_?????_000_00000_1110011: begin // SFENCE.VMA
                                                // nop
                                            end
                                            32'h10500073: begin // WFI, 视为异常
                                                trap_in <= 1'b1;
                                                trap_type <= ~edeleg[EX_ILLEGAL_INST];
                                                flush_pc_o <= edeleg[EX_ILLEGAL_INST] ? stvec_r : mtvec_r;
                                                epc_w <= in.pc;
                                                tval_w <= in.inst;
                                                cause_w <= EX_ILLEGAL_INST;
                                            end
                                            default: begin // 未知指令
                                                trap_in <= 1'b1;
                                                trap_type <= ~edeleg[EX_ILLEGAL_INST];
                                                flush_pc_o <= edeleg[EX_ILLEGAL_INST] ? stvec_r : mtvec_r;
                                                epc_w <= in.pc;
                                                tval_w <= in.inst;
                                                cause_w <= EX_ILLEGAL_INST;
                                            end
                                        endcase
                                    end
                                    3'b001: begin // CSRRW
                                        out.rf_we <= (`rd(in) != 0);
                                    end
                                    3'b010: begin // CSRRS
                                        out.rf_we <= 1;
                                    end
                                    3'b011: begin // CSRRC
                                        out.rf_we <= 1;
                                    end
                                    3'b101: begin // CSRRWI
                                        out.rf_we <= (`rd(in) != 0);
                                    end
                                    3'b110: begin // CSRRSI
                                        out.rf_we <= 1;
                                    end
                                    3'b111: begin // CSRRCI
                                        out.rf_we <= 1;
                                    end
                                    default: ;
                                endcase
                            end
                            default: begin // 未知指令
                                trap_in <= 1'b1;
                                trap_type <= ~edeleg[EX_ILLEGAL_INST];
                                flush_pc_o <= edeleg[EX_ILLEGAL_INST] ? stvec_r : mtvec_r;
                                epc_w <= in.pc;
                                tval_w <= in.inst;
                                cause_w <= EX_ILLEGAL_INST;
                            end
                        endcase
                    end
                end
            end
        end
    end

    // 写 CSR
    always_comb begin
        csr_addr = `csr(in);
        csr_wdata = '0;
        csr_we = 0;
        if ((out_ready & in.valid & ~stall & ~flush) && !in.cause && `opcode(in) == 7'b1110011) begin
            // TODO: 判断 PMODE 是否有权限
            case (`funct3(in))
                3'b001: begin // CSRRW
                    csr_we = 1;
                    csr_wdata = rs1_data;
                end
                3'b010: begin // CSRRS
                    csr_we = (`rs1(in) != 0);
                    csr_wdata = csr_rdata | rs1_data;
                end
                3'b011: begin // CSRRC
                    csr_we = (`rs1(in) != 0);
                    csr_wdata = csr_rdata & ~rs1_data;
                end
                3'b101: begin // CSRRWI
                    csr_we = 1;
                    csr_wdata = `uimm_csr(in);
                end
                3'b110: begin // CSRRSI
                    csr_we = (`uimm_csr(in) != 0);
                    csr_wdata = csr_rdata | `uimm_csr(in);
                end
                3'b111: begin // CSRRCI
                    csr_we = (`uimm_csr(in) != 0);
                    csr_wdata = csr_rdata & ~`uimm_csr(in);
                end
            endcase
        end
    end

endmodule
