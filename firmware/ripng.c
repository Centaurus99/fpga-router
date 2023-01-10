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

#ifdef TIME_DEBUG
Ripng_time_checker checker;
#endif
Ripng_mode ripng_mode;

const RipngEntry request_for_all = {
    .addr.s6_addr16 = {0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000}, .route_tag = 0x0000, .prefix_len = 0x00, .metric = 0x10};

const in6_addr ripng_multicast = {
    .s6_addr16 = {0x02ff, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0900}};

bool update_with_ripngentry(RipngEntry *entry, in6_addr *nexthop, uint8_t port) {
    if (entry->metric > METRIC_INF && entry->metric != 0xff) {
        printf("Invalid metric: %x", entry->metric);
        return false;
    }
    if (entry->prefix_len > 128) {
        printf("Invalid prefix len: %x", entry->prefix_len);
        return false;
    }
    char ipbuffer[200];
    printip(&(entry->addr), ipbuffer);
    printip(nexthop, &ipbuffer[100]);
    if (entry->metric == 0xff) {
        if (entry->prefix_len == 0x00 && entry->route_tag == 0x0000) {
            *(nexthop) = entry->addr;
            dbgprintf("Set nexthop to %s\r\n", ipbuffer);
        } else {
            printf("Invalid nexthop RTE: route tag %x prefix length %x", entry->route_tag, entry->metric);
        }
        return false;
    }
    if (check_linklocal_address(entry->addr) || entry->addr.s6_addr[0] == 0xff) {
        printf("Invalid RIP entry IP %s \r\n", ipbuffer);
        return false;
    }
    dbgprintf("\tValid ripentry: %s/%d metric=%d to %d %s\r\n", ipbuffer, entry->prefix_len, entry->metric, port, &ipbuffer[100]);
    LeafNode *leaf = prefix_query(entry->addr, entry->prefix_len, NULL, NULL, NULL);
    if (leaf != NULL) {
        LeafInfo *info = &leafs_info[leaf->_leaf_id];
        if (next_hops[info->nexthop_id].route_type == 0 || next_hops[info->nexthop_id].route_type == 1) {
            dbgprintf("\treject static or linklocal nexthop update\r\n");
            return false;
        }
        dbgprintf("\tIn routing table\r\n");
        if (next_hops[info->nexthop_id].port == port && in6_addr_equal(*nexthop, next_hops[info->nexthop_id].ip)) {
            // 相同nexthop时，更新metric并重启计时器
            if (entry->metric + 1 >= METRIC_INF) {
                dbgprintf("\tripentry metric is inf so delete\r\n");
                // 删除不可达的路由
                RoutingTableEntry table_entry = {
                    .addr = entry->addr, .len = entry->prefix_len, .if_index = port, .nexthop = *nexthop, .route_type = 2};
                update(false, table_entry);
                // 回发告知我们删除了这个路由
                return true;
            } else {
                // 更新metric，重置计时器
                update_leaf_info(leaf, entry->metric + 1, 0xff, (in6_addr){0}, 2);
                if (entry->metric + 1 != info->metric) {
                    // 回发告知我们更新了metric
                    return true;
                } // else all the same, do nothing
            }
        } else {
            // 不同nexthop时，比较metric的大小，选取最优的metric
            if (entry->metric + 1 < info->metric && entry->metric + 1 < METRIC_INF) {
                dbgprintf("\tripentry from another nexthop is smaller so update\r\n");
                update_leaf_info(leaf, entry->metric + 1, port, *(nexthop), 2);
                // 回发告知我们更新了路由信息
                return true;
            } // else do nothing
        }
    } else if (entry->metric + 1 < METRIC_INF) {
        dbgprintf("\tNot in routing table so add\r\n");
        RoutingTableEntry table_entry = {
            .addr = entry->addr, .len = entry->prefix_len, .if_index = port, .nexthop = *nexthop, .route_type = 2, .metric = entry->metric + 1};
        update(true, table_entry);
        // 回发告知我们更新了路由信息
        return true;
    }
    return false;
}

