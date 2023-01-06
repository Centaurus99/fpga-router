#ifndef _HEADER_H_
#define _HEADER_H_

#include <stdint.h>

// MAC address
typedef struct
{
    union {
        uint8_t __u6_addr8[16];
        uint16_t __u6_addr16[8];
    } __mac_u;
#define addr8 __mac_u.__u6_addr8
#define addr16 __mac_u.__u6_addr16
} mac_addr;

// IPv6 address
typedef struct
{
    union {
        uint8_t __u6_addr8[16];
        uint16_t __u6_addr16[8];
        uint32_t __u6_addr32[4];
    } __in6_u;
#define s6_addr __in6_u.__u6_addr8
#define s6_addr16 __in6_u.__u6_addr16
#define s6_addr32 __in6_u.__u6_addr32
} in6_addr;

// 以太网头
typedef struct {
    uint16_t mac_dst[3];
    uint16_t mac_src[3];
    uint16_t ethertype;
} EtherHeader;

// IPv6 头
typedef struct {
    uint8_t prefix_pad[4];
    uint16_t length;
    uint8_t next_header;
    uint8_t hop_limit;
    in6_addr ip6_src;
    in6_addr ip6_dst;
} IP6Header;

// ICMPv6 头
typedef struct {
    uint8_t type;
    uint8_t code;
    uint16_t checksum;
    union _pad {
        uint32_t pad;
        struct _icmp6_echo {
            uint16_t identifier;
            uint16_t sequence;
        } icmp6_echo;
    } pad;
#define icmp6_identifier pad.icmp6_echo.identifier
#define icmp6_sequence pad.icmp6_echo.sequence
} ICMP6Header;

// UDP 头
typedef struct {
    uint16_t src;
    uint16_t dest;
    uint16_t length;
    uint16_t checksum;
} UDPHeader;

#define IPPROTO_UDP 17
#define IPPROTO_ICMPV6 58

#define IPv6_PTR(packet) (IP6Header *)((packet) + (sizeof(EtherHeader)))
#define UDP_PTR(packet) (UDPHeader *)((packet) + (sizeof(IP6Header)))

#endif