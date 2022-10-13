`timescale 1ns / 1ps `default_nettype none

`include "frame_datapath.vh"

module tb_checksum #(
    parameter PACKET_LENGTH = 88,
    parameter MOD = 4'd0
) ();

    frame_beat        in;
    reg        [15:0] sum;

    initial begin
        in = 0;
        // 一个有合法校验和的包, sum 输出理应为 0
        in.data = {<<8{688'hffffffffffff544553545f3081006000000000203aff2a0eaa0604970a000000000000000002fe80000000000000020000fffe030a0088003ffa600000002a0eaa0604970a0000000000000000020201544553545f30, 16'b0}};
        #100;
        $finish;
    end

    icmpv6_checksum dut (
        .beat(in),
        .sum (sum)
    );

endmodule
