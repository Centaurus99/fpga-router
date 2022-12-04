`timescale 1ns / 1ps `default_nettype none

// 从 IPv6 单播地址生成 IPv6 组播地址和 MAC 组播地址
module unicast_to_multicast (
    input  wire [127:0] ip_in,
    output wire [127:0] ip_out,
    output wire [ 47:0] mac_out
);
    logic [103:0] ip_prefix = {<<8{104'hff02_0000_0000_0000_0000_0001_ff}};
    logic [ 23:0] mac_suffix = {<<8{16'h3333, 8'hff}};

    assign ip_out  = {ip_in[127:104], ip_prefix};
    assign mac_out = {ip_in[127:104], mac_suffix};

endmodule
