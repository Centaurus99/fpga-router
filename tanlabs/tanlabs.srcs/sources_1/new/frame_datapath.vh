`ifndef _FRAME_DATAPATH_VH_
`define _FRAME_DATAPATH_VH_

// 'w' means wide.
localparam DATAW_WIDTH_ND = 8 * 88;
localparam DATAW_WIDTH_V6 = 8 * 56;
localparam ID_WIDTH = 3;

// README: Your code here.

typedef struct packed {
    logic [(DATAW_WIDTH_ND - 8 * 40 - 8 * 14 - 8 * 24 - 8 * 8) - 1:0] padding;
    logic [47:0] source_link_layer_address;
    logic [7:0] length;
    logic [7:0] option_type;
    logic [127:0] target_address;
    logic [31:0] reserved;
    logic [15:0] checksum;
    logic [7:0] code;
    logic [7:0] icmp_type;
} ns_mes;

// ns包的信息
// 原包24byte，option有8byte

typedef struct packed {
    logic [(DATAW_WIDTH_ND - 8 * 40 - 8 * 14 - 8 * 24 - 8 * 8) - 1:0] padding;
    logic [47:0] target_link_layer_address;
    logic [7:0] length;
    logic [7:0] option_type;
    logic [127:0] target_address;
    logic [23:0] reserved_lo;
    logic router_flag;
    logic solicited_flag;
    logic override_flag;
    logic [4:0] reserved_hi;
    logic [15:0] checksum;
    logic [7:0] code;
    logic [7:0] icmp_type;
} na_mes;

// na包的信息

typedef union packed {
    logic [(DATAW_WIDTH_ND - 8 * 40 - 8 * 14) - 1:0] raw_data;
    ns_mes ns_data;
    na_mes na_data;
} mes_union;

typedef struct packed
{
    mes_union p;
    logic [127:0] dst;
    logic [127:0] src;
    logic [7:0] hop_limit;
    logic [7:0] next_hdr;
    logic [15:0] payload_len;
    logic [23:0] flow_lo;
    logic [3:0] version;
    logic [3:0] flow_hi;
} ip6_hdr;

typedef struct packed
{
    ip6_hdr ip6;
    logic [15:0] ethertype;
    logic [47:0] src;
    logic [47:0] dst;
} ether_hdr;

typedef struct packed
{
    // Per-frame metadata.
    // **They are only effective at the first beat.**
    logic [ID_WIDTH - 1:0] id;  // The ingress interface.
    logic [ID_WIDTH - 1:0] dest;  // The egress interface.
    logic drop;  // Drop this frame (i.e., this beat and the following beats till the last)?

    // Do not touch this beat!
    // 目前用于表示发给软件的包和接收的 NS/NA 包
    logic dont_touch;  

    // Drop the next frame? It is useful when you need to shrink a frame
    // (e.g., replace an IPv6 packet to an ND solicitation).
    // You can do so by setting both last and drop_next.
    logic drop_next;

    // 该数据包由 datapath 生成和发送
    logic send_from_datapath;
    // 该数据包须由 ndp_datapath 接收
    logic ndp_packet;

} frame_meta;

typedef struct packed
{
    // AXI-Stream signals.
    ether_hdr data;
    logic [DATAW_WIDTH_ND / 8 - 1:0] keep;
    logic last;
    logic [DATAW_WIDTH_ND / 8 - 1:0] user;
    logic valid;

    // Handy signals.
    logic is_first;  // Is this the first beat of a frame?

    frame_meta meta;
} frame_beat;

`define should_handle(b) \
(b.valid && b.is_first && !b.meta.drop && !b.meta.dont_touch)

// README: Your code here. You can define some other constants like EtherType.
localparam ID_CPU = 3'd4;  // The interface ID of CPU is 4.

localparam ETHERTYPE_IP6 = 16'hdd86;

localparam IP6_TYPE_ICMP = 8'h3a;

localparam ICMP_TYPE_NS = 8'd135;
localparam ICMP_TYPE_NA = 8'd136;

`endif
