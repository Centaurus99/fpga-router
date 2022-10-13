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
    reg [23:0] sum_reg = 24'h000000;
    reg [23:0] sum_reg_temp         [7:0] = '{default: 0};
    always_comb begin
        // 加上next_header和payload_len
        sum_reg = beat.data.ip6.next_hdr;
        sum_reg = sum_reg + {beat.data.ip6.payload_len[7:0], beat.data.ip6.payload_len[15:8]};
        for (int i = 0; i < 8; i = i + 1) begin
            for (int j = 8 + 8 * i; j < 8 + 8 * i + 8; j = j + 2) begin
                sum_reg_temp[i]  = sum_reg_temp[i] + {beat.data.ip6[8*j+:8], beat.data.ip6[8*(j+1)+:8]};
            end
            sum_reg = sum_reg + sum_reg_temp[i];
        end
        sum_reg = {8'b0, sum_reg[15:0]} + sum_reg[23:16];
        sum_reg = {8'b0, sum_reg[15:0]} + sum_reg[23:16];
    end

    assign sum = ~{sum_reg[7:0], sum_reg[15:8]};  // sum_reg仅仅是数值和

endmodule
