#ifndef __MEMHELPER_H__
#define __MEMHELPER_H__

#include "lookup.h"

u32 node_malloc(u32 l);

void node_free(u32 s, u32 l);

u32 leaf_malloc(u32 l);

void leaf_free(u32 s, u32 l);

// TrieNode * _new();

#endif