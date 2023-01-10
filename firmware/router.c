#include <checksum.h>
#include <dma.h>
#include <printf.h>
#include <ripng.h>
#include <router.h>

mac_addr static_mac[4];
in6_addr static_local_ip[4];
in6_addr static_gua_ip[4];

#ifndef TEST_DEFINENATION
#define TEST_DEFINENATION
#define SINGLE_TEST
#endif

#ifdef SINGLE_TEST
uint8_t base_mac[6] = {0x8c, 0x1f, 0x64, 0x69, 0x10, 0x30};
uint8_t base_gua_ip[16] = {0x2a, 0x0e, 0xaa, 0x06, 0x04, 0x97, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01};
#endif

#ifdef BOARD_0
uint8_t base_mac[6] = {0x8c, 0x1f, 0x64, 0x69, 0x10, 0x30};
uint8_t base_gua_ip[16] = {0x2a, 0x0e, 0xaa, 0x06, 0x04, 0x97, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01};
#endif

#ifdef BOARD_1
uint8_t base_mac[6] = {0x8c, 0x1f, 0x64, 0x69, 0x10, 0x34};
uint8_t base_gua_ip[16] = {0x2a, 0x0e, 0xaa, 0x06, 0x04, 0x97, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01};
#endif

#ifdef BOARD_2
uint8_t base_mac[6] = {0x8c, 0x1f, 0x64, 0x69, 0x10, 0x38};
uint8_t base_gua_ip[16] = {0x2a, 0x0e, 0xaa, 0x06, 0x04, 0x97, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01};
#endif

in6_addr all_link_local_ip = {
    .s6_addr = {0xfe, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01}};

void init_port_config() {
    for (uint8_t port = 0; port < 4; ++port) {
        volatile uint8_t *mac = MAC_ADDR(port).mac_addr8;
        volatile uint8_t *gua_ip = GUA_IP(port).s6_addr;
        for (uint8_t i = 0; i < 6; ++i) {
            mac[i] = base_mac[i];
        }
        mac[5] += port;
        EUI64_CTRL(port) = 1;
        for (uint8_t i = 0; i < 16; ++i) {
            gua_ip[i] = base_gua_ip[i];
        }
        gua_ip[7] += port;
    }
#ifdef SINGLE_TEST
    for (uint8_t port = 0; port < 4; ++port) {
        LOCAL_IP(port) = all_link_local_ip;
    }
#endif
    for (uint8_t port = 0; port < 4; ++port) {
        RAM_MAC_ADDR(port) = MAC_ADDR(port);
        RAM_GUA_IP(port) = GUA_IP(port);
        RAM_LOCAL_IP(port) = LOCAL_IP(port);
    }

}

void icmp_error_gen() {
    dma_lock_request();
    dma_send_request();

    // 将原始包保留至 ICMPv6 错误包的数据部分
    uint16_t len = (DMA_LEN + 48) > 1280 ? 1280 : (DMA_LEN + 48);
    DMA_LEN = len;
    for (uint16_t i = len - 1; i >= 62; --i) {
        DMA_PTR[i] = DMA_PTR[i - 48];
    }

    // 生成 ICMPv6 错误包
    uint8_t port = dma_get_receive_port();

    EtherHeader *ether = ETHER_PTR(DMA_PTR);
    IP6Header *ip6 = IP6_PTR(DMA_PTR);
    ICMP6Header *icmp6 = ICMP6_PTR(DMA_PTR);
    icmp6->type = ether->ethertype & 0xff;
    icmp6->code = ether->ethertype >> 8;
    icmp6->checksum = 0;
    icmp6->icmp6_unused = 0;

    ip6->flow = IP6_DEFAULT_FLOW;
    ip6->payload_len = __htons(len - sizeof(EtherHeader) - sizeof(IP6Header));
    ip6->next_header = IPPROTO_ICMPV6;
    ip6->hop_limit = IP6_DEFAULT_HOP_LIMIT;
    ip6->ip6_dst = ip6->ip6_src;
    ip6->ip6_src = GUA_IP(port);

    // 若发回给链路本地地址, 则使用收包接口
    if (check_linklocal_address(ip6->ip6_dst)) {
        dma_set_out_port(dma_get_receive_port());
    }

#ifdef TIME_DEBUG
    checker.sending_tag = 3;
#endif

    validateAndFillChecksum((uint8_t *)ip6, len - sizeof(EtherHeader));

    dma_send_finish();
    dma_lock_release();
}

