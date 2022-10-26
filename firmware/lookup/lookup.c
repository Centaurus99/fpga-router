#include "lookup.h"
#include "memhelper.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define BITINDEX(v)     ((v) & ((1 << K) - 1))
#define NODEINDEX(v)    ((v) >> K)
#define VEC_CLEAR(v, i) ((v) &= ~((u64)1 << (i)))
#define VEC_BT(v, i)    ((v) & (u64)1 << (i))
#define VEC_SET(v, i)   ((v) |= (u64)1 << (i))
#define popcnt(v)               __builtin_popcountll(v)
#define POPCNT(v)       popcnt(v)
#define ZEROCNT(v)      popcnt(~(v))
#define POPCNT_LS(v, i) popcnt((v) & (((u64)2 << (i)) - 1))
#define ZEROCNT_LS(v, i) popcnt((~(v)) & (((u64)2 << (i)) - 1))


const int K = 4;


static inline u64 INDEX (u128 addr, int s, int n) {
    if ( 0 == ((s) + (n)) ) {
        return 0;
    } else {
        int shift = (128 - ((s) + (n)));
        // printf("~INDEX %x <- %d %d\n", (u32)(((addr) >> shift) & ((1ULL << (n)) - 1)), s, n);
        return ((addr) >> shift) & ((1ULL << (n)) - 1);
    }
}

inline u128 calc_addr(in6_addr in) {
    u128 addr = 0;
    for (int i = 0; i < 16; ++i) addr = (addr << 8) | in.s6_addr[i];
    return addr;
}


TrieNode nodes[NODECOUNT];
u32 leafs[LEAFCOUNT];
RoutingTableEntry entrys[ENTRYCOUNT];
u32 entry_count;
u32 node_root;

u32 new_entry(const RoutingTableEntry entry) {
    for (u32 i = 0; i < entry_count; ++ i) {
        if (entrys[i].if_index == entry.if_index &&
            calc_addr(entrys[i].nexthop) == calc_addr(entry.nexthop)) {
            return i;
        }
    }
    entrys[entry_count++] = entry;
    return entry_count - 1;
}

// 在now的idx处增加一个新节点（保证之前不存在），必要时整体移动子节点
void insert_node(TrieNode *now, u32 idx, u32 child_id) {
    if (!now->child_base) { // 如果now是新的点
        now->child_base = child_id;
    } else {
        // TODO: 改成每次空间乘以2
        u32 cnt = POPCNT(now->vec);
        u32 new_base = node_malloc(cnt + 1);
        for (u32 i = 0, op = now->child_base, np = new_base; i < (1<<K); ++i) {
            if (i == idx) {
                nodes[np] = nodes[child_id];
                ++np;
            } else if (VEC_BT(now->vec, i)) { // TODO: 改成右移一位效率更高
                nodes[np] = nodes[op];
                ++np, ++op;
            }
        }
        node_free(now->child_base, cnt);
        now->child_base = new_base;
    }
    VEC_SET(now->vec, idx);
}

// 在now的pfx处增加一个新叶子（保证之前不存在），必要时整体移动叶子
void insert_leaf(TrieNode *now, u32 pfx, u32 entry_id) {
    // printf("~INSERT LEAF: %x, %x %x\n", now - nodes, pfx, entry_id);
    if (!now->leaf_base) { // 如果now是新的点
        now->leaf_base = leaf_malloc(1);
        leafs[now->leaf_base] = entry_id;
    } else {
        // TODO: 改成每次空间乘以2
        u32 cnt = POPCNT(now->leaf_vec);
        u32 new_base = leaf_malloc(cnt + 1);
        for (u32 i = 1, op = now->leaf_base, np = new_base; i < (1<<K); ++i) {
            if (i == pfx) {
                leafs[np] = entry_id;
                ++np;
            } else if (VEC_BT(now->leaf_vec, i)) { // TODO: 改成右移一位效率更高
                leafs[np] = leafs[op];
                ++np, ++op;
            }
        }
        leaf_free(now->leaf_base, cnt);
        now->leaf_base = new_base;
    }
    VEC_SET(now->leaf_vec, pfx);
}

// TODO: 移除now的pfx位置的叶子（保证存在）然后把后面的往前挪
void remove_leaf(TrieNode *now, u32 pfx) {
    // printf("~REMOVE LEAF: %x, %x\n", now - nodes, pfx);
    u32 p = POPCNT_LS(now->leaf_vec, pfx);
    if (p <= 1) {
        leaf_free(now->leaf_base, 1);
        ++(now->leaf_base);
    } else {
        p = now->leaf_base + p - 1;  // 要删掉的叶子
        for (u32 i = pfx + 1; i < (1<<K); ++i) {
            if (VEC_BT(now->leaf_vec, i)) {
                leafs[p] = leafs[p+1];
                ++p;
            }
        }
        leaf_free(p, 1);
    }
    VEC_CLEAR(now->leaf_vec, pfx);
}

