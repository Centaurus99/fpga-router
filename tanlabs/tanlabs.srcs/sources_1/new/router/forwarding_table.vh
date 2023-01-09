`ifndef _FORWARDING_TABLE_VH_
`define _FORWARDING_TABLE_VH_

`include "frame_datapath.vh"

localparam PIPELINE_LENGTH = 8;  // 流水线级数，也是存储层数量
localparam STAGE_HEIGHT = 4;  // 每级流水线的层数, 即经过的树高
localparam STRIDE = 4;  // Trie 树每层压位数
localparam CHILD_MAP_SIZE = 1 << STRIDE;  // 子节点 bitmap 大小
localparam LEAF_MAP_SIZE = 1 << STRIDE;  // 前缀(叶节点) bitmap 大小
localparam CHILD_ADDR_WIDTH = 19;  // 子节点地址宽度
localparam LEAF_ADDR_WIDTH = 19;  // 叶节点地址宽度
localparam NEXT_HOP_ADDR_WIDTH = 8;  // 下一跳地址宽度
localparam TAG_WIDTH = 2;  // 子节点地址宽度

// forwarding table entry
typedef struct packed {
    logic [TAG_WIDTH - 1:0] tag;  // 若 Tag 首位为 1, 则表示叶节点
    logic [LEAF_ADDR_WIDTH - 1:0] leaf_base_addr;
    logic [CHILD_ADDR_WIDTH - 1:0] child_base_addr;
    logic [LEAF_MAP_SIZE - 1:0] leaf_map;
    logic [CHILD_MAP_SIZE - 1:0] child_map;
} FTE_node;

typedef struct packed {
    logic stop;  // 是否已经结束匹配
    logic matched;  // 是否有匹配到的前缀
    logic [LEAF_ADDR_WIDTH - 1:0] leaf_addr;  // 已匹配到的最长前缀叶节点地址
    logic [CHILD_ADDR_WIDTH - 1:0] node_addr;  // 当前节点地址
    frame_beat beat;
} forwarding_beat;

// 叶节点, 存放 next_hop 编号
typedef struct packed {logic [NEXT_HOP_ADDR_WIDTH - 1:0] next_hop_addr;} leaf_node;

typedef enum logic [3:0] {
    ROUTE_DIRECT  = 4'b0000,
    ROUTE_STATIC  = 4'b0001,
    ROUTE_DYNAMIC = 4'b0010
} route_type_t;

// next_hop 节点
typedef struct packed {
    // 路由类型, 直连:0, 静态:1, 动态:2
    route_type_t  route_type;
    logic [3:0]   port;
    logic [127:0] ip;
} next_hop_node;

`define should_search(b) (`should_handle(b.beat) && !b.stop)

`endif
