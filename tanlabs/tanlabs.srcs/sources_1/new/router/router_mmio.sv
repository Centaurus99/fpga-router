`timescale 1ns / 1ps `default_nettype none

module router_mmio #(
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

    // 网络接口信号
    input wire eth_tx8_ready[4:0],
    input wire eth_tx8_valid[4:0],
    input wire eth_rx8_ready[4:0],
    input wire eth_rx8_valid[4:0],

    // 网络接口配置
    output reg [ 47:0] mac     [3:0],
    output reg [127:0] local_ip[3:0],
    output reg [127:0] gua_ip  [3:0],

    // DMA 状态与控制寄存器
    output reg dma_cpu_lock_o,
    output reg dma_router_lock_o,
    output reg dma_wait_cpu_o,
    output reg dma_wait_router_o,

    // 路由器写入 DMA 寄存器请求
    input wire dma_router_request_i,
    input wire dma_router_sent_fin_i,
    input wire dma_router_read_fin_i

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

    // 端口相关 MMIO 的端口号
    wire [1:0] port_num;
    assign port_num = wb_adr_i[9:8];

    // 网络端口统计
    reg  [31:0] tx_counter[4:0];
    reg  [31:0] rx_counter[4:0];

    // Reset 后的默认 MAC 地址, 用于硬件调试
    wire [47:0] preset_mac[3:0];
    assign preset_mac[0] = {<<8{48'h8C_1F_64_69_10_30}};
    assign preset_mac[1] = {<<8{48'h8C_1F_64_69_10_31}};
    assign preset_mac[2] = {<<8{48'h8C_1F_64_69_10_32}};
    assign preset_mac[3] = {<<8{48'h8C_1F_64_69_10_33}};

    // Reset 后的默认 MAC 地址, 用于硬件调试
    wire [127:0] preset_local_ip[3:0];
    assign preset_local_ip[0] = {<<8{128'hfe80_0000_0000_0000_8e1f_64ff_fe69_1030}};
    assign preset_local_ip[1] = {<<8{128'hfe80_0000_0000_0000_8e1f_64ff_fe69_1031}};
    assign preset_local_ip[2] = {<<8{128'hfe80_0000_0000_0000_8e1f_64ff_fe69_1032}};
    assign preset_local_ip[3] = {<<8{128'hfe80_0000_0000_0000_8e1f_64ff_fe69_1033}};

    // 硬件 EUI64 生成器
    wire [127:0] eui64_ip_o;
    eui64 eui64_i (
        .mac(mac[port_num]),
        .ip (eui64_ip_o)
    );

    generate
        for (genvar i = 0; i <= 4; ++i) begin
            always_ff @(posedge clk) begin
                if (rst) begin
                    tx_counter[i] <= '0;
                    rx_counter[i] <= '0;
                end else begin
                    if (eth_tx8_valid[i] && eth_tx8_ready[i]) begin
                        tx_counter[i] <= tx_counter[i] + 1;
                    end
                    if (eth_rx8_valid[i] && eth_rx8_ready[i]) begin
                        rx_counter[i] <= rx_counter[i] + 1;
                    end
                end
            end
        end
    endgenerate

    always_ff @(posedge clk) begin
        if (rst) begin
            wb_dat_o <= '0;
            wb_ack_o <= 1'b0;
            for (int i = 0; i < 4; i = i + 1) begin
                mac[i]      <= preset_mac[i];
                local_ip[i] <= preset_local_ip[i];
                gua_ip[i]   <= 128'h0;
            end
            dma_cpu_lock_o    <= 1'b0;
            dma_router_lock_o <= 1'b0;
            dma_wait_cpu_o    <= 1'b0;
            dma_wait_router_o <= 1'b0;
        end else begin
            wb_dat_o <= '0;
            wb_ack_o <= 1'b0;
            if (request && !wb_ack_o) begin
                wb_ack_o <= 1'b1;
                case (wb_adr_i[31:24])
                    8'h60: begin
                        if (wb_adr_i[23:12] == 12'h000 && wb_adr_i[11:10] == 2'b00) begin
                            case (wb_adr_i[7:2])
                                6'b0000_00: wb_dat_o <= tx_counter[port_num] & data_mask;
                                6'b0000_01: wb_dat_o <= rx_counter[port_num] & data_mask;
                                default: ;
                            endcase
                        end
                    end
                    8'h61: begin
                        if (wb_adr_i[23:12] == 12'h000 && wb_adr_i[11:10] == 2'b00) begin
                            case (wb_adr_i[7:4])
                                4'h0: begin
                                    if (wb_adr_i[3] == 1'b0) begin
                                        // MAC 地址
                                        if (wb_adr_i[2] == 1'b0) begin
                                            if (wb_we_i) begin
                                                mac[port_num][31:0] <= (mac[port_num] & ~data_mask) | (wb_dat_i & data_mask);
                                            end else begin
                                                wb_dat_o <= mac[port_num][31:0] & data_mask;
                                            end
                                        end else begin
                                            if (wb_we_i) begin
                                                mac[port_num][47:32] <= (mac[port_num][47:32] & ~data_mask) | (wb_dat_i & data_mask);
                                            end else begin
                                                wb_dat_o <= mac[port_num][47:32] & data_mask;
                                            end
                                        end
                                    end else begin
                                        // EUI64 控制
                                        if (wb_we_i && (wb_dat_i & data_mask)) begin
                                            local_ip[port_num] <= eui64_ip_o;
                                        end
                                    end
                                end
                                4'h1: begin
                                    if (wb_we_i) begin
                                        local_ip[port_num][{
                                            wb_adr_i[3:2], 5'b00000
                                        }+:32] <= (local_ip[port_num][{wb_adr_i[3:2], 5'b00000}+:32]
                                                   & ~data_mask) | (wb_dat_i & data_mask);
                                    end else begin
                                        wb_dat_o <= local_ip[port_num][{wb_adr_i[3:2], 5'b00000}+:32] & data_mask;
                                    end
                                end
                                4'h2: begin
                                    if (wb_we_i) begin
                                        gua_ip[port_num][{
                                            wb_adr_i[3:2], 5'b00000
                                        }+:32] <= (gua_ip[port_num][{wb_adr_i[3:2], 5'b00000}+:32]
                                                   & ~data_mask) | (wb_dat_i & data_mask);
                                    end else begin
                                        wb_dat_o <= gua_ip[port_num][{wb_adr_i[3:2], 5'b00000}+:32] & data_mask;
                                    end
                                end
                                default: ;
                            endcase
                        end
                    end
                    8'h62: begin
                        if (wb_adr_i[23:0] == 24'h000000) begin
                            if (wb_we_i) begin
                                if (wb_dat_i[0] && !dma_router_lock_o && !dma_router_request_i) begin
                                    dma_cpu_lock_o <= 1'b1;
                                end
                                if (wb_dat_i[2]) begin
                                    dma_wait_cpu_o <= 1'b0;
                                end
                                if (wb_dat_i[3]) begin
                                    dma_cpu_lock_o    <= 1'b0;
                                    dma_wait_router_o <= 1'b1;
                                end
                            end else begin
                                wb_dat_o <= {
                                    dma_wait_router_o,
                                    dma_wait_cpu_o,
                                    dma_router_lock_o,
                                    dma_cpu_lock_o
                                };
                            end
                        end
                    end
                    default: ;
                endcase
            end
            if (dma_router_request_i && !dma_cpu_lock_o) begin
                dma_router_lock_o <= 1'b1;
            end
            if (dma_router_sent_fin_i) begin
                dma_router_lock_o <= 1'b0;
                dma_wait_cpu_o    <= 1'b1;
            end
            if (dma_router_read_fin_i) begin
                dma_wait_router_o <= 1'b0;
            end
        end
    end

endmodule
