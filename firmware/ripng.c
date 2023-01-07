#include <ripng.h>
#include <header.h>
#include <dma.h>

const RipngEntry request_for_all = {
    .addr = 0, .route_tag = 0x0000, .prefix_len = 0x00,  .metric = 0x0f
};

void _ripng(uint8_t *packet, uint32_t length) {
    // 此处处理 RIPNG 协议
    RipngHead *riphead = RipngHead_PTR(packet);
    uint32_t ripng_num = RipngEntryNum(length);
    if(ripng_num * sizeof(RipngEntry) + sizeof(RipngHead) + sizeof(UDPHeader) + sizeof(IP6Header) + sizeof(EtherHeader) == length) { 
        RipngEntry *ripentry = RipngEntries_PTR(packet);
        if(riphead->command == RIPNG_REQUEST) {
            uint32_t ripng_num = RipngEntryNum(length);
            for(uint32_t i = 0; i < ripng_num; i++) {
                if(in6_addr_equal(ripentry[i].addr, request_for_all.addr) && ripentry[i].metric == request_for_all.metric && ripentry[i].prefix_len == request_for_all.prefix_len) {
                    // TODO: send all of your route tables
                }
            }
        } else if(riphead->command == RIPNG_RESPONSE) {
            
        }
    } else {
        // 不合法的 ripng 包
    }
}

void receive_ripngentry(RipngEntry* entry) {
    if(entry->metric == 0xff) {
        // 这个是一个nexthop
        
    } else {
    
    }
}

void send_ripngentries() {
    
}