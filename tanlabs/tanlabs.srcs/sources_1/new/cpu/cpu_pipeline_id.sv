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

    output reg [4:0] rf_raddr_a_o,
    output reg [4:0] rf_raddr_b_o,
    input wire [31:0] rf_rdata_a_i,
    input wire [31:0] rf_rdata_b_i,

    input wire [31:0] M_Interrupt,
    
    output reg [11:0] csr_addr,
    output reg [31:0] csr_wdata,
    output reg        csr_we,
    input wire [31:0] csr_rdata,

    output reg trap_in,
    output reg trap_out,

    output mepc_t mepc_w,
    output mcause_t mcause_w,
    output mtval_t mtval_w,
    input mtvec_t mtvec_r,
    input mepc_t  mepc_r,

    input stage_t exe_mem,
    input stage_t mem_wb,
    output reg wait_wb,

    input wire[4:0]  exe_rd,
    input wire[31:0] exe_alu_y,

    output wire branch,
    output reg [31:0] new_pc,

    output wire [31:0] btb_pc_w,
    output reg [31:0] btb_next_pc_w,
    output reg btb_jump,
    output reg btb_we
);
    assign in_ready = out_ready || !out.valid;

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
        wait_wb = 0;
        if (in.valid && (out.rf_we && out.valid)) begin
            if (`rd(out) != 0) begin
                if (`rd(out) == `rs1(in)) begin
                    wait_wb = 1;
                end else if (`opcode(in) == 7'b0110011 || `opcode(in) == 7'b1100011 || `opcode(in) == 7'b0100011) begin  // R / B / S
                    if (`rd(out) == `rs2(in)) begin
                        wait_wb = 1;
                    end
                end
            end
        end
        if (in.valid && (`opcode(exe_mem) == 7'b0000011 && exe_mem.valid)) begin
            if (`rd(exe_mem) != 0) begin
                if (`rd(exe_mem) == `rs1(in)) begin
                    wait_wb = 1;
                end else if (`opcode(in) == 7'b0110011 || `opcode(in) == 7'b1100011 || `opcode(in) == 7'b0100011) begin  // R / B / S
                    if (`rd(exe_mem) == `rs2(in)) begin
                        wait_wb = 1;
                    end
                end
            end
        end
    end

    always_comb begin
        btb_jump = 0;
        btb_next_pc_w = in.next_pc;
        case (`opcode(in))
            7'b1101111: begin 
                btb_jump = 1;
                btb_next_pc_w = in.pc + `imm_j(in);
            end
            7'b1100111: begin
                btb_jump = 1;
                btb_next_pc_w = rs1_data + `imm_i(in);
            end
            7'b1100011: begin
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

    assign branch = (btb_we && new_pc != out.next_pc) || trap_in || trap_out;
    assign btb_pc_w = out.pc;

    always_ff @(posedge clk) begin
        if (rst) begin
            out <= 0;
            btb_we <= 0;
            new_pc <= 0;
            trap_in <= 1'b0;
            trap_out <= 1'b0;
            mepc_w <= '{default: '0};
            mcause_w <= '{default: '0};
            mtval_w <= '{default: '0};
        end else begin
            btb_we <= 0;
            trap_in <= 1'b0;
            trap_out <= 1'b0;
            if (in_ready) begin
                out <= in;
                out.valid <= in.valid & ~wait_wb & ~branch;
                if (in.valid & ~wait_wb & ~branch) begin
                    // 中断, 此处实现待改进
                    if (M_Interrupt[EX_INT_M_TIMER] && in.PMODE < 2'b11) begin
                        out.inst_type <= CSR_TYPE;
                        trap_in <= 1'b1;
                        new_pc <= mtvec_r;
                        mepc_w <= in.pc;
                        mtval_w <= '{default: '0};
                        mcause_w.Interrupt <= 1'b1;
                        mcause_w.Exception_Code <= EX_INT_M_TIMER;
                    end else begin
                        out.alu_a <= rs1_data;
                        case (`opcode(in))
                            7'b1101111: begin // JAL: x[rd] = pc + 4 and pc += offset
                                out.inst_type <= J_TYPE;
                                new_pc <= btb_next_pc_w;
                                btb_we <= 1;
                                out.alu_a <= in.pc;
                                out.alu_op <= 4'b0000;
                                out.alu_b <= 32'h0000_0004;
                                out.rf_we <= 1;
                            end
                            7'b1100111: begin // JALR: x[rd] = pc + 4 and pc = x[rs1] + offset
                                out.inst_type <= I_TYPE;
                                new_pc <= btb_next_pc_w;
                                btb_we <= 1;
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
                                endcase
                            end
                            7'b1100011: begin
                                out.inst_type <= B_TYPE;
                                btb_we <= 1;
                                new_pc <= btb_jump ? btb_next_pc_w : (in.pc + 4);
                            end
                            7'b1110011: begin // 特权态相关指令
                                out.inst_type <= CSR_TYPE;
                                out.alu_a <= '0;
                                out.alu_op <= 4'b0000;
                                out.alu_b <= csr_rdata;
                                // TODO: 判断 PMODE 是否有权限
                                case (`funct3(in))
                                    3'b000: begin
                                        case (`rs2(in))
                                            5'b00000: begin // ECALL
                                                trap_in <= 1'b1;
                                                new_pc <= mtvec_r;
                                                mepc_w <= in.pc;
                                                mtval_w <= '{default: '0};
                                                mcause_w <= EX_ECALL_U + in.PMODE;
                                            end
                                            5'b00001: begin // EBREAK
                                                trap_in <= 1'b1;
                                                new_pc <= mtvec_r;
                                                mepc_w <= in.pc;
                                                mtval_w <= '{default: '0};
                                                mcause_w <= EX_BREAK;
                                            end
                                            5'b00010: begin // xRET
                                                trap_out <= 1'b1;
                                                new_pc <= mepc_r;
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
                                endcase
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
        if ((in_ready & in.valid & ~wait_wb & ~branch) && `opcode(in) == 7'b1110011) begin
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
