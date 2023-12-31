`timescale 1ns / 1ps `default_nettype none

localparam CHECKSUM_START_ADDA = 32;
localparam CHECKSUM_HEADER_LENGTH = (CHECKSUM_START_ADDA - 1) * 2;
localparam CHECKSUM_WB_ADDR = 2047;

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
    output reg dma_router_sent_fin_o,
    output reg dma_router_read_fin_o,

    // 校验和交互
    input  wire dma_cpu_checksum_request_i,
    output reg  dma_router_checksum_fin_o,

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
    input  wire       tx8_ready,

    output reg drop_led
);
    reg         bram_cpu_en;
    reg  [ 3:0] bram_cpu_we;
    reg  [ 9:0] bram_cpu_addr;
    reg  [31:0] bram_cpu_din;
    wire [31:0] bram_cpu_dout;

    reg         bram_router_en;
    reg  [ 3:0] bram_router_we;
    reg  [ 9:0] bram_router_addr;
    reg  [31:0] bram_router_din;
    wire [31:0] bram_router_dout;

    // Port B 须没有输出寄存器
    router_dma_data router_dma_data_read (
        .clka (cpu_clk),        // input wire clka
        .ena  (bram_cpu_en),    // input wire ena
        .wea  (bram_cpu_we),    // input wire [3 : 0] wea
        .addra(bram_cpu_addr),  // input wire [9 : 0] addra
        .dina (bram_cpu_din),   // input wire [31 : 0] dina
        .douta(bram_cpu_dout),  // output wire [31 : 0] douta

        .clkb (eth_clk),           // input wire clkb
        .enb  (bram_router_en),    // input wire enb
        .web  (bram_router_we),    // input wire [3 : 0] web
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
        CPU_READ,
        CPU_WRITE
    } dma_cpu_state_t;
    dma_cpu_state_t dma_cpu_state;

    always_ff @(posedge cpu_clk) begin
        if (cpu_reset) begin
            dma_cpu_state <= CPU_IDLE;
            bram_cpu_we   <= 4'b0000;
            wb_ack_o      <= 1'b0;
        end else begin
            case (dma_cpu_state)
                CPU_IDLE: begin
                    if (request) begin
                        wb_ack_o <= 1'b1;
                        if (wb_we_i == 1'b0) begin
                            dma_cpu_state <= CPU_READ;
                        end else begin
                            bram_cpu_we   <= 4'b1111;
                            dma_cpu_state <= CPU_WRITE;
                        end
                    end
                end
                CPU_READ: begin
                    wb_ack_o      <= 1'b0;
                    dma_cpu_state <= CPU_IDLE;
                end
                CPU_WRITE: begin
                    wb_ack_o      <= 1'b0;
                    bram_cpu_we   <= 4'b0000;
                    dma_cpu_state <= CPU_IDLE;
                end
                default: begin
                    dma_cpu_state <= CPU_IDLE;
                end
            endcase
        end
    end

    /* =========== Router Domain =========== */
    wire [15:0] rx_data;
    wire [ 1:0] rx_keep;
    wire        rx_last;
    reg         rx_ready;
    wire [ 1:0] rx_user;
    wire        rx_valid;

    reg  [15:0] tx_data;
    reg  [ 1:0] tx_keep;
    reg         tx_last;
    wire        tx_ready;
    reg  [ 1:0] tx_user;
    reg         tx_valid;

    axis_dwidth_converter_8_16 dma_rx_axis_dwidth_converter_8_16 (
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
        .m_axis_tdata (rx_data),   // output wire [15 : 0] m_axis_tdata
        .m_axis_tkeep (rx_keep),   // output wire [1 : 0] m_axis_tkeep
        .m_axis_tlast (rx_last),   // output wire m_axis_tlast
        .m_axis_tuser (rx_user)    // output wire [1 : 0] m_axis_tuser
    );

    axis_dwidth_converter_16_8 dma_tx_axis_dwidth_converter_16_8 (
        .aclk   (eth_clk),    // input wire aclk
        .aresetn(~eth_reset), // input wire aresetn

        .s_axis_tvalid(tx_valid),  // input wire s_axis_tvalid
        .s_axis_tready(tx_ready),  // output wire s_axis_tready
        .s_axis_tdata (tx_data),   // input wire [15 : 0] s_axis_tdata
        .s_axis_tkeep (tx_keep),   // input wire [1 : 0] s_axis_tkeep
        .s_axis_tlast (tx_last),   // input wire s_axis_tlast
        .s_axis_tuser (tx_user),   // input wire [1 : 0] s_axis_tuser

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
        RT_WRITE_USER_ERR,
        RT_WRITE_END,

        RT_CHECKSUM_START,
        RT_CHECKSUM_CALC,
        RT_CHECKSUM_WB,
        RT_CHECKSUM_END

    } dma_router_state_t;
    dma_router_state_t        dma_router_state;

    reg                       router_we;
    reg                [10:0] router_addr;
    reg                [10:0] router_addr_reg;
    reg                [15:0] router_din;
    reg                [15:0] router_dout;
    always_comb begin
        bram_router_en   = 1'b1;
        bram_router_addr = router_addr[10:1];
        if (router_addr[0] == 1'b0) begin
            bram_router_din = {16'b0, router_din};
            bram_router_we  = {2'b00, router_we, router_we};
        end else begin
            bram_router_din = {router_din, 16'b0};
            bram_router_we  = {router_we, router_we, 2'b00};
        end
        if (router_addr_reg[0] == 1'b0) begin
            router_dout = bram_router_dout[15:0];
        end else begin
            router_dout = bram_router_dout[31:16];
        end
    end

    reg [11:0] length;
    reg [16:0] checksum;

    always_ff @(posedge eth_clk) begin
        if (eth_reset) begin
            dma_router_request_o      <= 1'b0;
            dma_router_sent_fin_o     <= 1'b0;
            dma_router_read_fin_o     <= 1'b0;
            dma_router_checksum_fin_o <= 1'b0;

            dma_router_state          <= RT_IDLE;
            router_we                 <= 1'b0;
            router_addr               <= '0;
            router_addr_reg           <= '0;
            router_din                <= '0;

            rx_ready                  <= 1'b0;

            tx_valid                  <= 1'b0;
            tx_data                   <= '0;
            tx_keep                   <= '0;
            tx_last                   <= 1'b0;
            tx_user                   <= '0;

            length                    <= '0;
            checksum                  <= '0;

            drop_led                  <= 1'b0;

        end else begin
            dma_router_request_o      <= 1'b0;
            dma_router_sent_fin_o     <= 1'b0;
            dma_router_read_fin_o     <= 1'b0;
            dma_router_checksum_fin_o <= 1'b0;
            router_we                 <= 1'b0;
            router_addr_reg           <= router_addr;
            drop_led                  <= 1'b0;
            case (dma_router_state)
                RT_IDLE: begin
                    // RT_IDLE 状态 addr 须为 0
                    if (dma_cpu_checksum_request_i) begin
                        // 处理校验和请求
                        // 流水线读取, 预先读取下一个数据
                        router_addr      <= CHECKSUM_START_ADDA;
                        dma_router_state <= RT_CHECKSUM_START;
                    end else if (!dma_router_request_o && !dma_router_sent_fin_o && !dma_router_read_fin_o) begin
                        if (dma_wait_router_i) begin
                            // 先处理读取
                            router_addr <= 1'b1;  // 流水线读取, 预先读取下一个数据
                            dma_router_state <= RT_READ_START;
                        end else if (!dma_wait_cpu_i && !dma_cpu_lock_i && rx_valid) begin
                            // 再处理写入
                            dma_router_request_o <= 1'b1;
                            dma_router_state     <= RT_WRITE_INIT;
                        end
                    end
                end

                RT_CHECKSUM_START: begin
                    length      <= router_dout - CHECKSUM_HEADER_LENGTH;
                    router_addr <= router_addr + 1;
                    checksum    <= '0;
                    if (router_dout <= CHECKSUM_HEADER_LENGTH) begin
                        dma_router_state <= RT_CHECKSUM_WB;
                    end else begin
                        dma_router_state <= RT_CHECKSUM_CALC;
                    end
                end

                RT_CHECKSUM_CALC: begin
                    router_addr <= router_addr + 1;
                    if (length == 1) begin
                        checksum <= {1'b0, checksum[15:0]} + {router_dout[7:0], 8'b0} + checksum[16];
                        length <= '0;
                    end else begin
                        checksum <= {1'b0, checksum[15:0]} + {router_dout[7:0], router_dout[15:8]} + checksum[16];
                        length <= length - 2;
                    end
                    if (length > 2) begin
                        dma_router_state <= RT_CHECKSUM_CALC;
                    end else begin
                        dma_router_state <= RT_CHECKSUM_WB;
                    end
                end

                RT_CHECKSUM_WB: begin
                    router_din       <= checksum[15:0] + checksum[16];
                    router_we        <= 1'b1;
                    router_addr      <= CHECKSUM_WB_ADDR;
                    dma_router_state <= RT_CHECKSUM_END;
                end

                RT_CHECKSUM_END: begin
                    router_addr               <= '0;
                    length                    <= '0;
                    dma_router_checksum_fin_o <= 1'b1;
                    dma_router_state          <= RT_IDLE;
                end

                RT_READ_START: begin
                    length           <= router_dout;
                    dma_router_state <= RT_READ_BRAM;
                end
                RT_READ_BRAM: begin
                    if (length) begin
                        tx_valid <= 1'b1;
                        tx_data  <= router_dout;
                        if (length > 2) begin
                            tx_last <= 1'b0;
                            tx_keep <= 2'b11;
                            length  <= length - 2;
                        end else begin
                            tx_last <= 1'b1;
                            unique case (length)
                                1: tx_keep <= 2'b01;
                                2: tx_keep <= 2'b11;
                            endcase
                            length <= '0;
                        end
                        router_addr      <= router_addr + 1;
                        dma_router_state <= RT_READ_TX;
                    end else begin
                        dma_router_read_fin_o <= 1'b1;
                        router_addr           <= '0;
                        router_we             <= 1'b0;
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
                        checksum         <= '0;
                        dma_router_state <= RT_WRITE_RX;
                    end else begin
                        dma_router_state <= RT_IDLE;
                    end
                end
                RT_WRITE_RX: begin
                    if (rx_valid) begin
                        if (rx_user) begin
                            length    <= '0;
                            router_we <= 1'b0;
                            drop_led  <= 1'b1;
                            if (rx_last) begin
                                rx_ready         <= 1'b0;
                                dma_router_state <= RT_WRITE_END;
                            end else begin
                                dma_router_state <= RT_WRITE_USER_ERR;
                            end
                        end else begin
                            router_din  <= rx_data;
                            router_we   <= 1'b1;
                            router_addr <= router_addr + 1;
                            if (rx_last) begin
                                unique case (rx_keep)
                                    2'b01: begin
                                        length <= length + 1;
                                        if (length > CHECKSUM_HEADER_LENGTH - 2) begin
                                            checksum <= {1'b0, checksum[15:0]} + {rx_data[7:0], 8'b0} + checksum[16];
                                        end
                                    end
                                    2'b11: begin
                                        length <= length + 2;
                                        if (length > CHECKSUM_HEADER_LENGTH - 2) begin
                                            checksum <= {1'b0, checksum[15:0]} + {rx_data[7:0], rx_data[15:8]} + checksum[16];
                                        end
                                    end
                                endcase
                                rx_ready         <= 1'b0;
                                dma_router_state <= RT_WRITE_END;
                            end else begin
                                length <= length + 2;
                                if (length > CHECKSUM_HEADER_LENGTH - 2) begin
                                    checksum <= {1'b0, checksum[15:0]} + {rx_data[7:0], rx_data[15:8]} + checksum[16];
                                end
                            end
                        end
                    end else begin
                        router_we <= 1'b0;
                    end
                end
                RT_WRITE_USER_ERR: begin
                    if (rx_valid && rx_last) begin
                        rx_ready         <= 1'b0;
                        dma_router_state <= RT_WRITE_END;
                    end
                end
                RT_WRITE_END: begin
                    router_din            <= length;
                    router_we             <= 1'b1;
                    router_addr           <= '0;
                    length                <= '0;
                    dma_router_sent_fin_o <= 1'b1;
                    dma_router_state      <= RT_CHECKSUM_WB;
                end

                default: begin
                    router_addr      <= '0;
                    router_we        <= 1'b0;
                    dma_router_state <= RT_IDLE;
                end
            endcase
        end
    end

endmodule
