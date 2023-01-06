#include <ripng.h>
#include <dma.h>

void check_ripng_entry(RipngEntry* entry) {
    if(entry->metric == 0xff) {
        // 这个是一个nexthop
    } else {
    
    }
}

void _ripng() {
    // 此处处理RIPNG协议
    
}