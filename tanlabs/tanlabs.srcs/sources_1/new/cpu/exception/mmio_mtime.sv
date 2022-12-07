`timescale 1ns / 1ps `default_nettype none

module mmio_mtime #(
    parameter CLK_FREQ   = 50_000_000,
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter TICK_TIME  = 10
) (
    // clk and reset
    input wire clk,
    input wire rst,

    // wishbone slave interface
    input  wire                    wb_cyc_i,
    input  wire                    wb_stb_i,
    output reg                     wb_ack_o,
    input  wire [  ADDR_WIDTH-1:0] wb_adr_i,
    input  wire [  DATA_WIDTH-1:0] wb_dat_i,
    output reg  [  DATA_WIDTH-1:0] wb_dat_o,
    input  wire [DATA_WIDTH/8-1:0] wb_sel_i,
    input  wire                    wb_we_i,

    output wire [63:0] mtime_o,
    output wire        mtime_int_o
);
    wire                  request;
    wire [ADDR_WIDTH-1:0] addr_mask;
    wire [DATA_WIDTH-1:0] data_mask;

    assign request   = wb_cyc_i & wb_stb_i;
    assign addr_mask = 32'hffff_fffc;

    // data mask
    genvar i;
    for (i = 0; i < DATA_WIDTH / 8; i = i + 1) begin
        assign data_mask[i*8+:8] = wb_sel_i[i] ? 8'hFF : 8'h00;
    end

    reg [63:0] mtime;
    reg [63:0] mtimecmp;
    int        tick_count;
    assign mtime_o     = mtime;
    assign mtime_int_o = mtime >= mtimecmp;

    always_comb begin
        wb_ack_o = request;
        case (wb_adr_i & addr_mask)
            32'h0200_BFF8: begin
                wb_dat_o = mtime[31:0] & data_mask;
            end
            32'h0200_BFFC: begin
                wb_dat_o = mtime[63:32] & data_mask;
            end
            32'h0200_4000: begin
                wb_dat_o = mtimecmp[31:0] & data_mask;
            end
            32'h0200_4004: begin
                wb_dat_o = mtimecmp[63:32] & data_mask;
            end
            default: begin
                wb_dat_o = 32'h0000_0000;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            mtime      <= 64'h0000_0000_0000_0000;
            mtimecmp   <= 64'h0000_0000_0000_0000;
            tick_count <= 0;
        end else begin
            if (request & wb_we_i) begin
                case (wb_adr_i & addr_mask)
                    32'h0200_4000: begin
                        mtimecmp[31:0] <= (wb_dat_i & data_mask) | (mtimecmp[31:0] & ~data_mask);
                    end
                    32'h0200_4004: begin
                        mtimecmp[63:32] <= (wb_dat_i & data_mask) | (mtimecmp[63:32] & ~data_mask);
                    end
                    default: ;  // do nothing
                endcase
            end
            if (tick_count == TICK_TIME - 1) begin
                mtime      <= mtime + 1;
                tick_count <= 0;
            end else begin
                tick_count <= tick_count + 1;
            end
        end
    end

endmodule
