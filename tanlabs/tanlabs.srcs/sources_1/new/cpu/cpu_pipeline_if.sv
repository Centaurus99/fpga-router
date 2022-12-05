`timescale 1ns / 1ps `default_nettype none

`include "cpu_pipeline.vh"

module cpu_pipeline_if (
    input wire clk,
    input wire rst,

    output wire    in_ready,
    output stage_t out,
    input  wire    out_ready,

    // wishbone master interface
    output wire        wb_cyc_o,
    output wire        wb_stb_o,
    input  wire        wb_ack_i,
    output wire [31:0] wb_adr_o,
    output wire [31:0] wb_dat_o,
    input  wire [31:0] wb_dat_i,
    output wire [ 3:0] wb_sel_o,
    output wire        wb_we_o,

    output reg  [31:0] pc,
    input  wire [31:0] next_pc,
    input  wire [31:0] new_pc,
    input  wire        branch,
    input  wire        wait_wb,
    input  wire [ 1:0] PMODE
);
    assign in_ready = (out_ready && !wait_wb) || !out.valid;

    logic if_state, branch_reg;

    assign wb_cyc_o = wb_stb_o;
    assign wb_stb_o = if_state;
    assign wb_adr_o = pc;
    assign wb_dat_o = '0;
    assign wb_sel_o = 4'hf;
    assign wb_we_o  = 0;

    always_ff @(posedge clk) begin
        if (rst) begin
            pc         <= 32'h8000_0000;
            if_state   <= 0;
            out        <= '{default: 0};
            branch_reg <= 0;
        end else begin
            if (branch) begin
                branch_reg <= 1;
            end
            if (in_ready) begin
                out.valid <= 0;  // 只有本级是ready的时候才能改变这一级中的信号！
            end
            case (if_state)
                0: begin
                    if (in_ready) begin
                        if_state <= 1;
                    end
                end
                1: begin
                    if (wb_ack_i) begin
                        if (branch || branch_reg) begin
                            pc         <= new_pc;
                            branch_reg <= 0;
                        end else if (in_ready) begin
                            out.inst    <= wb_dat_i;
                            out.pc      <= pc;
                            out.next_pc <= next_pc;
                            out.valid   <= 1;
                            out.PMODE   <= PMODE;
                            pc          <= next_pc;
                        end else if_state <= 0;
                    end
                end
            endcase
        end
    end

endmodule
