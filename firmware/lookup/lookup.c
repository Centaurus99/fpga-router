#include <lookup.h>
#include <memhelper.h>
#include <stdio.h>
#include <assert.h>

#ifndef LOOKUP_ONLY
#include <timer.h>
#include <ripng.h>
#endif

#ifndef ENABLE_BITMANIP
int popcnt(uint32_t x) {
    int cnt = 0;
    while (x) {
        if (x & 1) cnt++;
        x >>= 1;
    }
    return cnt;
}
#else
extern int popcnt(uint32_t x);
#endif

static inline uint32_t INDEX (in6_addr addr, int d) {
    uint32_t res = 0;
    if (d&0b100)
        return addr.s6_addr[d>>3] & 0xf;
    else
        return (addr.s6_addr[d>>3] >> 4) & 0xf;
    // int shift = 128 - s - n;
    // for (int i = 15; i >= 0; -- i) {
    //     if (shift >= 0 && shift < 8)
    //         res |= addr.s6_addr[i] >> shift;
    //     else if (shift < 0 && shift > -8)
    //         res |= (uint32_t)addr.s6_addr[i] << (-shift);
    //     shift -= 8;
    //     if (shift < -32) break;
    // }
    // res = res & ((1u << n) - 1);
    // // print_ip(addr);
    // // printf("%d %d %x\n", s, n, (uint32_t)res);
    return res;
}

#ifndef ON_BOARD

    #ifdef TRIVIAL_MALLOC
    TrieNode _nodes[STAGE_COUNT][NODE_COUNT_PER_STAGE];
    #else
    TrieNode *_nodes[STAGE_COUNT];
    #endif

    #define nodes(i) _nodes[i]
    LeafNode leafs[LEAF_NODE_COUNT];
    NextHopEntry next_hops[ENTRY_COUNT];
    LeafInfo leafs_info[LEAF_INFO_COUNT];

#else
    #define nodes(i) ((TrieNode *)NODE_ADDRESS(i))
    #define leafs ((LeafNode *)LEAF_ADDRESS)
#endif
nexthop_id_t entry_count;
uint32_t leaf_count;
uint32_t unused_leafid[LEAF_INFO_COUNT], unused_leafid_top;
int node_root;
TrieNode stk[33];

uint32_t pop_unused_leafid() {
    assert_id(unused_leafid_top > 0, 0xff);
    return unused_leafid[--unused_leafid_top];
}

void push_unused_leafid(uint32_t id) {
    unused_leafid[unused_leafid_top++] = id;
}

#ifdef LOOKUP_ONLY
bool in6_addr_equal(const in6_addr a, const in6_addr b) {
    return a.s6_addr32[0] == b.s6_addr32[0] &&
           a.s6_addr32[1] == b.s6_addr32[1] &&
           a.s6_addr32[2] == b.s6_addr32[2] &&
           a.s6_addr32[3] == b.s6_addr32[3];
}
#endif

nexthop_id_t _new_entry(uint8_t port, const in6_addr ip, uint32_t route_type) {
    for (nexthop_id_t i = 0; i < entry_count; ++ i) {
        if (next_hops[i].port == port &&
            in6_addr_equal(next_hops[i].ip, ip) &&
            next_hops[i].route_type == route_type) { // TODO: 在输入中增加对route_type的支持
            return i;
        }
    }
    next_hops[entry_count].port = port;
    next_hops[entry_count].ip = ip;
    next_hops[entry_count].route_type = route_type;
    assert_id(entry_count < 256, 0xfe);
    // routing_table[entry_count] = entry;
    return entry_count++;
}

LeafNode _new_leaf_node(const RoutingTableEntry entry) {
    LeafNode ret;
    ret.leaf_id = pop_unused_leafid();
    ret._nexthop_id = _new_entry(entry.if_index, entry.nexthop, entry.route_type);
    return ret;
}

static inline void _copy_leaf(int src, int dst) {
    leafs[dst] = leafs[src];
}

static inline void _set_leaf(int i, const LeafNode leaf) {
    leafs[i] = leaf;
}

