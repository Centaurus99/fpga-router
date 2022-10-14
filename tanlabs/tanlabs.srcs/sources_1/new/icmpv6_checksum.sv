`timescale 1ns / 1ps `default_nettype none

`include "frame_datapath.vh"

module icmpv6_checksum #(
    parameter PACKET_LENGTH = 88,
    parameter MOD = 4'd0
) (
    input wire clk,
    input wire reset,

    input  frame_beat in,
    output reg        in_ready,

    output frame_beat        out,
    output reg        [15:0] sum,
    input  wire              out_ready
);

    frame_beat s1;
    wire       s1_ready;
    assign in_ready = s1_ready || !in.valid;

    // 注意这样的代码只能算单包 88 Byte
    reg [23:0] sum_reg = 24'h000000;
    always_comb begin
        // 加上next_header和payload_len
        sum_reg = in.data.ip6.next_hdr;
        sum_reg = sum_reg + {in.data.ip6.payload_len[7:0], in.data.ip6.payload_len[15:8]};
        for (int i = 8; i < 72; i = i + 2) begin
            sum_reg = sum_reg + {in.data.ip6[8*i+:8], in.data.ip6[8*(i+1)+:8]};
        end
        sum_reg = {8'b0, sum_reg[15:0]} + sum_reg[23:16];
        sum_reg = {8'b0, sum_reg[15:0]} + sum_reg[23:16];
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            s1 <= 0;
        end else if (s1_ready) begin
            s1  <= in;
            sum <= ~{sum_reg[7:0], sum_reg[15:8]};  // sum_reg仅仅是数值和
        end
    end

    assign out      = s1;
    assign s1_ready = out_ready;

endmodule
