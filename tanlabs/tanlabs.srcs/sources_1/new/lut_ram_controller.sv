`timescale 1ns / 1ps `default_nettype none

// 第二个端口使用不同时钟域的 LUTRAM 控制器

module lut_ram_dp_controller #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8,
    parameter FF_NUM = 2
) (
    input  wire                    clk,
    input  wire                    rst,
    input  wire [ADDR_WIDTH-1 : 0] dpra,
    input  wire                    qdpo_clk,
    input  wire                    qdpo_rst,
    output wire [DATA_WIDTH-1 : 0] qdpo,

    input  wire qdpo_send,  // 请求 dpo 读取数据
    output wire qdpo_ack,   // dpo 读取数据完成

    output reg  [ADDR_WIDTH-1 : 0] lut_dpra,
    input  wire [DATA_WIDTH-1 : 0] lut_qdpo
);
    wire [ADDR_WIDTH-1 : 0] addr_dest_out;
    wire                    addr_dest_req;
    wire                    addr_src_rcv;

    reg  [ADDR_WIDTH-1 : 0] addr_src_in;
    reg                     addr_src_send;

    xpm_cdc_handshake #(
        .DEST_EXT_HSK(0),  // DECIMAL; 0=internal handshake, 1=external handshake
        .DEST_SYNC_FF(FF_NUM),  // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(1),  // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_SYNC_FF(FF_NUM),  // DECIMAL; range: 2-10
        .WIDTH(ADDR_WIDTH)  // DECIMAL; range: 1-1024
    ) xpm_cdc_handshake_addr (
        .dest_out(addr_dest_out),
        .dest_req(addr_dest_req),
        .src_rcv (addr_src_rcv),
        .dest_ack(),
        .dest_clk(clk),
        .src_clk (qdpo_clk),
        .src_in  (addr_src_in),
        .src_send(addr_src_send)
    );

    wire [DATA_WIDTH-1 : 0] data_dest_out;
    wire                    data_dest_req;
    wire                    data_src_rcv;

    reg  [DATA_WIDTH-1 : 0] data_src_in;
    reg                     data_src_send;

    xpm_cdc_handshake #(
        .DEST_EXT_HSK(0),  // DECIMAL; 0=internal handshake, 1=external handshake
        .DEST_SYNC_FF(FF_NUM),  // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(1),  // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_SYNC_FF(FF_NUM),  // DECIMAL; range: 2-10
        .WIDTH(DATA_WIDTH)  // DECIMAL; range: 1-1024
    ) xpm_cdc_handshake_data (
        .dest_out(data_dest_out),
        .dest_req(data_dest_req),
        .src_rcv (data_src_rcv),
        .dest_ack(),
        .dest_clk(qdpo_clk),
        .src_clk (clk),
        .src_in  (data_src_in),
        .src_send(data_src_send)
    );

    assign qdpo     = data_dest_out;
    assign qdpo_ack = data_dest_req;

    typedef enum logic [1:0] {
        IDLE,
        READ_LUT,
        WATI_RCV_N,
        SEND_DATA
    } lut_ram_state_t;

    lut_ram_state_t qdpo_state;
    always_ff @(posedge qdpo_clk or posedge qdpo_rst) begin
        if (qdpo_rst) begin
            addr_src_in   <= '0;
            addr_src_send <= 1'b0;
            qdpo_state    <= IDLE;
        end else begin
            case (qdpo_state)
                IDLE: begin
                    if (qdpo_send) begin
                        addr_src_in <= dpra;
                        if (!addr_src_rcv) begin
                            addr_src_send <= 1'b1;
                            qdpo_state    <= SEND_DATA;
                        end else begin
                            qdpo_state <= WATI_RCV_N;
                        end
                    end
                end
                WATI_RCV_N: begin
                    if (!addr_src_rcv) begin
                        addr_src_send <= 1'b1;
                        qdpo_state    <= SEND_DATA;
                    end
                end
                SEND_DATA: begin
                    if (addr_src_rcv) begin
                        addr_src_send <= 1'b0;
                        qdpo_state    <= IDLE;
                    end
                end
                default: begin
                    qdpo_state <= IDLE;
                end
            endcase
        end
    end

    lut_ram_state_t state;
    assign lut_dpra = addr_dest_out;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            data_src_in   <= '0;
            data_src_send <= 1'b0;
            state         <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (addr_dest_req) begin
                        state <= READ_LUT;
                    end
                end
                READ_LUT: begin
                    data_src_in <= lut_qdpo;
                    if (!data_src_rcv) begin
                        data_src_send <= 1'b1;
                        state         <= SEND_DATA;
                    end else begin
                        state <= WATI_RCV_N;
                    end
                end
                WATI_RCV_N: begin
                    if (!data_src_rcv) begin
                        data_src_send <= 1'b1;
                        state         <= SEND_DATA;
                    end
                end
                SEND_DATA: begin
                    if (data_src_rcv) begin
                        data_src_send <= 1'b0;
                        state         <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