// 在now的pfx处增加一个新叶子（保证之前不存在），必要时整体移动叶子
static inline LeafNode* _insert_leaf(const int dep, TrieNode *now, const uint32_t pfx) {
    // printf("~INSERT LEAF: %x %x\n", pfx, entry_id);
    int cnt = POPCNT(now->leaf_vec);
    if (!cnt) { // 如果now没有叶子
        now->leaf_base = leaf_malloc(1);
        leafs[now->leaf_base].leaf_id = 0;
        VEC_SET(now->leaf_vec, pfx);
        return &leafs[now->leaf_base];
    } else {
        const int new_base = leaf_malloc(cnt + 1);
        const int insnp = new_base + POPCNT_LS(now->leaf_vec, pfx);
        int op = now->leaf_base, np = new_base;
        for (; np < insnp; ++np, ++op) {
            _copy_leaf(op, np);
        }
        for (++np; np <= new_base + cnt; ++np, ++op) {
            _copy_leaf(op, np);
        }
        leaf_free(now->leaf_base, cnt);
        now->leaf_base = new_base;
        VEC_SET(now->leaf_vec, pfx);
        return &leafs[insnp];
    }
}

static inline void _set_node_from_lin_leaf(TrieNode* p, const int op) {
    p->tag = 0;
    p->vec = 0;
    p->leaf_vec = 2;
    p->leaf_base = leaf_malloc(1);
    _copy_leaf(op, p->leaf_base);
}

LeafNode* get_leaf_to_insert_entry(const in6_addr addr, const int len) {
    TrieNode *now = &nodes(0)[node_root];
    int dep = 0;
    for (; dep + STRIDE <= len; dep += STRIDE) {
        const uint32_t idx = INDEX(addr, dep);
        const int child_stage = STAGE(dep + STRIDE);
        const bool have = VEC_BT(now->vec, idx);
        if (!now->vec) {
            VEC_SET(now->vec, idx);
            if (dep + STRIDE == len) {
                now->tag = 0xff;
                now->child_base = leaf_malloc(1);
                leafs[now->child_base].leaf_id = 0;
                return &leafs[now->child_base];
            } else {
                now->child_base = node_malloc(child_stage, 1);
                now = &nodes(child_stage)[now->child_base];
                now->vec = now->leaf_vec = now->tag = 0;
            }
        } else if (now->tag) { // 我是LIN
            if (dep + STRIDE == len) { // 可直接插或改
                if (!have) {
                    const int cnt = POPCNT(now->vec);
                    const int new_base = leaf_malloc(cnt + 1);
                    const int insnp = new_base + POPCNT_LS(now->vec, idx);
                    int op = now->child_base, np = new_base;
                    for (; np < insnp; ++np, ++op)
                        _copy_leaf(op, np);
                    for (++np; np <= new_base + cnt; ++np, ++op)
                        _copy_leaf(op, np);
                    leaf_free(now->child_base, cnt);
                    now->child_base = new_base;
                    VEC_SET(now->vec, idx);
                    leafs[insnp].leaf_id = 0;
                    return &leafs[insnp];
                } else {
                    return &leafs[now->child_base + POPCNT_LS(now->vec, idx) - 1];
                }
            } else { // 需要取消
                const int cnt = POPCNT(now->vec);
                const int new_base = node_malloc(child_stage, cnt + !have);
                const int insnp = new_base + POPCNT_LS(now->vec, idx) - have;
                int op = now->child_base, np = new_base;
                leaf_free(now->child_base, cnt);  // 需要把大块的叶节点拆成一个一个的
                now->child_base = new_base;
                now->tag = 0;
                if (have) {
                    for (; np < new_base + cnt; ++np, ++op)
                        _set_node_from_lin_leaf(&nodes(child_stage)[np], op);
                    now = &nodes(child_stage)[insnp];
                } else {
                    for (; np < insnp; ++np, ++op)
                        _set_node_from_lin_leaf(&nodes(child_stage)[np], op);
                    for (++np; np <= new_base + cnt; ++np, ++op)
                        _set_node_from_lin_leaf(&nodes(child_stage)[np], op);
                    VEC_SET(now->vec, idx);
                    now = &nodes(child_stage)[insnp];    
                    now->vec = now->leaf_vec = now->tag = 0;
                }
            }
        } else {
            if (have) {
                now = &nodes(child_stage)[now->child_base + POPCNT_LS(now->vec, idx) - 1];
            } else {
                const int cnt = POPCNT(now->vec);
                const int new_base = node_malloc(child_stage, cnt + 1);
                const int insnp = new_base + POPCNT_LS(now->vec, idx);
                int op = now->child_base, np = new_base;
                for (; np < insnp; ++np, ++op) {
                    nodes(child_stage)[np] = nodes(child_stage)[op];
                }
                for (++np; np <= new_base + cnt; ++np, ++op) {
                    nodes(child_stage)[np] = nodes(child_stage)[op];
                }
                node_free(child_stage, now->child_base, cnt);
                VEC_SET(now->vec, idx);
                now->child_base = new_base;
                now = &nodes(child_stage)[insnp];
                now->vec = now->leaf_vec = now->tag = 0;
            }
        }
    }
    const int l = len - dep;
    const uint32_t idx = INDEX(addr, dep);
    const uint32_t pfx = (idx >> (4-l)) | (1 << l);
    if (VEC_BT(now->leaf_vec, pfx)) { // change
        return &leafs[now->leaf_base + POPCNT_LS(now->leaf_vec, pfx) - 1];
    } else { // add
        return _insert_leaf(dep, now, pfx);
    }
}

