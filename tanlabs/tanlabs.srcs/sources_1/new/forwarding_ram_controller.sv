`timescale 1ns / 1ps `default_nettype none

`include "forwarding_table.vh"

module forwarding_ram_controller #(
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32
) (
    // clk and reset
    input wire clk_i,
    input wire rst_i,

    // wishbone slave interface
    input  wire                             wb_cyc_i,
    input  wire                             wb_stb_i,
    output reg                              wb_ack_o,
    input  wire [  WISHBONE_ADDR_WIDTH-1:0] wb_adr_i,
    input  wire [  WISHBONE_DATA_WIDTH-1:0] wb_dat_i,
    output reg  [  WISHBONE_DATA_WIDTH-1:0] wb_dat_o,
    input  wire [WISHBONE_DATA_WIDTH/8-1:0] wb_sel_i,
    input  wire                             wb_we_i,

    // Forwarding table BRAM interface
    output reg                               ft_en  [PIPELINE_LENGTH:1],
    output reg                               ft_we  [PIPELINE_LENGTH:1],
    output reg      [CHILD_ADDR_WIDTH - 1:0] ft_addr[PIPELINE_LENGTH:1],
    output FTE_node                          ft_din [PIPELINE_LENGTH:1],
    input  FTE_node                          ft_dout[PIPELINE_LENGTH:1],

    // Leaf node LUTRAM interface
    output logic     [LEAF_ADDR_WIDTH - 1:0] leaf_addr,
    output leaf_node                         leaf_in,
    input  leaf_node                         leaf_out,
    output wire                              leaf_we,

    // Next-Hop node LUTRAM interface
    output logic         [NEXT_HOP_ADDR_WIDTH - 1:0] next_hop_addr,
    output next_hop_node                             next_hop_in,
    input  next_hop_node                             next_hop_out,
    output wire                                      next_hop_we
);
    // TODO: controller

    typedef enum { 
        ST_INIT,
        ST_READ_BRAM1,
        ST_READ_BRAM2,
        ST_READ_BRAM3,
        ST_READ_BRAM4,
        ST_READ_LEAF1,
        ST_READ_LEAF2,
        ST_READ_HOP1,
        ST_READ_HOP2,
        ST_WRITE_BRAM1,
        ST_WRITE_BRAM2,
        ST_WRITE_BRAM3,
        ST_WRITE_BRAM4,
        ST_WRITE_LEAF1,
        ST_WRITE_LEAF2,
        ST_WRITE_HOP1,
        ST_WRITE_HOP2,
    } state_slave;

    state_slave state = ST_INIT;
    reg wb_stb_i_reg = 1'b0;

    always_ff(posedge clk_i) begin
        if(rst_i) begin
            wb_ack_o <= 1'b0;
            wb_dat_o <= 1'b0;
        end else begin
            case(state)
                ST_INIT:
                    if(wb_stb_i == 1'b1 && wb_stb_i_reg = 1'b0 && wb_cyc_i == 1'b1 && wb_cyc_i == 1'b0) begin
                        wb_stb_i_reg <= wb_stb_i;
                        wb_cyc_i_reg <= wb_cyc_i;
                        if(wb_we_i == 1'b0) begin
                            if(wb_adr_i >= 32'h40000000 && wb_adr_i < 32'h48000000)
                                state <= ST_READ_BRAM1
                            if(wb_adr_i >= 32'h50000000 && wb_adr_i < 32'h51000000)
                                state <= ST_READ_LEAF1
                            if(wb_adr_i >= 32'h51000000 && wb_adr_i < 32'h52000000)
                                state <= ST_READ_HOP1
                        end else begin
                            if(wb_adr_i >= 32'h40000000 && wb_adr_i < 32'h48000000)
                                state <= ST_WRITE_BRAM1
                            if(wb_adr_i >= 32'h50000000 && wb_adr_i < 32'h51000000)
                                state <= ST_WRITE_LEAF1
                            if(wb_adr_i >= 32'h51000000 && wb_adr_i < 32'h52000000)
                                state <= ST_WRITE_HOP1
                        end
                        wb_ack_o = 1'b1;
                    end else begin
                        wb_ack_o = 1'b1;
                    end
                ST_READ_BRAM1:
            endcase 
        end
    end

endmodule
