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
    printf("N %d %d +\n", stage, len);

    return node_tops[stage] - len;
}

void node_free(int stage, int begin, int len) {
    for (int i=begin; i<begin+len; ++i) {
        node_used[stage][i] = false;
    }
    printf("N %d %d -\n", stage, len);
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
    printf("L %d +\n", len);
    return leaf_top - len;
}

void leaf_free(int begin, int len) {
    for (int i=begin; i<begin+len; ++i) {
        leaf_used[i] = false;
    }
    printf("L %d -\n", len);
}

bool is_leaf_used(int id) {
    return leaf_used[id];
}

void memhelper_init() {

}

#else
int node_blk_cnt[8][17] = {
	{1015 ,14   ,9    ,7    ,7    ,7    ,7    ,7    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,16   },
	{11258,2014 ,429  ,244  ,208  ,165  ,118  ,91   ,60   ,46   ,30   ,24   ,24   ,25   ,30   ,31   ,106  },
	{20473,8961 ,1422 ,542  ,283  ,158  ,112  ,75   ,69   ,55   ,51   ,38   ,27   ,21   ,21   ,15   ,52   },
	{1024 ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,19   },
	{1024 ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,19   },
	{1024 ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,19   },
	{1024 ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,19   },
	{1024 ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,19   }};
int leaf_blk_cnt[17] = 
	{14323,8860 ,1274 ,283  ,66   ,25   ,15   ,13   ,13   ,12   ,12   ,12   ,12   ,12   ,12   ,12   ,24   };
#ifndef USE_BRAM
TrieNode node_pool[37866];
extern TrieNode *_nodes[8];
#endif
int blk_pool[26871];

int *free_blk[9][17];
int free_blk_top[9][17], blk_begin[9][17];

void _blk_push(int stage, int len, int id) {
    free_blk[stage][len][free_blk_top[stage][len]++] = id;
}
int _blk_pop(int stage, int len) {
    if (free_blk_top[stage][len] <= 0)
        return -1;
    return free_blk[stage][len][--free_blk_top[stage][len]];
}

void memhelper_init() {
    int cnt = 0;
    int begin = 0;
    int nodes_begin = 0;
    for (int i = 0; i < 8; ++i) {
#ifndef USE_BRAM
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
    assert(cnt <= 65536);
}

int node_malloc(int stage, int len) {
    int id = _blk_pop(stage, len);
    assert(id != -1);  // TODO: 挤到更大的块里
    return blk_begin[stage][len] + id*len;
}

void node_free(int stage, int begin, int len) {
    int id = (begin - blk_begin[stage][len]) / len;
    _blk_push(stage, len, id);
}

bool is_node_used(int stage, int id) {return 0;} // HACK: 应该是不需要实现了

int leaf_malloc(int len) {
    int id = _blk_pop(8, len);
    assert(id != -1);  // TODO: 挤到更大的块里
    return blk_begin[8][len] + id*len;
}

void leaf_free(int begin, int len) {
    while (len < 16 && begin >= blk_begin[8][len+1]) ++len;
    int id = (begin - blk_begin[8][len]) / len;
    _blk_push(8, len, id);
}

bool is_leaf_used(int id) {return 0;} // HACK: 应该是不需要实现了

#endif