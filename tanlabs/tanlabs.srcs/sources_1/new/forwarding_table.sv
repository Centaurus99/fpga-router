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
    input  wire                             cpu_reset,
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

    // Skid buffer
    basic_skid_buffer u_basic_skid_buffer_1 (
        .clk     (clk),
        .reset   (reset),
        .in_data (in),
        .in_ready(in_ready),

        .out_data (s[0].beat),
        .out_ready(s_ready[0])
    );

    assign s[0].stop      = '0;
    assign s[0].matched   = '0;
    assign s[0].leaf_addr = '0;
    assign s[0].node_addr = '0;  // 默认根节点地址为 0

    logic         [                      3:0] state           [  PIPELINE_LENGTH:1];

    // 内部节点读取信号
    logic         [   CHILD_ADDR_WIDTH - 1:0] ft_addr         [  PIPELINE_LENGTH:1];
    FTE_node                                  ft_dout         [  PIPELINE_LENGTH:1];
    // 叶节点读取信号
    reg           [    LEAF_ADDR_WIDTH - 1:0] leaf_addr;
    leaf_node                                 leaf_out;
    reg                                       leaf_send;
    wire                                      leaf_ack;
    // Next_hop 节点读取信号
    reg           [NEXT_HOP_ADDR_WIDTH - 1:0] next_hop_addr;
    next_hop_node                             next_hop_out;
    reg                                       next_hop_send;
    wire                                      next_hop_ack;

    // 内部节点存储 BRAM 的端口 A 接入总线
    // 为了方便 Wishbone 总线地址转换, 将编号改为从 0 开始
    wire                                      ft_en_a         [PIPELINE_LENGTH-1:0];
    wire                                      ft_we_a         [PIPELINE_LENGTH-1:0];
    wire          [   CHILD_ADDR_WIDTH - 1:0] ft_addr_a       [PIPELINE_LENGTH-1:0];
    FTE_node                                  ft_din_a        [PIPELINE_LENGTH-1:0];
    FTE_node                                  ft_dout_a       [PIPELINE_LENGTH-1:0];
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
        .rst_i   (cpu_reset),
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

    // 例化流水线各级存储, 单独例化前三级
    forwarding_data_1 FT_data_1 (
        .clka (cpu_clk),       // input wire clka
        .ena  (ft_en_a[0]),    // input wire ena
        .wea  (ft_we_a[0]),    // input wire [0 : 0] wea
        .addra(ft_addr_a[0]),  // input wire [14 : 0] addra
        .dina (ft_din_a[0]),   // input wire [71 : 0] dina
        .douta(ft_dout_a[0]),  // output wire [71 : 0] douta
        .clkb (clk),           // input wire clkb
        .enb  (1'b1),          // input wire enb
        .web  (1'b0),          // input wire [0 : 0] web
        .addrb(ft_addr[1]),    // input wire [14 : 0] addrb
        .dinb ('0),            // input wire [71 : 0] dinb
        .doutb(ft_dout[1])     // output wire [71 : 0] doutb
    );
    forwarding_data_2 FT_data_2 (
        .clka (cpu_clk),       // input wire clka
        .ena  (ft_en_a[1]),    // input wire ena
        .wea  (ft_we_a[1]),    // input wire [0 : 0] wea
        .addra(ft_addr_a[1]),  // input wire [15 : 0] addra
        .dina (ft_din_a[1]),   // input wire [71 : 0] dina
        .douta(ft_dout_a[1]),  // output wire [71 : 0] douta
        .clkb (clk),           // input wire clkb
        .enb  (1'b1),          // input wire enb
        .web  (1'b0),          // input wire [0 : 0] web
        .addrb(ft_addr[2]),    // input wire [15 : 0] addrb
        .dinb ('0),            // input wire [71 : 0] dinb
        .doutb(ft_dout[2])     // output wire [71 : 0] doutb
    );
    forwarding_data_3 FT_data_3 (
        .clka (cpu_clk),       // input wire clka
        .ena  (ft_en_a[2]),    // input wire ena
        .wea  (ft_we_a[2]),    // input wire [0 : 0] wea
        .addra(ft_addr_a[2]),  // input wire [15 : 0] addra
        .dina (ft_din_a[2]),   // input wire [71 : 0] dina
        .douta(ft_dout_a[2]),  // output wire [71 : 0] douta
        .clkb (clk),           // input wire clkb
        .enb  (1'b1),          // input wire enb
        .web  (1'b0),          // input wire [0 : 0] web
        .addrb(ft_addr[3]),    // input wire [15 : 0] addrb
        .dinb ('0),            // input wire [71 : 0] dinb
        .doutb(ft_dout[3])     // output wire [71 : 0] doutb
    );
    generate
        for (genvar i = 4; i <= PIPELINE_LENGTH; ++i) begin : forwarding_data_gen
            forwarding_data_0 FT_data_0 (
                .clka (cpu_clk),         // input wire clka
                .ena  (ft_en_a[i-1]),    // input wire ena
                .wea  (ft_we_a[i-1]),    // input wire [0 : 0] wea
                .addra(ft_addr_a[i-1]),  // input wire [9 : 0] addra
                .dina (ft_din_a[i-1]),   // input wire [71 : 0] dina
                .douta(ft_dout_a[i-1]),  // output wire [71 : 0] douta
                .clkb (clk),             // input wire clkb
                .enb  (1'b1),            // input wire enb
                .web  (1'b0),            // input wire [0 : 0] web
                .addrb(ft_addr[i]),      // input wire [9 : 0] addrb
                .dinb ('0),              // input wire [71 : 0] dinb
                .doutb(ft_dout[i])       // output wire [71 : 0] doutb
            );
        end
    endgenerate

    // 例化叶节点存储和控制器
    wire [9 : 0] lut_leaf_dpra;
    wire [7 : 0] lut_leaf_qdpo;

    lut_ram_dp_controller #(
        .ADDR_WIDTH(10),
        .DATA_WIDTH(8)
    ) leaf_lut_ram_dp_controller (
        .clk      (cpu_clk),
        .rst      (cpu_reset),
        .dpra     (leaf_addr),
        .qdpo_clk (clk),
        .qdpo_rst (reset),
        .qdpo     (leaf_out),
        .qdpo_send(leaf_send),
        .qdpo_ack (leaf_ack),

        .lut_dpra(lut_leaf_dpra),
        .lut_qdpo(lut_leaf_qdpo)
    );

    forwarding_leaf_data leaf_data (
        .a       (leaf_addr_a),    // input wire [9 : 0] a
        .d       (leaf_in_a),      // input wire [7 : 0] d
        .dpra    (lut_leaf_dpra),  // input wire [9 : 0] dpra
        .clk     (cpu_clk),        // input wire clk
        .we      (leaf_we_a),      // input wire we
        .qdpo_clk(cpu_clk),        // input wire qdpo_clk
        .qspo    (leaf_out_a),     // output wire [7 : 0] qspo
        .qdpo    (lut_leaf_qdpo)   // output wire [7 : 0] qdpo
    );

    // 例化 Next-Hop 节点存储和控制器
    wire [  5 : 0] lut_next_hop_dpra;
    wire [135 : 0] lut_next_hop_qdpo;

    lut_ram_dp_controller #(
        .ADDR_WIDTH(6),
        .DATA_WIDTH(136)
    ) next_hop_lut_ram_dp_controller (
        .clk      (cpu_clk),
        .rst      (cpu_reset),
        .dpra     (next_hop_addr),
        .qdpo_clk (clk),
        .qdpo_rst (reset),
        .qdpo     (next_hop_out),
        .qdpo_send(next_hop_send),
        .qdpo_ack (next_hop_ack),

        .lut_dpra(lut_next_hop_dpra),
        .lut_qdpo(lut_next_hop_qdpo)
    );

    forwarding_next_hop_data next_hop_data (
        .a       (next_hop_addr_a),    // input wire [5 : 0] a
        .d       (next_hop_in_a),      // input wire [135 : 0] d
        .dpra    (lut_next_hop_dpra),  // input wire [5 : 0] dpra
        .clk     (cpu_clk),            // input wire clk
        .we      (next_hop_we_a),      // input wire we
        .qdpo_clk(cpu_clk),            // input wire qdpo_clk
        .qspo    (next_hop_out_a),     // output wire [135 : 0] qspo
        .qdpo    (lut_next_hop_qdpo)   // output wire [135 : 0] qdpo
    );

    // 流水线
    generate
        for (genvar i = 1; i <= PIPELINE_LENGTH; ++i) begin : pipeline_gen
            // 连接 ready 信号
            assign s_ready[i-1] = (s_ready[i] && state[i] == 0) || !s[i-1].beat.valid;

            // 连接状态机寄存器
            always_comb begin
                s[i]            = s_reg[i];
                s[i].beat.valid = s_reg[i].beat.valid && state[i] == 0;
            end

            // bitmap 解析与匹配
            wire                          parser_stop;
            wire                          parser_matched;
            wire [ LEAF_ADDR_WIDTH - 1:0] parser_leaf_addr;
            wire [CHILD_ADDR_WIDTH - 1:0] parser_node_addr;
            wire [                 127:0] ip_little_endian;
            reg  [                 127:0] ip_for_match;

            assign ip_little_endian = {<<8{s[i-1].beat.data.ip6.dst}};

            // 寄存 BRAM 查询结果, 可能可以优化时序
            FTE_node ft_dout_for_parser;

            forwarding_bitmap_parser u_forwarding_bitmap_parser (
                .node   (ft_dout_for_parser),
                .pattern(ip_for_match[STRIDE-1:0]),

                .stop     (parser_stop),
                .matched  (parser_matched),
                .leaf_addr(parser_leaf_addr),
                .node_addr(parser_node_addr)
            );

            // 状态机
            always_ff @(posedge clk or posedge reset) begin
                if (reset) begin
                    s_reg[i]           <= '{default: 0};
                    state[i]           <= '0;
                    ft_addr[i]         <= '0;
                    ip_for_match       <= '0;
                    ft_dout_for_parser <= '{default: 0};
                end else begin
                    if (state[i] == 0) begin
                        if (s_ready[i]) begin
                            s_reg[i] <= s[i-1];
                            if (`should_search(s[i-1])) begin
                                state[i] <= 1'b1;
                                ft_addr[i] <= s[i-1].node_addr;
                                ip_for_match <= {<<STRIDE{ip_little_endian << ((i-1)*STRIDE*STAGE_HEIGHT)}};
                            end
                        end
                    end
                    // 读取 BRAM, 解析 bitmap
                    for (int j = 1; j <= STAGE_HEIGHT; ++j) begin
                        // 等待读取 BRAM
                        if (state[i] == (3 * j - 2)) begin
                            state[i] <= state[i] + 1;
                        end
                        // 寄存读取结果
                        if (state[i] == (3 * j - 1)) begin
                            ft_dout_for_parser <= ft_dout[i];
                            state[i]           <= state[i] + 1;
                        end
                        // BRAM 读取完成
                        if (state[i] == (3 * j)) begin
                            // 是否需要到下一级流水线(查完这一级或已结束查询)
                            if (j == STAGE_HEIGHT || parser_stop) begin
                                state[i] <= '0;
                            end else begin
                                state[i] <= state[i] + 1;
                            end
                            // 若匹配到前缀, 则更新
                            if (parser_matched) begin
                                s_reg[i].matched   <= 1'b1;
                                s_reg[i].leaf_addr <= parser_leaf_addr;
                            end
                            s_reg[i].node_addr <= parser_node_addr;  // 更新当前节点地址
                            ft_addr[i] <= parser_node_addr;  // 更新查询节点地址, 若已结束查询也无影响
                            s_reg[i].stop <= parser_stop; // 表示是否结束查询（对应子节点为空或为叶节点）
                            ip_for_match <= ip_for_match >> STRIDE;  // 更新 ip_for_match
                        end
                    end
                end
            end
        end
    endgenerate

    // 查询叶节点中 next_hop 编号
    typedef enum {
        ST_INIT,  // 初始阶段
        ST_READ   // 查询中, 等待结果
    } read_state_t;

    reg error;
    forwarding_beat s_leaf, s_leaf_reg;
    read_state_t s_leaf_state;
    reg          s_leaf_ready;
    assign s_ready[PIPELINE_LENGTH] = (s_leaf_ready && s_leaf_state == ST_INIT) || !s[PIPELINE_LENGTH].beat.valid;

    reg [NEXT_HOP_ADDR_WIDTH - 1:0] s_leaf_next_hop_addr;

    always_comb begin
        s_leaf            = s_leaf_reg;
        s_leaf.beat.valid = s_leaf_reg.beat.valid && s_leaf_state == ST_INIT;
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            error                <= '0;
            s_leaf_reg           <= '{default: 0};
            s_leaf_state         <= ST_INIT;
            leaf_addr            <= '0;
            leaf_send            <= '0;
            s_leaf_next_hop_addr <= '0;
        end else begin
            unique case (s_leaf_state)
                ST_INIT: begin
                    if (s_leaf_ready) begin
                        s_leaf_reg <= s[PIPELINE_LENGTH];
                        if (`should_handle(s[PIPELINE_LENGTH].beat)) begin
                            // 应有匹配（至少根节点上有默认路由）, 若无匹配则错误
                            if (s[PIPELINE_LENGTH].matched) begin
                                leaf_addr    <= s[PIPELINE_LENGTH].leaf_addr;
                                leaf_send    <= 1'b1;
                                s_leaf_state <= ST_READ;
                            end else begin
                                error        <= 1'b1;
                                s_leaf_state <= ST_INIT;
                            end
                        end
                    end
                end
                ST_READ: begin
                    leaf_send <= 1'b0;
                    if (leaf_ack) begin
                        s_leaf_next_hop_addr <= leaf_out.next_hop_addr;
                        s_leaf_state         <= ST_INIT;
                    end
                end
            endcase
        end
    end

    // 根据 next_hop 编号查询 next_hop 表
    forwarding_beat s_next_hop, s_next_hop_reg;
    read_state_t s_next_hop_state;
    reg          s_next_hop_ready;
    assign s_leaf_ready = (s_next_hop_ready && s_next_hop_state == ST_INIT) || !s_leaf.beat.valid;

    always_comb begin
        s_next_hop            = s_next_hop_reg;
        s_next_hop.beat.valid = s_next_hop_reg.beat.valid && s_next_hop_state == ST_INIT;
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            s_next_hop_reg   <= '{default: 0};
            s_next_hop_state <= ST_INIT;
            next_hop_addr    <= '0;
            next_hop_send    <= '0;
            next_hop_ip      <= '0;
        end else begin
            unique case (s_next_hop_state)
                ST_INIT: begin
                    if (s_next_hop_ready) begin
                        s_next_hop_reg <= s_leaf;
                        if (`should_handle(s_leaf.beat)) begin
                            next_hop_addr    <= s_leaf_next_hop_addr;
                            next_hop_send    <= 1'b1;
                            s_next_hop_state <= ST_READ;
                        end
                    end
                end
                ST_READ: begin
                    next_hop_send <= 1'b0;
                    if (next_hop_ack) begin
                        if (next_hop_out.route_type == ROUTE_DIRECT) begin
                            // 直连路由
                            next_hop_ip <= s_next_hop_reg.beat.data.ip6.dst;
                        end else begin
                            // 静态路由或动态路由
                            next_hop_ip <= next_hop_out.ip;
                        end
                        s_next_hop_reg.beat.meta.dest <= next_hop_out.port;
                        s_next_hop_state              <= ST_INIT;
                    end
                end
            endcase
        end
    end

    assign out              = s_next_hop.beat;
    assign s_next_hop_ready = out_ready;

endmodule