u32 insert_entry(int nid, u32 dep, u128 addr, u32 len, u32 entry_id) {
    if (nid < 0) {
        nid = node_malloc(1);
    }
    TrieNode *now = &nodes[nid];
    if (dep + K > len) {
        u32 l = len - dep;
        u32 pfx = INDEX(addr, dep, l) | (1 << l);
        if (VEC_BT(now->leaf_vec, pfx)) { // change
            leafs[now->leaf_base + POPCNT_LS(now->leaf_vec, pfx) - 1] = entry_id;
        } else { // add
            insert_leaf(now, pfx, entry_id);
        }
        return nid;
    }
    u32 idx = INDEX(addr, dep, K);
    // printf("insert entry ~ %x %d %d\n",nid, dep, idx);
    if (VEC_BT(now->vec, idx)) {
        insert_entry(now->child_base + POPCNT_LS(now->vec, idx) - 1, dep + K, addr, len, entry_id);
    } else {
        u32 cid = insert_entry(-1, dep + K, addr, len, entry_id);
        insert_node(now, idx, cid);
    }
    return nid;
}

// HACK: 为了方便，即使是没有叶子的点也会保留在树里
void remove_entry(u32 nid, u32 dep, u128 addr, u32 len) {
    TrieNode *now = &nodes[nid];
    if (dep + K > len) {
        u32 l = len - dep;
        u32 pfx = INDEX(addr, dep, l) | (1 << l);
        if (VEC_BT(now->leaf_vec, pfx)) { // remove
            remove_leaf(now, pfx);
        }
        return;
    }
    u32 idx = INDEX(addr, dep, K);
    if (VEC_BT(now->vec, idx)) {
        remove_entry(now->child_base + POPCNT_LS(now->vec, idx) - 1, dep + K, addr, len);
    }
}

void update(bool insert, const RoutingTableEntry entry) {
    if (insert) {
        u32 eid = new_entry(entry);
        insert_entry(node_root, 0, calc_addr(entry.addr), entry.len, eid);
    } else {
        remove_entry(node_root, 0, calc_addr(entry.addr), entry.len);
    }
}

bool prefix_query(const in6_addr addr, in6_addr *nexthop, uint32_t *if_index) {
    int leaf = -1;
    TrieNode *now = &nodes[node_root];
    // print(node_root, 0);
    for (int i = 0; i < 128; i += K) {
        u32 idx = INDEX(calc_addr(addr), i, K);
        // 在当前层匹配一个最长的前缀
        for (u32 pfx = (idx>>1)|(1<<(K-1)); pfx; pfx >>= 1) {
            if (VEC_BT(now->leaf_vec, pfx)) {
                leaf = leafs[now->leaf_base + POPCNT_LS(now->leaf_vec, pfx) - 1];
                break;
            }
        }
        // 跳下一层
        if (VEC_BT(now->vec, idx)) {
            now = &nodes[now->child_base + POPCNT_LS(now->vec, idx) - 1];
            if (i+K >= 128 && VEC_BT(now->leaf_vec, 1))
                leaf = leafs[now->leaf_base];
        } else {
            break;
        }
    }
    if (leaf == -1)  return 0;
    *nexthop = entrys[leaf].nexthop, *if_index = entrys[leaf].if_index;
    return 1;

}

int mask_to_len(const in6_addr mask) {
    for (int i=0; i<128; i+=8) {
        int m = 0x80;
        for (int j=0; j<8; ++j, m>>=1) {
            if (!(mask.s6_addr[i/8] & m)) {
                return i+j;
            }
        }
    }
    return 128;
}

in6_addr len_to_mask(int len) {
    in6_addr res={};
    for (int i=0; i<len; i+=8) {
        if (i+8 < len)  res.s6_addr[i/8] = 0xff;
        else {
            res.s6_addr[i/8] = 0xff << (8 + i - len);
        }
    }
    return res;
}

void print(u32 id, int dep) {
    TrieNode *now = &nodes[id];
    if (!dep) printf("PRINTING TREE:\n");
    for (int i = 0;i<dep;++i) printf("  ");
    printf("%x: %x %x %x %x\n", id, now->vec, now->leaf_vec, now->child_base, now->leaf_base);
    for (int i = 0; i < POPCNT(now->vec); ++i)
        print(now->child_base + i, dep + 1);
    if (!dep) printf("#################################\n");
}