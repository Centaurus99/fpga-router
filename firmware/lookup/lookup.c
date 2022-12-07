#include "lookup.h"
#include "memhelper.h"
#include <printf.h>

#ifndef ENABLE_BITMANIP
int popcnt(int x) {
    int cnt = 0;
    while (x) {
        if (x & 1) cnt++;
        x >>= 1;
    }
    return cnt;
}
#else
extern int popcnt(int x);
#endif

static inline u32 INDEX (in6_addr addr, int s, int n) {
    u32 res = 0;
    int shift = 128 - s - n;
    for (int i = 15; i >= 0; -- i) {
        if (shift >= 0 && shift < 8)
            res |= addr.s6_addr[i] >> shift;
        else if (shift < 0 && shift > -8)
            res |= (u32)addr.s6_addr[i] << (-shift);
        shift -= 8;
        if (shift < -32) break;
    }
    res = res & ((1u << n) - 1);
    // print_ip(addr);
    // printf("%d %d %x\n", s, n, (u32)res);
    return res;
}

#ifndef USE_BRAM
TrieNode _nodes[STAGE_COUNT][NODE_COUNT_PER_STAGE];
#define nodes(i) _nodes[i]
leaf_t leafs[LEAF_COUNT];
NextHopEntry next_hops[ENTRY_COUNT];
#else
#define nodes(i) ((volatile TrieNode *)NODE_ADDRESS(i))
#define leafs ((volatile leaf_t *)LEAF_ADDRESS)
#define next_hops ((volatile NextHopEntry *)NEXT_HOP_ADDRESS)
#endif
leaf_t entry_count;
int node_root;

// RoutingTableEntry routing_table[ENTRY_COUNT]; // TODO: 删掉

TrieNode stk[33];

leaf_t _new_entry(const RoutingTableEntry entry) {
    for (leaf_t i = 0; i < entry_count; ++ i) {
        if (next_hops[i].port == entry.if_index &&
            next_hops[i].ip[0] == entry.nexthop.s6_addr32[0] && 
            next_hops[i].ip[1] == entry.nexthop.s6_addr32[1] && 
            next_hops[i].ip[2] == entry.nexthop.s6_addr32[2] && 
            next_hops[i].ip[3] == entry.nexthop.s6_addr32[3] &&
            // // FIXME: 正式路由表里不应该判断addr和len相不相同！
            // routing_table[i].addr.s6_addr32[0] == entry.addr.s6_addr32[0] && 
            // routing_table[i].addr.s6_addr32[1] == entry.addr.s6_addr32[1] && 
            // routing_table[i].addr.s6_addr32[2] == entry.addr.s6_addr32[2] && 
            // routing_table[i].addr.s6_addr32[3] == entry.addr.s6_addr32[3] &&
            // routing_table[i].len == entry.len &&
            next_hops[i].route_type == entry.route_type) { // TODO: 在输入中增加对route_type的支持
            return i;
        }
    }
    next_hops[entry_count].port = entry.if_index;
    next_hops[entry_count].ip[0] = entry.nexthop.s6_addr32[0];
    next_hops[entry_count].ip[1] = entry.nexthop.s6_addr32[1];
    next_hops[entry_count].ip[2] = entry.nexthop.s6_addr32[2];
    next_hops[entry_count].ip[3] = entry.nexthop.s6_addr32[3];
    next_hops[entry_count].route_type = entry.route_type;

    // routing_table[entry_count] = entry;
    return entry_count++;
}

// 在now的idx处增加一个新节点（保证之前不存在），必要时整体移动子节点
void _insert_node(int dep, TrieNode *now, u32 idx, TrieNode *child) {
    // printf("NODE %d %d\n",dep, idx);
    int child_stage = STAGE(dep + STRIDE);

    // 如果child没有内部子节点且只有一个*的叶子节点，判断是否能做leaf-in-node优化
    // if (!child->child_base && child->leaf_vec == 1) {
    //     if (!now->child_base) {
    //         now->child_base = child->leaf_base;
    //         VEC_SET(now->child_base, 24);
    //         VEC_SET(now->vec, idx);
    //         return;
    //     } else if (VEC_BT(now->child_base, 24)) {
    //         int cnt = POPCNT(now->vec);
    //         int new_base = leaf_malloc(cnt + 1);
    //         for (u32 i = 0, op = now->child_base & 0x7fffff, np = new_base; i < (1<<STRIDE); ++i) {
    //             if (i == idx) {
    //                 leafs[np] = leafs[child->leaf_base];
    //                 leaf_free(child->leaf_base, 1);
    //                 ++np;
    //             } else if (VEC_BT(now->vec, i)) { // TODO: 改成右移一位效率更高
    //                 leafs[np] = leafs[op];
    //                 ++np, ++op;
    //             }
    //         }
    //         now->child_base = new_base;
    //         VEC_SET(now->child_base, 24);
    //         VEC_SET(now->vec, idx);
    //         return;
    //     }
    // }
    if (VEC_BT(now->child_base, 24)) { // TODO: 需要把之前做的leaf-in-node优化都下放
        
    } else if (!now->child_base) { // 如果now还没有子节点
        now->child_base = node_malloc(child_stage, 1);
        nodes(child_stage)[now->child_base] = *child;
    } else {
        // TODO: 改成每次空间乘以2
        int cnt = POPCNT(now->vec);
        int new_base = node_malloc(child_stage, cnt + 1);
        for (u32 i = 0, op = now->child_base, np = new_base; i < (1<<STRIDE); ++i) {
            if (i == idx) {
                nodes(child_stage)[np] = *child;
                ++np;
            } else if (VEC_BT(now->vec, i)) { // TODO: 改成右移一位效率更高
                nodes(child_stage)[np] = nodes(child_stage)[op];
                ++np, ++op;
            }
        }
        node_free(child_stage, now->child_base, cnt);
        now->child_base = new_base;
    }
    VEC_SET(now->vec, idx);
    // NOW = u32s_to_u8s(*now);
}