void update_with_response_packet(uint8_t port, uint32_t ripng_num, IP6Header *ipv6_header, UDPHeader *udp_header, RipngEntry *ripentry) {
    dma_lock_request();
    dma_send_request();
    in6_addr nexthop = ipv6_header->ip6_src;
    uint32_t answer_num = 0;
    for (uint32_t i = 0; i < ripng_num; i++) {
        if (update_with_ripngentry(&ripentry[i], &nexthop, port) && ripng_mode.triggered_update) {
            if (i != answer_num) {
                ripentry[answer_num].addr = ripentry[i].addr;
                ripentry[answer_num].route_tag = ripentry[i].route_tag;
                ripentry[answer_num].prefix_len = ripentry[i].prefix_len;
            }
            ripentry[answer_num].metric = ripentry[i].metric + 1 < METRIC_INF ? ripentry[i].metric + 1 : METRIC_INF;
            answer_num += 1;
        }
    }
    // 更改ip层的包头
    if (answer_num != 0) {
        dbgprintf("response answer %x", answer_num);
        // 有需要回复的包
        for (uint8_t send_port = 0; send_port < 4; send_port++) {
            if (send_port == port) {
                continue;
            }
            dma_send_request();
            bool use_gua = !check_multicast_address(ipv6_header->ip6_dst);
            ipv6_header->ip6_dst = ripng_multicast;
            ipv6_header->ip6_src = use_gua ? RAM_GUA_IP(send_port) : RAM_LOCAL_IP(send_port);
            ipv6_header->hop_limit = 0xff;
            ipv6_header->payload_len = __htons(RipngUDPLength(answer_num));
            // 更改udp层的包头
            udp_header->dest = __htons(RIPNGPORT);
            udp_header->src = __htons(RIPNGPORT);
            udp_header->length = __htons(RipngUDPLength(answer_num));
            validateAndFillChecksum((uint8_t *)ipv6_header, RipngIP6Length(answer_num));
            DMA_LEN = RipngETHLength(answer_num);
            dma_set_out_port(send_port);
            dma_send_finish();
        }
    }
    dma_lock_release();
}

