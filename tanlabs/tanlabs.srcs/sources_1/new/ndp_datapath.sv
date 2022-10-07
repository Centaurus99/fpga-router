`timescale 1ns / 1ps

// ND 协议包处理

`include "frame_datapath.vh"

module ndp_datapath
#(
    parameter DATA_WIDTH = 64,
    parameter ID_WIDTH = 3
)
(
    input wire eth_clk,
    input wire reset,

    input wire [ 47:0] mac[3:0],
    input wire [127:0] ip [3:0],

    input wire [DATA_WIDTH - 1:0] s_data,
    input wire [DATA_WIDTH / 8 - 1:0] s_keep,
    input wire s_last,
    input wire [DATA_WIDTH / 8 - 1:0] s_user,
    input wire [ID_WIDTH - 1:0] s_id,
    input wire s_valid,
    output wire s_ready,

    output wire [DATA_WIDTH - 1:0] m_data,
    output wire [DATA_WIDTH / 8 - 1:0] m_keep,
    output wire m_last,
    output wire [DATA_WIDTH / 8 - 1:0] m_user,
    output wire [ID_WIDTH - 1:0] m_dest,
    output wire m_valid,
    input wire m_ready
);

    frame_beat in8, in;
    wire in_ready;

    always @ (*)
    begin
        in8.meta = 0;
        in8.valid = s_valid;
        in8.data = s_data;
        in8.keep = s_keep;
        in8.last = s_last;
        in8.meta.id = s_id;
        in8.user = s_user;
    end

    // Track frames and figure out when it is the first beat.
    always @ (posedge eth_clk or posedge reset)
    begin
        if (reset)
        begin
            in8.is_first <= 1'b1;
        end
        else
        begin
            if (in8.valid && s_ready)
            begin
                in8.is_first <= in8.last;
            end
        end
    end

    // README: Here, we use a width upsizer to change the width to 56 bytes
    // (MAC 14 + IPv6 40 + round up 2) to ensure that L2 (MAC) and L3 (IPv6) headers appear
    // in one beat (the first beat) facilitating our processing.
    // You can remove this.
    frame_beat_width_converter #(DATA_WIDTH, DATAW_WIDTH_ND) frame_beat_upsizer(
        .clk(eth_clk),
        .rst(reset),

        .in(in8),
        .in_ready(s_ready),
        .out(in),
        .out_ready(in_ready)
    );

    frame_beat s1;
    wire       s1_ready;
    assign in_ready = s1_ready || !in.valid;
    ip6_hdr in_ip6;
    assign in_ip6 = in.data.ip6;
    always_ff @(posedge eth_clk or posedge reset) begin
        if (reset) begin
            s1 <= 0;
        end else if (s1_ready) begin
            s1 <= in;
            if (`should_handle(in) && in_ip6.next_hdr == 8'h3a) begin
                // Receipt of Neighbor Solicitations
                if (in_ip6.p.ns_data.icmp_type == 135) begin
                    // TODO: 补充完成 NS 包(ICMPv6 部分)的合法性检验
                    if (in_ip6.hop_limit != 255) begin
                        s1.meta.drop <= 1'b1;
                    
                    // TODO: 转发时邻居缓存未命中, 发送 NS 包查询, 暂定各接口均需发送
                    end else if (in_ip6.p.ns_data.code != DROP_AND_SEND_NS_CODE) begin

                    // Target Address 须为接受口地址
                    end else if (in_ip6.p.ns_data.target_address != ip[s_id]) begin
                        s1.meta.drop <= 1'b1;

                    // 重复地址检测 (Duplicate Address Detection, DAD), 丢弃
                    // IPv6 Source Address 为未指定地址
                    end else if (in_ip6.src == 128'b0)begin
                        s1.meta.drop <= 1'b1;

                    // 组播 NS
                    end else if (in_ip6.dst[7:0] == 8'hff) begin
                        // TODO: 更新邻居缓存

                        // TODO: 发送 NA 包

                    // 单播 NS
                    end else begin
                        // TODO: 响应邻居不可达检测 (Neighbor Unreachability Detection, NUD)

                    end

                // Receipt of Neighbor Advertisements
                end else if (in_ip6.p.na_data.icmp_type == 136) begin
                    // TODO: 补充完成 NA 包(ICMPv6 部分)的合法性检验
                    if (in_ip6.hop_limit != 255) begin
                        s1.meta.drop <= 1'b1;

                    // 组播 NA, 丢弃
                    end else if (in_ip6.dst[7:0] == 8'hff) begin
                        s1.meta.drop <= 1'b1;

                    // 单播 NA
                    end else begin
                        // TODO: 更新邻居缓存

                    end
                end else begin
                    s1.meta.drop <= 1'b1;
                end
            end
        end
    end

    frame_beat out;
    assign out = s1;

    wire out_ready;
    assign s1_ready = out_ready || !out.valid;

    reg out_is_first;
    always @ (posedge eth_clk or posedge reset)
    begin
        if (reset)
        begin
            out_is_first <= 1'b1;
        end
        else
        begin
            if (out.valid && out_ready)
            begin
                out_is_first <= out.last;
            end
        end
    end

    reg [ID_WIDTH - 1:0] dest;
    reg drop_by_prev;  // Dropped by the previous frame?
    always @ (posedge eth_clk or posedge reset)
    begin
        if (reset)
        begin
            dest <= 0;
            drop_by_prev <= 1'b0;
        end
        else
        begin
            if (out_is_first && out.valid && out_ready)
            begin
                dest <= out.meta.dest;
                drop_by_prev <= out.meta.drop_next;
            end
        end
    end

    // Rewrite dest.
    wire [ID_WIDTH - 1:0] dest_current = out_is_first ? out.meta.dest : dest;

    frame_beat filtered;
    wire filtered_ready;

    frame_filter
    #(
        .DATA_WIDTH(DATAW_WIDTH_ND),
        .ID_WIDTH(ID_WIDTH)
    )
    frame_filter_i(
        .eth_clk(eth_clk),
        .reset(reset),

        .s_data(out.data),
        .s_keep(out.keep),
        .s_last(out.last),
        .s_user(out.user),
        .s_id(dest_current),
        .s_valid(out.valid),
        .s_ready(out_ready),

        .drop(out.meta.drop || drop_by_prev),

        .m_data(filtered.data),
        .m_keep(filtered.keep),
        .m_last(filtered.last),
        .m_user(filtered.user),
        .m_id(filtered.meta.dest),
        .m_valid(filtered.valid),
        .m_ready(filtered_ready)
    );

    // README: Change the width back. You can remove this.
    frame_beat out8;
    frame_beat_width_converter #(DATAW_WIDTH_ND, DATA_WIDTH) frame_beat_downsizer(
        .clk(eth_clk),
        .rst(reset),

        .in(filtered),
        .in_ready(filtered_ready),
        .out(out8),
        .out_ready(m_ready)
    );

    assign m_valid = out8.valid;
    assign m_data = out8.data;
    assign m_keep = out8.keep;
    assign m_last = out8.last;
    assign m_dest = out8.meta.dest;
    assign m_user = out8.user;
endmodule
