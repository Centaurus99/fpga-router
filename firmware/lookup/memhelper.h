#ifndef __MEMHELPER_H__
#define __MEMHELPER_H__

#include "lookup.h"

int node_malloc(int stage, int len);

void node_free(int stage, int begin, int len);

bool is_node_used(int stage, int id);

int leaf_malloc(int len);

void leaf_free(int begin, int len);

bool is_leaf_used(int id);


#endif