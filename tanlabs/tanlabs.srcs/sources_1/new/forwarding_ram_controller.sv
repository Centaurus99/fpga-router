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
        BRAM,
        LEAF,
        NEXTHOP,
    } storetype

    reg [WISHBONE_ADDR_WIDTH-1:0] wb_adr_i_reg;
    reg [] nodenum;
    reg [5:0] place;
    
    always_comb begin
        if(wb_adr_i[WISHBONE_ADDR_WIDTH - 1:WISHBONE_ADDR_WIDTH - 4] == 4'h4) begin
            storetype <= BRAM;
        end else if(wb_adr_i[WISHBONE_ADDR_WIDTH - 1:WISHBONE_ADDR_WIDTH - 8] == 8'h50) begin
            storetype <= LEAF;
        end else if(wb_adr_i[WISHBONE_ADDR_WIDTH - 1:WISHBONE_ADDR_WIDTH - 8] == 8'h51) begin
            storetype <= NEXTHOP;
        end
        
    end

    typedef enum { 
        ST_INIT,
        ST_READ,
        ST_CHANGE,
        ST_WRITE
    } state_slave;

    state_slave state = ST_INIT;

    always_ff @ (posedge clk_i) begin
        if(rst_i) begin
            wb_ack_o <= 1'b0;
            wb_dat_o <= 1'b0;
        end else begin
            case(state)
                ST_INIT:
                    if(wb_stb_i == 1'b1 && wb_cyc_i == 1'b1) begin
                        wb_stb_i_reg <= wb_stb_i;
                        wb_cyc_i_reg <= wb_cyc_i;
                        if(wb_we_i == 1'b0) begin
                            if(wb_adr_i[WISHBONE_ADDR_WIDTH - 1:WISHBONE_ADDR_WIDTH - 4] == 4'h4) begin
                                state <= ST_READ_BRAM1;
                            end else if(wb_adr_i[WISHBONE_ADDR_WIDTH - 1:WISHBONE_ADDR_WIDTH - 8] == 8'h50) begin
                                state <= ST_READ_LEAF1;
                            end else if(wb_adr_i[WISHBONE_ADDR_WIDTH - 1:WISHBONE_ADDR_WIDTH - 8] == 8'h51) begin
                                state <= ST_READ_HOP1;
                            end
                        end else begin
                            if(wb_adr_i[WISHBONE_ADDR_WIDTH - 1:WISHBONE_ADDR_WIDTH - 4] == 4'h4) begin
                                state <= ST_WRITE_BRAM1;
                            end else if(wb_adr_i[WISHBONE_ADDR_WIDTH - 1:WISHBONE_ADDR_WIDTH - 8] == 8'h50) begin
                                state <= ST_WRITE_LEAF1;
                            end else if(wb_adr_i[WISHBONE_ADDR_WIDTH - 1:WISHBONE_ADDR_WIDTH - 8] == 8'h51) begin
                                state <= ST_WRITE_HOP1;
                            end
                        end
                        wb_ack_o <= 1'b1;
                    end else begin
                        wb_ack_o <= 1'b1;
                    end
            endcase 
        end
    end

endmodule