// 为了方便，即使是没有叶子的点也会保留在树里
// 返回被删除的叶子的leaf_id或0如果没删除
uint32_t try_remove_entry(const in6_addr addr, const int len, bool judge_nexthop, const in6_addr nexthop, const uint8_t port) {
    TrieNode *now = &nodes(0)[node_root];
    int dep = 0;
    for (; dep + STRIDE <= len; dep += STRIDE) {
        uint32_t idx = INDEX(addr, dep);
        if (!VEC_BT(now->vec, idx))  return 0;
        if (now->tag) { // 要删的是在LIN优化里的
            if (dep + STRIDE == len) {
                int p = POPCNT_LS(now->vec, idx);
                const LeafNode *leaf = &leafs[now->child_base + p - 1];
                if (judge_nexthop) {
                    NextHopEntry *entry = &next_hops[leaf->_nexthop_id];
                    if (entry->route_type < 2 || !in6_addr_equal(entry->ip, nexthop) || entry->port != port)
                        return 0;
                }
                const uint32_t lid = leaf->_leaf_id;
                // remove LIN
                if (p <= 1) {
                    VEC_CLEAR(now->vec, idx);
                    if (!now->vec) {
                        now->tag = 0;  // LIN子节点都删没了 tag也要清掉
                        leaf_free(now->child_base, 1);
                    }
                    ++(now->child_base);
                } else {
                    p = now->child_base + p - 1;  // 要删掉的LIN子节点
                    const int p_until = now->child_base + POPCNT(now->vec) - 1;
                    for (; p < p_until; ++p) {
                        _copy_leaf(p+1, p);
                    }
                    VEC_CLEAR(now->vec, idx);
                }
                return lid;
            }
        } else {
            now = &nodes(STAGE(dep + STRIDE))[now->child_base + POPCNT_LS(now->vec, idx) - 1];
        }
    }
    uint32_t idx = INDEX(addr, dep);
    int l = len - dep;
    uint32_t pfx = (idx >> (4-l)) | (1 << l);
    if (!VEC_BT(now->leaf_vec, pfx)) return 0;
    // 移除now的pfx位置的叶子然后把后面的往前挪
    int p = POPCNT_LS(now->leaf_vec, pfx);
    const LeafNode *leaf = &leafs[now->leaf_base + p - 1];
    if (judge_nexthop) {
        NextHopEntry *entry = &next_hops[leaf->_nexthop_id];
        if (entry->route_type < 2 || !in6_addr_equal(entry->ip, nexthop) || entry->port != port)
            return 0;
    }
    const uint32_t lid = leaf->_leaf_id;    
    if (p <= 1) {
        VEC_CLEAR(now->leaf_vec, pfx);
        if (!now->leaf_vec)
            leaf_free(now->leaf_base, 1);
        ++(now->leaf_base);
    } else {
        p = now->leaf_base + p - 1;  // 要删掉的叶子
        const int p_until = now->leaf_base + POPCNT(now->leaf_vec) - 1;
        for (; p < p_until; ++p) {
            _copy_leaf(p+1, p);
        }
        VEC_CLEAR(now->leaf_vec, pfx);
    }
    return lid;
}