void receive_ripng(uint8_t *packet, uint16_t length) {
#ifdef TIME_DEBUG
    checker.receive_temp = now_time;
#endif
    // 此处处理 RIPNG 协议
    IP6Header *ipv6_header = IP6_PTR(packet);
    UDPHeader *udp_header = UDP_PTR(packet);
    RipngHead *riphead = RipngHead_PTR(packet);
    RipngEntry *ripentry = RipngEntries_PTR(packet);
    uint32_t ripng_num = RipngEntryNum(length);
    uint8_t port = dma_get_receive_port();
    // 校验 ripng 包的格式
    dbgprintf("Receive RIPng, length: %d, should be %d\r\n", length, RipngETHLength(ripng_num));
    if (RipngETHLength(ripng_num) == length && riphead->version == 0x01) {
        // 校验命令 command 是否正确
        if (riphead->command == RIPNG_REQUEST) {
#ifdef TIME_DEBUG
            checker.receive_request_temp = now_time;
#endif
            dbgprintf("Recived RIPng Request\r\n");
            bool use_gua = !check_multicast_address(ipv6_header->ip6_dst);
            if (ripng_num == 1 && in6_addr_equal(ripentry[0].addr, request_for_all.addr) && ripentry[0].metric == request_for_all.metric && ripentry[0].prefix_len == request_for_all.prefix_len) {
                // 响应所有路由表
                dbgprintf("Response all entries\r\n");
                send_all_ripngentries(packet, port, ipv6_header->ip6_src, udp_header->src, use_gua, 0);
#ifdef TIME_DEBUG
                checker.receive_request_time += now_time - checker.receive_request_temp;
                checker.receive_time += now_time - checker.receive_temp;
#endif
                return;
            }
            if (ripng_num == 0) {
                // 无 entries, 不响应
                dbgprintf("No entry no response\r\n");
#ifdef TIME_DEBUG
                checker.receive_request_time += now_time - checker.receive_request_temp;
                checker.receive_time += now_time - checker.receive_temp;
#endif
                return;
            }
            dma_lock_request();
            dma_send_request();
            dbgprintf("Responsing\r\n");
            for (uint32_t i = 0; i < ripng_num; i++) {
                // 查路由表并修改 RIPNG 的 metric
                LeafNode *leaf = prefix_query(ripentry[i].addr, ripentry[i].prefix_len, NULL, NULL, NULL);
                if (leaf == NULL) {
                    ripentry[i].metric = METRIC_INF;
                } else {
                    ripentry[i].metric = leafs_info[leaf->_leaf_id].metric;
                }
            }
            riphead->command = RIPNG_RESPONSE;
            // 更改ip层的包头
            ipv6_header->ip6_dst = ipv6_header->ip6_src;
            ipv6_header->ip6_src = use_gua ? RAM_GUA_IP(port) : RAM_LOCAL_IP(port);
            ipv6_header->hop_limit = 0xff;
            // 更改udp层的包头
            udp_header->dest = udp_header->src;
            udp_header->src = __htons(RIPNGPORT);
            validateAndFillChecksum((uint8_t *)ipv6_header, RipngIP6Length(ripng_num));
            dma_set_out_port(port);
            dma_send_finish();
            dma_lock_release();
#ifdef TIME_DEBUG
            checker.receive_request_time += now_time - checker.receive_request_temp;
#endif
        } else if (riphead->command == RIPNG_RESPONSE) {
#ifdef TIME_DEBUG
            checker.receive_response_temp = now_time;
#endif
            dbgprintf("Recived RIPng Response\r\n");
            if (check_linklocal_address(ipv6_header->ip6_src) && !check_own_address(ipv6_header->ip6_src)) {
                if (ipv6_header->ip6_dst.s6_addr[0] == 0xff) {
                    if (ipv6_header->hop_limit == 0xff && udp_header->src == __htons(RIPNGPORT)) {
                        // 收到广播的 Response，可用于更改路由表
                        update_with_response_packet(port, ripng_num, ipv6_header, udp_header, ripentry);
                    } else {
                        // 收到一个错误的广播 Response
                        printf("Drop Packet: Boardcast Ripng Response with hop limit %x src %x \r\n", riphead->command);
                    }
                } else {
                    // 收到单播的 Response
                    if (ipv6_header->hop_limit == 0xff) {
                        // 可以更新路由表
                        update_with_response_packet(port, ripng_num, ipv6_header, udp_header, ripentry);
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
#ifdef TIME_DEBUG
            checker.receive_response_time += now_time - checker.receive_response_temp;
#endif
        } else {
            // 不合法的 ripng 指令
            printf("Drop Packet: Invalid Ripng command %x \r\n", riphead->command);
        }
    } else {
        // 不合法的 ripng 包
        printf("Drop Packet: Invalid Ripng packet format \r\n");
    }
#ifdef TIME_DEBUG
    checker.receive_time += now_time - checker.receive_temp;
#endif
}

void _send_all_fill_dma(uint8_t *packet, uint8_t port, in6_addr dest_ip, uint16_t dest_port, bool use_gua, uint8_t EntryNum) {
    IP6Header *ipv6_header = IP6_PTR(packet);
    UDPHeader *udp_header = UDP_PTR(packet);
    RipngHead *riphead = RipngHead_PTR(packet);

    ipv6_header->flow = IP6_DEFAULT_FLOW;
    ipv6_header->payload_len = __htons(RipngUDPLength(EntryNum));
    ipv6_header->next_header = IPPROTO_UDP;
    ipv6_header->hop_limit = 0xff;
    ipv6_header->ip6_src = use_gua ? RAM_GUA_IP(port) : RAM_LOCAL_IP(port);
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

// 返回当前路由条数
int send_all_ripngentries(uint8_t *packet, uint8_t port, in6_addr dest_ip, uint16_t dest_port, bool use_gua, bool allow_interrupt) {
#ifdef TIME_DEBUG
    if (allow_interrupt) {
        checker.send_temp = now_time;
    }
#endif
    // 本函数中默认已经获得lock_request并不释放
    dbgprintf("Sending all ripng entries\r\n");
    if (!allow_interrupt) {
        dma_lock_request();
    }
    uint32_t ripngentrynum = 0;
    RipngEntry *ripentry = RipngEntries_PTR(packet);
    int cnt = 0;
    for (uint32_t i = leafid_iterator(true); i; i = leafid_iterator(false)) {
        if (ripngentrynum == 0) {
            if (allow_interrupt) {
#ifdef TIME_DEBUG
                checker.send_time = now_time - checker.send_temp;
#endif
                mainloop(false);
#ifdef TIME_DEBUG
                checker.send_temp = now_time;
#endif
            }
            dma_send_request();
        }
        ++cnt;
        ripentry[ripngentrynum].addr = leafs_info[i].ip;
        ripentry[ripngentrynum].route_tag = 0x0000;
        ripentry[ripngentrynum].prefix_len = leafs_info[i].len;
        ripentry[ripngentrynum].metric = next_hops[leafs_info[i].nexthop_id].port == port ? METRIC_INF : leafs_info[i].metric;
        ripngentrynum += 1;

        if (ripngentrynum == MAXRipngEntryNum) {
            _send_all_fill_dma(packet, port, dest_ip, dest_port, use_gua, ripngentrynum);
            dma_set_out_port(port);
            dma_send_finish();
            if (allow_interrupt) {
                dma_lock_release();
            }
            ripngentrynum -= MAXRipngEntryNum;
        }
    }
    if (ripngentrynum > 0) {
        _send_all_fill_dma(packet, port, dest_ip, dest_port, use_gua, ripngentrynum);
        dma_set_out_port(port);
        dma_send_finish();
    }
    dma_lock_release();
#ifdef TIME_DEBUG
    if (allow_interrupt) {
        checker.send_time = now_time - checker.send_temp;
    }
#endif
    return cnt;
}

void debug_ripng() {
    // TODO: 用于回复远程诊断
}

void ripng_timeout(Timer *t, int i) {
    timer_start(t, i);
    dma_counter_print();
    for (uint8_t i = 0; i < 4; i++) {
        int cnt;
        cnt = send_all_ripngentries((uint8_t *)DMA_PTR, i, ripng_multicast, __htons(RIPNGPORT), 0, 1);
        printf("S%d:%d ", i, cnt);
    }
#ifdef TIME_DEBUG
    printf("\r\n");
    checker.time = now_time - checker.temp;
    printf(
        "all: %d \r\nreceive: %d \r\nsend: %d \r\nrequest: %d \r\nresponse: %d \r\nchecksum: %d \r\nquery table: %d \r\nupdate table %d \r\n",
        checker.time,
        checker.receive_time,
        checker.send_time,
        checker.receive_request_time,
        checker.receive_response_time,
        checker.receive_checksum_time,
        checker.receive_table_time,
        checker.receive_update_time);
    checker.temp = now_time;
    checker.time = 0;
    checker.receive_time = 0;
    checker.send_time = 0;
    checker.receive_request_time = 0;
    checker.receive_response_time = 0;
    checker.receive_checksum_time = 0;
    checker.receive_table_time = 0;
    checker.receive_update_time = 0;
#endif
    printf("\r\n");
    dma_counter_print();
}

void ripng_init() {
    // FF02::9
    ripng_mode.triggered_update = true;
    ripng_mode.checksum = true;

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
        ipv6_header->ip6_src = RAM_LOCAL_IP(i);
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

#ifdef _DEBUG
    char buf[100];
    printip(&LOCAL_IP(0), buf);
    printf("LOCAL IP 0: %s\r\n", buf);
#endif
}