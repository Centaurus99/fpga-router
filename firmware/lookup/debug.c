#include <lookup.h>
#include <memhelper.h>
// #include <printf.h>
#include <stdio.h>
// #include <assert.h>

#ifndef ON_BOARD
extern TrieNode _nodes[STAGE_COUNT][NODE_COUNT_PER_STAGE];
#define nodes(i) _nodes[i]
extern nexthop_id_t leafs[LEAF_COUNT];
#else
#define nodes(i) ((volatile TrieNode *)NODE_ADDRESS(i))
#define leafs ((volatile nexthop_id_t *)LEAF_ADDRESS)
#endif

extern nexthop_id_t entry_count;
extern int node_root;

// void print_ip(in6_addr ip) {
//     for (int i = 0; i < 4; ++ i) {
//         printf("%08x ", ip.s6_addr32[i]);
//     }
// }

void print(uint32_t nid, int dep) {
    // TrieNode now = u8s_to_u32s(NOW);
    if (!dep) printf("PRINTING TREE:\n");
    for (int i = 0;i<dep/STRIDE;++i) printf("  ");
    printf("%x-%x: %x %x %x %x %x\n", STAGE(dep), nid, NOW.vec, NOW.leaf_vec, NOW.child_base, NOW.tag, NOW.leaf_base);
    if (!VEC_BT(NOW.tag, 7))
        for (int i = 0; i < POPCNT(NOW.vec); ++i)
            print(NOW.child_base + i, dep + STRIDE);
    if (!dep) printf("#################################\n");
}

// inline void _write_u8s(FILE *f, uint32_t addr, uint8_t *ptr, int len) {
//     for (int i = 0; i < len; ++i) {
//         if (*(ptr + i) != 0)
//             fprintf(f, "%08X %02X\n", addr+i, *(ptr+i));
//     }
// }

// inline void _write_u32s(FILE *f, uint32_t addr, uint32_t *ptr, int len) {
//     for (int i = 0; i < len; ++i) {
//         if (*(ptr + i) != 0)
//             fprintf(f, "%08X %08X\n", addr+i*4, *(ptr+i));
//     }
// }

// void export_mem() {
//     print(node_root, 0);
//     FILE *f = fopen("mem.txt", "w");
//     // nodes
//     uint32_t addr;
//     for (int s = 0; s < STAGE_COUNT; ++s) {
//         addr = NODE_ADDRESS[s];
//         for (int i = 0; i < NODE_COUNT_PER_STAGE; ++ i) {
//             if (is_node_used(s, i)) {
//                 _write_u32s(f, addr, (uint32_t *)(&nodes[s][i]), 4);
//             }
//             addr += 16;  // 按照16字节对齐，方便总线计算
//         }
//     }

//     // leafs
//     addr = LEAF_ADDRESS;
//     for (int i = 0; i < LEAF_COUNT; ++i) {
//         if (is_leaf_used(i)) {
//             _write_u32s(f, addr, (uint32_t *)&leafs[i], 1);
//         }
//         addr += 4;
//     }

//     // next hops
//     addr = NEXT_HOP_ADDRESS;
//     for (int i = 0; i < entry_count; ++i) {
//         _write_u32s(f, addr, (uint32_t *)(next_hops[i].ip), 4);
//         _write_u32s(f, addr + 16, (uint32_t *)(&next_hops[i].port), 1);
//         _write_u32s(f, addr + 20, (uint32_t *)(&next_hops[i].route_type), 1);
//         addr += 32;  // 按照32字节对齐，方便总线计算
//     }
    
//     fclose(f);
// }