#ifndef LOOKUP_ONLY
Timer *timeout_timer;

void timeout_timeout(Timer *t, int i) {
    assert_id(leafs_info[i].valid, 0x11);
    if (next_hops[leafs_info[i].nexthop_id].route_type == 0 || next_hops[leafs_info[i].nexthop_id].route_type == 1) {
        timer_start(t, i);
        return;
    }
    leafs_info[i].valid = false;
    push_unused_leafid(i);
    remove_entry(0, node_root, leafs_info[i].ip, leafs_info[i].len);
}

uint32_t leafid_iterator(bool restart) {
    return timer_iterate_id(timeout_timer, restart);
}
#endif

void update(bool insert, const RoutingTableEntry entry) {
#ifdef TIME_DEBUG
    checker.receive_update_temp = now_time;
#endif
    if (insert) {
        LeafNode *leaf = get_leaf_to_insert_entry(entry.addr, entry.len);
        *leaf = _new_leaf_node(entry);
        LeafInfo *info = &leafs_info[leaf->_leaf_id];
        info->valid = true;
        info->metric = entry.metric;
        info->nexthop_id = leaf->_nexthop_id;
        info->len = entry.len;
        info->ip = entry.addr;
#ifndef LOOKUP_ONLY
        timer_start(timeout_timer, leaf->_leaf_id);
#endif
    } else {
        // assert_id(entry.route_type != 0, 1);
        uint32_t lid = try_remove_entry(entry.addr, entry.len, false, (in6_addr){0}, 0);
        if (lid) {
            leafs_info[lid].valid = false;
            push_unused_leafid(lid);
#ifndef LOOKUP_ONLY
            timer_stop(timeout_timer, lid);
#endif
        }
    }
#ifdef TIME_DEBUG
    checker.receive_update_time += now_time - checker.receive_update_temp;
#endif
}

void update_leaf_info(LeafNode *leaf, uint8_t metric, uint8_t port, const in6_addr nexthop, uint8_t route_type) {
    assert_id(metric < 16 && metric > 0, 3);
    uint32_t lid = leaf->_leaf_id;
    if (metric != 0xff)
        leafs_info[lid].metric = metric;
    if (port != 0xff) {
        nexthop_id_t nexthopid = _new_entry(port, nexthop, route_type);
        leafs_info[lid].nexthop_id = nexthopid;
        leaf->_nexthop_id = nexthopid;
    }
#ifndef LOOKUP_ONLY
    timer_stop(timeout_timer, lid);
    timer_start(timeout_timer, lid);
#endif
}

LeafNode* prefix_query(const in6_addr addr, uint8_t len, in6_addr *nexthop, uint32_t *if_index, uint32_t *route_type) {
#ifdef TIME_DEBUG
    checker.receive_table_temp = now_time;
#endif 
    LeafNode *leaf = NULL;
    TrieNode *now = &nodes(0)[node_root];
    for (int dep = 0; dep <= len; dep += STRIDE) {
        uint32_t idx = INDEX(addr, dep);
        // 在当前层匹配一个最长的前缀
        int l = dep + STRIDE - 1;
        for (uint32_t pfx = (idx>>1)|(1<<(STRIDE-1)); pfx; pfx >>= 1, --l) {
            if (VEC_BT(now->leaf_vec, pfx)) {
                if (len == 255 || len == l) {
                    leaf = &leafs[now->leaf_base + POPCNT_LS(now->leaf_vec, pfx) - 1];
                    break;
                }
            }
        }
        // 跳下一层
        if (VEC_BT(now->vec, idx)) {
            if (now->tag) {
                if (len == 255 || len == dep + STRIDE) {
                    leaf = &leafs[now->child_base + POPCNT_LS(now->vec, idx) - 1];
                }
                break;
            } else {
                now = &nodes(STAGE(dep + STRIDE))[now->child_base + POPCNT_LS(now->vec, idx) - 1];
            }
        } else {
            break;
        }
    }
#ifdef TIME_DEBUG
    checker.receive_table_time += now_time - checker.receive_table_temp;
#endif 
    if (leaf == NULL)  return NULL;
    if (nexthop != NULL)
        *nexthop = next_hops[leaf->_nexthop_id].ip;
    if (if_index != NULL)
        *if_index = next_hops[leaf->_nexthop_id].port;
    if (route_type != NULL)
        *route_type = next_hops[leaf->_nexthop_id].route_type;
    return leaf;
}

