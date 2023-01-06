#include <ripng.h>

void check_ripng_entry(RipngEntry* entry) {
    if(entry->metric == 0xff) {
        // 这个是一个nexthop
    } else {
        // if(entry->metric)
    }
}

void _ripng() {
    // 此处处理RIPNG协议
    
}