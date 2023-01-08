#include <lookup.h>
#include <memhelper.h>
#include <stdio.h>
#include <assert.h>
#include <timer.h>

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

static inline uint32_t INDEX (in6_addr addr, int s, int n) {
    uint32_t res = 0;
    int shift = 128 - s - n;
    for (int i = 15; i >= 0; -- i) {
        if (shift >= 0 && shift < 8)
            res |= addr.s6_addr[i] >> shift;
        else if (shift < 0 && shift > -8)
            res |= (uint32_t)addr.s6_addr[i] << (-shift);
        shift -= 8;
        if (shift < -32) break;
    }
    res = res & ((1u << n) - 1);
    // print_ip(addr);
    // printf("%d %d %x\n", s, n, (uint32_t)res);
    return res;
}

#ifndef ON_BOARD

    #ifdef TRIVIAL_MALLOC
    TrieNode _nodes[STAGE_COUNT][NODE_COUNT_PER_STAGE];
    #else
    TrieNode *_nodes[STAGE_COUNT];
    #endif

    #define nodes(i) _nodes[i]
    LeafNode leafs[LEAF_COUNT];
    NextHopEntry next_hops[ENTRY_COUNT];
    LeafInfo leafs_info[LEAF_COUNT];

#else
    #define nodes(i) ((TrieNode *)NODE_ADDRESS(i))
    #define leafs ((LeafNode *)LEAF_ADDRESS)
#endif
nexthop_id_t entry_count;
uint32_t leaf_count;
int node_root;

TrieNode stk[33];

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

    // routing_table[entry_count] = entry;
    return entry_count++;
}

LeafNode _new_leaf_node(const RoutingTableEntry entry) {
    LeafNode ret;
    ret.leaf_id = ++leaf_count;
    ret._nexthop_id = _new_entry(entry.if_index, entry.nexthop, entry.route_type);
    return ret;
}

void _copy_leaf(int src, int dst) {
    leafs[dst] = leafs[src];
}

void _set_leaf(int i, const LeafNode leaf) {
    leafs[i] = leaf;
}

