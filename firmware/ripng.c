#include <checksum.h>
#include <dma.h>
#include <header.h>
#include <inout.h>
#include <lookup.h>
#include <printf.h>
#include <ripng.h>
#include <router.h>
#include <stddef.h>
#include <timer.h>

const RipngEntry request_for_all = {
    .addr.s6_addr16 = {0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000}, .route_tag = 0x0000, .prefix_len = 0x00, .metric = 0x0f};

const in6_addr ripng_multicast = {
    .s6_addr16 = {0x02ff, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0900}};

void receive_ripng(uint8_t *packet, uint32_t length) {
    // 此处处理 RIPNG 协议
    IP6Header *ipv6_header = IP6_PTR(packet);
    UDPHeader *udp_header = UDP_PTR(packet);
    RipngHead *riphead = RipngHead_PTR(packet);
    RipngEntry *ripentry = RipngEntries_PTR(packet);
    uint32_t ripng_num = RipngEntryNum(length);
    uint8_t port = dma_get_receive_port();
    // 校验 ripng 包的格式
    dbgprintf("Receive RIPng, length: %d, should be %d\r\n", length, ripng_num * sizeof(RipngEntry) + sizeof(RipngHead) + sizeof(UDPHeader) + sizeof(IP6Header) + sizeof(EtherHeader));
    if (ripng_num * sizeof(RipngEntry) + sizeof(RipngHead) + sizeof(UDPHeader) + sizeof(IP6Header) + sizeof(EtherHeader) == length 
        && riphead->version == 0x01 && riphead->zero == 0x0000) {
        // 校验命令 command 是否正确
        if (riphead->command == RIPNG_REQUEST) {
            dbgprintf("Recived RIPng Request\r\n");
            dma_lock_request();
            dma_send_request();
            for (uint32_t i = 0; i < ripng_num; i++) {
                if (in6_addr_equal(ripentry[i].addr, request_for_all.addr) && ripentry[i].metric == request_for_all.metric && ripentry[i].prefix_len == request_for_all.prefix_len) {
                    // TODO: send all of your route tables
                    send_all_ripngentries(packet, port, ipv6_header->ip6_src, udp_header->src, 0);
                    dma_lock_release();
                    return;
                } else {
                    // 查路由表并修改 RIPNG 的 metric
                    uint32_t lid = prefix_query(ripentry[i].addr, ripentry[i].prefix_len, NULL, NULL, NULL);
                    if (!lid) {
                        ripentry[i].metric = METRIC_INF;
                    } else {
                        ripentry[i].metric = leafs_info[lid].metric;
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
            udp_header->src = __htons(RIPNGPORT);
            validateAndFillChecksum(packet, length);
            dma_send_finish();
            dma_lock_release();
        } else if (riphead->command == RIPNG_RESPONSE) {
            dbgprintf("Recived RIPng Response\r\n");
            if (check_linklocal_address(ipv6_header->ip6_src) && !check_own_address(ipv6_header->ip6_src)) {
                if (ipv6_header->ip6_dst.s6_addr[0] == 0xff) {
                    if (ipv6_header->hop_limit == 0xff && udp_header->src == __htons(RIPNGPORT)) {
                        // 收到广播的 Response，可用于更改路由表
                        in6_addr nexthop = ipv6_header->ip6_src;
                        for (uint32_t i = 0; i < ripng_num; i++) {
                            if (ripentry[i].metric > METRIC_INF && ripentry[i].metric != 0xff) {
                                printf("Invalid metric: %x", ripentry[i].metric);
                                continue;
                            }
                            if (ripentry[i].prefix_len > 128) {
                                printf("Invalid prefix len: %x", ripentry[i].prefix_len);
                                continue;
                            }
                            if (!check_linklocal_address(ripentry[i].addr) || ripentry[i].addr.s6_addr[0] == 0xff) {
                                char ipbuffer[100];
                                printip(&(ipv6_header->ip6_src), ipbuffer);
                                printf("Invalid IP %s \r\n", ipbuffer);
                                continue;
                            }
                            if(ripentry[i].metric == 0xff) {
                                if(ripentry[i].prefix_len == 0x00 && ripentry[i].route_tag == 0x0000) {
                                    nexthop = ripentry[i].addr;
                                } else {
                                    printf("Invalid nexthop RTE: route tag %x prefix length %x", ripentry[i].route_tag, ripentry[i].metric);
                                }
                                continue;
                             }
                            uint32_t lid = prefix_query(ripentry[i].addr, ripentry[i].prefix_len, NULL, NULL, NULL);
                            LeafInfo *info = &leafs_info[lid];
                            if (lid) {
                                if (next_hops[info->nexthop_id].port == port && in6_addr_equal(ripentry[i].addr, next_hops[info->nexthop_id].ip)) {
                                    // 相同nexthop时，更新metric并重启计时器
                                    if (info->metric + 1 >= METRIC_INF) {
                                        // 删除不可达的路由
                                        RoutingTableEntry entry = {
                                            .addr = ripentry[i].addr, .len = ripentry[i].prefix_len, .if_index = port, .nexthop = nexthop, .route_type = 1};
                                        update(false, entry);
                                    } else {
                                        // 更新metric
                                        update_leaf_info(lid, ripentry[i].metric + 1, 0xff, (in6_addr){0});
                                    }
                                } else {
                                    // 不同nexthop时，比较metric的大小，选取最优的metric
                                    if (ripentry[i].metric + 1 < info->metric && ripentry[i].metric + 1 < METRIC_INF) {
                                        // TODO: 应该能够根据port选取新的nexthop，这里我不太会
                                        update_leaf_info(lid, ripentry[i].metric + 1, port, nexthop); // FIXME port和nexthopip的设置
                                    }                                                                        // else do nothing
                                }
                            } else {
                                RoutingTableEntry entry = {
                                    .addr = ripentry[i].addr, .len = ripentry[i].prefix_len, .if_index = port, .nexthop = nexthop, .route_type = 1};
                                update(true, entry);
                            }
                        }
                    } else {
                        // 收到一个错误的广播 Response
                        printf("Drop Packet: Boardcast Ripng Response with hop limit %x src %x \r\n", riphead->command);
                    }
                } else {
                    // 收到单播的 Response
                    if (ipv6_header->hop_limit == 0xff) {
                        // 可以更新路由表
                        in6_addr nexthop = ipv6_header->ip6_src;
                        for (uint32_t i = 0; i < ripng_num; i++) {
                            if (ripentry[i].metric > METRIC_INF && ripentry[i].metric != 0xff) {
                                printf("Invalid metric: %x", ripentry[i].metric);
                                continue;
                            }
                            if (ripentry[i].prefix_len > 128) {
                                printf("Invalid prefix len: %x", ripentry[i].prefix_len);
                                continue;
                            }
                            if (!check_linklocal_address(ripentry[i].addr) || ripentry[i].addr.s6_addr[0] == 0xff) {
                                char ipbuffer[100];
                                printip(&(ipv6_header->ip6_src), ipbuffer);
                                printf("Invalid IP %s \r\n", ipbuffer);
                                continue;
                            }
                            if(ripentry[i].metric == 0xff) {
                                if(ripentry[i].prefix_len == 0x00 && ripentry[i].route_tag == 0x0000) {
                                    nexthop = ripentry[i].addr;
                                } else {
                                    printf("Invalid nexthop RTE: route tag %x prefix length %x", ripentry[i].route_tag, ripentry[i].metric);
                                }
                                continue;
                             }
                            uint32_t lid = prefix_query(ripentry[i].addr, ripentry[i].prefix_len, NULL, NULL, NULL);
                            LeafInfo *info = &leafs_info[lid];
                            if (lid) {
                                if (next_hops[info->nexthop_id].port == port && in6_addr_equal(ripentry[i].addr, next_hops[info->nexthop_id].ip)) {
                                    // 相同nexthop时，更新metric并重启计时器
                                    if (info->metric + 1 >= METRIC_INF) {
                                        // 删除不可达的路由
                                        RoutingTableEntry entry = {
                                            .addr = ripentry[i].addr, .len = ripentry[i].prefix_len, .if_index = port, .nexthop = nexthop, .route_type = 1};
                                        update(false, entry);
                                    } else {
                                        // 更新metric
                                        update_leaf_info(lid, ripentry[i].metric + 1, 0xff, (in6_addr){0});
                                    }
                                } else {
                                    // 不同nexthop时，比较metric的大小，选取最优的metric
                                    if (ripentry[i].metric + 1 < info->metric && ripentry[i].metric + 1 < METRIC_INF) {
                                        update_leaf_info(lid, ripentry[i].metric + 1, port, nexthop); // FIXME port和nexthopip的设置
                                    }                                                                        // else do nothing
                                }
                            } else {
                                RoutingTableEntry entry = {
                                    .addr = ripentry[i].addr, .len = ripentry[i].prefix_len, .if_index = port, .nexthop = nexthop, .route_type = 1};
                                update(true, entry);
                            }
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

void _send_all_fill_dma(uint8_t *packet, uint8_t port, in6_addr dest_ip, uint16_t dest_port, bool use_gua, uint8_t EntryNum) {
    IP6Header *ipv6_header = IP6_PTR(packet);
    UDPHeader *udp_header = UDP_PTR(packet);
    RipngHead *riphead = RipngHead_PTR(packet);

    ipv6_header->flow = IP6_DEFAULT_FLOW;
    ipv6_header->payload_len = __htons(RipngUDPLength(EntryNum));
    ipv6_header->next_header = IPPROTO_UDP;
    ipv6_header->hop_limit = 0xff;
    ipv6_header->ip6_src = use_gua ? GUA_IP(port) : LOCAL_IP(port);
    ipv6_header->ip6_dst = dest_ip;

    udp_header->src = __htons(RIPNGPORT);
    udp_header->dest = dest_port;
    udp_header->length = __htons(RipngUDPLength(EntryNum));

    riphead->command = RIPNG_RESPONSE;
    riphead->version = 0x01;
    riphead->zero = 0x0000;

    DMA_LEN = RipngETHLength(EntryNum);
    validateAndFillChecksum((uint8_t *)ipv6_header, RipngIP6Length(EntryNum));
}

void send_all_ripngentries(uint8_t *packet, uint8_t port, in6_addr dest_ip, uint16_t dest_port, bool use_gua) {
    // 本函数中默认已经获得lock_request并不释放
    dma_send_request();
    uint32_t ripngentrynum = 0;
    RipngEntry *ripentry = RipngEntries_PTR(packet);
    for (uint32_t i = 1; i <= leaf_count; i++) {
        if (leafs_info[i].valid) {
            ripentry[ripngentrynum].addr = leafs_info[i].ip;
            ripentry[ripngentrynum].route_tag = 0x0000;
            ripentry[ripngentrynum].prefix_len = leafs_info[i].len;
            ripentry[ripngentrynum].metric = next_hops[leafs_info[i].nexthop_id].port == port ? METRIC_INF : leafs_info[i].metric;
            ripngentrynum += 1;

            if (ripngentrynum == MAXRipngEntryNum) {
                _send_all_fill_dma(packet, port, dest_ip, dest_port, use_gua, ripngentrynum);
                dma_set_out_port(port);
                dma_send_finish();
                // 重新尝试得到发送允许
                dma_send_request();
                ripngentrynum -= MAXRipngEntryNum;
            }
        }
    }
    if (ripngentrynum > 0) {
        _send_all_fill_dma(packet, port, dest_ip, dest_port, use_gua, ripngentrynum);
        dma_set_out_port(port);
    }
    dma_send_finish();
}

void debug_ripng() {
    // TODO: 用于回复远程诊断
}

void ripng_timeout(Timer *t, int i) {
    mainloop(false);
    for (uint8_t i = 0; i < 4; i++) {
        send_all_ripngentries((uint8_t *)DMA_PTR, i, ripng_multicast, __htons(RIPNGPORT), 0);
    }
    dma_lock_release();
    timer_start(t, i);
}

void ripng_init() {
    // FF02::9
    mainloop(false);
    IP6Header *ipv6_header = IP6_PTR(DMA_PTR);
    UDPHeader *udp_header = UDP_PTR(DMA_PTR);
    RipngHead *riphead = RipngHead_PTR(DMA_PTR);
    RipngEntry *ripentry = RipngEntries_PTR(DMA_PTR);
    for (uint8_t i = 0; i < 4; i++) {
        dma_send_request();
        ipv6_header->flow = IP6_DEFAULT_FLOW;
        ipv6_header->payload_len = __htons(RipngUDPLength(1));
        ipv6_header->next_header = IPPROTO_UDP;
        ipv6_header->hop_limit = 0xff;
        ipv6_header->ip6_src = LOCAL_IP(i);
        ipv6_header->ip6_dst = ripng_multicast;

        udp_header->src = __htons(RIPNGPORT);
        udp_header->dest = __htons(RIPNGPORT);
        udp_header->length = __htons(RipngUDPLength(1));

        riphead->command = RIPNG_REQUEST;
        riphead->version = 0x01;
        riphead->zero = 0x0000;

        *ripentry = request_for_all;

        DMA_LEN = RipngETHLength(1);
        validateAndFillChecksum((uint8_t *)ipv6_header, RipngIP6Length(1));

        dma_set_out_port(i);
        dma_send_finish();
    }
    dma_lock_release();
    Timer *ripng_timer = timer_init(RIPNG_UPDATE_TIME, 2);
    timer_set_timeout(ripng_timer, ripng_timeout);
    timer_start(ripng_timer, 1);
}