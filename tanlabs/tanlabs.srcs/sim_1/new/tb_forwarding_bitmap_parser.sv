`timescale 1ns / 1ps

`include "../../sources_1/new/forwarding_table.vh"

module tb_forwarding_bitmap_parser #(
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32
) ();

    FTE_node                          node;
    reg      [          STRIDE - 1:0] pattern;

    wire                              parser_stop;
    wire                              parser_matched;
    wire     [ LEAF_ADDR_WIDTH - 1:0] parser_leaf_addr;
    wire     [CHILD_ADDR_WIDTH - 1:0] parser_node_addr;

    // Leaf:
    // |  *  |  0* |  1* | 00* | 01* | 10* | 11* | 000*| 001*| 010*| 011*| 100*| 101*| 110*| 111*|
    // |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |  9  | 10  | 11  | 12  | 13  | 14  |

    initial begin
        node.leaf_base_addr  = 'b0;
        node.child_base_addr = 'b0;
        node.leaf_map        = 16'b0111_1111_1111_1111;
        node.child_map       = 16'b0111_1111_1111_1111;
        pattern              = 4'b1000;

        #10;
        $display("Output: leaf_addr = %8h; node_addr = %8h;", parser_leaf_addr, parser_node_addr);
        $display("Expect: leaf_addr = %8h; node_addr = %8h;", node.leaf_base_addr + 11,
                 node.child_base_addr + 8);

        node.leaf_base_addr  = 'b0;
        node.child_base_addr = 'b0;
        node.leaf_map        = 16'b0111_1111_1111_1111;
        node.child_map       = 16'b1111_1111_1111_1111;
        pattern              = 4'b1111;

        #10;
        $display("Output: leaf_addr = %8h; node_addr = %8h;", parser_leaf_addr, parser_node_addr);
        $display("Expect: leaf_addr = %8h; node_addr = %8h;", node.leaf_base_addr + 14,
                 node.child_base_addr + 15);


        $finish;
    end

    forwarding_bitmap_parser u_forwarding_bitmap_parser (
        .node   (node),
        .pattern(pattern),

        .stop     (parser_stop),
        .matched  (parser_matched),
        .leaf_addr(parser_leaf_addr),
        .node_addr(parser_node_addr)
    );

endmodule
