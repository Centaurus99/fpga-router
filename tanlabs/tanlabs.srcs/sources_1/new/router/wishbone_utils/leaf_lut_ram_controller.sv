`timescale 1ns / 1ps `default_nettype none

`include "../forwarding_table.vh"

module leaf_lut_ram_controller #(
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32
) (
    input wire clk,
    input wire rst,

    // wishbone slave interface
    input  wire                             wb_cyc_i,
    input  wire                             wb_stb_i,
    output reg                              wb_ack_o,
    input  wire [  WISHBONE_ADDR_WIDTH-1:0] wb_adr_i,
    input  wire [  WISHBONE_DATA_WIDTH-1:0] wb_dat_i,
    output reg  [  WISHBONE_DATA_WIDTH-1:0] wb_dat_o,
    input  wire [WISHBONE_DATA_WIDTH/8-1:0] wb_sel_i,
    input  wire                             wb_we_i,

    // Leaf node LUTRAM interface
    output logic     [LEAF_ADDR_WIDTH - 1:0] leaf_addr,
    output leaf_node                         leaf_in,
    input  leaf_node                         leaf_out,
    output reg                               leaf_we
);
    // 根据 sel 获取 mask
    reg [WISHBONE_DATA_WIDTH-1:0] data_mask;
    always_comb begin
        for (int i = 0; i < WISHBONE_DATA_WIDTH / 8; i = i + 1) begin
            data_mask[i*8+:8] = wb_sel_i[i] ? 8'hff : 8'h00;
        end
    end

    always_comb begin
        wb_dat_o  = leaf_out;
        leaf_addr = wb_adr_i[WISHBONE_ADDR_WIDTH-9:2];
        leaf_in   = (leaf_out & ~data_mask) | (wb_dat_i & data_mask);
    end

    typedef enum {
        ST_IDLE,
        ST_WAIT,
        ST_DONE
    } slave_state_t;

    slave_state_t state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wb_ack_o <= 1'b0;
            leaf_we  <= 1'b0;
            state    <= ST_IDLE;
        end else begin
            case (state)
                ST_IDLE: begin
                    if (wb_cyc_i && wb_stb_i) begin
                        state <= ST_WAIT;
                    end
                end
                ST_WAIT: begin
                    wb_ack_o <= 1'b1;
                    leaf_we  <= wb_we_i;
                    state    <= ST_DONE;
                end
                ST_DONE: begin
                    wb_ack_o <= 1'b0;
                    leaf_we  <= 1'b0;
                    state    <= ST_IDLE;
                end
                default: begin
                    state <= ST_IDLE;
                end
            endcase
        end
    end
endmodule
