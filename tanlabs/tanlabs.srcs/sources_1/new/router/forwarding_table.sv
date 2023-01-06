`timescale 1ns / 1ps `default_nettype none

// 查询转发表, 给出下一跳地址和网口号
// 下一跳地址 next_hop_ip
// 目标网口号放置在 meta.dest

`include "forwarding_table.vh"

module forwarding_table #(
    parameter EXT_RAM_FOR_LEAF = 1,  // 将 ExtRAM 作为叶节点
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32,

    parameter SRAM_ADDR_WIDTH = 20,
    parameter SRAM_DATA_WIDTH = 32,

    localparam SRAM_BYTES      = SRAM_DATA_WIDTH / 8,
    localparam SRAM_BYTE_WIDTH = $clog2(SRAM_BYTES)
) (
    input wire clk,
    input wire reset,

    input  frame_beat in,
    output reg        in_ready,

    output frame_beat         out,
    output reg        [127:0] next_hop_ip,
    input  wire               out_ready,

    // wishbone slave interface
    input wire cpu_clk,
    input wire cpu_reset,

    input  wire                             wb_cyc_i,
    input  wire                             wb_stb_i,
    output reg                              wb_ack_o,
    input  wire [  WISHBONE_ADDR_WIDTH-1:0] wb_adr_i,
    input  wire [  WISHBONE_DATA_WIDTH-1:0] wb_dat_i,
    output reg  [  WISHBONE_DATA_WIDTH-1:0] wb_dat_o,
    input  wire [WISHBONE_DATA_WIDTH/8-1:0] wb_sel_i,
    input  wire                             wb_we_i,

    input  wire                             wb_sram_cyc_i,
    input  wire                             wb_sram_stb_i,
    output reg                              wb_sram_ack_o,
    input  wire [  WISHBONE_ADDR_WIDTH-1:0] wb_sram_adr_i,
    input  wire [  WISHBONE_DATA_WIDTH-1:0] wb_sram_dat_i,
    output reg  [  WISHBONE_DATA_WIDTH-1:0] wb_sram_dat_o,
    input  wire [WISHBONE_DATA_WIDTH/8-1:0] wb_sram_sel_i,
    input  wire                             wb_sram_we_i,

    // sram interface
    output wire [SRAM_ADDR_WIDTH-1:0] sram_addr,
    inout  wire [SRAM_DATA_WIDTH-1:0] sram_data,
    output wire                       sram_ce_n,
    output wire                       sram_oe_n,
    output wire                       sram_we_n,
    output wire [     SRAM_BYTES-1:0] sram_be_n,

    // debug
    output wire [7:0] debug_led_cpu,
    output wire       debug_led_eth
);
    reg [7:0] debug_cdc;
    reg       debug_no_match_error;
    assign debug_led_cpu = debug_cdc;
    assign debug_led_eth = debug_no_match_error;

    forwarding_beat s               [PIPELINE_LENGTH:1];
    forwarding_beat s_reg           [PIPELINE_LENGTH:1];
    wire            s_ready         [PIPELINE_LENGTH:1];
    forwarding_beat s_buf           [PIPELINE_LENGTH:1];
    wire            s_buf_ready     [PIPELINE_LENGTH:1];
    forwarding_beat s_buf_skid      [PIPELINE_LENGTH:0];
    wire            s_buf_skid_ready[PIPELINE_LENGTH:0];

    // Skid buffer
    basic_skid_buffer u_basic_skid_buffer_1 (
        .clk     (clk),
        .reset   (reset),
        .in_data (in),
        .in_ready(in_ready),

        .out_data (s_buf_skid[0].beat),
        .out_ready(s_buf_skid_ready[0])
    );

    assign s_buf_skid[0].stop      = '0;
    assign s_buf_skid[0].matched   = '0;
    assign s_buf_skid[0].leaf_addr = '0;
    assign s_buf_skid[0].node_addr = '0;  // 默认根节点地址为 0

    // 内部节点读取信号
    logic         [   CHILD_ADDR_WIDTH - 1:0] ft_addr         [  PIPELINE_LENGTH:1];
    FTE_node                                  ft_dout         [  PIPELINE_LENGTH:1];
    // Next_hop 节点读取信号
    reg           [NEXT_HOP_ADDR_WIDTH - 1:0] next_hop_addr;
    next_hop_node                             next_hop_out;

    // 内部节点存储 BRAM 的端口 A 接入总线
    // 为了方便 Wishbone 总线地址转换, 将编号改为从 0 开始
    wire                                      ft_en_a         [PIPELINE_LENGTH-1:0];
    wire                                      ft_we_a         [PIPELINE_LENGTH-1:0];
    wire          [   CHILD_ADDR_WIDTH - 1:0] ft_addr_a       [PIPELINE_LENGTH-1:0];
    FTE_node                                  ft_din_a        [PIPELINE_LENGTH-1:0];
    FTE_node                                  ft_dout_a       [PIPELINE_LENGTH-1:0];
    // Next-Hop 节点存储 LUTRAM 的端口 A 接入总线
    logic         [NEXT_HOP_ADDR_WIDTH - 1:0] next_hop_addr_a;
    next_hop_node                             next_hop_in_a;
    next_hop_node                             next_hop_out_a;
    wire                                      next_hop_we_a;

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

    // 例化 Next-Hop 节点存储
    forwarding_next_hop_data next_hop_data (
        .a       (next_hop_addr_a),  // input wire [6 : 0] a
        .d       (next_hop_in_a),    // input wire [135 : 0] d
        .dpra    (next_hop_addr),    // input wire [6 : 0] dpra
        .clk     (clk),              // input wire clk
        .we      (next_hop_we_a),    // input wire we
        .qdpo_clk(clk),              // input wire qdpo_clk
        .qspo    (next_hop_out_a),   // output wire [135 : 0] qspo
        .qdpo    (next_hop_out)      // output wire [135 : 0] qdpo
    );

    /* =========== Wishbone MUX start =========== */
    logic                             wbs0_cyc_o;
    logic                             wbs0_stb_o;
    logic                             wbs0_ack_i;
    logic [WISHBONE_ADDR_WIDTH - 1:0] wbs0_adr_o;
    logic [WISHBONE_DATA_WIDTH - 1:0] wbs0_dat_o;
    logic [WISHBONE_DATA_WIDTH - 1:0] wbs0_dat_i;
    logic [WISHBONE_DATA_WIDTH/8-1:0] wbs0_sel_o;
    logic                             wbs0_we_o;

    logic                             wbs1_cyc_o;
    logic                             wbs1_stb_o;
    logic                             wbs1_ack_i;
    logic [WISHBONE_ADDR_WIDTH - 1:0] wbs1_adr_o;
    logic [WISHBONE_DATA_WIDTH - 1:0] wbs1_dat_o;
    logic [WISHBONE_DATA_WIDTH - 1:0] wbs1_dat_i;
    logic [WISHBONE_DATA_WIDTH/8-1:0] wbs1_sel_o;
    logic                             wbs1_we_o;

    logic                             wbs2_cyc_o;
    logic                             wbs2_stb_o;
    logic                             wbs2_ack_i;
    logic [WISHBONE_ADDR_WIDTH - 1:0] wbs2_adr_o;
    logic [WISHBONE_DATA_WIDTH - 1:0] wbs2_dat_o;
    logic [WISHBONE_DATA_WIDTH - 1:0] wbs2_dat_i;
    logic [WISHBONE_DATA_WIDTH/8-1:0] wbs2_sel_o;
    logic                             wbs2_we_o;

    wb_mux_3 wb_mux (
        .clk(cpu_clk),
        .rst(cpu_reset),

        // Master interface
        .wbm_adr_i(wb_adr_i),
        .wbm_dat_i(wb_dat_i),
        .wbm_dat_o(wb_dat_o),
        .wbm_we_i (wb_we_i),
        .wbm_sel_i(wb_sel_i),
        .wbm_stb_i(wb_stb_i),
        .wbm_ack_o(wb_ack_o),
        .wbm_err_o(),
        .wbm_rty_o(),
        .wbm_cyc_i(wb_cyc_i),

        // Slave interface 0 (to BRAM)
        // Address range: 0x4000_0000 ~ 0x47FF_FFFF
        .wbs0_addr    (32'h4000_0000),
        .wbs0_addr_msk(32'hF800_0000),

        .wbs0_adr_o(wbs0_adr_o),
        .wbs0_dat_i(wbs0_dat_i),
        .wbs0_dat_o(wbs0_dat_o),
        .wbs0_we_o (wbs0_we_o),
        .wbs0_sel_o(wbs0_sel_o),
        .wbs0_stb_o(wbs0_stb_o),
        .wbs0_ack_i(wbs0_ack_i),
        .wbs0_err_i('0),
        .wbs0_rty_i('0),
        .wbs0_cyc_o(wbs0_cyc_o),

        // Slave interface 1 (to Leaf LUTRAM)
        // Address range: 0x5000_0000 ~ 0x50FF_FFFF
        .wbs1_addr    (32'h5000_0000),
        .wbs1_addr_msk(32'hFF00_0000),

        .wbs1_adr_o(wbs1_adr_o),
        .wbs1_dat_i(wbs1_dat_i),
        .wbs1_dat_o(wbs1_dat_o),
        .wbs1_we_o (wbs1_we_o),
        .wbs1_sel_o(wbs1_sel_o),
        .wbs1_stb_o(wbs1_stb_o),
        .wbs1_ack_i(wbs1_ack_i),
        .wbs1_err_i('0),
        .wbs1_rty_i('0),
        .wbs1_cyc_o(wbs1_cyc_o),

        // Slave interface 1 (to Next-Hop LUTRAM)
        // Address range: 0x5100_0000 ~ 0x51FF_FFFF
        .wbs2_addr    (32'h5100_0000),
        .wbs2_addr_msk(32'hFF00_0000),

        .wbs2_adr_o(wbs2_adr_o),
        .wbs2_dat_i(wbs2_dat_i),
        .wbs2_dat_o(wbs2_dat_o),
        .wbs2_we_o (wbs2_we_o),
        .wbs2_sel_o(wbs2_sel_o),
        .wbs2_stb_o(wbs2_stb_o),
        .wbs2_ack_i(wbs2_ack_i),
        .wbs2_err_i('0),
        .wbs2_rty_i('0),
        .wbs2_cyc_o(wbs2_cyc_o)
    );
    /* =========== Wishbone MUX end =========== */

    /* =========== Wishbone Slaves begin =========== */
    logic                             dest_wbs2_cyc_o;
    logic                             dest_wbs2_stb_o;
    logic                             dest_wbs2_ack_i;
    logic [WISHBONE_ADDR_WIDTH - 1:0] dest_wbs2_adr_o;
    logic [WISHBONE_DATA_WIDTH - 1:0] dest_wbs2_dat_o;
    logic [WISHBONE_DATA_WIDTH - 1:0] dest_wbs2_dat_i;
    logic [WISHBONE_DATA_WIDTH/8-1:0] dest_wbs2_sel_o;
    logic                             dest_wbs2_we_o;

    wishbone_cdc_handshake #(
        .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
        .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH)
    ) u_wishbone_cdc_handshake_2 (
        .src_clk (cpu_clk),
        .src_rst (cpu_reset),
        .dest_clk(clk),
        .dest_rst(reset),
        .wb_cyc_i(wbs2_cyc_o),
        .wb_stb_i(wbs2_stb_o),
        .wb_ack_o(wbs2_ack_i),
        .wb_adr_i(wbs2_adr_o),
        .wb_dat_i(wbs2_dat_o),
        .wb_dat_o(wbs2_dat_i),
        .wb_sel_i(wbs2_sel_o),
        .wb_we_i (wbs2_we_o),

        .dest_wb_cyc_o(dest_wbs2_cyc_o),
        .dest_wb_stb_o(dest_wbs2_stb_o),
        .dest_wb_ack_i(dest_wbs2_ack_i),
        .dest_wb_adr_o(dest_wbs2_adr_o),
        .dest_wb_dat_o(dest_wbs2_dat_o),
        .dest_wb_dat_i(dest_wbs2_dat_i),
        .dest_wb_sel_o(dest_wbs2_sel_o),
        .dest_wb_we_o (dest_wbs2_we_o),

        .debug_led(debug_cdc)
    );

    forwarding_bram_controller #(
        .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
        .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH)
    ) u_forwarding_bram_controller (
        .clk_i   (cpu_clk),
        .rst_i   (cpu_reset),
        .wb_cyc_i(wbs0_cyc_o),
        .wb_stb_i(wbs0_stb_o),
        .wb_ack_o(wbs0_ack_i),
        .wb_adr_i(wbs0_adr_o),
        .wb_dat_i(wbs0_dat_o),
        .wb_dat_o(wbs0_dat_i),
        .wb_sel_i(wbs0_sel_o),
        .wb_we_i (wbs0_we_o),

        .ft_en  (ft_en_a),
        .ft_we  (ft_we_a),
        .ft_addr(ft_addr_a),
        .ft_din (ft_din_a),
        .ft_dout(ft_dout_a)
    );

    next_hop_lut_ram_controller #(
        .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
        .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH)
    ) u_next_hop_lut_ram_controller (
        .clk     (clk),
        .rst     (reset),
        .wb_cyc_i(dest_wbs2_cyc_o),
        .wb_stb_i(dest_wbs2_stb_o),
        .wb_ack_o(dest_wbs2_ack_i),
        .wb_adr_i(dest_wbs2_adr_o),
        .wb_dat_i(dest_wbs2_dat_o),
        .wb_dat_o(dest_wbs2_dat_i),
        .wb_sel_i(dest_wbs2_sel_o),
        .wb_we_i (dest_wbs2_we_o),

        .next_hop_addr(next_hop_addr_a),
        .next_hop_in  (next_hop_in_a),
        .next_hop_out (next_hop_out_a),
        .next_hop_we  (next_hop_we_a)
    );
    /* =========== Wishbone Slaves end =========== */

    // 流水线中 BRAM 读取状态
    typedef enum logic [1:0] {
        BRAM_IDLE,
        BRAM_ADDR_SENT,
        BRAM_DATA_GET,
        BRAM_CALC
    } bram_state_t;

    // 流水线
    generate
        for (genvar i = 1; i <= PIPELINE_LENGTH; ++i) begin : pipeline_gen

            logic        [2:0] now_height;  // 当前处理高度 (0~STAGE_HEIGHT)
            bram_state_t       bram_state;  // BRAM 读取状态

            // 连接 ready 信号
            assign s_buf_skid_ready[i-1] = (s_ready[i] && bram_state == BRAM_IDLE) || !s_buf_skid[i-1].beat.valid;

            // 连接状态机寄存器
            always_comb begin
                s[i]            = s_reg[i];
                s[i].beat.valid = s_reg[i].beat.valid && bram_state == BRAM_IDLE;
            end

            // bitmap 解析与匹配
            wire                          parser_stop;
            wire                          parser_matched;
            wire [ LEAF_ADDR_WIDTH - 1:0] parser_leaf_addr;
            wire [CHILD_ADDR_WIDTH - 1:0] parser_node_addr;
            wire [                 127:0] ip_little_endian;
            reg  [                 127:0] ip_for_match;

            assign ip_little_endian = {<<8{s_buf_skid[i-1].beat.data.ip6.dst}};

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
                    s_reg[i]           <= '{default: '0};
                    now_height         <= 0;
                    bram_state         <= BRAM_IDLE;
                    ft_addr[i]         <= '0;
                    ip_for_match       <= '0;
                    ft_dout_for_parser <= '{default: '0};
                end else begin
                    unique case (bram_state)
                        BRAM_IDLE: begin
                            if (s_ready[i]) begin
                                s_reg[i] <= s_buf_skid[i-1];
                                if (`should_search(s_buf_skid[i-1])) begin
                                    now_height <= 1;
                                    bram_state <= BRAM_ADDR_SENT;
                                    ft_addr[i] <= s_buf_skid[i-1].node_addr;
                                    ip_for_match <= {<<STRIDE{ip_little_endian << ((i-1)*STRIDE*STAGE_HEIGHT)}};
                                end
                            end
                        end
                        BRAM_ADDR_SENT: begin  // 等待读取 BRAM
                            bram_state <= BRAM_DATA_GET;
                        end
                        BRAM_DATA_GET: begin  // 寄存读取结果
                            bram_state         <= BRAM_CALC;
                            ft_dout_for_parser <= ft_dout[i];
                        end
                        BRAM_CALC: begin  // BRAM 读取完成
                            // 是否需要到下一级流水线(查完这一级或已结束查询)
                            if (now_height == STAGE_HEIGHT || parser_stop) begin
                                now_height <= 0;
                                bram_state <= BRAM_IDLE;
                            end else begin
                                now_height <= now_height + 1;
                                bram_state <= BRAM_ADDR_SENT;
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
                        default: begin
                            bram_state <= BRAM_IDLE;
                        end
                    endcase
                end
            end

            // 连接 Buffer
            assign s_ready[i] = s_buf_ready[i] || !s[i].beat.valid;
            always_ff @(posedge clk or posedge reset) begin
                if (reset) begin
                    s_buf[i] <= '{default: '0};
                end else if (s_buf_ready[i]) begin
                    s_buf[i] <= s[i];
                end
            end

            // 连接 Skid Buffer
            basic_forwarding_skid_buffer u_basic_forwarding_skid_buffer (
                .clk     (clk),
                .reset   (reset),
                .in_data (s_buf[i]),
                .in_ready(s_buf_ready[i]),

                .out_data (s_buf_skid[i]),
                .out_ready(s_buf_skid_ready[i])
            );
        end
    endgenerate

    forwarding_beat s_leaf, s_leaf_reg;
    reg                             s_leaf_ready;
    reg [NEXT_HOP_ADDR_WIDTH - 1:0] s_leaf_next_hop_addr;
    generate
        if (EXT_RAM_FOR_LEAF) begin  // 使用 Ext RAM 作为叶节点存储
            assign wbs1_ack_i = 1'b0;
            assign wbs1_dat_i = '0;

            reg                              wb_router_cyc_i;
            reg                              wb_router_stb_i;
            wire                             wb_router_ack_o;
            reg  [  WISHBONE_ADDR_WIDTH-1:0] wb_router_adr_i;
            reg  [  WISHBONE_DATA_WIDTH-1:0] wb_router_dat_i;
            wire [  WISHBONE_DATA_WIDTH-1:0] wb_router_dat_o;
            reg  [WISHBONE_DATA_WIDTH/8-1:0] wb_router_sel_i;
            reg                              wb_router_we_i;

            leaf_sram_controller #(
                .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
                .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH),
                .SRAM_ADDR_WIDTH(SRAM_ADDR_WIDTH),
                .SRAM_DATA_WIDTH(SRAM_DATA_WIDTH)
            ) u_leaf_sram_controller (
                .cpu_clk  (cpu_clk),
                .cpu_reset(cpu_reset),

                .wb_cpu_cyc_i(wb_sram_cyc_i),
                .wb_cpu_stb_i(wb_sram_stb_i),
                .wb_cpu_ack_o(wb_sram_ack_o),
                .wb_cpu_adr_i(wb_sram_adr_i),
                .wb_cpu_dat_i(wb_sram_dat_i),
                .wb_cpu_dat_o(wb_sram_dat_o),
                .wb_cpu_sel_i(wb_sram_sel_i),
                .wb_cpu_we_i (wb_sram_we_i),

                .eth_clk  (clk),
                .eth_reset(reset),

                .wb_router_cyc_i(wb_router_cyc_i),
                .wb_router_stb_i(wb_router_stb_i),
                .wb_router_ack_o(wb_router_ack_o),
                .wb_router_adr_i(wb_router_adr_i),
                .wb_router_dat_i(wb_router_dat_i),
                .wb_router_dat_o(wb_router_dat_o),
                .wb_router_sel_i(wb_router_sel_i),
                .wb_router_we_i (wb_router_we_i),

                .sram_addr(sram_addr),
                .sram_data(sram_data),
                .sram_ce_n(sram_ce_n),
                .sram_oe_n(sram_oe_n),
                .sram_we_n(sram_we_n),
                .sram_be_n(sram_be_n)
            );

            typedef enum {
                ST_INIT,
                ST_READ
            } leaf_read_state_t;

            leaf_read_state_t s_leaf_state;
            assign s_buf_skid_ready[PIPELINE_LENGTH] = (s_leaf_ready && s_leaf_state == ST_INIT) || !s_buf_skid[PIPELINE_LENGTH].beat.valid;

            always_comb begin
                s_leaf            = s_leaf_reg;
                s_leaf.beat.valid = s_leaf_reg.beat.valid && s_leaf_state == ST_INIT;
                wb_router_stb_i   = s_leaf_state == ST_READ;
                wb_router_cyc_i   = wb_router_stb_i;
                wb_router_sel_i   = 4'b0001;
                wb_router_dat_i   = '0;
                wb_router_we_i    = 1'b0;
            end

            always_ff @(posedge clk or posedge reset) begin
                if (reset) begin
                    debug_no_match_error <= '0;
                    s_leaf_reg           <= '{default: '0};
                    s_leaf_state         <= ST_INIT;
                    s_leaf_next_hop_addr <= '0;
                    wb_router_adr_i      <= '0;
                end else begin
                    unique case (s_leaf_state)
                        ST_INIT: begin
                            if (s_leaf_ready) begin
                                s_leaf_reg <= s_buf_skid[PIPELINE_LENGTH];
                                if (`should_handle(s_buf_skid[PIPELINE_LENGTH].beat)) begin
                                    // 应有匹配（至少根节点上有默认路由）, 若无匹配则错误
                                    if (s_buf_skid[PIPELINE_LENGTH].matched) begin
                                        wb_router_adr_i <= {
                                            s_buf_skid[PIPELINE_LENGTH].leaf_addr, 2'b00
                                        };
                                        s_leaf_state <= ST_READ;
                                    end else begin
                                        debug_no_match_error <= 1'b1;
                                        s_leaf_state         <= ST_INIT;
                                    end
                                end
                            end
                        end
                        ST_READ: begin
                            if (wb_router_ack_o) begin
                                wb_router_adr_i      <= '0;
                                s_leaf_next_hop_addr <= wb_router_dat_o;
                                s_leaf_state         <= ST_INIT;
                            end
                        end
                        default: begin
                            s_leaf_state <= ST_INIT;
                        end
                    endcase
                end
            end

        end else begin  // 使用 LUTRAM 作为叶节点存储
            assign wb_sram_ack_o = 1'b0;
            assign wb_sram_dat_o = '0;

            // 叶节点读取信号
            reg       [LEAF_ADDR_WIDTH - 1:0] leaf_addr;
            leaf_node                         leaf_out;

            // 叶节点存储 LUTRAM 的端口 A 接入总线
            logic     [LEAF_ADDR_WIDTH - 1:0] leaf_addr_a;
            leaf_node                         leaf_in_a;
            leaf_node                         leaf_out_a;
            wire                              leaf_we_a;

            // 例化叶节点存储
            forwarding_leaf_data leaf_data (
                .a       (leaf_addr_a),  // input wire [14 : 0] a
                .d       (leaf_in_a),    // input wire [7 : 0] d
                .dpra    (leaf_addr),    // input wire [14 : 0] dpra
                .clk     (clk),          // input wire clk
                .we      (leaf_we_a),    // input wire we
                .qdpo_clk(clk),          // input wire qdpo_clk
                .qspo    (leaf_out_a),   // output wire [7 : 0] qspo
                .qdpo    (leaf_out)      // output wire [7 : 0] qdpo
            );

            logic                             dest_wbs1_cyc_o;
            logic                             dest_wbs1_stb_o;
            logic                             dest_wbs1_ack_i;
            logic [WISHBONE_ADDR_WIDTH - 1:0] dest_wbs1_adr_o;
            logic [WISHBONE_DATA_WIDTH - 1:0] dest_wbs1_dat_o;
            logic [WISHBONE_DATA_WIDTH - 1:0] dest_wbs1_dat_i;
            logic [WISHBONE_DATA_WIDTH/8-1:0] dest_wbs1_sel_o;
            logic                             dest_wbs1_we_o;

            wishbone_cdc_handshake #(
                .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
                .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH)
            ) u_wishbone_cdc_handshake_1 (
                .src_clk (cpu_clk),
                .src_rst (cpu_reset),
                .dest_clk(clk),
                .dest_rst(reset),
                .wb_cyc_i(wbs1_cyc_o),
                .wb_stb_i(wbs1_stb_o),
                .wb_ack_o(wbs1_ack_i),
                .wb_adr_i(wbs1_adr_o),
                .wb_dat_i(wbs1_dat_o),
                .wb_dat_o(wbs1_dat_i),
                .wb_sel_i(wbs1_sel_o),
                .wb_we_i (wbs1_we_o),

                .dest_wb_cyc_o(dest_wbs1_cyc_o),
                .dest_wb_stb_o(dest_wbs1_stb_o),
                .dest_wb_ack_i(dest_wbs1_ack_i),
                .dest_wb_adr_o(dest_wbs1_adr_o),
                .dest_wb_dat_o(dest_wbs1_dat_o),
                .dest_wb_dat_i(dest_wbs1_dat_i),
                .dest_wb_sel_o(dest_wbs1_sel_o),
                .dest_wb_we_o (dest_wbs1_we_o),

                .debug_led()
            );
            leaf_lut_ram_controller #(
                .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
                .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH)
            ) u_leaf_lut_ram_controller (
                .clk     (clk),
                .rst     (reset),
                .wb_cyc_i(dest_wbs1_cyc_o),
                .wb_stb_i(dest_wbs1_stb_o),
                .wb_ack_o(dest_wbs1_ack_i),
                .wb_adr_i(dest_wbs1_adr_o),
                .wb_dat_i(dest_wbs1_dat_o),
                .wb_dat_o(dest_wbs1_dat_i),
                .wb_sel_i(dest_wbs1_sel_o),
                .wb_we_i (dest_wbs1_we_o),

                .leaf_addr(leaf_addr_a),
                .leaf_in  (leaf_in_a),
                .leaf_out (leaf_out_a),
                .leaf_we  (leaf_we_a)
            );

            // 查询叶节点中 next_hop 编号
            typedef enum {
                ST_INIT,   // 初始阶段
                ST_ADDR,   // 多寄存一级地址
                ST_READ,   // 给出地址
                ST_READ2,  // 等待结果寄存器
                ST_READ3   // 获得结果
            } leaf_read_state_t;

            leaf_read_state_t s_leaf_state;
            assign s_buf_skid_ready[PIPELINE_LENGTH] = (s_leaf_ready && s_leaf_state == ST_INIT) || !s_buf_skid[PIPELINE_LENGTH].beat.valid;

            reg [LEAF_ADDR_WIDTH - 1:0] leaf_addr_reg1;

            always_comb begin
                s_leaf            = s_leaf_reg;
                s_leaf.beat.valid = s_leaf_reg.beat.valid && s_leaf_state == ST_INIT;
            end

            always_ff @(posedge clk or posedge reset) begin
                if (reset) begin
                    debug_no_match_error <= '0;
                    s_leaf_reg           <= '{default: '0};
                    s_leaf_state         <= ST_INIT;
                    leaf_addr            <= '0;
                    leaf_addr_reg1       <= '0;
                    s_leaf_next_hop_addr <= '0;
                end else begin
                    unique case (s_leaf_state)
                        ST_INIT: begin
                            if (s_leaf_ready) begin
                                s_leaf_reg <= s_buf_skid[PIPELINE_LENGTH];
                                if (`should_handle(s_buf_skid[PIPELINE_LENGTH].beat)) begin
                                    // 应有匹配（至少根节点上有默认路由）, 若无匹配则错误
                                    if (s_buf_skid[PIPELINE_LENGTH].matched) begin
                                        leaf_addr_reg1 <= s_buf_skid[PIPELINE_LENGTH].leaf_addr;
                                        s_leaf_state   <= ST_ADDR;
                                    end else begin
                                        debug_no_match_error <= 1'b1;
                                        s_leaf_state         <= ST_INIT;
                                    end
                                end
                            end
                        end
                        ST_ADDR: begin
                            leaf_addr    <= leaf_addr_reg1;
                            s_leaf_state <= ST_READ;
                        end
                        ST_READ: begin
                            s_leaf_state <= ST_READ2;
                        end
                        ST_READ2: begin
                            s_leaf_state <= ST_READ3;
                        end
                        ST_READ3: begin
                            s_leaf_next_hop_addr <= leaf_out.next_hop_addr;
                            s_leaf_state         <= ST_INIT;
                        end
                        default: begin
                            s_leaf_state <= ST_INIT;
                        end
                    endcase
                end
            end
        end
    endgenerate

    // 根据 next_hop 编号查询 next_hop 表
    typedef enum {
        ST_INIT,   // 初始阶段
        ST_ADDR,   // 多寄存一级地址
        ST_READ,   // 给出地址
        ST_READ2,  // 等待结果寄存器
        ST_READ3   // 获得结果
    } next_hop_read_state_t;

    forwarding_beat s_next_hop, s_next_hop_reg;
    next_hop_read_state_t s_next_hop_state;
    reg                   s_next_hop_ready;
    assign s_leaf_ready = (s_next_hop_ready && s_next_hop_state == ST_INIT) || !s_leaf.beat.valid;

    always_comb begin
        s_next_hop            = s_next_hop_reg;
        s_next_hop.beat.valid = s_next_hop_reg.beat.valid && s_next_hop_state == ST_INIT;
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            s_next_hop_reg   <= '{default: '0};
            s_next_hop_state <= ST_INIT;
            next_hop_addr    <= '0;
            next_hop_ip      <= '0;
        end else begin
            unique case (s_next_hop_state)
                ST_INIT: begin
                    if (s_next_hop_ready) begin
                        s_next_hop_reg <= s_leaf;
                        if (`should_handle(s_leaf.beat)) begin
                            next_hop_addr    <= s_leaf_next_hop_addr;
                            s_next_hop_state <= ST_READ;
                        end
                    end
                end
                ST_READ: begin
                    s_next_hop_state <= ST_READ2;
                end
                ST_READ2: begin
                    s_next_hop_state <= ST_READ3;
                end
                ST_READ3: begin
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
                default: begin
                    s_next_hop_state <= ST_INIT;
                end
            endcase
        end
    end

    assign out              = s_next_hop.beat;
    assign s_next_hop_ready = out_ready;

endmodule
