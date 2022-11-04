#ifndef __LOOKUP_H__
#define __LOOKUP_H__

#include <stdint.h>
#include <stdbool.h>
#include <arpa/inet.h>
#include "common.h"


const int NODE_COUNT_PER_STAGE = 1024;
const int LEAF_COUNT = 1024;
const int ENTRY_COUNT = 64;

const int STAGE_HEIGHT = 4;
const int STRIDE = 4;
const int STAGE_COUNT = 128 / STRIDE / STAGE_HEIGHT;

const int NODE_ADDRESS[8] = {
    0x40000000,
    0x41000000,
    0x42000000,
    0x43000000,
    0x44000000,
    0x45000000,
    0x46000000,
    0x47000000
};
const int LEAF_ADDRESS = 0x50000000;
const int NEXT_HOP_ADDRESS = 0x51000000;

typedef uint64_t u64;
typedef uint32_t u32;
typedef uint8_t u8;
typedef __uint128_t u128;
typedef uint32_t leaf_t;  // fixme: change to u8

// /* IPv6 address */
// typedef struct {
//     union {
// 	uint8_t	__u6_addr8[16];
// 	uint16_t __u6_addr16[8];
// 	uint32_t __u6_addr32[4];
//     } __in6_u;
// #define s6_addr			__in6_u.__u6_addr8
// } in6_addr;

/*
  表示路由表的一项。
  保证 addr 和 len 构成合法的网络前缀。
  当 nexthop 为零时这是一条直连路由。
  你可以在全局变量中把路由表以一定的数据结构格式保存下来。
*/

typedef struct {
    u32 ip[4];
    u32 port;
    u32 route_type;
} NextHopEntry;

typedef struct {
  in6_addr addr;     // 匹配的 IPv6 地址前缀
  uint32_t len;      // 前缀长度
  uint32_t if_index; // 出端口编号
  in6_addr nexthop;  // 下一跳的 IPv6 地址
  // 为了实现 RIPng 协议，在 router 作业中需要在这里添加额外的字段
} RoutingTableEntry;



// // 真正的存储用的结构体
// typedef struct {
//     u8 vec[2];
//     u8 leaf_vec[2];
//     u8 child_base[3];
//     u8 leaf_base[2];
//     u8 padding[7];  //对齐到16位，实际不会访问到这个 TODO: use __align
// } _TrieNode;

// 为了处理时方便会先转成这个结构体 有改动的话再转回去
// 现在结构体内也会对齐 所以可以都用uint32
typedef struct {
    u32 vec;
    u32 leaf_vec;
    u32 child_base;
    u32 leaf_base;
} TrieNode;

/**
 * @brief 插入/删除一条路由表表项
 * @param insert 如果要插入则为 true ，要删除则为 false
 * @param entry 要插入/删除的表项
 *
 * 插入时如果已经存在一条 addr 和 len 都相同的表项，则替换掉原有的。
 * 删除和更新时按照 addr 和 len **精确** 匹配。
 */
void update(bool insert, const RoutingTableEntry entry);

/**
 * @brief 进行一次路由表的查询，按照最长前缀匹配原则
 * @param addr 需要查询的目标地址，网络字节序
 * @param nexthop 如果查询到目标，把表项的 nexthop 写入
 * @param if_index 如果查询到目标，把表项的 if_index 写入
 * @return 查到则返回 true ，没查到则返回 false
 */
bool prefix_query(const in6_addr addr, in6_addr *nexthop, uint32_t *if_index);

/**
 * @brief 转换 mask 为前缀长度
 * @param mask 需要转换的 IPv6 mask
 * @return mask 合法则返回前缀长度，不合法则返回 -1
 */
int mask_to_len(const in6_addr mask);

/**
 * @brief 转换前缀长度为 IPv6 mask，前缀长度范围为 [0,128]
 * @param len 需要转换的前缀长度
 * @return len 合法则返回对应的 mask，不合法则返回 0
 */
in6_addr len_to_mask(int len);

void print(u32 id, int dep);

void export_mem();

#endif