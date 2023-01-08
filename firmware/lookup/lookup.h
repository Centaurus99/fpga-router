#ifndef __LOOKUP_H__
#define __LOOKUP_H__

#include "../include/header.h"
#include <stdbool.h>
#include <stdint.h>

#define NODE_COUNT_PER_STAGE  1024
#define LEAF_COUNT  65536
#define ENTRY_COUNT  640
#define STAGE_HEIGHT  4
#define STRIDE  4
#define STAGE_COUNT  8

#define NODE_ADDRESS(i) (0x40000000 + i * 0x01000000)
#define LEAF_ADDRESS  0x80400000
#define NEXT_HOP_ADDRESS  0x51000000
#define LEAF_INFO_ADDRESS 0x80500000


#define BITINDEX(v)     ((v) & ((1 << STRIDE) - 1))
#define NODEINDEX(v)    ((v) >> STRIDE)
#define VEC_CLEAR(v, i) ((v) &= ~((uint32_t)1 << (i)))
#define VEC_BT(v, i)    ((v) & (uint32_t)1 << (i))
#define VEC_SET(v, i)   ((v) |= (uint32_t)1 << (i))
#define POPCNT(v)       popcnt(v)
#define ZEROCNT(v)      popcnt(~(v))
#define POPCNT_LS(v, i) popcnt((v) & (((uint32_t)2 << (i)) - 1))
#define ZEROCNT_LS(v, i) popcnt((~(v)) & (((uint32_t)2 << (i)) - 1))

#define NOW nodes((dep) / STRIDE / STAGE_HEIGHT)[nid]
#define STAGE(d) (((d) / STRIDE) / STAGE_HEIGHT)

typedef uint8_t nexthop_id_t;

int popcnt(uint32_t x);

/*
  表示路由表的一项。
  保证 addr 和 len 构成合法的网络前缀。
  当 nexthop 为零时这是一条直连路由。
  你可以在全局变量中把路由表以一定的数据结构格式保存下来。
*/

typedef struct {
    in6_addr ip;
    uint32_t port;
    uint32_t route_type;
    uint32_t padding[2];
} NextHopEntry;

typedef struct {
    in6_addr addr;     // 匹配的 IPv6 地址前缀
    uint32_t len;      // 前缀长度
    uint32_t if_index; // 出端口编号
    in6_addr nexthop;  // 下一跳的 IPv6 地址
    uint32_t route_type;
    // 为了实现 RIPng 协议，在 router 作业中需要在这里添加额外的字段
    uint8_t metric;
} RoutingTableEntry;

// 现在结构体内也会对齐 所以可以都用u32
typedef struct {
    uint32_t vec;
    uint32_t leaf_vec;
    uint16_t child_base; // should be 16
    uint16_t tag; // 低8位可用，第8位表示leaf-in-node优化
    uint32_t leaf_base; // 16位可用
} TrieNode;

typedef union {
    uint8_t nexthop_id[4]; // only use nexthop_id[3]
    uint32_t leaf_id; // only use low 24 bits
    #define _nexthop_id nexthop_id[3]
    #define _leaf_id leaf_id & 0x00ffffff
} LeafNode;

typedef struct {
    bool valid;
    uint8_t metric;
    uint8_t len;
    nexthop_id_t nexthop_id;
    in6_addr ip;
} LeafInfo;

extern uint32_t leaf_count;
#ifndef ON_BOARD
    extern LeafInfo leafs_info[LEAF_COUNT];
    extern NextHopEntry next_hops[ENTRY_COUNT];
#else
    #define leafs_info ((LeafInfo *)LEAF_INFO_ADDRESS)
    #define next_hops ((NextHopEntry *)NEXT_HOP_ADDRESS)
#endif

/**
 * @brief 插入/删除一条路由表表项
 * @param insert 如果要插入则为 true ，要删除则为 false
 * @param entry 要插入/删除的表项
 *
 * 插入时如果已经存在一条 addr 和 len 都相同的表项，则替换掉原有的。
 * 删除和更新时按照 addr 和 len **精确** 匹配。
 */
void update(bool insert, const RoutingTableEntry entry);

void update_leaf_info(LeafNode *leafS, uint8_t metric, uint8_t port, const in6_addr nexthop, uint8_t route_type);

/**
 * @brief 进行一次路由表的查询，len=255时，按照最长前缀匹配原则；否则按照 len 匹配
 * @param addr 需要查询的目标地址，网络字节序
 * @param nexthop 如果查询到目标，把表项的 nexthop 写入
 * @param if_index 如果查询到目标，把表项的 if_index 写入
 * @return 查到则返回 指向树中叶节点的指针 ，没查到则返回 NULL
 */
LeafNode* prefix_query(const in6_addr addr, uint8_t len, in6_addr *nexthop, uint32_t *if_index, uint32_t *route_type);

// /**
//  * @brief 转换 mask 为前缀长度
//  * @param mask 需要转换的 IPv6 mask
//  * @return mask 合法则返回前缀长度，不合法则返回 -1
//  */
// int mask_to_len(const in6_addr mask);

// /**
//  * @brief 转换前缀长度为 IPv6 mask，前缀长度范围为 [0,128]
//  * @param len 需要转换的前缀长度
//  * @return len 合法则返回对应的 mask，不合法则返回 0
//  */
// in6_addr len_to_mask(int len);

// void print_ip(const in6_addr addr);

// void print(uint32_t id, int dep);

// void export_mem();

void lookup_init();

#endif