// 在now的pfx处增加一个新叶子（保证之前不存在），必要时整体移动叶子
void _insert_leaf(int dep, TrieNode *now, u32 pfx, leaf_t entry_id) {
    // printf("~INSERT LEAF: %x %x\n", pfx, entry_id);
    int cnt = POPCNT(now->leaf_vec);
    if (!cnt) { // 如果now没有叶子
        now->leaf_base = leaf_malloc(1);
        leafs[now->leaf_base] = entry_id;
    } else {
        // TODO: 改成每次空间乘以2
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
    // NOW = u32s_to_u8s(*now);
}

// 移除now的pfx位置的叶子（保证存在）然后把后面的往前挪
void _remove_leaf(int dep, TrieNode *now, u32 pfx) {
    // printf("~REMOVE LEAF: %x, %x\n", now, pfx);
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
    // NOW = u32s_to_u8s(*now);
}


void insert_entry(int dep, TrieNode *now, in6_addr addr, int len, leaf_t entry_id) {
    if (dep + STRIDE > len) {
        int l = len - dep;
        u32 pfx = INDEX(addr, dep, l) | (1 << l);
        // printf("INSERT %d %x\n", dep,pfx);
        if (VEC_BT(now->leaf_vec, pfx)) { // change
            leafs[now->leaf_base + POPCNT_LS(now->leaf_vec, pfx) - 1] = entry_id;
        } else { // add
            _insert_leaf(dep, now, pfx, entry_id);
        }
    } else {
        u32 idx = INDEX(addr, dep, STRIDE);
        // printf("INSERT %d %x\n", dep,idx);
        // TODO: 如果now做了leaf-in-node优化，判断是否要把孩子下放
        if (VEC_BT(now->child_base, 24) && len != dep + STRIDE) {
            int cnt = popcnt(now->vec);
        }
        if (VEC_BT(now->vec, idx)) {
            TrieNode *child = &nodes(STAGE(dep + STRIDE))[now->child_base + POPCNT_LS(now->vec, idx) - 1];
            insert_entry(dep + STRIDE, child, addr, len, entry_id);
        } else {
            TrieNode *child = &stk[dep/STRIDE + 1];
            child->vec = child->leaf_vec = 0;
            insert_entry(dep + STRIDE, child, addr, len, entry_id);
            _insert_node(dep, now, idx, child);
        }
    }
}

// HACK: 为了方便，即使是没有叶子的点也会保留在树里
void remove_entry(int dep, int nid, in6_addr addr, int len) {
    TrieNode *now = &NOW;
    if (dep + STRIDE > len) {
        int l = len - dep;
        u32 pfx = INDEX(addr, dep, l) | (1 << l);
        if (VEC_BT(now->leaf_vec, pfx)) { // remove
            _remove_leaf(dep, now, pfx);
        }
    } else {
        u32 idx = INDEX(addr, dep, STRIDE);
        if (VEC_BT(now->vec, idx)) {
            remove_entry(dep + STRIDE, now->child_base + POPCNT_LS(now->vec, idx) - 1, addr, len);
        }
    }
}

void update(bool insert, const RoutingTableEntry entry) {
    if (insert) {
        leaf_t eid = _new_entry(entry);
        insert_entry(0, &nodes(0)[node_root], entry.addr, entry.len, eid);
    } else {
        remove_entry(0, node_root, entry.addr, entry.len);
    }
}

bool prefix_query(const in6_addr addr, in6_addr *nexthop, u32 *if_index, u32 *route_type) {
    int leaf = -1;
    TrieNode *now = &nodes(0)[node_root];
    // print(node_root, 0);
    for (int dep = 0; dep < 128; dep += STRIDE) {
        u32 idx = INDEX(addr, dep, STRIDE);
        // 在当前层匹配一个最长的前缀
        for (u32 pfx = (idx>>1)|(1<<(STRIDE-1)); pfx; pfx >>= 1) {
            if (VEC_BT(now->leaf_vec, pfx)) {
                leaf = leafs[now->leaf_base + POPCNT_LS(now->leaf_vec, pfx) - 1];
                break;
            }
        }
        // 跳下一层
        if (VEC_BT(now->vec, idx)) {
            now = &nodes(STAGE(dep + STRIDE))[now->child_base + POPCNT_LS(now->vec, idx) - 1];
            if (dep + STRIDE >= 128 && VEC_BT(now->leaf_vec, 1))
                leaf = leafs[now->leaf_base];
        } else {
            break;
        }
    }
    if (leaf == -1)  return 0;
    nexthop->s6_addr32[0] = next_hops[leaf].ip[0];
    nexthop->s6_addr32[1] = next_hops[leaf].ip[1];
    nexthop->s6_addr32[2] = next_hops[leaf].ip[2];
    nexthop->s6_addr32[3] = next_hops[leaf].ip[3];
    *if_index = next_hops[leaf].port;
    *route_type = next_hops[leaf].route_type;
    return 1;
}

void _append_answer(RoutingTableEntry *t, in6_addr *ip, int len, int leaf) {
    t->addr = *ip;
    t->len = len;
    t->nexthop.s6_addr32[0] = next_hops[leaf].ip[0];
    t->nexthop.s6_addr32[1] = next_hops[leaf].ip[1];
    t->nexthop.s6_addr32[2] = next_hops[leaf].ip[2];
    t->nexthop.s6_addr32[3] = next_hops[leaf].ip[3];
    t->if_index = next_hops[leaf].port;
    t->route_type = next_hops[leaf].route_type;
}

// 按照前缀长度从长到短的顺序返回所有匹配的路由
void _prefix_query_all(int dep, int nid, const in6_addr addr, RoutingTableEntry *checking_entry, int *count, bool checking_all, in6_addr ip) {
    if (dep > 128) return;
    TrieNode *now = &NOW;
    // 在当前层匹配所有的前缀
    // printf("~~~%d %d %d\n", dep, nid, *count);
    // for (int i = 0; i < 10; ++i);
    if (checking_all) {
        for (int pfx = 1; pfx < (1<<(STRIDE)); ++pfx) {
            if (!VEC_BT(now->leaf_vec, pfx)) continue;
            for (int l = 3; l >= 0; --l) {
                if (pfx & (1<<l)) {
                    int leaf = leafs[now->leaf_base + POPCNT_LS(now->leaf_vec, pfx) - 1];
                    if (dep%8==0) {
                        ip.s6_addr[dep/8] = (ip.s6_addr[dep/8] & 0x0f) | ((pfx ^ (1<<l)) << (8-l));
                    } else {
                        ip.s6_addr[dep/8] = (ip.s6_addr[dep/8] & 0xf0) | ((pfx ^ (1<<l)) << (4-l));
                    }
                    _append_answer(checking_entry + (*count)++, &ip, dep + l, leaf);
                    break;
                }
            }
        }
        for (int idx = 0; idx < (1<<(STRIDE)); ++idx) {
            if (VEC_BT(now->vec, idx)) {
                if (dep%8==0) {
                    ip.s6_addr[dep/8] = (ip.s6_addr[dep/8] & 0xf) | (idx << 4);
                } else {
                    ip.s6_addr[dep/8] = (ip.s6_addr[dep/8] & 0xf0) | idx;
                }
                _prefix_query_all(dep + STRIDE, now->child_base + POPCNT_LS(now->vec, idx) - 1, addr, checking_entry, count, checking_all, ip);
            }
        }
    } else {
        u32 idx = INDEX(addr, dep, STRIDE);
        u32 x = (idx>>1)|(1<<(STRIDE-1));
        for (int i = 0; i < STRIDE; ++i) {
            u32 pfx = x >> i;
            u32 idxi = idx >> (i+1);
            if (VEC_BT(now->leaf_vec, pfx)) {
                int leaf = leafs[now->leaf_base + POPCNT_LS(now->leaf_vec, pfx) - 1];
                if (dep%8==0) {
                    ip.s6_addr[dep/8] = (ip.s6_addr[dep/8] & 0xf) | (idxi << (4+i+1));
                } else {
                    ip.s6_addr[dep/8] = (ip.s6_addr[dep/8] & 0xf0) | (idxi << (i+1));
                }
                _append_answer(checking_entry + (*count)++, &ip, dep + STRIDE - 1 - i, leaf);
            }
        }
        if (VEC_BT(now->vec, idx)) {
            if (dep%8==0) {
                ip.s6_addr[dep/8] = (ip.s6_addr[dep/8] & 0xf) | (idx << 4);
            } else {
                ip.s6_addr[dep/8] = (ip.s6_addr[dep/8] & 0xf0) | idx;
            }
            _prefix_query_all(dep + STRIDE, now->child_base + POPCNT_LS(now->vec, idx) - 1, addr, checking_entry, count, checking_all, ip);
        }
    }

}

