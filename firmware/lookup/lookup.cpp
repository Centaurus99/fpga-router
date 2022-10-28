#include "lookup.h"
#include "memhelper.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define BITINDEX(v)     ((v) & ((1 << STRIDE) - 1))
#define NODEINDEX(v)    ((v) >> STRIDE)
#define VEC_CLEAR(v, i) ((v) &= ~((u64)1 << (i)))
#define VEC_BT(v, i)    ((v) & (u64)1 << (i))
#define VEC_SET(v, i)   ((v) |= (u64)1 << (i))
#define popcnt(v)               __builtin_popcountll(v)
#define POPCNT(v)       popcnt(v)
#define ZEROCNT(v)      popcnt(~(v))
#define POPCNT_LS(v, i) popcnt((v) & (((u64)2 << (i)) - 1))
#define ZEROCNT_LS(v, i) popcnt((~(v)) & (((u64)2 << (i)) - 1))

#define NOW nodes[(dep) / STRIDE / STAGE_HEIGHT][nid]
#define STAGE(d) (((d) / STRIDE) / STAGE_HEIGHT)
 

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

//小端序
inline TrieNode u8s_to_u32s(_TrieNode n) {
    return TrieNode {
        (u32) n.vec[1] << 8 | n.vec[0],
        (u32) n.leaf_vec[1] << 8 | n.leaf_vec[0],
        (u32) n.child_base[2] << 16 | n.child_base[1] << 8 | n.child_base[0],
        (u32) n.leaf_base[1] << 8 | n.leaf_base[0]
    };
}
inline _TrieNode u32s_to_u8s(TrieNode n) {
    return _TrieNode {
        {(u8)n.vec, (u8)(n.vec >> 8)},
        {(u8)n.leaf_vec, (u8)(n.leaf_vec >> 8)},
        {(u8)n.child_base, (u8)(n.child_base >> 8), (u8)(n.child_base >> 16)},
        {(u8)n.leaf_base, (u8)(n.leaf_base >> 8)}
    };
}

_TrieNode nodes[STAGE_COUNT][NODE_COUNT_PER_STAGE];
leaf_t leafs[LEAF_COUNT];
RoutingTableEntry entrys[ENTRY_COUNT];
leaf_t entry_count;
int node_root;

leaf_t new_entry(const RoutingTableEntry entry) {
    for (leaf_t i = 0; i < entry_count; ++ i) {
        if (entrys[i].if_index == entry.if_index &&
            calc_addr(entrys[i].nexthop) == calc_addr(entry.nexthop)) {
            return i;
        }
    }
    entrys[entry_count++] = entry;
    return entry_count - 1;
}

// 在now的idx处增加一个新节点（保证之前不存在），必要时整体移动子节点
void insert_node(int dep, int nid, TrieNode *now, u32 idx, int child_id) {
    // printf("NODE %d %d\n",dep, nid);
    if (!now->child_base) { // 如果now是新的点
        now->child_base = child_id;
    } else {
        // TODO: 改成每次空间乘以2
        int cnt = POPCNT(now->vec);
        int child_stage = STAGE(dep + STRIDE);
        int new_base = node_malloc(child_stage, cnt + 1);
        for (u32 i = 0, op = now->child_base, np = new_base; i < (1<<STRIDE); ++i) {
            if (i == idx) {
                nodes[child_stage][np] = nodes[child_stage][child_id];
                ++np;
            } else if (VEC_BT(now->vec, i)) { // TODO: 改成右移一位效率更高
                nodes[child_stage][np] = nodes[child_stage][op];
                ++np, ++op;
            }
        }
        node_free(child_stage, now->child_base, cnt);
        now->child_base = new_base;
    }
    VEC_SET(now->vec, idx);
    NOW = u32s_to_u8s(*now);
}

