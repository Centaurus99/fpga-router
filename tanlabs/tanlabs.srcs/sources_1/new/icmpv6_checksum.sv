`timescale 1ns / 1ps `default_nettype none

`include "frame_datapath.vh"

module icmpv6_checksum #(
    parameter PACKET_LENGTH = 88,
    parameter MOD = 4'd0
) (
    input  frame_beat        beat,
    output wire       [15:0] sum
);

    // 注意这样的代码只能算单包 88 Byte
    reg [23:0] sum_reg = 6'h000000;
    always_comb begin
        // 加上next_header和payload_len
        sum_reg = beat.data.ip6.next_hdr + {beat.data.ip6.payload_len[7:0], beat.data.ip6.payload_len[15:8]};
        for (int i = 0; i < PACKET_LENGTH; i = i + 2) begin
            sum_reg = sum_reg + {beat.data.ip6[8*i+:8], beat.data.ip6[8*(i+1)+:8]};
        end
        sum_reg = {sum_reg[7:0], sum_reg[15:8]} + sum_reg[23:16];
        sum_reg = {sum_reg[7:0], sum_reg[15:8]} + sum_reg[23:16];
    end

    assign sum = ~{sum_reg[7:0], sum_reg[15:8]};  // sum_reg仅仅是数值和

endmodule
