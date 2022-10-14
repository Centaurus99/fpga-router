`timescale 1ns / 1ps

// ND 协议包处理

`include "frame_datapath.vh"
`include "packet_templete.vh"

module ndp_datapath #(
    parameter DATA_WIDTH = 64,
    parameter ID_WIDTH   = 3
) (
    input wire eth_clk,
    input wire reset,

    input wire [ 47:0] mac[3:0],
    input wire [127:0] ip [3:0],

    output reg         nc_we,
    output reg [127:0] nc_in_v6_w,
    output reg [ 47:0] nc_in_mac,

    input  frame_meta                        s_meta,
    input  wire       [    DATA_WIDTH - 1:0] s_data,
    input  wire       [DATA_WIDTH / 8 - 1:0] s_keep,
    input  wire                              s_last,
    input  wire       [DATA_WIDTH / 8 - 1:0] s_user,
    input  wire                              s_valid,
    output wire                              s_ready,

    output wire [    DATA_WIDTH - 1:0] m_data,
    output wire [DATA_WIDTH / 8 - 1:0] m_keep,
    output wire                        m_last,
    output wire [DATA_WIDTH / 8 - 1:0] m_user,
    output wire [      ID_WIDTH - 1:0] m_dest,
    output wire                        m_valid,
    input  wire                        m_ready
);

    frame_beat in8;

    always_comb begin
        in8.meta  = s_meta;
        in8.valid = s_valid;
        in8.data  = s_data;
        in8.keep  = s_keep;
        in8.last  = s_last;
        in8.user  = s_user;
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

    frame_beat check;
    wire       check_ready;

    frame_beat_width_converter #(DATA_WIDTH, DATAW_WIDTH_ND) frame_beat_upsizer (
        .clk(eth_clk),
        .rst(reset),

        .in       (in8),
        .in_ready (s_ready),
        .out      (check),
        .out_ready(check_ready)
    );

    frame_beat        in;
    wire              in_ready;
    logic      [15:0] in_sum;

    icmpv6_checksum icmpv6_checksum_i_check (
        .clk  (eth_clk),
        .reset(reset),

        .in      (check),
        .in_ready(check_ready),

        .out      (in),
        .sum      (in_sum),
        .out_ready(in_ready)
    );

    frame_beat s1;
    wire       s1_ready;
    assign in_ready = s1_ready || !in.valid;

    ip6_hdr in_ip6;
    assign in_ip6 = in.data.ip6;

    // 生成 in.data.ip6.dst 对应的组播地址
    wire [127:0] in_multicast_ip;
    wire [ 47:0] in_multicast_mac;
    unicast_to_multicast unicast_to_multicast_i (
        .ip_in  (in_ip6.dst),
        .ip_out (in_multicast_ip),
        .mac_out(in_multicast_mac)
    );


    always_ff @(posedge eth_clk or posedge reset) begin
        if (reset) begin
            s1 <= 0;
            nc_we <= 0;
            nc_in_mac <= 0;
            nc_in_v6_w <= 0;
        end else if (s1_ready) begin
            s1    <= in;
            nc_we <= 0;
            if (in.valid && in.is_first && !in.meta.drop && in.meta.ndp_packet) begin
                // Receipt of Neighbor Solicitations
                // 解除锁定
                s1.meta.dont_touch <= 1'b0;
                if (in_ip6.p.ns_data.icmp_type == ICMP_TYPE_NS) begin
                    // 转发时邻居缓存未命中, 发送 NS 包查询, 对应接口在之前的路由表中获得, 故不做更改
                    if (in.meta.send_from_datapath) begin
                        // frame 部分
                        if (in.last == 1'b0) begin
                            s1.meta.drop_next <= 1'b1;
                        end
                        s1.last <= 1'b1;
                        s1.keep <= '1;
                        s1.keep[DATAW_WIDTH_ND/8-1:DATAW_WIDTH_ND/8-2] <= 2'b00;

                        // IPv6 模板
                        s1.data <= IPv6_packet(
                            .dst_mac(in_multicast_mac),
                            .src_mac(mac[in.meta.dest]),
                            .payload_len(16'h20_00),
                            .next_hdr(IP6_TYPE_ICMP),
                            .hop_limit(8'd255),
                            .src_ip(ip[in.meta.dest]),
                            .dst_ip(in_multicast_ip)
                        );

                        // ICMPv6 部分
                        s1.data.ip6.p.ns_data.icmp_type <= ICMP_TYPE_NS;
                        s1.data.ip6.p.ns_data.code <= 8'b0;
                        s1.data.ip6.p.ns_data.checksum <= 16'b0;
                        s1.data.ip6.p.ns_data.reserved <= 32'b0;
                        s1.data.ip6.p.ns_data.target_address <= in_ip6.dst;
                        s1.data.ip6.p.ns_data.option_type <= 8'd1;
                        s1.data.ip6.p.ns_data.length <= 8'd1;
                        s1.data.ip6.p.ns_data.source_link_layer_address <= mac[in.meta.dest];

                        // NS 包(ICMPv6 部分)的合法性检验
                    end else if (
                        in_ip6.hop_limit != 8'd255 ||  // The IP Hop Limit field has a value of 255
                        in_sum != 0 ||  // ICMP Checksum is valid
                        in_ip6.p.ns_data.code != 0 ||  // ICMP Code is 0
                        in_ip6.payload_len < 24 ||  // ICMP length (derived from the IP length) is 24 or more octets
                        in_ip6.p.ns_data.target_address[7:0] == 8'hff ||  // Target Address is not a multicast address
                        in_ip6.p.ns_data.length <= 0  // All included options have a length that is greater than zero
                        // If the IP source address is the unspecified address, the IP destination address is a solicited-node multicast address
                        // If the IP source address is the unspecified address, there is no source link-layer address option in the message
                        // 但我们不处理重复地址检测
                        ) begin
                        s1.meta.drop <= 1'b1;

                        // HACK: [调试时不启用] Target Address 须为接受口地址
                    end else if (in_ip6.p.ns_data.target_address != ip[in.meta.id]) begin
                        s1.meta.drop <= 1'b1;

                        // 重复地址检测 (Duplicate Address Detection, DAD), 丢弃
                        // IPv6 Source Address 为未指定地址
                    end else if (in_ip6.src == 128'b0) begin
                        s1.meta.drop <= 1'b1;

                        // 收到 NS, 发送单播 NA 进行响应
                    end else begin
                        // 组播 NS, SHOULD 更新邻居缓存
                        if (in_ip6.dst[7:0] == 8'hff) begin
                            // HACK: 前面的 check 需要保证这里 in_ip6.src 不是未指定 IPv6 地址
                            // HACK: in.data.src 源 MAC 地址暂时不知在哪里检验
                            if (in.data.src == in_ip6.p.ns_data.source_link_layer_address) begin
                                nc_in_v6_w <= in_ip6.src;
                                nc_in_mac  <= in_ip6.p.ns_data.source_link_layer_address;
                                nc_we      <= 1;
                            end
                        end

                        // 发送 NA 包
                        // frame 部分
                        s1.meta.dest <= in.meta.id;
                        if (in.last == 1'b0) begin
                            s1.meta.drop_next <= 1'b1;
                        end
                        s1.last <= 1'b1;
                        s1.keep <= '1;
                        s1.keep[DATAW_WIDTH_ND/8-1:DATAW_WIDTH_ND/8-2] <= 2'b00;

                        // IPv6 模板
                        s1.data <= IPv6_packet(
                            .dst_mac(in.data.src),
                            .src_mac(mac[in.meta.id]),
                            .payload_len(16'h20_00),
                            .next_hdr(IP6_TYPE_ICMP),
                            .hop_limit(8'd255),
                            .src_ip(ip[in.meta.id]),
                            .dst_ip(in_ip6.src)
                        );

                        // ICMPv6 部分
                        s1.data.ip6.p.na_data.icmp_type <= ICMP_TYPE_NA;
                        s1.data.ip6.p.na_data.code <= 0;
                        s1.data.ip6.p.na_data.checksum <= 0;
                        s1.data.ip6.p.na_data.reserved_lo <= 0;
                        s1.data.ip6.p.na_data.router_flag <= 1;
                        s1.data.ip6.p.na_data.solicited_flag <= 1;
                        // INFO: 若为 anycast 地址, 则 SHOULD NOT set override_flag, 此处暂时忽略
                        s1.data.ip6.p.na_data.override_flag <= 1;
                        s1.data.ip6.p.na_data.reserved_hi <= 0;
                        s1.data.ip6.p.na_data.target_address <= in_ip6.p.ns_data.target_address;
                        s1.data.ip6.p.na_data.option_type <= 8'd2;
                        s1.data.ip6.p.na_data.length <= 1;
                        s1.data.ip6.p.na_data.target_link_layer_address <= mac[in.meta.id];

                    end

                    // Receipt of Neighbor Advertisements
                end else if (in_ip6.p.na_data.icmp_type == ICMP_TYPE_NA) begin
                    // NA 包(ICMPv6 部分)的合法性检验
                    if (in_ip6.hop_limit != 8'd255 ||  // The IP Hop Limit field has a value of 255
                        in_sum != 0 ||  // ICMP Checksum is valid
                        in_ip6.p.ns_data.code != 0 ||  // ICMP Code is 0
                        in_ip6.payload_len < 24 ||  // ICMP length (derived from the IP length) is 24 or more octets
                        in_ip6.p.ns_data.target_address[7:0] == 8'hff ||  // Target Address is not a multicast address
                        // If the IP Destination Address is a multicast address the Solicited flag is zero 但我们不处理组播NA
                        in_ip6.p.ns_data.length <= 0 // All included options have a length that is greater than zero
                        ) begin
                        s1.meta.drop <= 1'b1;

                        // 组播 NA, 丢弃
                    end else if (in_ip6.dst[7:0] == 8'hff) begin
                        s1.meta.drop <= 1'b1;

                        // 单播 NA
                    end else begin
                        // 更新邻居缓存
                        nc_in_v6_w   <= in_ip6.p.na_data.target_address;
                        nc_in_mac    <= in_ip6.p.na_data.target_link_layer_address;
                        nc_we        <= 1;
                        s1.meta.drop <= 1'b1;
                    end
                end else begin
                    s1.meta.drop <= 1'b1;
                end
            end
        end
    end

    frame_beat        s1_checked;
    wire              s1_checked_ready;
    logic      [15:0] s1_checked_sum;
    icmpv6_checksum icmpv6_checksum_i_calc (
        .clk  (eth_clk),
        .reset(reset),

        .in      (s1),
        .in_ready(s1_ready),

        .out      (s1_checked),
        .sum      (s1_checked_sum),
        .out_ready(s1_checked_ready)
    );

    frame_beat s2;
    wire       s2_ready;
    assign s1_checked_ready = s2_ready || !s1_checked.valid;
    // 生成发出去的 NS/NA 包的 checksum
    always_ff @(posedge eth_clk or posedge reset) begin
        if (reset) begin
            s2 <= 0;
        end else if (s2_ready) begin
            s2 <= s1_checked;
            if (s1_checked.valid && s1_checked.is_first && !s1_checked.meta.drop && s1_checked.meta.ndp_packet) begin
                s2.data.ip6.p.na_data.checksum <= s1_checked_sum;
            end
        end
    end

    frame_beat out;
    assign out = s2;

    wire out_ready;
    assign s2_ready = out_ready || !out.valid;

    reg out_is_first;
    always_ff @(posedge eth_clk or posedge reset) begin
        if (reset) begin
            out_is_first <= 1'b1;
        end else begin
            if (out.valid && out_ready) begin
                out_is_first <= out.last;
            end
        end
    end

    reg [ID_WIDTH - 1:0] dest;
    reg                  drop_by_prev;  // Dropped by the previous frame?
    always_ff @(posedge eth_clk or posedge reset) begin
        if (reset) begin
            dest         <= 0;
            drop_by_prev <= 1'b0;
        end else begin
            if (out_is_first && out.valid && out_ready) begin
                dest         <= out.meta.dest;
                drop_by_prev <= out.meta.drop_next;
            end
        end
    end

    // Rewrite dest.
    wire       [ID_WIDTH - 1:0] dest_current = out_is_first ? out.meta.dest : dest;

    frame_beat                                                                      filtered;
    wire                                                                            filtered_ready;

    frame_filter #(
        .DATA_WIDTH(DATAW_WIDTH_ND),
        .ID_WIDTH  (ID_WIDTH)
    ) frame_filter_i (
        .eth_clk(eth_clk),
        .reset  (reset),

        .s_data (out.data),
        .s_keep (out.keep),
        .s_last (out.last),
        .s_user (out.user),
        .s_id   (dest_current),
        .s_valid(out.valid),
        .s_ready(out_ready),

        .drop(out.meta.drop || drop_by_prev),

        .m_data (filtered.data),
        .m_keep (filtered.keep),
        .m_last (filtered.last),
        .m_user (filtered.user),
        .m_id   (filtered.meta.dest),
        .m_valid(filtered.valid),
        .m_ready(filtered_ready)
    );

    // README: Change the width back. You can remove this.
    frame_beat out8;
    frame_beat_width_converter #(DATAW_WIDTH_ND, DATA_WIDTH) frame_beat_downsizer (
        .clk(eth_clk),
        .rst(reset),

        .in       (filtered),
        .in_ready (filtered_ready),
        .out      (out8),
        .out_ready(m_ready)
    );

    assign m_valid = out8.valid;
    assign m_data  = out8.data;
    assign m_keep  = out8.keep;
    assign m_last  = out8.last;
    assign m_dest  = out8.meta.dest;
    assign m_user  = out8.user;
endmodule
