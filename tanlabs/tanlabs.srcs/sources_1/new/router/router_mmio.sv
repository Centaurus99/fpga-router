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
    input wire eth_rx8_valid[4:0]

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

    // 网络端口统计
    reg [31:0] tx_counter[4:0];
    reg [31:0] rx_counter[4:0];

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
        end else begin
            wb_ack_o <= 1'b0;
            if (request) begin
                case (wb_adr_i[31:24])
                    8'h60: begin
                        if (wb_adr_i[23:8] == 16'h0000 && wb_adr_i[7:6] == 2'b00) begin
                            case (wb_adr_i[3:0])
                                4'h0: begin
                                    wb_dat_o <= tx_counter[wb_adr_i[5:4]];
                                    wb_ack_o <= 1'b1;
                                end
                                4'h4: begin
                                    wb_dat_o <= rx_counter[wb_adr_i[5:4]];
                                    wb_ack_o <= 1'b1;
                                end
                                default: ;
                            endcase
                        end
                    end
                    default: ;
                endcase
            end
        end
    end

endmodule
