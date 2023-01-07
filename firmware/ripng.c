#include <dma.h>
#include <header.h>
#include <lookup.h>
#include <ripng.h>
#include <router.h>
#include <checksum.h>
#include <stddef.h>

const RipngEntry request_for_all = {
    .addr.__in6_u.__u6_addr16 = {0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000}, .route_tag = 0x0000, .prefix_len = 0x00, .metric = 0x0f};

void receive_ripng(uint8_t *packet, uint32_t length) {
    // 此处处理 RIPNG 协议
    IP6Header *ipv6_header = IP6_PTR(packet);
    UDPHeader *udp_header = UDP_PTR(packet);
    RipngHead *riphead = RipngHead_PTR(packet);
    RipngEntry *ripentry = RipngEntries_PTR(packet);
    uint32_t ripng_num = RipngEntryNum(length);
    // 校验 ripng 包的格式
    if (ripng_num * sizeof(RipngEntry) + sizeof(RipngHead) + sizeof(UDPHeader) + sizeof(IP6Header) + sizeof(EtherHeader) == length && riphead->version == 0x01 && riphead->zero == 0x0000) {
        // 校验命令 command 是否正确
        if (riphead->command == RIPNG_REQUEST) {
            uint32_t ripng_num = RipngEntryNum(length);
            while (!dma_lock_request()) {
                continue;
            }
            while (!dma_send_allow()) {
                continue;
            }
            uint8_t port = dma_get_receive_port();
            LeafInfo *leafinfo = NULL;
            for (uint32_t i = 0; i < ripng_num; i++) {
                if (in6_addr_equal(ripentry[i].addr, request_for_all.addr) && ripentry[i].metric == request_for_all.metric && ripentry[i].prefix_len == request_for_all.prefix_len) {
                    // TODO: send all of your route tables
                    send_all_ripngentries(packet, port, ipv6_header->ip6_src, udp_header->src);
                    return;
                } else {
                    // 查路由表并修改 RIPNG 的 metric
                    if (prefix_query(ripentry[i].addr, ripentry[i].prefix_len, NULL, NULL, NULL, leafinfo) == -1) {
                        ripentry[i].metric = METRIC_INF;
                    } else {
                        ripentry[i].metric = leafinfo->metric;
                    }
                }
            }
            riphead->command = RIPNG_RESPONSE;
            dma_set_out_port(port);
            // 更改ip层的包头
            ipv6_header->ip6_dst = ipv6_header->ip6_src;
            ipv6_header->ip6_src = GUA_IP(port);
            ipv6_header->hop_limit = 0xff;
            // 更改udp层的包头
            udp_header->dest = udp_header->src;
            udp_header->src = RIPNGPORT;
            dma_send_finish();
            dma_lock_release();
        } else if (riphead->command == RIPNG_RESPONSE) {
            IP6Header *ipv6_header = IP6_PTR(packet);
            if (ipv6_header->ip6_dst.s6_addr[0] == 0xff) {
                if (ipv6_header->hop_limit == 0xff && udp_header->src == RIPNGPORT) {
                    // 收到广播的 Response
                    
                } else {
                    // 收到一个不对的
#ifdef _DEBUG
                    printf("Drop Packet: Boardcast Ripng Response with hop limit %x src %x", riphead->command);
#endif
                }
            } else {
                // 收到单播的 Response

            }
        } else {
            // 不合法的 ripng 指令
#ifdef _DEBUG
            printf("Drop Packet: Invalid Ripng command %x", riphead->command);
#endif
        }
    } else {
        // 不合法的 ripng 包
#ifdef _DEBUG
        printf("Drop Packet: Invalid Ripng packet format");
#endif
    }
}

extern LeafInfo *leafs_info;
extern uint32_t leaf_count;

void send_all_ripngentries(uint8_t *packet, uint8_t port, in6_addr dest_ip, uint16_t dest_port) {
    while (!dma_lock_request()) { // 先获得写入锁, 再写入数据
        continue;
    }
    while (!dma_send_allow()) { // 等待发送允许
        continue;
    }
    uint32_t ripngentrynum = 0;
    IP6Header *ipv6_header = IP6_PTR(packet);
    UDPHeader *udp_header = UDP_PTR(packet);
    RipngHead *riphead = RipngHead_PTR(packet);
    RipngEntry *ripentry = RipngEntries_PTR(packet);
    for(uint32_t i = 1; i <= leaf_count; i ++) {
        if(leafs_info[i].valid) {
            ripngentrynum += 1;
            if (ripngentrynum == MAXRipngEntryNum + 1) {
                ipv6_header->ip6_src = GUA_IP(port);
                ipv6_header->ip6_dst = dest_ip;
                udp_header->src = RIPNGPORT;
                udp_header->dest = dest_port;
                udp_header->length = 0;
                riphead->command = RIPNG_RESPONSE;
                riphead->version = 0x01;
                riphead->zero = 0x0000;
                udp_header->checksum = validateAndFillChecksum(packet, 0);
                dma_set_out_port(port);
                dma_send_finish();
                // 重新尝试得到发送允许
                while (!dma_send_allow()) {
                    continue;
                }
                ripngentrynum -= MAXRipngEntryNum;
            }
            ripentry[ripngentrynum - 1].addr = leafs_info[i].ip;
            ripentry[ripngentrynum - 1].route_tag = 0x0000;
            ripentry[ripngentrynum - 1].prefix_len = leafs_info[i].len;
            ripentry[ripngentrynum - 1].metric = leafs_info[i].metric;
        }
    }
    dma_lock_release();
}