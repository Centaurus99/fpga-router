`timescale 1ns / 1ps `default_nettype none

// EUI64 地址生成模块
module eui64 (
    input  wire [ 47:0] mac,
    output wire [127:0] ip
);

    assign ip[127:0] = {
        mac[47:24], 16'hfeff, mac[23:8], mac[7:2], mac[1] ^ 1'b1, mac[0], 64'h0000_0000_0000_80fe
    };

endmodule
