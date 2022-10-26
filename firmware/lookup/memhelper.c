#include "memhelper.h"

u32 node_top = 1, leaf_top = 1;

u32 node_malloc(u32 l) {
    node_top += l;
    return node_top - l;
}

void node_free(u32 s, u32 l) {

}

u32 leaf_malloc(u32 l) {
    leaf_top += l;
    return leaf_top - l;
}

void leaf_free(u32 s, u32 l) {

}