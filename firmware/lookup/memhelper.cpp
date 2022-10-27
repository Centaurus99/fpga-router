#include "memhelper.h"

int node_tops[8] = {1, 0, 0, 0, 0, 0, 0, 0};
int leaf_top = 1;

int node_malloc(int stage, int len) {
    node_tops[stage] += len;
    return stage * 1024 + node_tops[stage] - len;
}

void node_free(int stage, int begin, int len) {
 
}

int leaf_malloc(int len) {
    leaf_top += len;
    return leaf_top - len;
}

void leaf_free(int begin, int len) {

}