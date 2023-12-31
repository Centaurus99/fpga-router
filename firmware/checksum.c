#include <assert.h>
#include <checksum.h>
#include <dma.h>
#include <header.h>
#include <ripng.h>
#include <stdint.h>

bool validateAndFillChecksum(uint8_t *packet, uint16_t len) {
    if (!ripng_mode.checksum) {
        return true;
    }

#ifdef ENABLE_ROUTE_SUM
    if (!dma_checksum_available()) {
        dma_checksum_request();
    }
#endif

    IP6Header *ip6 = (IP6Header *)packet;

    uint32_t now_sum = 0;
    for (int i = 0; i < 16; i += 2) {
        now_sum += (ip6->ip6_src.s6_addr[i] << 8) + ip6->ip6_src.s6_addr[i + 1];
        now_sum += (ip6->ip6_dst.s6_addr[i] << 8) + ip6->ip6_dst.s6_addr[i + 1];
    }

    // check next header
    uint8_t nxt_header = ip6->next_header;
    if (nxt_header == IPPROTO_UDP) {
        // UDP
#ifdef TIME_DEBUG
        if (checker.sending_tag == 0 || checker.sending_tag == 1) {
            checker.receive_checksum_temp = now_time;
        } else if (checker.sending_tag == 2) {
            checker.send_checksum_temp = now_time;
        }
#endif
        UDPHeader *udp = (UDPHeader *)&packet[sizeof(IP6Header)];
        // length: udp->length
        // checksum: udp->checksum
        uint16_t udp_len = __ntohs(udp->length);
        uint16_t udp_sum = __ntohs(udp->checksum);
        udp->checksum = 0;

        now_sum += udp_len;
        now_sum += nxt_header;

#ifdef ENABLE_ROUTE_SUM
        uint16_t sum_len = udp_len < 8 ? udp_len : 8;
        for (int i = 0; i < sum_len; i += 2) {
            now_sum += packet[sizeof(IP6Header) + i] << 8;
            if (i + 1 < sum_len) {
                now_sum += packet[sizeof(IP6Header) + i + 1];
            }
        }
        while (!dma_checksum_available()) {
            continue;
        }
        now_sum += DMA_CHECKSUM;
#else
        for (int i = 0; i < udp_len; i += 2) {
            now_sum += packet[sizeof(IP6Header) + i] << 8;
            if (i + 1 < udp_len) {
                now_sum += packet[sizeof(IP6Header) + i + 1];
            }
        }
#endif

        uint32_t real_sum = now_sum;
        while (real_sum >> 16) {
            real_sum = (real_sum >> 16) + (real_sum & 0xffff);
        }
        real_sum = (uint16_t)~real_sum;
        if (real_sum == 0) {
            real_sum = 0xffff;
        }
        udp->checksum = __htons(real_sum);

        if (udp_sum == 0) {
#ifdef TIME_DEBUG
            if (checker.sending_tag == 0 || checker.sending_tag == 1) {
                checker.receive_checksum_time += now_time - checker.receive_checksum_temp;
            } else if (checker.sending_tag == 2) {
                checker.send_checksum_time += now_time - checker.send_checksum_temp;
            }
#endif
            return false;
        }
        now_sum += udp_sum;
        while (now_sum >> 16) {
            now_sum = (now_sum >> 16) + (now_sum & 0xffff);
        }
        if (now_sum == 0xffff) {
#ifdef TIME_DEBUG
            if (checker.sending_tag == 0 || checker.sending_tag == 1) {
                checker.receive_checksum_time += now_time - checker.receive_checksum_temp;
            } else if (checker.sending_tag == 2) {
                checker.send_checksum_time += now_time - checker.send_checksum_temp;
            }
#endif
            return true;
        } else {
#ifdef TIME_DEBUG
            if (checker.sending_tag == 0 || checker.sending_tag == 1) {
                checker.receive_checksum_time += now_time - checker.receive_checksum_temp;
            } else if (checker.sending_tag == 2) {
                checker.send_checksum_time += now_time - checker.send_checksum_temp;
            }
#endif
            return false;
        }

    } else if (nxt_header == IPPROTO_ICMPV6) {
        // ICMPv6
        ICMP6Header *icmp = (ICMP6Header *)&packet[sizeof(IP6Header)];
        // length:
        // checksum: icmp->checksum
        uint16_t icmp_len = len - sizeof(IP6Header);
        uint16_t icmp_sum = __ntohs(icmp->checksum);
        icmp->checksum = 0;

        now_sum += icmp_len;
        now_sum += nxt_header;

#ifdef ENABLE_ROUTE_SUM
        uint16_t sum_len = icmp_len < 8 ? icmp_len : 8;
        for (int i = 0; i < sum_len; i += 2) {
            now_sum += packet[sizeof(IP6Header) + i] << 8;
            if (i + 1 < sum_len) {
                now_sum += packet[sizeof(IP6Header) + i + 1];
            }
        }
        while (!dma_checksum_available()) {
            continue;
        }
        now_sum += DMA_CHECKSUM;
#else
        for (int i = 0; i < icmp_len; i += 2) {
            now_sum += packet[sizeof(IP6Header) + i] << 8;
            if (i + 1 < icmp_len) {
                now_sum += packet[sizeof(IP6Header) + i + 1];
            }
        }
#endif

        uint32_t real_sum = now_sum;
        while (real_sum >> 16) {
            real_sum = (real_sum >> 16) + (real_sum & 0xffff);
        }
        icmp->checksum = __htons(~real_sum);

        now_sum += icmp_sum;
        while (now_sum >> 16) {
            now_sum = (now_sum >> 16) + (now_sum & 0xffff);
        }
        if (now_sum == 0xffff) {
            return true;
        } else {
            return false;
        }

    } else {
        assert_id(false, 2);
    }
    return true;
}