void _append_answer(RoutingTableEntry *t, in6_addr *ip, int len, const LeafNode leaf) {
    t->addr = *ip;
    t->len = len;
    t->nexthop = next_hops[leaf._nexthop_id].ip;
    t->if_index = next_hops[leaf._nexthop_id].port;
    t->route_type = next_hops[leaf._nexthop_id].route_type;
    t->metric = leafs_info[leaf._leaf_id].metric;
}

// 按照前缀长度从长到短的顺序返回所有匹配的路由
void _prefix_query_all(int dep, int nid, const in6_addr addr, RoutingTableEntry *checking_entry, int *count, bool checking_all, in6_addr ip) {
    if (dep > 128) return;
    if (dep == 0 && nid == 0)  nid = node_root;
    TrieNode *now = &NOW;
    // 在当前层匹配所有的前缀
    if (checking_all) {
        for (int pfx = 1; pfx < (1<<(STRIDE)); ++pfx) {
            if (!VEC_BT(now->leaf_vec, pfx)) continue;
            for (int l = 3; l >= 0; --l) {
                if (pfx & (1<<l)) {
                    LeafNode leaf = leafs[now->leaf_base + POPCNT_LS(now->leaf_vec, pfx) - 1];
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
                if (now->tag) {
                    _append_answer(checking_entry + (*count)++, &ip, dep + STRIDE, leafs[now->child_base + POPCNT_LS(now->vec, idx) - 1]);
                } else {
                    _prefix_query_all(dep + STRIDE, now->child_base + POPCNT_LS(now->vec, idx) - 1, addr, checking_entry, count, checking_all, ip);
                }
            }
        }
    } else {
        uint32_t idx = INDEX(addr, dep);
        uint32_t x = (idx>>1)|(1<<(STRIDE-1));
        for (int i = 0; i < STRIDE; ++i) {
            uint32_t pfx = x >> i;
            uint32_t idxi = idx >> (i+1);
            if (VEC_BT(now->leaf_vec, pfx)) {
                LeafNode leaf = leafs[now->leaf_base + POPCNT_LS(now->leaf_vec, pfx) - 1];
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
            if (now->tag) {
                _append_answer(checking_entry + (*count)++, &ip, dep + STRIDE, leafs[now->child_base + POPCNT_LS(now->vec, idx) - 1]);
            } else {
                _prefix_query_all(dep + STRIDE, now->child_base + POPCNT_LS(now->vec, idx) - 1, addr, checking_entry, count, checking_all, ip);
            }
        }
    }

}

void test() {
    nodes(0)[2] = nodes(0)[1];
    printf("1 %d %d\n", nodes(0)[2].child_base, nodes(0)[2].tag);
    VEC_SET(nodes(0)[2].tag, 7);
    VEC_SET(nodes(0)[2].child_base, 5);
    printf("2 %d %d\n", nodes(0)[2].child_base, nodes(0)[2].tag);
    VEC_CLEAR(nodes(0)[2].tag, 7);
    nodes(0)[2].child_base = node_malloc(0,1);
    printf("3 %d %d\n", nodes(0)[2].child_base, nodes(0)[2].tag);
    nodes(0)[2].tag = 0;
    nodes(0)[2].child_base = 0;
}

void lookup_init() {
    assert(sizeof(TrieNode) == 16);
    memhelper_init();
    node_root = 0;
    for (int i = 1; i < LEAF_INFO_COUNT; ++i)
        push_unused_leafid(i);
#ifndef LOOKUP_ONLY
    timeout_timer = timer_init(ENTRY_TIMEOUT, LEAF_INFO_COUNT);
    timer_set_timeout(timeout_timer, timeout_timeout);
#endif
}