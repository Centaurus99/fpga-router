`timescale 1ns / 1ps `default_nettype none

`include "../forwarding_table.vh"

module leaf_sram_controller #(
    parameter ETH_CLK_FREQ = 125_000_000,

    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32,

    parameter SRAM_ADDR_WIDTH = 20,
    parameter SRAM_DATA_WIDTH = 32,

    localparam SRAM_BYTES      = SRAM_DATA_WIDTH / 8,
    localparam SRAM_BYTE_WIDTH = $clog2(SRAM_BYTES)
) (
    /* =========== CPU Domain =========== */
    input wire cpu_clk,
    input wire cpu_reset,

    // wishbone slave interface
    input  wire                             wb_cpu_cyc_i,
    input  wire                             wb_cpu_stb_i,
    output reg                              wb_cpu_ack_o,
    input  wire [  WISHBONE_ADDR_WIDTH-1:0] wb_cpu_adr_i,
    input  wire [  WISHBONE_DATA_WIDTH-1:0] wb_cpu_dat_i,
    output reg  [  WISHBONE_DATA_WIDTH-1:0] wb_cpu_dat_o,
    input  wire [WISHBONE_DATA_WIDTH/8-1:0] wb_cpu_sel_i,
    input  wire                             wb_cpu_we_i,

    /* =========== Router Domain =========== */
    input wire eth_clk,
    input wire eth_reset,

    // wishbone slave interface
    input  wire                             wb_router_cyc_i,
    input  wire                             wb_router_stb_i,
    output reg                              wb_router_ack_o,
    input  wire [  WISHBONE_ADDR_WIDTH-1:0] wb_router_adr_i,
    input  wire [  WISHBONE_DATA_WIDTH-1:0] wb_router_dat_i,
    output reg  [  WISHBONE_DATA_WIDTH-1:0] wb_router_dat_o,
    input  wire [WISHBONE_DATA_WIDTH/8-1:0] wb_router_sel_i,
    input  wire                             wb_router_we_i,

    // sram interface
    output wire [SRAM_ADDR_WIDTH-1:0] sram_addr,
    inout  wire [SRAM_DATA_WIDTH-1:0] sram_data,
    output wire                       sram_ce_n,
    output wire                       sram_oe_n,
    output wire                       sram_we_n,
    output wire [     SRAM_BYTES-1:0] sram_be_n
);
    wire                             wb_cpu_cdc_cyc_o;
    wire                             wb_cpu_cdc_stb_o;
    wire                             wb_cpu_cdc_ack_i;
    wire [  WISHBONE_ADDR_WIDTH-1:0] wb_cpu_cdc_adr_o;
    wire [  WISHBONE_DATA_WIDTH-1:0] wb_cpu_cdc_dat_o;
    wire [  WISHBONE_DATA_WIDTH-1:0] wb_cpu_cdc_dat_i;
    wire [WISHBONE_DATA_WIDTH/8-1:0] wb_cpu_cdc_sel_o;
    wire                             wb_cpu_cdc_we_o;

    wire                             wbs_cyc_o;
    wire                             wbs_stb_o;
    wire                             wbs_ack_i;
    wire [  WISHBONE_ADDR_WIDTH-1:0] wbs_adr_o;
    wire [  WISHBONE_DATA_WIDTH-1:0] wbs_dat_o;
    wire [  WISHBONE_DATA_WIDTH-1:0] wbs_dat_i;
    wire [WISHBONE_DATA_WIDTH/8-1:0] wbs_sel_o;
    wire                             wbs_we_o;

    wishbone_cdc_handshake #(
        .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
        .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH)
    ) u_wishbone_cdc_handshake_leaf (
        .src_clk (cpu_clk),
        .src_rst (cpu_reset),
        .dest_clk(eth_clk),
        .dest_rst(eth_reset),
        .wb_cyc_i(wb_cpu_cyc_i),
        .wb_stb_i(wb_cpu_stb_i),
        .wb_ack_o(wb_cpu_ack_o),
        .wb_adr_i(wb_cpu_adr_i),
        .wb_dat_i(wb_cpu_dat_i),
        .wb_dat_o(wb_cpu_dat_o),
        .wb_sel_i(wb_cpu_sel_i),
        .wb_we_i (wb_cpu_we_i),

        .dest_wb_cyc_o(wb_cpu_cdc_cyc_o),
        .dest_wb_stb_o(wb_cpu_cdc_stb_o),
        .dest_wb_ack_i(wb_cpu_cdc_ack_i),
        .dest_wb_adr_o(wb_cpu_cdc_adr_o),
        .dest_wb_dat_o(wb_cpu_cdc_dat_o),
        .dest_wb_dat_i(wb_cpu_cdc_dat_i),
        .dest_wb_sel_o(wb_cpu_cdc_sel_o),
        .dest_wb_we_o (wb_cpu_cdc_we_o),

        .debug_led()
    );

    wb_strict_arbiter_2 #(
        .DATA_WIDTH(WISHBONE_DATA_WIDTH),
        .ADDR_WIDTH(WISHBONE_ADDR_WIDTH)
    ) u_wb_strict_arbiter_2_leaf (
        .clk(eth_clk),
        .rst(eth_reset),

        .wbm0_adr_i(wb_cpu_cdc_adr_o),
        .wbm0_dat_i(wb_cpu_cdc_dat_o),
        .wbm0_dat_o(wb_cpu_cdc_dat_i),
        .wbm0_we_i (wb_cpu_cdc_we_o),
        .wbm0_sel_i(wb_cpu_cdc_sel_o),
        .wbm0_stb_i(wb_cpu_cdc_stb_o),
        .wbm0_ack_o(wb_cpu_cdc_ack_i),
        .wbm0_cyc_i(wb_cpu_cdc_cyc_o),

        .wbm1_adr_i(wb_router_adr_i),
        .wbm1_dat_i(wb_router_dat_i),
        .wbm1_dat_o(wb_router_dat_o),
        .wbm1_we_i (wb_router_we_i),
        .wbm1_sel_i(wb_router_sel_i),
        .wbm1_stb_i(wb_router_stb_i),
        .wbm1_ack_o(wb_router_ack_o),
        .wbm1_cyc_i(wb_router_cyc_i),

        .wbs_adr_o(wbs_adr_o),
        .wbs_dat_i(wbs_dat_i),
        .wbs_dat_o(wbs_dat_o),
        .wbs_we_o (wbs_we_o),
        .wbs_sel_o(wbs_sel_o),
        .wbs_stb_o(wbs_stb_o),
        .wbs_ack_i(wbs_ack_i),
        .wbs_cyc_o(wbs_cyc_o)
    );

    sram_controller #(
        .CLK_FREQ       (ETH_CLK_FREQ),
        .SRAM_ADDR_WIDTH(SRAM_ADDR_WIDTH),
        .SRAM_DATA_WIDTH(SRAM_DATA_WIDTH)
    ) sram_controller_ext (
        .clk_i(eth_clk),
        .rst_i(eth_reset),

        // Wishbone slave
        .wb_cyc_i(wbs_cyc_o),
        .wb_stb_i(wbs_stb_o),
        .wb_ack_o(wbs_ack_i),
        .wb_adr_i(wbs_adr_o),
        .wb_dat_i(wbs_dat_o),
        .wb_dat_o(wbs_dat_i),
        .wb_sel_i(wbs_sel_o),
        .wb_we_i (wbs_we_o),

        // To SRAM chip
        .sram_addr(sram_addr),
        .sram_data(sram_data),
        .sram_ce_n(sram_ce_n),
        .sram_oe_n(sram_oe_n),
        .sram_we_n(sram_we_n),
        .sram_be_n(sram_be_n)
    );

endmodule
