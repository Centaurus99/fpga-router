`timescale 1ns / 1ps `default_nettype none

// 根据地址解析 FTE_node, 匹配前缀, 给出下一内部节点地址

`include "forwarding_table.vh"

function logic [2:0] popcount_4bit(input [3:0] num);
    case (num)
        4'b0000: return 3'b000;
        4'b0001: return 3'b001;
        4'b0010: return 3'b001;
        4'b0011: return 3'b010;
        4'b0100: return 3'b001;
        4'b0101: return 3'b010;
        4'b0110: return 3'b010;
        4'b0111: return 3'b011;
        4'b1000: return 3'b001;
        4'b1001: return 3'b010;
        4'b1010: return 3'b010;
        4'b1011: return 3'b011;
        4'b1100: return 3'b010;
        4'b1101: return 3'b011;
        4'b1110: return 3'b011;
        4'b1111: return 3'b100;
    endcase
endfunction

function logic [3:0] popcount_15bit(input [14:0] num);
    automatic logic [3:0] ans;
    ans = {1'b0, popcount_4bit({1'b0, num[14:12]})} + popcount_4bit(num[11:8]) +
        popcount_4bit(num[7:4]) + popcount_4bit(num[3:0]);
    return ans;
endfunction

module forwarding_bitmap_parser (
    input FTE_node                node,
    input wire     [STRIDE - 1:0] pattern,

    output reg                          stop,       // 无下一子节点
    output reg                          matched,    // 新匹配到前缀
    output reg [ LEAF_ADDR_WIDTH - 1:0] leaf_addr,
    output reg [CHILD_ADDR_WIDTH - 1:0] node_addr
);
    // 右移 bitmap, 用于匹配 pattern 和进行 popcount
    wire [ LEAF_MAP_SIZE - 1:0] leaf_map_shifted  [3:0];
    wire [CHILD_MAP_SIZE - 1:0] child_map_shifted;
    wire [        STRIDE - 1:0] not_pattern;
    assign not_pattern         = ~pattern;
    assign leaf_map_shifted[3] = node.leaf_map << {1'b0, not_pattern[3:1]};
    assign leaf_map_shifted[2] = node.leaf_map << {2'b10, not_pattern[3:2]};
    assign leaf_map_shifted[1] = node.leaf_map << {3'b110, not_pattern[3:3]};
    assign leaf_map_shifted[0] = node.leaf_map << 4'b1110;
    assign child_map_shifted   = node.child_map << not_pattern;

    // 匹配叶节点
    wire [3:0] leaf_match;
    assign leaf_match = {
        leaf_map_shifted[3][LEAF_MAP_SIZE-1],
        leaf_map_shifted[2][LEAF_MAP_SIZE-1],
        leaf_map_shifted[1][LEAF_MAP_SIZE-1],
        leaf_map_shifted[0][LEAF_MAP_SIZE-1]
    };

    always_comb begin
        // 前缀长的优先
        unique casez (leaf_match)
            4'b1???: begin
                matched = 1'b1;
                leaf_addr = node.leaf_base_addr +
                    popcount_15bit(leaf_map_shifted[3][LEAF_MAP_SIZE-2:0]);
            end
            4'b01??: begin
                matched = 1'b1;
                leaf_addr = node.leaf_base_addr +
                    popcount_15bit(leaf_map_shifted[2][LEAF_MAP_SIZE-2:0]);
            end
            4'b001?: begin
                matched = 1'b1;
                leaf_addr = node.leaf_base_addr +
                    popcount_15bit(leaf_map_shifted[1][LEAF_MAP_SIZE-2:0]);
            end
            4'b0001: begin
                matched = 1'b1;
                leaf_addr = node.leaf_base_addr +
                    popcount_15bit(leaf_map_shifted[0][LEAF_MAP_SIZE-2:0]);
            end
            default: begin
                matched   = 1'b0;
                leaf_addr = '0;
            end
        endcase

        // 由 stop 信号标识是否有下一子节点, 故可以直接生成 node_addr (减少组合逻辑)
        node_addr = node.child_base_addr + popcount_15bit(child_map_shifted[CHILD_MAP_SIZE-2:0]);

        stop      = 1'b0;
        // 匹配到子节点
        if (child_map_shifted[CHILD_MAP_SIZE-1]) begin
            // Tag 最高位为 1, 说明为叶节点
            if (node.tag[TAG_WIDTH-1]) begin
                stop      = 1'b1;
                matched   = 1'b1;
                leaf_addr = node_addr[LEAF_ADDR_WIDTH-1:0];
            end
        end else begin
            stop = 1'b1;
        end
    end

endmodule
