#include <dma.h>
#include <ripng.h>
#include <router.h>

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

void mainloop() {
    if (dma_read_need()) {
        volatile PacketHeader *pkt = (PacketHeader *)DMA_PTR;
        if (pkt->eth_hdr.ethertype != 0xdd86) {
            // TODO: 回发 ICMP 错误包
        } else {
            // TODO: 根据不同类型的包做不同的处理
            _ripng();
        }
        dma_read_finish();
    }
}