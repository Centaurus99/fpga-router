#include <dma.h>
#include <header.h>
#include <lookup.h>
#include <ripng.h>
#include <router.h>
#include <checksum.h>
#include <stddef.h>
#include <printf.h>
#include <inout.h>
#include <timer.h>

const RipngEntry request_for_all = {
    .addr.__in6_u.__u6_addr16 = {0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000}, .route_tag = 0x0000, .prefix_len = 0x00, .metric = 0x0f};

const in6_addr ripng_multicast = {
    .__in6_u.__u6_addr16 = {0x02ff, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0900}
};

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
            LeafInfo leafinfo;
            for (uint32_t i = 0; i < ripng_num; i++) {
                if (in6_addr_equal(ripentry[i].addr, request_for_all.addr) && ripentry[i].metric == request_for_all.metric && ripentry[i].prefix_len == request_for_all.prefix_len) {
                    // TODO: send all of your route tables
                    send_all_ripngentries(packet, port, ipv6_header->ip6_src, udp_header->src);
                    return;
                } else {
                    // 查路由表并修改 RIPNG 的 metric
                    if (!prefix_query(ripentry[i].addr, ripentry[i].prefix_len, NULL, NULL, NULL, &leafinfo)) {
                        ripentry[i].metric = METRIC_INF;
                    } else {
                        ripentry[i].metric = leafinfo.metric;
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
            if(check_linklocal_address(ipv6_header->ip6_src) && ! check_own_address(ipv6_header->ip6_src)) {
                if (ipv6_header->ip6_dst.s6_addr[0] == 0xff) {
                    if (ipv6_header->hop_limit == 0xff && udp_header->src == RIPNGPORT) {
                        // 收到广播的 Response，可用于更改路由表
                        for (uint32_t i = 0; i < ripng_num; i++) {
                            
                        }
                    } else {
                        // 收到一个错误的广播 Response
                        printf("Drop Packet: Boardcast Ripng Response with hop limit %x src %x \r\n", riphead->command);
                    }
                } else {
                    // 收到单播的 Response
                    if (ipv6_header->hop_limit == 0xff) {
                        // 可以更新路由表
                        for (uint32_t i = 0; i < ripng_num; i++) {

                        }
                    } else {
                        // 不可以更新路由表，只能用作诊断
                        debug_ripng();
                    }
                }
            } else {
                // 不合理的地址
                char ipbuffer[100];
                printip(&(ipv6_header->ip6_src), ipbuffer);
                printf("Drop Packet: Invalid Ripng from %s \r\n", ipbuffer);
            }
        } else {
            // 不合法的 ripng 指令
            printf("Drop Packet: Invalid Ripng command %x \r\n", riphead->command);
        }
    } else {
        // 不合法的 ripng 包
        printf("Drop Packet: Invalid Ripng packet format \r\n");
    }
}

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
                udp_header->length = MAXRipngUDPLength;
                riphead->command = RIPNG_RESPONSE;
                riphead->version = 0x01;
                riphead->zero = 0x0000;
                udp_header->checksum = validateAndFillChecksum(packet, 0);
                DMA_LEN = MAXRipngLength;
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
            ripentry[ripngentrynum - 1].metric = next_hops[leafs_info[i].nexthop_id].port == port ? METRIC_INF : leafs_info[i].metric;
        }
    }
    dma_lock_release();
}

void debug_ripng() {
    // TODO: 用于回复远程诊断
}

void ripng_timeout(Timer *t, int i) {
    for (uint8_t i = 0; i < 4; i ++) {
        send_all_ripngentries(DMA_PTR, i, ripng_multicast, RIPNGPORT);
    }
    timer_start(t, i);
}

void ripng_init() {
    // FF02::9
    while (!dma_lock_request()) {
        continue;
    }
    if(dma_read_need()) {
        dma_read_finish();
    }
}