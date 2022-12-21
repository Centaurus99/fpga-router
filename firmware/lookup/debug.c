#include "lookup.h"
#include "memhelper.h"
#include <stdio.h>
#include <assert.h>

extern TrieNode nodes[STAGE_COUNT][NODE_COUNT_PER_STAGE];
extern leaf_t leafs[LEAF_COUNT];
extern NextHopEntry next_hops[ENTRY_COUNT];
extern leaf_t entry_count;
extern int node_root;

void print_ip(in6_addr ip) {
    for (int i = 0; i < 4; ++ i) {
        printf("%08x ", ip.s6_addr32[i]);
    }
}

void print(u32 nid, int dep) {
    // TrieNode now = u8s_to_u32s(NOW);
    if (!dep) printf("PRINTING TREE:\n");
    for (int i = 0;i<dep/STRIDE;++i) printf("  ");
    printf("%x-%x: %x %x %x %x\n", STAGE(dep), nid, NOW.vec, NOW.leaf_vec, NOW.child_base, NOW.leaf_base);
    for (int i = 0; i < POPCNT(NOW.vec); ++i)
        print(NOW.child_base + i, dep + STRIDE);
    if (!dep) printf("#################################\n");
}

// inline void _write_u8s(FILE *f, u32 addr, u8 *ptr, int len) {
//     for (int i = 0; i < len; ++i) {
//         if (*(ptr + i) != 0)
//             fprintf(f, "%08X %02X\n", addr+i, *(ptr+i));
//     }
// }

inline void _write_u32s(FILE *f, u32 addr, u32 *ptr, int len) {
    for (int i = 0; i < len; ++i) {
        if (*(ptr + i) != 0)
            fprintf(f, "%08X %08X\n", addr+i*4, *(ptr+i));
    }
}

void export_mem() {
    print(node_root, 0);
    FILE *f = fopen("mem.txt", "w");
    // nodes
    u32 addr;
    for (int s = 0; s < STAGE_COUNT; ++s) {
        addr = NODE_ADDRESS[s];
        for (int i = 0; i < NODE_COUNT_PER_STAGE; ++ i) {
            if (is_node_used(s, i)) {
                _write_u32s(f, addr, (u32 *)(&nodes[s][i]), 4);
            }
            addr += 16;  // 按照16字节对齐，方便总线计算
        }
    }

    // leafs
    addr = LEAF_ADDRESS;
    for (int i = 0; i < LEAF_COUNT; ++i) {
        if (is_leaf_used(i)) {
            _write_u32s(f, addr, (u32 *)&leafs[i], 1);
        }
        addr += 4;
    }

    // next hops
    addr = NEXT_HOP_ADDRESS;
    for (int i = 0; i < entry_count; ++i) {
        _write_u32s(f, addr, (u32 *)(next_hops[i].ip), 4);
        _write_u32s(f, addr + 16, (u32 *)(&next_hops[i].port), 1);
        _write_u32s(f, addr + 20, (u32 *)(&next_hops[i].route_type), 1);
        addr += 32;  // 按照32字节对齐，方便总线计算
    }
    
    fclose(f);
}