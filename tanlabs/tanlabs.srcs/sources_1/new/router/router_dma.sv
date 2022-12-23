`timescale 1ns / 1ps `default_nettype none

module router_dma #(
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32
) (
    // CPU 时钟域
    input wire cpu_clk,
    input wire cpu_reset,

    // wishbone slave interface
    input  wire                             wb_cyc_i,
    input  wire                             wb_stb_i,
    output reg                              wb_ack_o,
    input  wire [  WISHBONE_ADDR_WIDTH-1:0] wb_adr_i,
    input  wire [  WISHBONE_DATA_WIDTH-1:0] wb_dat_i,
    output reg  [  WISHBONE_DATA_WIDTH-1:0] wb_dat_o,
    input  wire [WISHBONE_DATA_WIDTH/8-1:0] wb_sel_i,
    input  wire                             wb_we_i,

    // Router 时钟域
    input wire eth_clk,
    input wire eth_reset,

    // DMA 状态与控制寄存器
    input wire dma_cpu_lock_i,
    input wire dma_router_lock_i,
    input wire dma_wait_cpu_i,
    input wire dma_wait_router_i,

    // 路由器写入 DMA 寄存器请求
    output reg dma_router_request_o,
    output reg dma_router_request_fin_o,
    output reg dma_router_sent_fin_o,
    output reg dma_router_read_fin_o
);
    // 根据 sel 获取 mask
    reg [WISHBONE_DATA_WIDTH-1:0] data_mask;
    always_comb begin
        for (int i = 0; i < WISHBONE_DATA_WIDTH / 8; i = i + 1) begin
            data_mask[i*8+:8] = wb_sel_i[i] ? 8'hff : 8'h00;
        end
    end

    wire request;
    assign request = wb_cyc_i && wb_stb_i;

    // router_dma_data router_dma_data_read (
    //     .clka (clka),   // input wire clka
    //     .ena  (ena),    // input wire ena
    //     .wea  (wea),    // input wire [0 : 0] wea
    //     .addra(addra),  // input wire [9 : 0] addra
    //     .dina (dina),   // input wire [31 : 0] dina
    //     .douta(douta),  // output wire [31 : 0] douta
    //     .clkb (clkb),   // input wire clkb
    //     .enb  (enb),    // input wire enb
    //     .web  (web),    // input wire [0 : 0] web
    //     .addrb(addrb),  // input wire [9 : 0] addrb
    //     .dinb (dinb),   // input wire [31 : 0] dinb
    //     .doutb(doutb)   // output wire [31 : 0] doutb
    // );

endmodule
