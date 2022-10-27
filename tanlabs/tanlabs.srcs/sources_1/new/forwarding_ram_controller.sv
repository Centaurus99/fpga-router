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
    output reg                               ft_en  [PIPELINE_LENTGH:1],
    output reg                               ft_we  [PIPELINE_LENTGH:1],
    output reg      [CHILD_ADDR_WIDTH - 1:0] ft_addr[PIPELINE_LENTGH:1],
    output FTE_node                          ft_din [PIPELINE_LENTGH:1],
    input  FTE_node                          ft_dout[PIPELINE_LENTGH:1]
);
    // TODO: controller

endmodule
