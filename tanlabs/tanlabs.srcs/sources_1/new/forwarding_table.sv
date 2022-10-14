`timescale 1ns / 1ps `default_nettype none

// 查询转发表, 给出下一跳地址和网口号
// 下一跳地址 next_hop_ip
// 目标网口号放置在 meta.dest

`include "frame_datapath.vh"

module forwarding_table (
    input wire clk,
    input wire reset,

    input  frame_beat in,
    output reg        in_ready,

    output frame_beat         out,
    output reg        [127:0] next_hop_ip,
    input  wire               out_ready
);
    frame_beat s1;
    wire       s1_ready;
    assign in_ready = s1_ready || !in.valid;

    // FIXME: 硬编码直连路由表, 出口网口号为下标
    logic [63:0] ip_prefix[3:0];
    assign ip_prefix[0] = {<<8{64'h2a0e_aa06_497_0a00}};
    assign ip_prefix[1] = {<<8{64'h2a0e_aa06_497_0a01}};
    assign ip_prefix[2] = {<<8{64'h2a0e_aa06_497_0a02}};
    assign ip_prefix[3] = {<<8{64'h2a0e_aa06_497_0a03}};

    // 匹配直连路由表
    wire [3:0] in_match;
    assign in_match = {
        in.data.ip6.dst[127:64] == ip_prefix[3],
        in.data.ip6.dst[127:64] == ip_prefix[2],
        in.data.ip6.dst[127:64] == ip_prefix[1],
        in.data.ip6.dst[127:64] == ip_prefix[0]
    };

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            s1 <= 0;
            next_hop_ip <= 128'b0;
        end else if (s1_ready) begin
            s1 <= in;
            if (`should_handle(in)) begin
                // 直连路由下一跳地址为目标地址
                next_hop_ip <= in.data.ip6.dst;
                case(in_match)
                    4'b0001: begin
                        s1.meta.dest <= 0;
                    end
                    4'b0010: begin
                        s1.meta.dest <= 1;
                    end
                    4'b0100: begin
                        s1.meta.dest <= 2;
                    end
                    4'b1000: begin
                        s1.meta.dest <= 3;
                    end
                    default: begin
                        // 应发给默认路由, 暂时发给 3 号网口, 与默认值 0 号网口区分开
                        s1.meta.dest <= 3;
                    end
                endcase
            end
        end
    end

    assign out      = s1;
    assign s1_ready = out_ready;

endmodule
