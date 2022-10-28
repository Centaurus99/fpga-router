#include "memhelper.h"
#include <assert.h>

int node_tops[STAGE_COUNT] = {1, 0, 0, 0, 0, 0, 0, 0};
int leaf_top = 1;

int node_malloc(int stage, int len) {
    node_tops[stage] += len;
    assert(node_tops[stage] <= NODE_COUNT_PER_STAGE);
    return stage * 1024 + node_tops[stage] - len;
}

void node_free(int stage, int begin, int len) {
 
}

int leaf_malloc(int len) {
    leaf_top += len;
    assert(leaf_top <= LEAF_COUNT);
    return leaf_top - len;
}

void leaf_free(int begin, int len) {

}