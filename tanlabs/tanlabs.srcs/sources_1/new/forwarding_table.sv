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

    forwarding_beat s      [PIPELINE_LENGTH:0];
    forwarding_beat s_reg  [PIPELINE_LENGTH:1];
    wire            s_ready[PIPELINE_LENGTH:0];

    assign in_ready       = s_ready[0];
    assign s[0].stop      = '0;
    assign s[0].matched   = '0;
    assign s[0].leaf_addr = '0;
    assign s[0].node_addr = '0;  // 默认根节点地址为 0
    assign s[0].beat      = in;

    logic         [                      3:0] state           [PIPELINE_LENGTH:1];

    // 内部节点读取信号
    logic         [   CHILD_ADDR_WIDTH - 1:0] ft_addr         [PIPELINE_LENGTH:1];
    FTE_node                                  ft_dout         [PIPELINE_LENGTH:1];
    FTE_node                                  ft_dout_reg     [PIPELINE_LENGTH:1];
    // 叶节点读取信号
    logic         [    LEAF_ADDR_WIDTH - 1:0] leaf_addr;
    leaf_node                                 leaf_out;
    // Next_hop 节点读取信号
    logic         [NEXT_HOP_ADDR_WIDTH - 1:0] next_hop_addr;
    next_hop_node                             next_hop_out;

    // 内部节点存储 BRAM 的端口 A 接入总线
    wire                                      ft_en_a         [PIPELINE_LENGTH:1];
    wire                                      ft_we_a         [PIPELINE_LENGTH:1];
    wire          [   CHILD_ADDR_WIDTH - 1:0] ft_addr_a       [PIPELINE_LENGTH:1];
    FTE_node                                  ft_din_a        [PIPELINE_LENGTH:1];
    FTE_node                                  ft_dout_a       [PIPELINE_LENGTH:1];
    // 叶节点存储 LUTRAM 的端口 A 接入总线
    logic         [    LEAF_ADDR_WIDTH - 1:0] leaf_addr_a;
    leaf_node                                 leaf_in_a;
    leaf_node                                 leaf_out_a;
    wire                                      leaf_we_a;
    // Next-Hop 节点存储 LUTRAM 的端口 A 接入总线
    logic         [NEXT_HOP_ADDR_WIDTH - 1:0] next_hop_addr_a;
    next_hop_node                             next_hop_in_a;
    next_hop_node                             next_hop_out_a;
    wire                                      next_hop_we_a;

    // Wishbone 总线 slave 接口
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

        .ft_en  (ft_en_a),
        .ft_we  (ft_we_a),
        .ft_addr(ft_addr_a),
        .ft_din (ft_din_a),
        .ft_dout(ft_dout_a),

        .leaf_addr(leaf_addr_a),
        .leaf_in  (leaf_in_a),
        .leaf_out (leaf_out_a),
        .leaf_we  (leaf_we_a),

        .next_hop_addr(next_hop_addr_a),
        .next_hop_in  (next_hop_in_a),
        .next_hop_out (next_hop_out_a),
        .next_hop_we  (next_hop_we_a)
    );

    // 例化流水线各级存储
    generate
        for (genvar i = 1; i <= PIPELINE_LENGTH; ++i) begin : forwarding_data_gen
            forwarding_data_0 FT_data_0 (
                .clka (cpu_clk),       // input wire clka
                .ena  (ft_en_a[i]),    // input wire ena
                .wea  (ft_we_a[i]),    // input wire [0 : 0] wea
                .addra(ft_addr_a[i]),  // input wire [9 : 0] addra
                .dina (ft_din_a[i]),   // input wire [71 : 0] dina
                .douta(ft_dout_a[i]),  // output wire [71 : 0] douta
                .clkb (clk),           // input wire clkb
                .enb  (1'b1),          // input wire enb
                .web  (1'b0),          // input wire [0 : 0] web
                .addrb(ft_addr[i]),    // input wire [9 : 0] addrb
                .dinb ('b0),           // input wire [71 : 0] dinb
                .doutb(ft_dout[i])     // output wire [71 : 0] doutb
            );
        end
    endgenerate

    // 例化叶节点存储
    forwarding_leaf_data leaf_data (
        .a   (leaf_addr_a),  // input wire [9 : 0] a
        .d   (leaf_in_a),    // input wire [7 : 0] d
        .dpra(leaf_addr),    // input wire [9 : 0] dpra
        .clk (cpu_clk),      // input wire clk
        .we  (leaf_we_a),    // input wire we
        .spo (leaf_out_a),   // output wire [7 : 0] spo
        .dpo (leaf_out)      // output wire [7 : 0] dpo
    );

    // 例化 Next-Hop 节点存储
    forwarding_next_hop_data next_hop_data (
        .a   (next_hop_addr_a),  // input wire [5 : 0] a
        .d   (next_hop_in_a),    // input wire [135 : 0] d
        .dpra(next_hop_addr),    // input wire [5 : 0] dpra
        .clk (cpu_clk),          // input wire clk
        .we  (next_hop_we_a),    // input wire we
        .spo (next_hop_out_a),   // output wire [135 : 0] spo
        .dpo (next_hop_out)      // output wire [135 : 0] dpo
    );

    // 流水线
    generate
        for (genvar i = 1; i <= PIPELINE_LENGTH; ++i) begin : pipeline_gen
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
            wire [                 127:0] ip_little_endian;
            reg  [                 127:0] ip_for_match;

            assign ip_little_endian = {<<8{s[i-1].beat.data.ip6.dst}};

            forwarding_bitmap_parser u_forwarding_bitmap_parser (
                .node   (ft_dout_reg[i]),
                .pattern(ip_for_match[STRIDE-1:0]),

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
                    ip_for_match   <= 'b0;
                end else begin
                    if (state[i] == 'b0) begin
                        if (s_ready[i]) begin
                            s_reg[i] <= s[i-1];
                            if (`should_search(s[i-1])) begin
                                state[i] <= 'b1;
                                ft_addr[i] <= s[i-1].node_addr;
                                ip_for_match <= {<<STRIDE{ip_little_endian << ((i-1)*STRIDE*LAYER_HEIGHT)}};
                            end
                        end
                    end
                    // 读取 BRAM, 解析 bitmap
                    for (int j = 1; j <= LAYER_HEIGHT; ++j) begin
                        // 寄存 BRAM 中信息, 可能可以让解析的组合逻辑电路时序更优
                        if (state[i] == (2 * j - 1)) begin
                            state[i]       <= state[i] + 1;
                            ft_dout_reg[i] <= ft_dout[i];
                        end
                        // 解析完成
                        if (state[i] == (2 * j)) begin
                            // 是否需要到下一级流水线
                            if (j == LAYER_HEIGHT) begin
                                state[i] <= 'b0;
                            end else begin
                                state[i] <= state[i] + 1;
                            end
                            // 若匹配到前缀, 则更新
                            if (parser_matched) begin
                                s_reg[i].matched   <= 1'b1;
                                s_reg[i].leaf_addr <= parser_leaf_addr;
                            end
                            s_reg[i].node_addr <= parser_node_addr;  // 更新当前节点地址
                            s_reg[i].stop <= parser_stop; // 表示是否结束查询（对应子节点为空或为叶节点）
                            // 若已结束查询, 则结束状态机, 进入下一级流水线
                            if (parser_stop) begin
                                state[i] <= 'b0;
                                // 否则继续查询 BRAM
                            end else begin
                                ft_addr[i] <= parser_node_addr;
                            end
                            // 更新 ip_for_match
                            ip_for_match <= ip_for_match >> STRIDE;
                        end
                    end
                end
            end
        end
    endgenerate

    // 查询叶节点中 next_hop 编号, 再查询 next_hop 表
    typedef enum {
        ST_INIT,  // 初始阶段
        ST_GET_LEAF,  // 完成查询叶节点
        ST_GET_NEXT_HOP  // 完成查询 next_hop 表
    } after_state_t;

    reg error;
    forwarding_beat after, after_reg;
    after_state_t after_state;
    wire          after_ready;
    assign s_ready[PIPELINE_LENGTH] = (after_ready && after_state == ST_INIT) || !s[PIPELINE_LENGTH].beat.valid;

    always_comb begin
        after            = after_reg;
        after.beat.valid = after_reg.beat.valid && after_state == ST_INIT;
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            error         <= 'b0;
            after_reg     <= '{default: 0};
            after_state   <= ST_INIT;
            leaf_addr     <= 'b0;
            next_hop_addr <= 'b0;
            next_hop_ip   <= 'b0;
        end else begin
            case (after_state)
                ST_INIT: begin
                    if (after_ready) begin
                        after_reg <= s[PIPELINE_LENGTH];
                        if (`should_handle(s[PIPELINE_LENGTH].beat)) begin
                            // 应有匹配（至少根节点上有默认路由）, 若无匹配则错误
                            if (s[PIPELINE_LENGTH].matched) begin
                                leaf_addr   <= s[PIPELINE_LENGTH].leaf_addr;
                                after_state <= ST_GET_LEAF;
                            end else begin
                                error       <= 1'b1;
                                after_state <= ST_INIT;
                            end
                        end
                    end
                end
                // 查完叶节点, 根据叶节点中存储的 next_hop 编号, 查 next_hop 表
                ST_GET_LEAF: begin
                    next_hop_addr <= leaf_out.next_hop_addr;
                    after_state   <= ST_GET_NEXT_HOP;
                end
                // 查完 next_hop 表, 更新下一跳地址和出口
                ST_GET_NEXT_HOP: begin
                    next_hop_ip              <= next_hop_out.ip;
                    after_reg.beat.meta.dest <= next_hop_out.port;
                    after_state              <= ST_INIT;
                end
            endcase
        end
    end

    assign out         = after.beat;
    assign after_ready = out_ready;

endmodule
