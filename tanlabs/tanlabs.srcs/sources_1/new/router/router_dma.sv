`timescale 1ns / 1ps `default_nettype none

module router_dma #(
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32
) (
    /* =========== CPU Domain =========== */
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

    /* =========== Router Domain =========== */
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
    output reg dma_router_read_fin_o,

    // AXI Stream
    input  wire [7:0] rx8_data,
    input  wire       rx8_last,
    input  wire       rx8_user,
    input  wire       rx8_valid,
    output wire       rx8_ready,

    output wire [7:0] tx8_data,
    output wire       tx8_last,
    output wire       tx8_user,
    output wire       tx8_valid,
    input  wire       tx8_ready
);
    reg         bram_cpu_en;
    reg         bram_cpu_we;
    reg  [ 9:0] bram_cpu_addr;
    reg  [31:0] bram_cpu_din;
    wire [31:0] bram_cpu_dout;

    reg         bram_router_en;
    reg         bram_router_we;
    reg  [ 9:0] bram_router_addr;
    reg  [31:0] bram_router_din;
    wire [31:0] bram_router_dout;

    // Port B 须没有输出寄存器
    router_dma_data router_dma_data_read (
        .clka (cpu_clk),        // input wire clka
        .ena  (bram_cpu_en),    // input wire ena
        .wea  (bram_cpu_we),    // input wire [0 : 0] wea
        .addra(bram_cpu_addr),  // input wire [9 : 0] addra
        .dina (bram_cpu_din),   // input wire [31 : 0] dina
        .douta(bram_cpu_dout),  // output wire [31 : 0] douta

        .clkb (eth_clk),           // input wire clkb
        .enb  (bram_router_en),    // input wire enb
        .web  (bram_router_we),    // input wire [0 : 0] web
        .addrb(bram_router_addr),  // input wire [9 : 0] addrb
        .dinb (bram_router_din),   // input wire [31 : 0] dinb
        .doutb(bram_router_dout)   // output wire [31 : 0] doutb
    );

    /* =========== CPU Domain =========== */
    // 根据 sel 获取 mask
    reg [WISHBONE_DATA_WIDTH-1:0] data_mask;
    always_comb begin
        for (int i = 0; i < WISHBONE_DATA_WIDTH / 8; i = i + 1) begin
            data_mask[i*8+:8] = wb_sel_i[i] ? 8'hff : 8'h00;
        end
    end

    wire request;
    assign request = wb_cyc_i && wb_stb_i;

    always_comb begin
        wb_dat_o      = bram_cpu_dout & data_mask;
        bram_cpu_en   = 1'b1;
        bram_cpu_addr = wb_adr_i[11:2];
        bram_cpu_din  = (bram_cpu_dout & ~data_mask) | (wb_dat_i & data_mask);
    end

    typedef enum {
        CPU_IDLE,
        CPU_WAIT,
        CPU_READ,
        CPU_WRITE
    } dma_cpu_state_t;
    dma_cpu_state_t dma_cpu_state;

    always_ff @(posedge cpu_clk) begin
        if (cpu_reset) begin
            dma_cpu_state <= CPU_IDLE;
            bram_cpu_we   <= 1'b0;
        end else begin
            case (dma_cpu_state)
                CPU_IDLE: begin
                    if (request) begin
                        dma_cpu_state <= CPU_WAIT;
                    end
                end
                CPU_WAIT: begin
                    wb_ack_o <= 1'b1;
                    if (wb_we_i == 1'b0) begin
                        dma_cpu_state <= CPU_READ;
                    end else begin
                        bram_cpu_we   <= 1'b1;
                        dma_cpu_state <= CPU_WRITE;
                    end
                end
                CPU_READ: begin
                    wb_ack_o      <= 1'b0;
                    dma_cpu_state <= CPU_IDLE;
                end
                CPU_WRITE: begin
                    wb_ack_o      <= 1'b0;
                    bram_cpu_we   <= 1'b0;
                    dma_cpu_state <= CPU_IDLE;
                end
                default: begin
                    dma_cpu_state <= CPU_IDLE;
                end
            endcase
        end
    end

    /* =========== Router Domain =========== */
    wire [31:0] rx_data;
    wire [ 3:0] rx_keep;
    wire        rx_last;
    reg         rx_ready;
    wire [ 3:0] rx_user;
    wire        rx_valid;

    reg  [31:0] tx_data;
    reg  [ 3:0] tx_keep;
    reg         tx_last;
    wire        tx_ready;
    reg  [ 3:0] tx_user;
    reg         tx_valid;

    axis_dwidth_converter_8_32 dma_rx_axis_dwidth_converter_8_32 (
        .aclk   (eth_clk),    // input wire aclk
        .aresetn(~eth_reset), // input wire aresetn

        .s_axis_tvalid(rx8_valid),  // input wire s_axis_tvalid
        .s_axis_tready(rx8_ready),  // output wire s_axis_tready
        .s_axis_tdata (rx8_data),   // input wire [7 : 0] s_axis_tdata
        .s_axis_tkeep (1'b1),       // input wire [0 : 0] s_axis_tkeep
        .s_axis_tlast (rx8_last),   // input wire s_axis_tlast
        .s_axis_tuser (rx8_user),   // input wire [0 : 0] s_axis_tuser

        .m_axis_tvalid(rx_valid),  // output wire m_axis_tvalid
        .m_axis_tready(rx_ready),  // input wire m_axis_tready
        .m_axis_tdata (rx_data),   // output wire [31 : 0] m_axis_tdata
        .m_axis_tkeep (rx_keep),   // output wire [3 : 0] m_axis_tkeep
        .m_axis_tlast (rx_last),   // output wire m_axis_tlast
        .m_axis_tuser (rx_user)    // output wire [3 : 0] m_axis_tuser
    );

    axis_dwidth_converter_32_8 dma_tx_axis_dwidth_converter_32_8 (
        .aclk   (eth_clk),    // input wire aclk
        .aresetn(~eth_reset), // input wire aresetn

        .s_axis_tvalid(tx_valid),  // input wire s_axis_tvalid
        .s_axis_tready(tx_ready),  // output wire s_axis_tready
        .s_axis_tdata (tx_data),   // input wire [31 : 0] s_axis_tdata
        .s_axis_tkeep (tx_keep),   // input wire [3 : 0] s_axis_tkeep
        .s_axis_tlast (tx_last),   // input wire s_axis_tlast
        .s_axis_tuser (tx_user),   // input wire [3 : 0] s_axis_tuser

        .m_axis_tvalid(tx8_valid),  // output wire m_axis_tvalid
        .m_axis_tready(tx8_ready),  // input wire m_axis_tready
        .m_axis_tdata (tx8_data),   // output wire [7 : 0] m_axis_tdata
        .m_axis_tkeep (),           // output wire [0 : 0] m_axis_tkeep
        .m_axis_tlast (tx8_last),   // output wire m_axis_tlast
        .m_axis_tuser (tx8_user)    // output wire [0 : 0] m_axis_tuser
    );

    typedef enum {
        RT_IDLE,

        RT_READ_START,
        RT_READ_BRAM,
        RT_READ_TX,

        RT_WRITE_INIT,
        RT_WRITE_CHECK,
        RT_WRITE_RX,
        RT_WRITE_END

    } dma_router_state_t;
    dma_router_state_t dma_router_state;

    always_comb begin
        bram_router_en = 1'b1;
    end

    reg [11:0] length;

    always_ff @(posedge eth_clk) begin
        if (eth_reset) begin
            dma_router_request_o     <= 1'b0;
            dma_router_request_fin_o <= 1'b0;
            dma_router_sent_fin_o    <= 1'b0;
            dma_router_read_fin_o    <= 1'b0;

            dma_router_state         <= RT_IDLE;
            bram_router_we           <= 1'b0;
            bram_router_addr         <= '0;
            bram_router_din          <= '0;

            rx_ready                 <= 1'b0;

            tx_valid                 <= 1'b0;
            tx_data                  <= '0;
            tx_keep                  <= '0;
            tx_last                  <= 1'b0;
            tx_user                  <= '0;

            length                   <= '0;

        end else begin
            dma_router_request_o     <= 1'b0;
            dma_router_request_fin_o <= 1'b0;
            dma_router_sent_fin_o    <= 1'b0;
            dma_router_read_fin_o    <= 1'b0;
            bram_router_we           <= 1'b0;
            case (dma_router_state)
                RT_IDLE: begin
                    // RT_IDLE 状态 addr 须为 0
                    if (dma_wait_router_i) begin
                        // 先处理读取
                        bram_router_addr <= '1;  // 流水线读取, 预先读取下一个数据
                        dma_router_state <= RT_READ_START;
                    end else if (!dma_wait_cpu_i && !dma_cpu_lock_i && rx_valid) begin
                        // 再处理写入
                        dma_router_request_o <= 1'b1;
                        dma_router_state     <= RT_WRITE_INIT;
                    end
                end

                RT_READ_START: begin
                    length           <= bram_router_din;
                    dma_router_state <= RT_READ_BRAM;
                end
                RT_READ_BRAM: begin
                    if (length) begin
                        tx_valid <= 1'b1;
                        tx_data  <= bram_router_din;
                        if (length < 4) begin
                            tx_last <= 1'b0;
                            tx_keep <= 4'b1111;
                            length  <= length - 4;
                        end else begin
                            tx_last <= 1'b1;
                            unique case (length)
                                1: tx_keep <= 4'b0001;
                                2: tx_keep <= 4'b0011;
                                3: tx_keep <= 4'b0111;
                                4: tx_keep <= 4'b1111;
                            endcase
                            length <= '0;
                        end
                        bram_router_addr <= bram_router_addr + 1;
                        dma_router_state <= RT_READ_TX;
                    end else begin
                        dma_router_read_fin_o <= 1'b1;
                        bram_router_addr      <= '0;
                        bram_router_we        <= 1'b0;
                        dma_router_state      <= RT_IDLE;
                    end
                end
                RT_READ_TX: begin
                    if (tx_ready) begin
                        tx_valid         <= 1'b0;
                        dma_router_state <= RT_READ_BRAM;
                    end
                end

                RT_WRITE_INIT: begin
                    dma_router_state <= RT_WRITE_CHECK;
                end
                RT_WRITE_CHECK: begin
                    if (dma_router_lock_i) begin
                        length           <= '0;
                        rx_ready         <= 1'b1;
                        dma_router_state <= RT_WRITE_RX;
                    end
                end
                RT_WRITE_RX: begin
                    if (rx_valid) begin
                        bram_router_din  <= rx_data;
                        bram_router_we   <= 1'b1;
                        bram_router_addr <= bram_router_addr + 1;
                        if (rx_last) begin
                            unique case (rx_keep)
                                4'b0001: length <= length + 1;
                                4'b0011: length <= length + 2;
                                4'b0111: length <= length + 3;
                                4'b1111: length <= length + 4;
                            endcase
                            rx_ready         <= 1'b0;
                            dma_router_state <= RT_WRITE_END;
                        end else begin
                            length <= length + 4;
                        end
                    end else begin
                        bram_router_we <= 1'b0;
                    end
                end
                RT_WRITE_END: begin
                    bram_router_din          <= length;
                    bram_router_we           <= 1'b1;
                    bram_router_addr         <= '0;
                    length                   <= '0;
                    dma_router_request_fin_o <= 1'b1;
                    dma_router_sent_fin_o    <= 1'b1;
                    dma_router_state         <= RT_IDLE;
                end

                default: begin
                    bram_router_addr <= '0;
                    bram_router_we   <= 1'b0;
                    dma_router_state <= RT_IDLE;
                end
            endcase
        end
    end

endmodule
