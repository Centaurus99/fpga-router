`timescale 1ns / 1ps `default_nettype none

module packet_counter #(
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
    reg  [31:0] tx_counter[4:0];
    reg  [31:0] rx_counter[4:0];

    wire        request;
    reg  [31:0] read_data [4:0];

    assign request = wb_cyc_i && wb_stb_i && wb_adr_i[31:8] == 24'hA00000 && wb_adr_i[7:6] == 2'b00;
    assign wb_dat_o = read_data[0] | read_data[1] | read_data[2] | read_data[3] | read_data[4];

    always_ff @(posedge clk) begin
        if (rst) begin
            wb_ack_o <= 1'b0;
        end else begin
            wb_ack_o <= 1'b0;
            if (request) begin
                wb_ack_o <= 1'b1;
            end
        end
    end

    generate
        for (genvar i = 0; i <= 4; ++i) begin
            always_ff @(posedge clk) begin
                if (rst) begin
                    tx_counter[i] <= '0;
                    rx_counter[i] <= '0;
                    read_data[i]  <= '0;
                end else begin
                    if (eth_tx8_valid[i] && eth_tx8_ready[i]) begin
                        tx_counter[i] <= tx_counter[i] + 1;
                    end
                    if (eth_rx8_valid[i] && eth_rx8_ready[i]) begin
                        rx_counter[i] <= rx_counter[i] + 1;
                    end

                    read_data[i] <= '0;
                    if (request && wb_adr_i[5:4] == i && !wb_ack_o) begin
                        case (wb_adr_i[3:0])
                            4'h0: begin
                                read_data[i]  <= tx_counter[i];
                                tx_counter[i] <= '0;
                            end
                            4'h4: begin
                                read_data[i]  <= rx_counter[i];
                                rx_counter[i] <= '0;
                            end
                            default: begin
                                read_data[i] <= '0;
                            end
                        endcase
                    end
                end
            end
        end
    endgenerate

endmodule