// 在now的pfx处增加一个新叶子（保证之前不存在），必要时整体移动叶子
void insert_leaf(int dep, int nid, TrieNode *now, u32 pfx, leaf_t entry_id) {
    // printf("~INSERT LEAF: %x, %x %x\n", now - nodes, pfx, entry_id);
    if (!now->leaf_base) { // 如果now是新的点
        now->leaf_base = leaf_malloc(1);
        leafs[now->leaf_base] = entry_id;
    } else {
        // TODO: 改成每次空间乘以2
        int cnt = POPCNT(now->leaf_vec);
        int new_base = leaf_malloc(cnt + 1);
        for (u32 i = 1, op = now->leaf_base, np = new_base; i < (1<<STRIDE); ++i) {
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
    NOW = u32s_to_u8s(*now);
}

// TODO: 移除now的pfx位置的叶子（保证存在）然后把后面的往前挪
void remove_leaf(int dep, int nid, TrieNode *now, u32 pfx) {
    // printf("~REMOVE LEAF: %x, %x\n", now - nodes, pfx);
    int p = POPCNT_LS(now->leaf_vec, pfx);
    if (p <= 1) {
        leaf_free(now->leaf_base, 1);
        ++(now->leaf_base);
    } else {
        p = now->leaf_base + p - 1;  // 要删掉的叶子
        for (u32 i = pfx + 1; i < (1<<STRIDE); ++i) {
            if (VEC_BT(now->leaf_vec, i)) {
                leafs[p] = leafs[p+1];
                ++p;
            }
        }
        leaf_free(p, 1);
    }
    VEC_CLEAR(now->leaf_vec, pfx);
    NOW = u32s_to_u8s(*now);
}

int insert_entry(int dep, int nid, u128 addr, int len, leaf_t entry_id) {
    // printf("INSERT %d %d\n", dep,nid);
    if (nid < 0) {
        nid = node_malloc(STAGE(dep), 1);
    }
    TrieNode now = u8s_to_u32s(NOW);
    if (dep + STRIDE > len) {
        int l = len - dep;
        u32 pfx = INDEX(addr, dep, l) | (1 << l);
        if (VEC_BT(now.leaf_vec, pfx)) { // change
            leafs[now.leaf_base + POPCNT_LS(now.leaf_vec, pfx) - 1] = entry_id;
        } else { // add
            insert_leaf(dep, nid, &now, pfx, entry_id);
        }
    } else {
        u32 idx = INDEX(addr, dep, STRIDE);
        if (VEC_BT(now.vec, idx)) {
            insert_entry(dep + STRIDE, now.child_base + POPCNT_LS(now.vec, idx) - 1, addr, len, entry_id);
        } else {
            int cid = insert_entry(dep + STRIDE, -1, addr, len, entry_id);
            insert_node(dep, nid, &now, idx, cid);
        }
    }
    return nid;
}

// HACK: 为了方便，即使是没有叶子的点也会保留在树里
void remove_entry(int dep, int nid, u128 addr, int len) {
    TrieNode now = u8s_to_u32s(NOW);
    if (dep + STRIDE > len) {
        int l = len - dep;
        u32 pfx = INDEX(addr, dep, l) | (1 << l);
        if (VEC_BT(now.leaf_vec, pfx)) { // remove
            remove_leaf(dep, nid, &now, pfx);
        }
    } else {
        u32 idx = INDEX(addr, dep, STRIDE);
        if (VEC_BT(now.vec, idx)) {
            remove_entry(dep + STRIDE, now.child_base + POPCNT_LS(now.vec, idx) - 1, addr, len);
        }
    }
}

void update(bool insert, const RoutingTableEntry entry) {
    if (insert) {
        leaf_t eid = new_entry(entry);
        insert_entry(0, node_root, calc_addr(entry.addr), entry.len, eid);
    } else {
        remove_entry(0, node_root, calc_addr(entry.addr), entry.len);
    }
}

bool prefix_query(const in6_addr addr, in6_addr *nexthop, uint32_t *if_index) {
    int leaf = -1;
    TrieNode now = u8s_to_u32s(nodes[0][node_root]);
    // print(node_root, 0);
    for (int dep = 0; dep < 128; dep += STRIDE) {
        u32 idx = INDEX(calc_addr(addr), dep, STRIDE);
        // 在当前层匹配一个最长的前缀
        for (u32 pfx = (idx>>1)|(1<<(STRIDE-1)); pfx; pfx >>= 1) {
            if (VEC_BT(now.leaf_vec, pfx)) {
                leaf = leafs[now.leaf_base + POPCNT_LS(now.leaf_vec, pfx) - 1];
                break;
            }
        }
        // 跳下一层
        if (VEC_BT(now.vec, idx)) {
            now = u8s_to_u32s(nodes[STAGE(dep + STRIDE)][now.child_base + POPCNT_LS(now.vec, idx) - 1]);
            if (dep + STRIDE >= 128 && VEC_BT(now.leaf_vec, 1))
                leaf = leafs[now.leaf_base];
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

void print(u32 nid, int dep) {
    TrieNode now = u8s_to_u32s(NOW);
    if (!dep) printf("PRINTING TREE:\n");
    for (int i = 0;i<dep/STRIDE;++i) printf("  ");
    printf("%x-%x: %x %x %x %x\n", STAGE(dep), nid, now.vec, now.leaf_vec, now.child_base, now.leaf_base);
    for (int i = 0; i < POPCNT(now.vec); ++i)
        print(now.child_base + i, dep + STRIDE);
    if (!dep) printf("#################################\n");
}

inline void _write_u8s(FILE *f, u32 addr, u8 *ptr, int len) {
    for (int i = 0; i < len; ++i) {
        if (*(ptr + i) != 0)
            fprintf(f, "%08X %02X\n", addr+i, *(ptr+i));
    }
}

void export_mem() {
    FILE *f = fopen("mem.txt", "w");
    // nodes
    for (int s = 0; s < STAGE_COUNT; ++s) {
        _write_u8s(f, NODE_ADDRESS[s], (u8 *)(nodes[s]), 9 * NODE_COUNT_PER_STAGE);
    }

    // leafs
    _write_u8s(f, LEAF_ADDRESS, (u8 *)leafs, 1 * LEAF_COUNT);

    // next hops
    u32 addr = NEXT_HOP_ADDRESS;
    for (int i = 0; i < entry_count; ++i) {
        _write_u8s(f, addr, (u8 *)(&entrys[i].nexthop), 16);
        addr += 16;
        _write_u8s(f, addr, (u8 *)(&entrys[i].if_index), 1);
        ++addr;
    }
    
    fclose(f);
}