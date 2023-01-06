`timescale 1ns / 1ps `default_nettype none

`include "cpu_pipeline.vh"
`include "exception/csr_file.vh"
`include "exception/exception.vh"

module cpu_pipeline_mem (
    input wire clk,
    input wire rst,

    input  stage_t        in,
    output wire           in_ready,
    output stage_t        out,
    input  wire           out_ready,
    // 本级流水线不支持外部 flush (访存请求无法强制刷新)
    output wire           flush_o,    // 请求当前和之前的流水线 flush
    output reg     [31:0] flush_pc_o, // flush 后的 PC

    output reg      trap_in,
    output reg      trap_type,
    output mepc_t   epc_w,
    output mcause_t cause_w,
    output mtval_t  tval_w,

    input stvec_t   stvec_r,
    input medeleg_t medeleg_r,
    input mtvec_t   mtvec_r,

    // wishbone master interface
    output wire        wb_cyc_o,
    output wire        wb_stb_o,
    input  wire        wb_ack_i,
    input  wire        wb_err_i,
    output wire [31:0] wb_adr_o,
    output wire [31:0] wb_dat_o,
    input  wire [31:0] wb_dat_i,
    output wire [ 3:0] wb_sel_o,
    output wire        wb_we_o
);
    wire request = in.valid & in.wbm1_stb;
    wire stall = request && !wb_ack_i;
    wire flush = flush_o;

    assign in_ready = (out_ready && !stall) || !in.valid || flush;
    assign flush_o  = wb_err_i;

    assign wb_cyc_o = request;
    assign wb_stb_o = request;
    assign wb_adr_o = in.alu_y;
    assign wb_dat_o = in.wbm1_dat << {wb_adr_o[1:0], 3'b000};
    assign wb_sel_o = in.wbm1_sel << wb_adr_o[1:0];
    assign wb_we_o  = in.wbm1_we;

    reg [31:0] wb_dat_i_shifted;
    always_comb begin
        wb_dat_i_shifted = wb_dat_i >> {wb_adr_o[1:0], 3'b000};
        unique case (`funct3(in))
            3'b000:  wb_dat_i_shifted = {{24{wb_dat_i_shifted[7]}}, wb_dat_i_shifted[7:0]};  // LB
            3'b001:  wb_dat_i_shifted = {{16{wb_dat_i_shifted[15]}}, wb_dat_i_shifted[15:0]};  // LH
            3'b010:  wb_dat_i_shifted = wb_dat_i_shifted;  // LW
            3'b100:  wb_dat_i_shifted = {24'b0, wb_dat_i_shifted[7:0]};  // LBU
            3'b101:  wb_dat_i_shifted = {16'b0, wb_dat_i_shifted[15:0]};  // LHU
            default: wb_dat_i_shifted = '0;
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            out <= '{default: '0};
        end else begin
            if (out_ready) begin
                out       <= in;
                out.valid <= in.valid & ~stall & ~flush;
                if (`opcode(in) == 7'b0000011) begin
                    // 如果OPCODE反应是LOAD指令，则需要先修改alu_y
                    out.alu_y <= wb_dat_i_shifted;
                end
            end
        end
    end

    always_comb begin
        trap_in   = 1'b0;
        trap_type = 1'b0;
        epc_w     = '0;
        cause_w   = '0;
        tval_w    = '0;
        if (wb_err_i) begin
            trap_in = 1;
            epc_w   = in.pc;
            tval_w  = wb_adr_o;
            if (wb_we_o) begin
                cause_w   = EX_STORE_PAGE_FAULT;
                trap_type = ~medeleg_r[EX_STORE_PAGE_FAULT];
            end else begin
                cause_w   = EX_LOAD_PAGE_FAULT;
                trap_type = ~medeleg_r[EX_LOAD_PAGE_FAULT];
            end
        end
        flush_pc_o = trap_type ? mtvec_r : stvec_r;
    end

endmodule
