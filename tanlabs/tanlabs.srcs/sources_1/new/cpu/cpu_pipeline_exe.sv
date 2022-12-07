`timescale 1ns / 1ps

`include "cpu_pipeline.vh"

module cpu_pipeline_exe (
    input wire clk,
    input wire rst,

    input  stage_t in,
    output wire    in_ready,
    output stage_t out,
    input  wire    out_ready,
    input  wire    flush_i,

    output wire [31:0] alu_a_o,
    output wire [31:0] alu_b_o,
    output wire [ 3:0] alu_op_o,
    input  wire [31:0] alu_y_i,

    output reg [ 4:0] exe_rd,
    output reg [31:0] exe_alu_y
);
    wire flush = flush_i;

    assign in_ready = out_ready || !in.valid || flush;

    assign alu_op_o = in.alu_op;
    assign alu_a_o  = in.alu_a;
    assign alu_b_o  = in.alu_b;

    wire forward_valid_n = !in.rf_we || (`rd(in) == 0) || `opcode(in) == 7'b0000011;

    always_ff @(posedge clk) begin
        if (rst) begin
            out       <= 0;
            exe_alu_y <= 0;
            exe_rd    <= 0;
        end else if (out_ready) begin
            out       <= in;
            out.valid <= in.valid & ~flush;
            if (in.valid & ~flush) begin
                out.alu_y <= alu_y_i;
                exe_rd    <= forward_valid_n ? 0 : `rd(in);
                exe_alu_y <= forward_valid_n ? '0 : alu_y_i;
            end
        end
    end

endmodule