// 在now的idx处增加一个新节点（保证之前不存在），必要时整体移动子节点
void _insert_node(int dep, TrieNode *now, uint32_t idx, TrieNode *child) {
    // printf("NODE %d %d\n",dep, idx);
    int child_stage = STAGE(dep + STRIDE);

    // 如果child没有内部子节点且只有一个*的叶子节点，判断是否能做leaf-in-node优化
    if (!child->vec && child->leaf_vec == 2) {
        if (!now->vec) {//printf("LIN!");
            // assert(!VEC_BT(now->tag, 7));
            now->child_base = child->leaf_base;
            VEC_SET(now->tag, 7);
            VEC_SET(now->vec, idx);
            return;
        } else if (VEC_BT(now->tag, 7)) {
            int cnt = POPCNT(now->vec);
            int new_base = leaf_malloc(cnt + 1);
            for (uint32_t i = 0, op = now->child_base, np = new_base; i < (1<<STRIDE); ++i) {
                if (i == idx) {
                    _copy_leaf(child->leaf_base, np);
                    ++np;
                } else if (VEC_BT(now->vec, i)) { // TODO: 改成右移一位效率更高
                    _copy_leaf(op, np);
                    ++np, ++op;
                }
            }
            leaf_free(now->child_base, cnt);
            now->child_base = new_base;
            VEC_SET(now->vec, idx);
            leaf_free(child->leaf_base, 1); // TODO: 这里可以优化
            return;
        }
    }
    // 需要把LIN优化取消并且顺便把要插的插进来
    if (VEC_BT(now->tag, 7)) {
        int cnt = POPCNT(now->vec);
        int new_base = node_malloc(child_stage, cnt + 1);
        for (uint32_t i = 0, op = now->child_base, np = new_base; i < (1<<STRIDE); ++i) {
            if (i == idx) {
                nodes(child_stage)[np] = *child;
                ++np;
            } else if (VEC_BT(now->vec, i)) {
                nodes(child_stage)[np].tag = 0;
                nodes(child_stage)[np].vec = 0;
                nodes(child_stage)[np].leaf_vec = 2;
                nodes(child_stage)[np].leaf_base = leaf_malloc(1);
                _copy_leaf(op, nodes(child_stage)[np].leaf_base);
                ++np, ++op;
            }
        }
        leaf_free(now->child_base, cnt);
        now->child_base = new_base;
        VEC_CLEAR(now->tag, 7);
    } else if (!now->vec) { // 如果now还没有子节点
        now->child_base = node_malloc(child_stage, 1);
        nodes(child_stage)[now->child_base] = *child;
        
    } else {
        int cnt = POPCNT(now->vec);
        int new_base = node_malloc(child_stage, cnt + 1);
        for (uint32_t i = 0, op = now->child_base, np = new_base; i < (1<<STRIDE); ++i) {
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
}

// 在now的pfx处增加一个新叶子（保证之前不存在），必要时整体移动叶子
void _insert_leaf(int dep, TrieNode *now, uint32_t pfx, const LeafNode leaf) {
    // printf("~INSERT LEAF: %x %x\n", pfx, entry_id);
    int cnt = POPCNT(now->leaf_vec);
    if (!cnt) { // 如果now没有叶子
        now->leaf_base = leaf_malloc(1);
        _set_leaf(now->leaf_base, leaf);
    } else {
        int new_base = leaf_malloc(cnt + 1);
        for (uint32_t i = 1, op = now->leaf_base, np = new_base; i < (1<<STRIDE); ++i) {
            if (i == pfx) {
                _set_leaf(np, leaf);
                ++np;
            } else if (VEC_BT(now->leaf_vec, i)) { // TODO: 改成右移一位效率更高
                _copy_leaf(op, np);
                ++np, ++op;
            }
        }
        leaf_free(now->leaf_base, cnt);
        now->leaf_base = new_base;
    }
    VEC_SET(now->leaf_vec, pfx);
}

// 移除now的pfx位置的叶子（保证存在）然后把后面的往前挪
void _remove_leaf(int dep, TrieNode *now, uint32_t pfx) {
    // printf("~REMOVE LEAF: %x, %x\n", now, pfx);
    int p = POPCNT_LS(now->leaf_vec, pfx);
    if (p <= 1) {
        VEC_CLEAR(now->leaf_vec, pfx);
        if (!now->leaf_vec)
            leaf_free(now->leaf_base, 1);
        ++(now->leaf_base);
    } else {
        p = now->leaf_base + p - 1;  // 要删掉的叶子
        for (uint32_t i = pfx + 1; i < (1<<STRIDE); ++i) {
            if (VEC_BT(now->leaf_vec, i)) {
                _copy_leaf(p+1, p);
                ++p;
            }
        }
        // HACK: 删除的时候不再free一个了
        // leaf_free(p, 1); // 把原来的最后一个位置free掉
        VEC_CLEAR(now->leaf_vec, pfx);
    }
    
}

void _remove_lin(int dep, TrieNode *now, uint32_t idx) {
    int p = POPCNT_LS(now->vec, idx);
    if (p <= 1) {
        VEC_CLEAR(now->vec, idx);
        if (!now->vec) {
            VEC_CLEAR(now->tag, 7);  // LIN子节点都删没了 tag也要清掉
            leaf_free(now->child_base, 1);
        }
        ++(now->child_base);
    } else {
        p = now->child_base + p - 1;  // 要删掉的LIN子节点
        for (uint32_t i = idx + 1; i < (1<<STRIDE); ++i) {
            if (VEC_BT(now->vec, i)) {
                _copy_leaf(p+1, p);
                ++p;
            }
        }
        VEC_CLEAR(now->vec, idx);
        // leaf_free(p, 1);
    }
    
}


void insert_entry(int dep, TrieNode *now, in6_addr addr, int len, LeafNode leaf) {
    if (dep + STRIDE > len) {
        int l = len - dep;
        uint32_t pfx = INDEX(addr, dep, l) | (1 << l);
        // printf("INSERT %d %x\n", dep,pfx);
        if (VEC_BT(now->leaf_vec, pfx)) { // change
            _set_leaf(now->leaf_base + POPCNT_LS(now->leaf_vec, pfx) - 1, leaf);
        } else { // add
            _insert_leaf(dep, now, pfx, leaf);
        }
    } else {
        uint32_t idx = INDEX(addr, dep, STRIDE);
        // printf("INSERT %d %x\n", dep,idx);
        // 如果now已经有这个子节点了 就直接改这个子节点
        if (VEC_BT(now->vec, idx)) {
            if (VEC_BT(now->tag, 7) && dep + STRIDE == len) { // 已经有这个LIN子节点，直接改
                _set_leaf(now->child_base + POPCNT_LS(now->vec, idx) - 1, leaf);
                return;
            }
            int child_stage = STAGE(dep + STRIDE);
            // if(child_stage ==3 )printf("~~%d %d\n",dep,idx);
            if (VEC_BT(now->tag, 7) && dep + STRIDE != len) { // 需要把LIN取消掉
                int cnt = POPCNT(now->vec);
                int new_base = node_malloc(child_stage, cnt);
                for (uint32_t i = 0, op = now->child_base, np = new_base; i < (1<<STRIDE); ++i) {
                    if (VEC_BT(now->vec, i)) { // TODO: 改成右移一位效率更高
                        nodes(child_stage)[np].tag = 0;
                        nodes(child_stage)[np].vec = 0;
                        nodes(child_stage)[np].leaf_vec = 2;
                        nodes(child_stage)[np].leaf_base = leaf_malloc(1);
                        _copy_leaf(op, nodes(child_stage)[np].leaf_base);
                        nodes(child_stage)[np].child_base = 0;
                        ++np, ++op;
                    }
                }
                leaf_free(now->child_base, cnt);  // 需要把大块的叶节点拆成一个一个的
                now->child_base = new_base;
                VEC_CLEAR(now->tag, 7);
            }
            TrieNode *child = &nodes(child_stage)[now->child_base + POPCNT_LS(now->vec, idx) - 1];
            insert_entry(dep + STRIDE, child, addr, len, leaf);
        } else {
            TrieNode *child = &stk[dep/STRIDE + 1];
            child->vec = child->leaf_vec = 0;
            child->child_base = 0;
            child->leaf_base = 0;
            child->tag = 0;
            insert_entry(dep + STRIDE, child, addr, len, leaf);
            _insert_node(dep, now, idx, child);
        }
    }
}

// HACK: 为了方便，即使是没有叶子的点也会保留在树里
// 返回被删除的叶子的leaf_id
uint32_t remove_entry(int dep, int nid, in6_addr addr, int len) {
    TrieNode *now = &NOW;
    if (dep + STRIDE > len) {
        int l = len - dep;
        uint32_t pfx = INDEX(addr, dep, l) | (1 << l);
        if (VEC_BT(now->leaf_vec, pfx)) { // remove
            uint32_t lid = leafs[now->leaf_base + POPCNT_LS(now->leaf_vec, pfx) - 1]._leaf_id;
            _remove_leaf(dep, now, pfx);
            return lid;
        }
    } else {
        uint32_t idx = INDEX(addr, dep, STRIDE);
        if (VEC_BT(now->vec, idx)) {
            if (VEC_BT(now->tag, 7)) { // 要删的是在LIN优化里的
                if (dep + STRIDE == len) _remove_lin(dep, now, idx);
            } else {
                return remove_entry(dep + STRIDE, now->child_base + POPCNT_LS(now->vec, idx) - 1, addr, len);
            }
        }
    }
    return -1;
}

Timer *timeout_timer;

void timeout_timeout(Timer *t, int i) {
    if (leafs_info[i].valid) {
        leafs_info[i].valid = false;
        remove_entry(0, node_root, leafs_info[i].ip, leafs_info[i].len);
    }
}

void update(bool insert, const RoutingTableEntry entry) {
    if (insert) {
        LeafNode leaf = _new_leaf_node(entry);
        LeafInfo *info = &leafs_info[leaf._leaf_id];
        info->valid = true;
        info->metric = entry.metric;
        info->nexthop_id = leaf._nexthop_id;
        info->len = entry.len;
        info->ip = entry.addr;
        insert_entry(0, &nodes(0)[node_root], entry.addr, entry.len, leaf);
        if (entry.route_type != 0)
            timer_start(timeout_timer, leaf._leaf_id);
    } else {
        assert_id(entry.route_type != 0, 1);
        uint32_t lid = remove_entry(0, node_root, entry.addr, entry.len);
        if (lid != -1) {
            leafs_info[lid].valid = false;
            timer_stop(timeout_timer, lid);
        }
    }
}

void update_leaf_info(uint32_t leaf_id, uint8_t metric, uint8_t port, const in6_addr nexthop) {
    assert_id(metric < 16 && metric > 0, 3);
    if (metric != 0xff)
        leafs_info[leaf_id].metric = metric;
    if (port != 0xff) {
        nexthop_id_t nexthopid = _new_entry(port, nexthop, 1);
        leafs_info[leaf_id].nexthop_id = nexthopid; // FIXME: nexthop id in tree should be update too!!!
    }
    timer_stop(timeout_timer, leaf_id);
    timer_start(timeout_timer, leaf_id);
}

int prefix_query(const in6_addr addr, uint8_t len, in6_addr *nexthop, uint32_t *if_index, uint32_t *route_type) {
    LeafNode *leaf = NULL;
    TrieNode *now = &nodes(0)[node_root];
    // print(node_root, 0);
    for (int dep = 0; dep < len; dep += STRIDE) {
        uint32_t idx = INDEX(addr, dep, STRIDE);
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
            if (VEC_BT(now->tag, 7)) {
                if (len == 255 || len == dep + STRIDE) {
                    leaf = &leafs[now->child_base + POPCNT_LS(now->vec, idx) - 1];
                    break;
                }
            } else {
                now = &nodes(STAGE(dep + STRIDE))[now->child_base + POPCNT_LS(now->vec, idx) - 1];
            }
        } else {
            break;
        }
    }
    if (leaf == NULL)  return 0;
    if (nexthop != NULL)
        *nexthop = next_hops[leaf->_nexthop_id].ip;
    if (if_index != NULL)
        *if_index = next_hops[leaf->_nexthop_id].port;
    if (route_type != NULL)
        *route_type = next_hops[leaf->_nexthop_id].route_type;
    return leaf->_nexthop_id;
}

void _append_answer(RoutingTableEntry *t, in6_addr *ip, int len, const LeafNode leaf) {
    t->addr = *ip;
    t->len = len;
    t->nexthop = next_hops[leaf._nexthop_id].ip;
    t->if_index = next_hops[leaf._nexthop_id].port;
    t->route_type = next_hops[leaf._nexthop_id].route_type;
}

// 按照前缀长度从长到短的顺序返回所有匹配的路由
void _prefix_query_all(int dep, int nid, const in6_addr addr, RoutingTableEntry *checking_entry, int *count, bool checking_all, in6_addr ip) {
    if (dep > 128) return;
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
                if (VEC_BT(now->tag, 7)) {
                    _append_answer(checking_entry + (*count)++, &ip, dep + STRIDE, leafs[now->child_base + POPCNT_LS(now->vec, idx) - 1]);
                } else {
                    _prefix_query_all(dep + STRIDE, now->child_base + POPCNT_LS(now->vec, idx) - 1, addr, checking_entry, count, checking_all, ip);
                }
            }
        }
    } else {
        uint32_t idx = INDEX(addr, dep, STRIDE);
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
            if (VEC_BT(now->tag, 7)) {
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
    memhelper_init();
    timeout_timer = timer_init(ENTRY_TIMEOUT, LEAF_COUNT);
    timer_set_timeout(timeout_timer, timeout_timeout);
}