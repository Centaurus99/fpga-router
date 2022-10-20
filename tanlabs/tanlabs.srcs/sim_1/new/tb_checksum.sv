`timescale 1ns / 1ps `default_nettype none

`include "frame_datapath.vh"

module tb_checksum #(
    parameter PACKET_LENGTH = 88,
    parameter MOD = 4'd0
) ();

    reg reset;
    initial begin
        reset = 0;
        #1000
        reset = 1;
        #1000
        reset = 0;
    end

    wire clk_125M;

    clock clock_i(
        .clk_125M(clk_125M)
    );

    frame_beat        in;
    frame_beat        out;
    reg        [15:0] sum;
    reg          in_ready;
    reg         out_ready = 1;

    initial begin
        in = 0;
        // 涓�涓湁鍚堟硶鏍￠獙鍜岀殑鍖�, sum 杈撳嚭鐞嗗簲涓� 0
        in.data = {<<8{688'hffffffffffff544553545f3081006000000000203aff2a0eaa0604970a000000000000000002fe80000000000000020000fffe030a0088003ffa600000002a0eaa0604970a0000000000000000020201544553545f30, 16'b0}};
        in.valid = 1;
        in.is_first = 1;
        in.meta.ndp_packet = 1;
        #100;
        $finish;
    end

    icmpv6_checksum dut (
        .clk(clk_125M),
        .reset(reset),
        .in(in),
        .in_ready(in_ready),
        .out(out),
        .sum(sum),
        .out_ready(out_ready)
    );

endmodule