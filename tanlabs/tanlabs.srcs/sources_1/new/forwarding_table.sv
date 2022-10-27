`timescale 1ns / 1ps `default_nettype none

// 查询转发表, 给出下一跳地址和网口号
// 下一跳地址 next_hop_ip
// 目标网口号放置在 meta.dest

`include "forwarding_table.vh"

module forwarding_table #(
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32
) (
    input wire clk,
    input wire reset,

    input  frame_beat in,
    output reg        in_ready,

    output frame_beat         out,
    output reg        [127:0] next_hop_ip,
    input  wire               out_ready,

    // wishbone slave interface
    input  wire                             cpu_clk,
    input  wire                             wb_cyc_i,
    input  wire                             wb_stb_i,
    output reg                              wb_ack_o,
    input  wire [  WISHBONE_ADDR_WIDTH-1:0] wb_adr_i,
    input  wire [  WISHBONE_DATA_WIDTH-1:0] wb_dat_i,
    output reg  [  WISHBONE_DATA_WIDTH-1:0] wb_dat_o,
    input  wire [WISHBONE_DATA_WIDTH/8-1:0] wb_sel_i,
    input  wire                             wb_we_i
);

    forwarding_beat s      [PIPELINE_LENTGH:0];
    forwarding_beat s_reg  [PIPELINE_LENTGH:1];
    wire            s_ready[PIPELINE_LENTGH:0];

    assign in_ready       = s_ready[0];
    assign s[0].matched   = '0;
    assign s[0].leaf_addr = '0;
    assign s[0].node_addr = '0;  // 默认根节点地址为 0
    assign s[0].beat      = in;

    logic    [                   3:0] state      [PIPELINE_LENTGH:1];
    logic    [CHILD_ADDR_WIDTH - 1:0] ft_addr    [PIPELINE_LENTGH:1];
    FTE_node                          ft_dout    [PIPELINE_LENTGH:1];
    FTE_node                          ft_dout_reg[PIPELINE_LENTGH:1];

    // 端口 B 接入总线
    wire                              ft_en_b    [PIPELINE_LENTGH:1];
    wire                              ft_we_b    [PIPELINE_LENTGH:1];
    wire     [CHILD_ADDR_WIDTH - 1:0] ft_addr_b  [PIPELINE_LENTGH:1];
    FTE_node                          ft_din_b   [PIPELINE_LENTGH:1];
    FTE_node                          ft_dout_b  [PIPELINE_LENTGH:1];

    forwarding_ram_controller #(
        .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
        .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH)
    ) u_forwarding_ram_controller (
        .clk_i   (cpu_clk),
        .rst_i   (reset),
        .wb_cyc_i(wb_cyc_i),
        .wb_stb_i(wb_stb_i),
        .wb_ack_o(wb_ack_o),
        .wb_adr_i(wb_adr_i),
        .wb_dat_i(wb_dat_i),
        .wb_dat_o(wb_dat_o),
        .wb_sel_i(wb_sel_i),
        .wb_we_i (wb_we_i),

        .ft_en  (ft_en_b),
        .ft_we  (ft_we_b),
        .ft_addr(ft_addr_b),
        .ft_din (ft_din_b),
        .ft_dout(ft_dout_b)
    );

    // 初始化各级存储
    generate
        for (genvar i = 1; i <= PIPELINE_LENTGH; ++i) begin : forwarding_data_gen
            forwarding_data_0 FT_data_0 (
                .clka (clk),           // input wire clka
                .ena  (1'b1),          // input wire ena
                .wea  (1'b0),          // input wire [0 : 0] wea
                .addra(ft_addr[i]),    // input wire [9 : 0] addra
                .dina ('b0),           // input wire [71 : 0] dina
                .douta(ft_dout[i]),    // output wire [71 : 0] douta
                .clkb (cpu_clk),       // input wire clkb
                .enb  (ft_en_b[i]),    // input wire enb
                .web  (ft_we_b[i]),    // input wire [0 : 0] web
                .addrb(ft_addr_b[i]),  // input wire [9 : 0] addrb
                .dinb (ft_din_b[i]),   // input wire [71 : 0] dinb
                .doutb(ft_dout_b[i])   // output wire [71 : 0] doutb
            );
        end
    endgenerate

    // 流水线
    generate
        for (genvar i = 1; i <= PIPELINE_LENTGH; ++i) begin : pipeline_gen
            // 连接 ready 信号
            assign s_ready[i-1] = (s_ready[i] && state[i] == 'b0) || !s[i-1].beat.valid;

            // 连接状态机寄存器
            always_comb begin
                s[i]            = s_reg[i];
                s[i].beat.valid = s_reg[i].beat.valid && state[i] == 'b0;
            end

            // bitmap 解析与匹配
            wire                          parser_stop;
            wire                          parser_matched;
            wire [ LEAF_ADDR_WIDTH - 1:0] parser_leaf_addr;
            wire [CHILD_ADDR_WIDTH - 1:0] parser_node_addr;
            forwarding_bitmap_parser u_forwarding_bitmap_parser (
                .node(ft_dout_reg[i]),
                .pattern (s_reg[i].beat.data.ip6.dst[STRIDE-1:0]), // FIXME: 取出对应的地址段

                .stop     (parser_stop),
                .matched  (parser_matched),
                .leaf_addr(parser_leaf_addr),
                .node_addr(parser_node_addr)
            );

            // 状态机
            always_ff @(posedge clk or posedge reset) begin
                if (reset) begin
                    s_reg[i]       <= '{default: 0};
                    state[i]       <= 'b0;
                    ft_addr[i]     <= 'b0;
                    ft_dout_reg[i] <= '{default: 0};
                end else begin
                    if (state[i] == 'b0) begin
                        if (s_ready[i]) begin
                            s_reg[i] <= s[i-1];
                            // if (`should_search(s[i-1])) begin
                            //     state[i]   <= 'b1;
                            //     ft_addr[i] <= s[i-1].node_addr;
                            // end
                        end
                    end
                    // 读取 BRAM, 解析 bitmap
                    for (int j = 1; j <= LAYER_HEIGHT; ++j) begin
                        if (state[i] == (2 * j - 1)) begin
                            state[i]       <= state[i] + 1;
                            ft_dout_reg[i] <= ft_dout[i];
                        end
                        if (state[i] == (2 * j)) begin
                            if (j == LAYER_HEIGHT) begin
                                state[i] <= 'b0;
                            end else begin
                                state[i] <= state[i] + 1;
                            end
                            s_reg[i].stop <= parser_stop;
                            if (parser_matched) begin
                                s_reg[i].matched   <= 1'b1;
                                s_reg[i].leaf_addr <= parser_leaf_addr;
                            end
                            s_reg[i].node_addr <= parser_node_addr;
                            if (parser_stop) begin
                                state[i] <= 'b0;
                            end else begin
                                ft_addr[i] <= parser_node_addr;
                            end
                        end
                    end
                end
            end
        end
    endgenerate

    // TODO: 查询叶节点中 next_hop 编号, 再查询 next_hop 表
    typedef enum {
        ST_INIT,  // 初始阶段
        ST_GET_LEAF,  // 完成查询叶节点
        ST_GET_NEXT_HOP  // 完成查询 next_hop 表
    } after_state_t;

    reg error;
    forwarding_beat after, after_reg;
    after_state_t after_state;
    wire          after_ready;
    assign s_ready[PIPELINE_LENTGH] = (after_ready && after_state == ST_INIT) || !s[PIPELINE_LENTGH].beat.valid;

    always_comb begin
        after            = after_reg;
        after.beat.valid = after_reg.beat.valid && after_state == ST_INIT;
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            error       <= 'b0;
            after_reg   <= '{default: 0};
            after_state <= ST_INIT;
        end else if (after_ready) begin

        end
    end

endmodule
