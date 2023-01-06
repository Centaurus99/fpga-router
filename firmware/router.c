#include <checksum.h>
#include <dma.h>
#include <ripng.h>
#include <router.h>
#include <checksum.h>

uint8_t base_mac[6] = {0x8c, 0x1f, 0x64, 0x69, 0x10, 0x30};
uint8_t base_gua_ip[16] = {0x2a, 0x0e, 0xaa, 0x06, 0x04, 0x97, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01};

void init_port_config() {
    for (uint8_t port = 0; port < 4; ++port) {
        volatile PortConfig *config = (PortConfig *)PORT_CONFIG_ADDR(port);
        volatile uint8_t *mac = (uint8_t *)&config->mac;
        volatile uint8_t *gua_ip = (uint8_t *)&config->gua_ip;
        for (uint8_t i = 0; i < 6; ++i) {
            mac[i] = base_mac[i];
        }
        mac[5] += port;
        config->eui64_ctrl = 1;
        for (uint8_t i = 0; i < 16; ++i) {
            gua_ip[i] = base_gua_ip[i];
        }
        gua_ip[7] += port;
    }
}

uint8_t get_receive_port() {
    volatile uint8_t *pkt = (uint8_t *)DMA_PTR;
    volatile EtherHeader *ether = (EtherHeader *)pkt;
    uint8_t port;
    if (mac_addr_equal(ether->mac_dst, MAC_ADDR(0))) {
        port = 0;
    } else if (mac_addr_equal(ether->mac_dst, MAC_ADDR(1))) {
        port = 1;
    } else if (mac_addr_equal(ether->mac_dst, MAC_ADDR(2))) {
        port = 2;
    } else if (mac_addr_equal(ether->mac_dst, MAC_ADDR(3))) {
        port = 3;
    } else {
        port = 0;
    }
    return port;
}

void icmp_error_gen() {
    while (dma_lock_request())
        ;

    // 将原始包保留至 ICMPv6 错误包的数据部分
    uint32_t len = (DMA_LEN + 48) > 1280 ? 1280 : (DMA_LEN + 48);
    DMA_LEN = len;
    for (uint32_t i = len; i > 62; --i) {
        DMA_PTR[i] = DMA_PTR[i - 48];
    }

    // 生成 ICMPv6 错误包
    uint8_t port = get_receive_port();
    volatile uint8_t *pkt = (uint8_t *)DMA_PTR;
    volatile EtherHeader *ether = (EtherHeader *)pkt;
    volatile IP6Header *ip6 = (IP6Header *)&pkt[sizeof(EtherHeader)];
    volatile ICMP6Header *icmp6 = (ICMP6Header *)&pkt[sizeof(EtherHeader) + sizeof(IP6Header)];
    icmp6->type = ether->ethertype >> 8;
    icmp6->code = ether->ethertype & 0xff;
    icmp6->checksum = 0;
    icmp6->icmp6_unused = 0;

    ip6->flow = IP6_DEFAULT_FLOW;
    ip6->payload_len = len - sizeof(EtherHeader) - sizeof(IP6Header);
    ip6->next_header = IPPROTO_ICMPV6;
    ip6->hop_limit = IP6_DEFAULT_HOP_LIMIT;
    ip6->ip6_dst = ip6->ip6_src;
    ip6->ip6_src = GUA_IP(port);

    dma_send_finish();
}

void icmp_reply_gen() {
}

void mainloop() {
    if (dma_read_need()) {
        volatile uint8_t *pkt = (uint8_t *)DMA_PTR;
        volatile uint32_t len = (uint32_t)DMA_LEN;
        volatile EtherHeader *ether = (EtherHeader *)pkt;
        if (ether->ethertype != 0xdd86) {
            icmp_error_gen();
        } else {
            // TODO: 根据不同类型的包做不同的处理
            IP6Header *ipv6 = IPv6_PTR(pkt);
            if(! validateAndFillChecksum((uint8_t *)(ipv6), len)){ 
                // TODO: 处理 checksum 异常
            } else {
                if(ipv6->next_header == IPPROTO_UDP) {
                    UDPHeader * udp = UDP_PTR(ipv6);
                    if(udp->src == RIPNGPORT && udp->dest == RIPNGPORT) {
                        _ripng(pkt, len);
                    }
                }
            }
        }
        dma_read_finish();
    }
}