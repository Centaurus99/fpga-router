#include "memhelper.h"
#include <assert.h>
#include <stdio.h>

#ifdef TRIVIAL_MALLOC
int node_tops[STAGE_COUNT] = {1, 1, 1, 1, 1, 1, 1, 1};
bool node_used[STAGE_COUNT][NODE_COUNT_PER_STAGE] = {{1}};
int leaf_top = 1;
bool leaf_used[LEAF_COUNT];


int node_malloc(int stage, int len) {
    node_tops[stage] += len;
    assert(node_tops[stage] <= NODE_COUNT_PER_STAGE);
    for (int i=node_tops[stage]-len; i<node_tops[stage]; ++i) {
        node_used[stage][i] = true;
    }
#ifdef TRACE
    printf("N %d %d +\n", stage, len);
#endif

    return node_tops[stage] - len;
}

void node_free(int stage, int begin, int len) {
    for (int i=begin; i<begin+len; ++i) {
        node_used[stage][i] = false;
    }
#ifdef TRACE
    printf("N %d %d -\n", stage, len);
#endif
}

bool is_node_used(int stage, int id) {
    return node_used[stage][id];
}

int leaf_malloc(int len) {
    leaf_top += len;
    assert(leaf_top <= LEAF_COUNT);
    for (int i=leaf_top-len; i<leaf_top; ++i) {
        leaf_used[i] = true;
    }
#ifdef TRACE
    printf("L %d +\n", len);
#endif
    return leaf_top - len;
}

void leaf_free(int begin, int len) {
    for (int i=begin; i<begin+len; ++i) {
        leaf_used[i] = false;
    }
#ifdef TRACE
    printf("L %d -\n", len);
#endif
}

bool is_leaf_used(int id) {
    return leaf_used[id];
}

void memhelper_init() {

}

#else
// ---generated by trace.py START---
// 40000 insertions, 10 times, 1.0x size
int node_blk_cnt[8][17] = {
	{1020 ,12   ,7    ,6    ,6    ,6    ,6    ,6    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,24   },
	{17406,2945 ,912  ,215  ,176  ,157  ,144  ,141  ,133  ,116  ,107  ,87   ,82   ,63   ,44   ,30   ,103  },
	{38912,15453,2745 ,1196 ,627  ,366  ,261  ,179  ,144  ,105  ,76   ,59   ,56   ,44   ,44   ,46   ,73   },
	{1016 ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,26   },
	{1016 ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,26   },
	{1016 ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,26   },
	{1016 ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,26   },
	{1016 ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,26   }};
int leaf_blk_cnt[17] = 
	{42994,17747,3898 ,1787 ,1080 ,602  ,306  ,139  ,61   ,25   ,17   ,12   ,11   ,10   ,10   ,10   ,24   };
#ifndef ON_BOARD
TrieNode node_pool[65536];
extern TrieNode *_nodes[8];
#endif
int blk_pool[53286];
// ---generated by trace.py END---

int *free_blk[9][17];
int free_blk_top[9][17], blk_begin[9][17];

void _blk_push(int stage, int len, int id) {
    // printf("PUSH %d %d %d\n", stage, len, id);
    assert(free_blk_top[stage][len] < (stage < 8 ? node_blk_cnt[stage][len]: leaf_blk_cnt[len]));
    free_blk[stage][len][free_blk_top[stage][len]++] = id;
}
int _blk_pop(int stage, int len) {
    if (free_blk_top[stage][len] <= 0)
        return -1;
    // printf("POP %d %d\n", stage, len);
    return free_blk[stage][len][--free_blk_top[stage][len]];
}

void memhelper_init() {
    int cnt = 0;
    int begin = 0;
#ifndef ON_BOARD
    int nodes_begin = 0;
#endif
    for (int i = 0; i < 8; ++i) {
#ifndef ON_BOARD
        _nodes[i] = &node_pool[nodes_begin];
        nodes_begin += node_blk_cnt[i][0];
#endif
        begin = 0;
        for (int j = 1; j < 17; ++j) {
            free_blk[i][j] = &blk_pool[cnt];
            for (int k = 0; k < node_blk_cnt[i][j]; ++k) {
                _blk_push(i, j, k);
            }
            cnt += node_blk_cnt[i][j];

            blk_begin[i][j] = begin;
            begin += node_blk_cnt[i][j] * j;
        }
    }
    begin = 0;
    for (int j = 1; j < 17; ++j) {
        free_blk[8][j] = &blk_pool[cnt];
        cnt += leaf_blk_cnt[j];
        for (int k = 0; k < leaf_blk_cnt[j]; ++k) {
            _blk_push(8, j, k);
        }

        blk_begin[8][j] = begin;
        begin += leaf_blk_cnt[j] * j;
    }
}

int node_malloc(int stage, int len) {
    int id = _blk_pop(stage, len);
    while (id == -1) { // 挤到更大的块里
        assert(len < 16);
        id = _blk_pop(stage, ++len); // TODO: 记录一下，如果这种小占大的把大的给占满了 应该把小的再挪回去
    }
    assert(blk_begin[stage][len] + id*len + len <= node_blk_cnt[stage][0]);
#ifdef TRACE
    printf("N %d %d +\n", stage, len);
#endif
    return blk_begin[stage][len] + id*len;
}

void node_free(int stage, int begin, int len) {
    // printf("NF %d %d %d %d\n",stage,begin,len);
    while (len < 16 && begin >= blk_begin[stage][len+1]) ++len; // 找到真正的块大小
    int id = (begin - blk_begin[stage][len]) / len;
    assert(id < node_blk_cnt[stage][len]);
#ifdef TRACE
    printf("N %d %d -\n", stage, len);
#endif
    _blk_push(stage, len, id);
}

// bool is_node_used(int stage, int id) {return 0;} // HACK: 应该是不需要实现了

int leaf_malloc(int len) {
    int id = _blk_pop(8, len);
    while (id == -1) { // 挤到更大的块里
        assert(len < 16);
        id = _blk_pop(8, ++len); // TODO: 记录一下，如果这种小占大的把大的给占满了 应该把小的再挪回去
    }
    assert(blk_begin[8][len] + id*len + len < 65535);
#ifdef TRACE
    printf("L %d +\n", len);
#endif
    return blk_begin[8][len] + id*len;
}

void leaf_free(int begin, int len) {
    while (len < 16 && begin >= blk_begin[8][len+1]) ++len;
    // printf("%d %d\n",begin ,len);
    int id = (begin - blk_begin[8][len]) / len;
    assert(id < leaf_blk_cnt[len]);
#ifdef TRACE
    printf("L %d -\n", len);
#endif
    _blk_push(8, len, id);
}

// bool is_leaf_used(int id) {return 0;} // HACK: 应该是不需要实现了

#endif