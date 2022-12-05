#include "memhelper.h"

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

int node_tops[STAGE_COUNT] = {1, 1, 1, 1, 1, 1, 1, 1};
bool node_used[STAGE_COUNT][NODE_COUNT_PER_STAGE] = {1};
int leaf_top = 1;
bool leaf_used[LEAF_COUNT];

int node_malloc(int stage, int len) {
    // printf("NODE MALLOC %d %d: %d\n", stage, len, node_tops[stage]);
    node_tops[stage] += len;
    // assert(node_tops[stage] <= NODE_COUNT_PER_STAGE);
    for (int i=node_tops[stage]-len; i<node_tops[stage]; ++i) {
        node_used[stage][i] = true;
    }

    return node_tops[stage] - len;
}

void node_free(int stage, int begin, int len) {
    // printf("NODE FREE %d %d %d\n", stage, begin, len);
    for (int i=begin; i<begin+len; ++i) {
        node_used[stage][i] = false;
    }
}

bool is_node_used(int stage, int id) {
    return node_used[stage][id];
}

int leaf_malloc(int len) {
    leaf_top += len;
    // assert(leaf_top <= LEAF_COUNT);
    for (int i=leaf_top-len; i<leaf_top; ++i) {
        leaf_used[i] = true;
    }
    return leaf_top - len;
}

void leaf_free(int begin, int len) {
    for (int i=begin; i<begin+len; ++i) {
        leaf_used[i] = false;
    }
}

bool is_leaf_used(int id) {
    return leaf_used[id];
}