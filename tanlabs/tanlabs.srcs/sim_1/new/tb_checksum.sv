`timescale 1ns / 1ps `default_nettype none

`include "frame_datapath.vh"

module tb_checksum #(
    parameter PACKET_LENGTH = 88,
    parameter MOD = 4'd0
) ();

    frame_beat        in;
    reg        [15:0] sum;

    initial begin

        $finish;
    end

    icmpv6_checksum dut (
        .beat(in),
        .sum (sum)
    );

endmodule