void icmp_reply_gen() {
    dma_lock_request();
    dma_send_request();

    IP6Header *ip6 = IP6_PTR(DMA_PTR);
    if (ip6->ip6_dst.s6_addr[0] == 0xff) {
        // 组播包使用 0 号口作为源 IP
        ip6->ip6_dst = ip6->ip6_src;
        ip6->ip6_src = GUA_IP(0);
    } else {
        // 单播包使用原来的目的地址作为源 IP
        in6_addr temp = ip6->ip6_dst;
        ip6->ip6_dst = ip6->ip6_src;
        ip6->ip6_src = temp;
    }

    ICMP6Header *icmp6 = ICMP6_PTR(DMA_PTR);
    icmp6->type = ICMP6_TYPE_ECHO_REPLY;
    icmp6->code = 0;
    icmp6->checksum = 0;

    // 若发回给链路本地地址, 则使用收包接口
    if (check_linklocal_address(ip6->ip6_dst)) {
        dma_set_out_port(dma_get_receive_port());
    }

#ifdef TIME_DEBUG
    checker.sending_tag = 3;
#endif

    validateAndFillChecksum((uint8_t *)ip6, DMA_LEN - sizeof(EtherHeader));

    dma_send_finish();
    dma_lock_release();
}

void mainloop(bool release_lock) {
    if (!release_lock) {
        dma_lock_request();
    }
    if (dma_read_need()) {
        volatile EtherHeader *ether = ETHER_PTR(DMA_PTR);
        if (ether->ethertype != 0xdd86) {
            // 以太网类型不是 IPv6, 即为硬件通知生成 ICMPv6 错误包
            icmp_error_gen();
        } else {
            volatile IP6Header *ip6 = IP6_PTR(DMA_PTR);
            if (ip6->next_header == IPPROTO_ICMPV6) {
                // ICMPv6 包
                uint16_t original_checksum = ((ICMP6Header *)((uint8_t *)(ip6) + sizeof(IP6Header)))->checksum;
#ifdef TIME_DEBUG
                checker.sending_tag = 3;
#endif
                if (validateAndFillChecksum((uint8_t *)(ip6), DMA_LEN - sizeof(EtherHeader))) {
                    volatile ICMP6Header *icmp6 = ICMP6_PTR(DMA_PTR);
                    if (icmp6->type == ICMP6_TYPE_ECHO_REQUEST) {
                        icmp_reply_gen();
                    }
                } else {
                    printf("Drop ICMPv6 Packet: checksum %04x error\r\n", original_checksum);
                    printf("PORT[%x] Read: len = %d data = ...\r\n", dma_get_receive_port(), DMA_LEN);
                    for (int i = 0; i < DMA_LEN; i++) {
                        printf("%02x ", DMA_PTR[i]);
                    }
                    printf(".\r\n");
                }
            } else if (ip6->next_header == IPPROTO_UDP) {
                // UDP 包
                uint16_t original_checksum = ((UDPHeader *)((uint8_t *)(ip6) + sizeof(IP6Header)))->checksum;
#ifdef TIME_DEBUG
                checker.sending_tag = 0;
#endif
                if (validateAndFillChecksum((uint8_t *)(ip6), DMA_LEN - sizeof(EtherHeader))) {
                    volatile UDPHeader *udp = UDP_PTR(DMA_PTR);
                    // dbgprintf("UDP Packet: src = %04x, dest = %04x\r\n", udp->src, udp->dest);
                    if (udp->dest == __htons(RIPNGPORT)) {
                        receive_ripng((uint8_t *)DMA_PTR, DMA_LEN);
                    }
                } else {
                    printf("Drop UDP Packet: checksum %04x error\r\n", original_checksum);
                    printf("PORT[%x] Read: len = %d data = ...\r\n", dma_get_receive_port(), DMA_LEN);
                    for (int i = 0; i < DMA_LEN; i++) {
                        printf("%02x ", DMA_PTR[i]);
                    }
                    printf(".\r\n");
                }
            } else {
                // 其他包直接丢弃
#ifdef _DEBUG
                printf("Drop Packet: ip6->next_header = %02x\r\n", ip6->next_header);
#endif
            }
        }
        if (!release_lock) {
            dma_lock_request();
        }
        dma_read_finish();
    }
}

bool check_linklocal_address(const in6_addr addr) {
    return (addr.s6_addr16[0] & 0xc0ff) == 0x80fe;
}

bool check_multicast_address(const in6_addr addr) {
    return addr.s6_addr[0] == 0xff;
}

bool check_own_address(const in6_addr addr) {
#ifndef CONTINOUS_ADDR
    return in6_addr_equal(addr, RAM_LOCAL_IP(0)) || in6_addr_equal(addr, RAM_LOCAL_IP(1)) || in6_addr_equal(addr, RAM_LOCAL_IP(2)) || in6_addr_equal(addr, RAM_LOCAL_IP(3));
#endif
#ifdef CONTINOUS_ADDR
    return addr.s6_addr32[0] == RAM_LOCAL_IP(0).s6_addr32[0] && addr.s6_addr32[1] == RAM_LOCAL_IP(0).s6_addr32[1] && addr.s6_addr32[2] == RAM_LOCAL_IP(0).s6_addr32[2] && (addr.s6_addr32[3] & 0x03000000) == (RAM_LOCAL_IP(0).s6_addr32[3] & 0x03000000);
#endif
}