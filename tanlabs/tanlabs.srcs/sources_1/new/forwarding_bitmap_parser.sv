`timescale 1ns / 1ps `default_nettype none

// 根据地址解析 FTE_node, 匹配前缀, 给出下一内部节点地址

`include "forwarding_table.vh"

module forwarding_bitmap_parser (
    input FTE_node                node,
    input wire     [STRIDE - 1:0] pattern,

    output wire                          stop,       // 无下一子节点
    output wire                          matched,    // 新匹配到前缀
    output wire [ LEAF_ADDR_WIDTH - 1:0] leaf_addr,
    output wire [CHILD_ADDR_WIDTH - 1:0] node_addr
);
    // TODO
    assign stop      = 1'b0;
    assign matched   = 1'b0;
    assign leaf_addr = 'b0;
    assign node_addr = 'b0;

endmodule
