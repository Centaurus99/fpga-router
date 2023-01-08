#include <checksum.h>
#include <dma.h>
#include <printf.h>
#include <ripng.h>
#include <router.h>

uint8_t base_mac[6] = {0x8c, 0x1f, 0x64, 0x69, 0x10, 0x30};
uint8_t base_gua_ip[16] = {0x2a, 0x0e, 0xaa, 0x06, 0x04, 0x97, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01};

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
}

void icmp_error_gen() {
    dma_lock_request();
    dma_send_request();

    // 将原始包保留至 ICMPv6 错误包的数据部分
    uint32_t len = (DMA_LEN + 48) > 1280 ? 1280 : (DMA_LEN + 48);
    DMA_LEN = len;
    for (uint32_t i = len - 1; i >= 62; --i) {
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
                if (validateAndFillChecksum((uint8_t *)(ip6), DMA_LEN - sizeof(EtherHeader))) {
                    volatile ICMP6Header *icmp6 = ICMP6_PTR(DMA_PTR);
                    if (icmp6->type == ICMP6_TYPE_ECHO_REQUEST) {
                        icmp_reply_gen();
                    }
                } else {
                    printf("Drop ICMPv6 Packet: checksum error\r\n");
                }
            } else if (ip6->next_header == IPPROTO_UDP) {
                // UDP 包
                if (validateAndFillChecksum((uint8_t *)(ip6), DMA_LEN - sizeof(EtherHeader))) {
                    volatile UDPHeader *udp = UDP_PTR(DMA_PTR);
                    if (udp->dest == __htons(RIPNGPORT)) {
                        receive_ripng((uint8_t *)DMA_PTR, DMA_LEN);
                    }
                } else {
                    printf("Drop UDP Packet: checksum error\r\n");
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

bool check_linklocal_address(in6_addr addr) {
    return (addr.s6_addr16[0] & 0xc0ff) == 0x80fe;
}

bool check_own_address(in6_addr addr) {
    return in6_addr_equal(addr, LOCAL_IP(0)) || in6_addr_equal(addr, LOCAL_IP(1)) || in6_addr_equal(addr, LOCAL_IP(2)) || in6_addr_equal(addr, LOCAL_IP(3));
}