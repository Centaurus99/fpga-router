#include <ripng.h>
#include <header.h>
#include <dma.h>
#include <lookup.h>
#include <stddef.h>

const RipngEntry request_for_all = {
    .addr = 0, .route_tag = 0x0000, .prefix_len = 0x00,  .metric = 0x0f
};

void _ripng(uint8_t *packet, uint32_t length) {
    // 此处处理 RIPNG 协议
    RipngHead *riphead = RipngHead_PTR(packet);
    uint32_t ripng_num = RipngEntryNum(length);
    if(ripng_num * sizeof(RipngEntry) + sizeof(RipngHead) + sizeof(UDPHeader) + sizeof(IP6Header) + sizeof(EtherHeader) == length && riphead->version == 0x01 && riphead->zero == 0x0000) { 
        RipngEntry *ripentry = RipngEntries_PTR(packet);
        if(riphead->command == RIPNG_REQUEST) {
            uint32_t ripng_num = RipngEntryNum(length);
            while (!dma_lock_request()) { // 先获得写入锁, 再写入数据
                continue;
            }
            while (!dma_send_allow()) { // 等待发送允许
                continue;
            }
            LeafInfo *leafinfo = NULL;
            for(uint32_t i = 0; i < ripng_num; i++) {
                if(in6_addr_equal(ripentry[i].addr, request_for_all.addr) && ripentry[i].metric == request_for_all.metric && ripentry[i].prefix_len == request_for_all.prefix_len) {
                    // TODO: send all of your route tables
                    return;
                } else {
                    // 查路由表并修改 RIPNG 的 metric
                    if(prefix_query(ripentry[i].addr, ripentry[i].prefix_len, NULL, NULL, NULL, leafinfo) == -1) {
                        ripentry[i].metric = METRIC_INF;
                    } else {
                        ripentry[i].metric = leafinfo->metric;
                    }
                }
            }
            dma_send_finish();
            dma_lock_release();
        } else if(riphead->command == RIPNG_RESPONSE) {
            
        } else {
            // 不合法的 ripng 包
            // TODO: debug信息
        }
    } else {
        // 不合法的 ripng 包
        // TODO: debug信息
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