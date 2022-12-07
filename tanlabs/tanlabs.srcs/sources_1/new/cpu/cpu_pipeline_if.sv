`timescale 1ns / 1ps `default_nettype none

`include "cpu_pipeline.vh"
`include "exception/exception.vh"

module cpu_pipeline_if (
    input wire clk,
    input wire rst,

    output stage_t        out,
    input  wire           out_ready,
    input  wire           flush_i,
    input  wire    [31:0] flush_pc_i,

    // wishbone master interface
    output wire        wb_cyc_o,
    output wire        wb_stb_o,
    input  wire        wb_ack_i,
    input  wire        wb_err_i,
    output wire [31:0] wb_adr_o,
    output wire [31:0] wb_dat_o,
    input  wire [31:0] wb_dat_i,
    output wire [ 3:0] wb_sel_o,
    output wire        wb_we_o,

    output reg  [31:0] pc,
    input  wire [31:0] next_pc,
    input  wire [ 1:0] PMODE,
    input  wire [31:0] M_Interrupt,
    input  wire [31:0] S_Interrupt
);
    wire        flush;
    reg         flush_reg;
    reg  [31:0] flush_pc_reg;

    assign flush    = flush_i;

    assign wb_cyc_o = wb_stb_o;
    assign wb_stb_o = 1'b1;
    assign wb_adr_o = pc;
    assign wb_dat_o = '0;
    assign wb_sel_o = 4'hf;
    assign wb_we_o  = 0;

    always_ff @(posedge clk) begin
        if (rst) begin
            pc           <= 32'h8000_0000;
            out          <= '{default: 0};
            flush_reg    <= 0;
            flush_pc_reg <= 32'h0000_0000;
        end else begin
            if (flush) begin
                flush_reg    <= 1;
                flush_pc_reg <= flush_pc_i;
            end
            if (out_ready) begin
                out.valid <= 0;  // in.valid 始终为 0
            end
            if (wb_err_i | wb_ack_i) begin
                if (flush || flush_reg) begin
                    pc           <= flush ? flush_pc_i : flush_pc_reg;
                    flush_reg    <= 0;
                    flush_pc_reg <= 32'h0000_0000;
                end else if (out_ready) begin
                    out <= '{default: 0};
                    if (wb_err_i) begin
                        out.cause <= EX_INST_PAGE_FAULT;
                    end
                    if (S_Interrupt | M_Interrupt) begin
                        out.cause.Interrupt <= 1'b1;
                    end
                    out.inst    <= wb_dat_i;
                    out.pc      <= pc;
                    out.next_pc <= next_pc;
                    out.valid   <= 1;
                    out.PMODE   <= PMODE;
                    pc          <= next_pc;
                end
            end
        end
    end

endmodule
