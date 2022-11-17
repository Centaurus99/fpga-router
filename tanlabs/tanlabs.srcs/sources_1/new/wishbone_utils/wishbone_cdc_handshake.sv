`timescale 1ns / 1ps `default_nettype none

// 基于 xpm_cdc_handshake 的简单跨时钟域 Wishbone 总线转接器
// 若有较高的写入性能要求，建议使用基于 FIFO 的转接器

module wishbone_cdc_handshake #(
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32,

    parameter CDC_SRC_DATA_WIDTH = WISHBONE_ADDR_WIDTH + WISHBONE_DATA_WIDTH + (WISHBONE_DATA_WIDTH/8) + 1,
    parameter CDC_DEST_DATA_WIDTH = WISHBONE_DATA_WIDTH,
    parameter FF_NUM = 2
) (
    input wire src_clk,
    input wire src_rst,
    input wire dest_clk,
    input wire dest_rst,

    input  wire                             wb_cyc_i,
    input  wire                             wb_stb_i,
    output reg                              wb_ack_o,
    input  wire [  WISHBONE_ADDR_WIDTH-1:0] wb_adr_i,
    input  wire [  WISHBONE_DATA_WIDTH-1:0] wb_dat_i,
    output reg  [  WISHBONE_DATA_WIDTH-1:0] wb_dat_o,
    input  wire [WISHBONE_DATA_WIDTH/8-1:0] wb_sel_i,
    input  wire                             wb_we_i,

    output reg                              dest_wb_cyc_o,
    output reg                              dest_wb_stb_o,
    input  wire                             dest_wb_ack_i,
    output reg  [  WISHBONE_ADDR_WIDTH-1:0] dest_wb_adr_o,
    output reg  [  WISHBONE_DATA_WIDTH-1:0] dest_wb_dat_o,
    input  wire [  WISHBONE_DATA_WIDTH-1:0] dest_wb_dat_i,
    output reg  [WISHBONE_DATA_WIDTH/8-1:0] dest_wb_sel_o,
    output reg                              dest_wb_we_o,

    // debug
    output reg [7:0] debug_led
);
    wire  [ CDC_SRC_DATA_WIDTH-1:0] SRC_dest_out;
    wire                            SRC_dest_req;

    wire                            SRC_src_rcv;
    reg   [ CDC_SRC_DATA_WIDTH-1:0] SRC_src_in;
    reg                             SRC_src_send;

    wire  [CDC_DEST_DATA_WIDTH-1:0] DEST_dest_out;
    wire                            DEST_dest_req;

    wire                            DEST_src_rcv;
    reg   [CDC_DEST_DATA_WIDTH-1:0] DEST_src_in;
    reg                             DEST_src_send;

    logic [                    3:0] debug_count;

    /* =========== SRC to DEST begin =========== */
    xpm_cdc_handshake #(
        .DEST_EXT_HSK(0),  // DECIMAL; 0=internal handshake, 1=external handshake
        .DEST_SYNC_FF(FF_NUM),  // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(1),  // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_SYNC_FF(FF_NUM),  // DECIMAL; range: 2-10
        .WIDTH(CDC_SRC_DATA_WIDTH)  // DECIMAL; range: 1-1024
    ) xpm_cdc_handshake_addr (
        .dest_out(SRC_dest_out),
        .dest_req(SRC_dest_req),
        .src_rcv (SRC_src_rcv),
        .dest_ack(),
        .dest_clk(dest_clk),
        .src_clk (src_clk),
        .src_in  (SRC_src_in),
        .src_send(SRC_src_send)
    );

    typedef enum {
        SRC_IDLE,
        SRC_WAIT_DATA,
        SRC_ACK
    } src_state_t;
    src_state_t src_state;

    always @(posedge src_clk or posedge src_rst) begin
        if (src_rst) begin
            src_state    <= SRC_IDLE;
            wb_ack_o     <= 1'b0;
            wb_dat_o     <= '0;
            SRC_src_in   <= '0;
            SRC_src_send <= 1'b0;
            debug_count  <= '0;
            debug_led    <= '0;
        end else begin
            if (wb_cyc_i && wb_stb_i) begin
                debug_count <= debug_count + 1;
            end
            if (SRC_src_rcv) begin
                SRC_src_send <= 1'b0;
            end
            case (src_state)
                SRC_IDLE: begin
                    if (wb_cyc_i && wb_stb_i && !(SRC_src_send | SRC_src_rcv)) begin
                        SRC_src_in   <= {wb_adr_i, wb_dat_i, wb_sel_i, wb_we_i};
                        SRC_src_send <= 1'b1;
                        src_state    <= SRC_WAIT_DATA;
                    end
                end
                SRC_WAIT_DATA: begin
                    if (DEST_dest_req) begin
                        wb_dat_o  <= DEST_dest_out;
                        wb_ack_o  <= 1'b1;
                        src_state <= SRC_ACK;
                    end
                end
                SRC_ACK: begin
                    debug_count              <= '0;
                    debug_led[debug_count-7] <= 1;
                    wb_ack_o                 <= 1'b0;
                    src_state                <= SRC_IDLE;
                end
                default: begin
                    src_state <= SRC_IDLE;
                end
            endcase
        end
    end
    /* =========== SRC to DEST end =========== */

    /* =========== DEST to SRC begin =========== */
    xpm_cdc_handshake #(
        .DEST_EXT_HSK(0),  // DECIMAL; 0=internal handshake, 1=external handshake
        .DEST_SYNC_FF(FF_NUM),  // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(1),  // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_SYNC_FF(FF_NUM),  // DECIMAL; range: 2-10
        .WIDTH(CDC_DEST_DATA_WIDTH)  // DECIMAL; range: 1-1024
    ) xpm_cdc_handshake_data (
        .dest_out(DEST_dest_out),
        .dest_req(DEST_dest_req),
        .src_rcv (DEST_src_rcv),
        .dest_ack(),
        .dest_clk(src_clk),
        .src_clk (dest_clk),
        .src_in  (DEST_src_in),
        .src_send(DEST_src_send)
    );

    typedef enum {
        DEST_IDLE,
        DEST_WAIT_ACK,
        DEST_WAIT_RCV_N,
        DEST_WAIT_RCV
    } dest_state_t;
    dest_state_t dest_state;

    always @(posedge dest_clk or posedge dest_rst) begin
        if (dest_rst) begin
            dest_state    <= DEST_IDLE;
            dest_wb_cyc_o <= 1'b0;
            dest_wb_stb_o <= 1'b0;
            dest_wb_adr_o <= '0;
            dest_wb_dat_o <= '0;
            dest_wb_sel_o <= '0;
            dest_wb_we_o  <= 1'b0;
            DEST_src_in   <= '0;
            DEST_src_send <= 1'b0;
        end else begin
            case (dest_state)
                DEST_IDLE: begin
                    if (SRC_dest_req) begin
                        dest_wb_cyc_o <= 1'b1;
                        dest_wb_stb_o <= 1'b1;
                        {dest_wb_adr_o, dest_wb_dat_o, dest_wb_sel_o, dest_wb_we_o} <= SRC_dest_out;
                        dest_state <= DEST_WAIT_ACK;
                    end
                end
                DEST_WAIT_ACK: begin
                    if (dest_wb_ack_i) begin
                        dest_wb_cyc_o <= 1'b0;
                        dest_wb_stb_o <= 1'b0;
                        DEST_src_in   <= dest_wb_dat_i;
                        if (!DEST_src_rcv) begin
                            DEST_src_send <= 1'b1;
                            dest_state    <= DEST_WAIT_RCV;
                        end else begin
                            DEST_src_send <= 1'b0;
                            dest_state    <= DEST_WAIT_RCV_N;
                        end
                    end
                end
                DEST_WAIT_RCV_N: begin
                    if (!DEST_src_rcv) begin
                        DEST_src_send <= 1'b1;
                        dest_state    <= DEST_WAIT_RCV;
                    end
                end
                DEST_WAIT_RCV: begin
                    if (DEST_src_rcv) begin
                        DEST_src_send <= 1'b0;
                        dest_state    <= DEST_IDLE;
                    end
                end
                default: begin
                    dest_state <= DEST_IDLE;
                end
            endcase
        end
    end
    /* =========== DEST to SRC end =========== */

endmodule
