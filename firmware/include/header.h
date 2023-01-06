#ifndef _HEADER_H_
#define _HEADER_H_

#include <stdbool.h>
#include <stdint.h>

// MAC address
typedef struct
{
    union {
        uint8_t __u6_addr8[6];
        uint16_t __u6_addr16[3];
    } __mac_u;
#define mac_addr8 __mac_u.__u6_addr8
#define mac_addr16 __mac_u.__u6_addr16
} mac_addr;

bool mac_addr_equal(mac_addr a, mac_addr b);

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

bool in6_addr_equal(in6_addr a, in6_addr b);

// 以太网头
typedef struct {
    mac_addr mac_dst;
    mac_addr mac_src;
    uint16_t ethertype;
} EtherHeader;
#define ETHERTYPE_IPV6 0xdd86

// IPv6 头
typedef struct {
    uint32_t flow;
    uint16_t payload_len;
    uint8_t next_header;
    uint8_t hop_limit;
    in6_addr ip6_src;
    in6_addr ip6_dst;
} IP6Header;
#define IP6_DEFAULT_FLOW 0x00000006
#define IP6_DEFAULT_HOP_LIMIT 64

// ICMPv6 头
typedef struct {
    uint8_t type;
    uint8_t code;
    uint16_t checksum;
    union _pad {
        uint32_t unused;
        struct _icmp6_echo {
            uint16_t identifier;
            uint16_t sequence;
        } icmp6_echo;
    } pad;
#define icmp6_unused pad.unused
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

#endif