#include <dma.h>
#include <ripng.h>
#include <router.h>
#include <checksum.h>

uint8_t base_mac[6] = {0x8c, 0x1f, 0x64, 0x69, 0x10, 0x30};
uint8_t base_gua_ip[16] = {0x2a, 0x0e, 0xaa, 0x06, 0x04, 0x97, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01};

void init_port_config() {
    for (uint8_t port = 0; port < 4; ++port) {
        volatile PortConfig *config = (PortConfig *)PORT_CONFIG_ADDR(port);
        volatile uint8_t *mac = (uint8_t *)config->mac;
        volatile uint8_t *gua_ip = (uint8_t *)config->gua_ip;
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

void icmp_error_gen() {
    while (dma_lock_request())
        ;
    volatile uint8_t *pkt = (uint8_t *)DMA_PTR;
    uint32_t len = (DMA_LEN + 48) > 1280 ? 1280 : (DMA_LEN + 48);
    DMA_LEN = len;
    for (uint32_t i = len; i > 62; --i) {
        DMA_PTR[i] = DMA_PTR[i - 48];
    }
}

void icmp_reply_gen() {
    volatile uint8_t *pkt = (uint8_t *)DMA_PTR;
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