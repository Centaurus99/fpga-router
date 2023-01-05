`timescale 1ns / 1ps

`include "frame_datapath.vh"
`include "multicast.vh"

module frame_datapath #(
    parameter EXT_RAM_FOR_LEAF = 1,  // 将 ExtRAM 作为叶节点
    parameter DATA_WIDTH = 64,
    parameter ID_WIDTH = 3,
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32,

    parameter SRAM_ADDR_WIDTH = 20,
    parameter SRAM_DATA_WIDTH = 32,

    localparam SRAM_BYTES      = SRAM_DATA_WIDTH / 8,
    localparam SRAM_BYTE_WIDTH = $clog2(SRAM_BYTES)
) (
    input wire eth_clk,
    input wire reset,

    input wire [ 47:0] mac     [3:0],
    input wire [127:0] local_ip[3:0],
    input wire [127:0] gua_ip  [3:0],

    input  wire [    DATA_WIDTH - 1:0] s_data,
    input  wire [DATA_WIDTH / 8 - 1:0] s_keep,
    input  wire                        s_last,
    input  wire [DATA_WIDTH / 8 - 1:0] s_user,
    input  wire [      ID_WIDTH - 1:0] s_id,
    input  wire                        s_valid,
    output wire                        s_ready,

    output wire [    DATA_WIDTH - 1:0] m_data,
    output wire [DATA_WIDTH / 8 - 1:0] m_keep,
    output wire                        m_last,
    output wire [DATA_WIDTH / 8 - 1:0] m_user,
    output wire [      ID_WIDTH - 1:0] m_dest,
    output wire                        m_valid,
    input  wire                        m_ready,

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
    output reg [7:0] debug_led_cpu,
    output reg       debug_led_eth
);

    logic [127:0] nc_in_v6_r, nc_in_v6_w;
    logic [47:0] nc_in_mac, nc_out_mac;
    logic nc_found, nc_we, nc_ready;
    logic [1:0] nc_in_id_r, nc_in_id_w;
    neighbor_cache neighbor_cache_i (
        .clk    (eth_clk),
        .reset  (reset),
        .we     (nc_we),
        .in_v6_w(nc_in_v6_w),
        .in_v6_r(nc_in_v6_r),
        .in_mac (nc_in_mac),
        .in_id_w(nc_in_id_w),
        .in_id_r(nc_in_id_r),

        .out_mac(nc_out_mac),
        .found  (nc_found),
        .ready  (nc_ready)
    );

    frame_beat in8, in;
    wire in_ready;

    always_comb begin
        in8.meta    = 0;
        in8.valid   = s_valid;
        in8.data    = s_data;
        in8.keep    = s_keep;
        in8.last    = s_last;
        in8.meta.id = s_id;
        in8.user    = s_user;
    end

    // Track frames and figure out when it is the first beat.
    always_ff @(posedge eth_clk or posedge reset) begin
        if (reset) begin
            in8.is_first <= 1'b1;
        end else begin
            if (in8.valid && s_ready) begin
                in8.is_first <= in8.last;
            end
        end
    end

    // README: Here, we use a width upsizer to change the width to 56 bytes
    // (MAC 14 + IPv6 40 + round up 2) to ensure that L2 (MAC) and L3 (IPv6) headers appear
    // in one beat (the first beat) facilitating our processing.
    // You can remove this.
    frame_beat_width_converter #(DATA_WIDTH, DATAW_WIDTH_V6) frame_beat_upsizer (
        .clk(eth_clk),
        .rst(reset),

        .in       (in8),
        .in_ready (s_ready),
        .out      (in),
        .out_ready(in_ready)
    );

    // 二层检验 (检验 MAC 地址及 Type) 及 CPU 发包预处理
    frame_beat s1;
    wire       s1_ready;
    assign in_ready = s1_ready || !in.valid;
    always_ff @(posedge eth_clk or posedge reset) begin
        if (reset) begin
            s1 <= 0;
        end else if (s1_ready) begin
            s1 <= in;
            if (`should_handle(in)) begin
                if (in.meta.id == ID_CPU) begin
                    // CPU 发包, 预处理
                    s1.data.ethertype  <= ETHERTYPE_IP6;  // 填充 Type 为 IPv6
                    s1.meta.dont_touch <= 1'b1;
                    case (in.data.src)
                        // 若 CPU 设置了 src mac, 则生成对应的出接口号, 并直接发出
                        mac[0]: s1.meta.dest <= 0;
                        mac[1]: s1.meta.dest <= 1;
                        mac[2]: s1.meta.dest <= 2;
                        mac[3]: s1.meta.dest <= 3;
                        default: begin
                            s1.meta.dest       <= ID_CPU;
                            s1.meta.dont_touch <= 1'b0;
                        end
                    endcase
                    if (in.data.ip6.dst == {8'h01, 120'b0}) begin
                        // Loopback
                        s1.meta.dest       <= ID_CPU;
                        s1.meta.dont_touch <= 1'b1;
                    end
                    if (in.data.ip6.dst[7:0] == 8'hff) begin
                        // Multicast
                        // MAC src 应由 CPU 设置
                        s1.data.dst        <= multicast_MAC(in.data.ip6.dst);
                        s1.meta.dont_touch <= 1'b1;
                    end
                    // 其余情况进入转发逻辑
                end else begin
                    // 非 CPU 发包, 二层检验
                    if (in.data.dst != mac[in.meta.id] && in.data.dst[15:0] != 16'h3333 && in.data.dst != 48'hff_ff_ff_ff_ff_ff) begin
                        // 仅接收接口 mac 地址, 组播 mac 地址, 广播 mac 地址
                        s1.meta.drop <= 1;
                    end else if (in.data.ethertype != ETHERTYPE_IP6) begin
                        // 仅接收 IPv6 包
                        s1.meta.drop <= 1;
                    end
                end
            end
        end
    end

    reg s1_is_gua;
    always_comb begin
        s1_is_gua = 1'b0;
        for (int i = 0; i < 4; i++) begin
            if (s1.data.ip6.dst == gua_ip[i]) begin
                s1_is_gua = 1'b1;
            end
        end
    end

    // 判断接收还是转发
    frame_beat s2;
    wire       s2_ready;
    assign s1_ready = s2_ready || !s1.valid;
    always_ff @(posedge eth_clk or posedge reset) begin
        if (reset) begin
            s2 <= 0;
        end else if (s2_ready) begin
            s2 <= s1;
            if (`should_handle(s1)) begin
                if (s1.data.ip6.version != 4'd6) begin
                    // 参数错误
                    // TODO: 回发 ICMP Parameter Problem Message
                    s2.meta.drop <= 1'b1;

                end else if ((s1.data.ip6.dst == local_ip[s1.meta.id] || s1_is_gua || s1.data.ip6.dst[7:0] == 8'hff)) begin
                    // IPv6 目的地址为对应网口可接收地址 (链路本地, GUA, 组播), 需要接收
                    // 需要接收的包不需要转发逻辑处理
                    s2.meta.dont_touch <= 1'b1;

                    if (s1.data.ip6.next_hdr == IP6_TYPE_ICMP
                        && (s1.data.ip6.p.ns_data.icmp_type == ICMP_TYPE_NS || s1.data.ip6.p.ns_data.icmp_type == ICMP_TYPE_NA)) begin
                        // 如果为 NS 或 NA 包, 则交给 ndp_datapath 处理
                        s2.meta.ndp_packet <= 1'b1;

                    end else begin
                        // 否则转给软件处理
                        s2.meta.dest <= ID_CPU;
                    end

                end else if (s1.meta.id != ID_CPU) begin
                    // 否则需要转发
                    if (s1.data.ip6.hop_limit <= 1) begin
                        // hop_limit 不足, 回发 ICMP Time Exceeded Message
                        // TODO: 限制发送速率
                        if (s1.data.ip6.next_hdr == IP6_TYPE_ICMP && s1.data.ip6.p.ns_data.icmp_type[7] == 1'b0) begin
                            // 若为 ICMP error messages, 则不回发
                            s2.meta.drop <= 1'b1;
                        end else begin
                            s2.data.ethertype  <= ETHERTYPE_ICMP_TEM;
                            s2.meta.dest       <= ID_CPU;
                            s2.meta.dont_touch <= 1'b1;
                        end
                    end
                end
            end
        end
    end

    // 查询转发表
    frame_beat         forwarded;
    wire               forwarded_ready;
    logic      [127:0] forwarded_next_hop_ip;
    forwarding_table #(
        .EXT_RAM_FOR_LEAF(EXT_RAM_FOR_LEAF),
        .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
        .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH),
        .SRAM_ADDR_WIDTH(SRAM_ADDR_WIDTH),
        .SRAM_DATA_WIDTH(SRAM_DATA_WIDTH)
    ) forwarding_table_i (
        .clk     (eth_clk),
        .reset   (reset),
        .in      (s2),
        .in_ready(s2_ready),

        .out        (forwarded),
        .next_hop_ip(forwarded_next_hop_ip),
        .out_ready  (forwarded_ready),

        .cpu_clk  (cpu_clk),
        .cpu_reset(cpu_reset),

        .wb_cyc_i(wb_cyc_i),
        .wb_stb_i(wb_stb_i),
        .wb_ack_o(wb_ack_o),
        .wb_adr_i(wb_adr_i),
        .wb_dat_i(wb_dat_i),
        .wb_dat_o(wb_dat_o),
        .wb_sel_i(wb_sel_i),
        .wb_we_i (wb_we_i),

        .wb_sram_cyc_i(wb_sram_cyc_i),
        .wb_sram_stb_i(wb_sram_stb_i),
        .wb_sram_ack_o(wb_sram_ack_o),
        .wb_sram_adr_i(wb_sram_adr_i),
        .wb_sram_dat_i(wb_sram_dat_i),
        .wb_sram_dat_o(wb_sram_dat_o),
        .wb_sram_sel_i(wb_sram_sel_i),
        .wb_sram_we_i (wb_sram_we_i),

        .sram_addr(sram_addr),
        .sram_data(sram_data),
        .sram_ce_n(sram_ce_n),
        .sram_oe_n(sram_oe_n),
        .sram_we_n(sram_we_n),
        .sram_be_n(sram_be_n),

        .debug_led_cpu(debug_led_cpu),
        .debug_led_eth(debug_led_eth)
    );

    typedef enum {
        ST_SEND_RECV,  // 初始阶段
        ST_QUERY_WAIT1,  // 等待查询邻居缓存
        ST_QUERY_WAIT2,  // 等待查询邻居缓存
        ST_QUERY_FIN  // 查询到邻居缓存
    } s3_state_t;

    frame_beat s3_reg, s3;
    s3_state_t s3_state;
    wire       s3_ready;
    assign forwarded_ready = (s3_ready && s3_state == ST_SEND_RECV) || !forwarded.valid;

    always_comb begin
        s3       = s3_reg;
        s3.valid = s3_reg.valid && s3_state == ST_SEND_RECV;
    end

    // 转发逻辑
    always_ff @(posedge eth_clk or posedge reset) begin
        if (reset) begin
            s3_reg     <= '{default: 0};
            s3_state   <= ST_SEND_RECV;
            nc_in_v6_r <= 0;
            nc_in_id_r <= 0;
        end else begin
            case (s3_state)
                ST_SEND_RECV: begin
                    if (s3_ready) begin
                        s3_reg <= forwarded;
                        if (`should_handle(forwarded)) begin
                            s3_state   <= ST_QUERY_WAIT1;
                            nc_in_v6_r <= forwarded_next_hop_ip;
                            nc_in_id_r <= forwarded.meta.dest[1:0];
                            if (forwarded.meta.id != ID_CPU) begin
                                s3_reg.data.ip6.hop_limit <= forwarded.data.ip6.hop_limit - 1;
                            end
                        end
                    end
                end

                // 等待查询
                ST_QUERY_WAIT1: s3_state <= ST_QUERY_WAIT2;
                ST_QUERY_WAIT2: s3_state <= ST_QUERY_FIN;

                // 查询邻居缓存, 更新 MAC 地址
                ST_QUERY_FIN: begin
                    // 查询到, 更新 MAC 地址并继续发送
                    if (nc_found) begin
                        s3_reg.data.dst <= nc_out_mac;
                        s3_reg.data.src <= mac[s3_reg.meta.dest];

                        // 未查询到, 丢掉 并且发一个NS
                    end else begin
                        s3_reg.last                         <= 1;
                        s3_reg.keep[DATAW_WIDTH_V6/8-1:0]   <= '1;
                        s3_reg.meta.drop_next               <= 1;
                        s3_reg.data.ip6.p.ns_data.icmp_type <= ICMP_TYPE_NS;
                        s3_reg.meta.ndp_packet              <= 1;
                        s3_reg.meta.send_from_datapath      <= 1;
                    end
                    s3_state <= ST_SEND_RECV;
                end
                default: begin
                    s3_state <= ST_SEND_RECV;
                end
            endcase
        end
    end

    frame_beat s4;
    wire       s4_ready;

    // Skid buffer
    basic_skid_buffer u_basic_skid_buffer_2 (
        .clk     (eth_clk),
        .reset   (reset),
        .in_data (s3),
        .in_ready(s3_ready),

        .out_data (s4),
        .out_ready(s4_ready)
    );

    frame_beat ndp;
    wire       ndp_ready;
    frame_beat_width_converter #(DATAW_WIDTH_V6, DATA_WIDTH) frame_beat_downsizer (
        .clk(eth_clk),
        .rst(reset),

        .in       (s4),
        .in_ready (s4_ready),
        .out      (ndp),
        .out_ready(ndp_ready)
    );

    ndp_datapath #(
        .DATA_WIDTH(DATA_WIDTH),
        .ID_WIDTH  (ID_WIDTH)
    ) ndp_datapath_i (
        .eth_clk(eth_clk),
        .reset  (reset),

        .mac     (mac),
        .local_ip(local_ip),
        .gua_ip  (gua_ip),

        .nc_we     (nc_we),
        .nc_in_v6_w(nc_in_v6_w),
        .nc_in_mac (nc_in_mac),
        .nc_in_id_w(nc_in_id_w),
        .nc_ready  (nc_ready),

        .s_meta (ndp.meta),
        .s_data (ndp.data),
        .s_keep (ndp.keep),
        .s_last (ndp.last),
        .s_user (ndp.user),
        .s_valid(ndp.valid),
        .s_ready(ndp_ready),

        .m_data (m_data),
        .m_keep (m_keep),
        .m_last (m_last),
        .m_user (m_user),
        .m_dest (m_dest),
        .m_valid(m_valid),
        .m_ready(m_ready)
    );

endmodule
