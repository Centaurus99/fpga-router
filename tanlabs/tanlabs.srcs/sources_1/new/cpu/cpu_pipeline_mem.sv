`timescale 1ns / 1ps `default_nettype none

`include "cpu_pipeline.vh"

module cpu_pipeline_mem (
    input wire clk,
    input wire rst,

    input  stage_t in,
    output wire    in_ready,
    output stage_t out,
    // out_ready 须保证一直为 1

    // wishbone master interface
    output wire        wb_cyc_o,
    output wire        wb_stb_o,
    input  wire        wb_ack_i,
    output wire [31:0] wb_adr_o,
    output wire [31:0] wb_dat_o,
    input  wire [31:0] wb_dat_i,
    output wire [ 3:0] wb_sel_o,
    output wire        wb_we_o
);
    wire request = in.valid & in.wbm1_stb;

    assign in_ready = !request || (request && wb_ack_i);

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
            out <= '{default: 0};
        end else begin
            if (in_ready) begin
                out <= in;
                if (in.valid && `opcode(in) == 7'b0000011) begin
                    // 如果OPCODE反应是LOAD指令，则需要先修改alu_y
                    out.alu_y <= wb_dat_i_shifted;
                end
            end
        end
    end

endmodule
