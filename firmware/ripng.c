#include <ripng.h>
#include <dma.h>

void receive_ripngentry(RipngEntry* entry) {
    if(entry->metric == 0xff) {
        // 这个是一个nexthop
        
    } else {
    
    }
}

void _ripng(uint8_t *packet, uint32_t length) {
    // 此处处理RIPNG协议
    
}

void send_ripngentries() {
    
}