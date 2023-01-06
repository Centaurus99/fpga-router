#include "checksum.h"
#include <assert.h>
#include <stdint.h>

// <machine/endian.h>
static inline uint16_t
__bswap16(uint16_t _x) {

    return ((uint16_t)((_x >> 8) | ((_x << 8) & 0xff00)));
}

static inline uint32_t
__bswap32(uint32_t _x) {

    return ((uint32_t)((_x >> 24) | ((_x >> 8) & 0xff00) |
                       ((_x << 8) & 0xff0000) | ((_x << 24) & 0xff000000)));
}

#define __htonl(_x) __bswap32(_x)
#define __htons(_x) __bswap16(_x)
#define __ntohl(_x) __bswap32(_x)
#define __ntohs(_x) __bswap16(_x)

// End <machine/endian.h>

bool validateAndFillChecksum(volatile uint8_t *packet, uint32_t len) {
    volatile IP6Header *ip6 = (IP6Header *)packet;

    uint32_t now_sum = 0;
    for (int i = 0; i < 16; i += 2) {
        now_sum += (ip6->ip6_src.s6_addr[i] << 8) + ip6->ip6_src.s6_addr[i + 1];
        now_sum += (ip6->ip6_dst.s6_addr[i] << 8) + ip6->ip6_dst.s6_addr[i + 1];
    }

    // check next header
    uint8_t nxt_header = ip6->next_header;
    if (nxt_header == IPPROTO_UDP) {
        // UDP
        volatile UDPHeader *udp = (UDPHeader *)&packet[sizeof(IP6Header)];
        // length: udp->length
        // checksum: udp->checksum
        uint16_t udp_len = __ntohs(udp->length);
        uint16_t udp_sum = __ntohs(udp->checksum);
        udp->checksum = 0;

        now_sum += udp_len;
        now_sum += nxt_header;
        for (int i = 0; i < udp_len; i += 2) {
            now_sum += packet[sizeof(IP6Header) + i] << 8;
            if (i + 1 < udp_len) {
                now_sum += packet[sizeof(IP6Header) + i + 1];
            }
        }

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
            return false;
        }
        now_sum += udp_sum;
        while (now_sum >> 16) {
            now_sum = (now_sum >> 16) + (now_sum & 0xffff);
        }
        if (now_sum == 0xffff) {
            return true;
        } else {
            return false;
        }

    } else if (nxt_header == IPPROTO_ICMPV6) {
        // ICMPv6
        volatile ICMP6Header *icmp = (ICMP6Header *)&packet[sizeof(IP6Header)];
        // length:
        // checksum: icmp->checksum
        uint16_t icmp_len = len - sizeof(IP6Header);
        uint16_t icmp_sum = __ntohs(icmp->checksum);
        icmp->checksum = 0;

        now_sum += icmp_len;
        now_sum += nxt_header;
        for (int i = 0; i < icmp_len; i += 2) {
            now_sum += packet[sizeof(IP6Header) + i] << 8;
            if (i + 1 < icmp_len) {
                now_sum += packet[sizeof(IP6Header) + i + 1];
            }
        }

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
        assert(false);
    }
    return true;
}
