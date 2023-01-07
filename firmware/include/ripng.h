#ifndef _RIPNG_H_
#define _RIPNG_H_

#include <header.h>
#include <stdint.h>

typedef struct {
    uint8_t command;
    uint8_t version;
    uint16_t zero;
} RipngHead;

typedef struct {
    in6_addr addr;
    uint16_t route_tag;
    uint8_t prefix_len;
    uint8_t metric;
} RipngEntry;

void _ripng(uint8_t *packet, uint32_t length);

void receive_ripngentry(RipngEntry *);

void send_ripngentries();

#define RIPNGPORT 0x0209 // 521

#define RipngEntryNum(len) (uint32_t)(((len) - sizeof(EtherHeader) - sizeof(IP6Header) - sizeof(UDPHeader) - sizeof(RipngHead)) / sizeof(RipngEntry))
#define RipngHead_PTR(packet) (RipngHead *)((packet) + sizeof(EtherHeader) + sizeof(IP6Header) + sizeof(UDPHeader))
#define RipngEntries_PTR(packet) (RipngEntry *)((packet) + sizeof(EtherHeader) + sizeof(IP6Header) + sizeof(UDPHeader) + sizeof(RipngHead))

#define RIPNG_REQUEST 0x1
#define RIPNG_RESPONSE 0x2

#define METRIC_INF 0x0f

#endif