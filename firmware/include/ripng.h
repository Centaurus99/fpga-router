#ifndef _RIPNG_H_
#define _RIPNG_H_

#include <header.h>
#include <stdint.h>


typedef struct {
    in6_addr addr;
    uint16_t route_tag;
    uint8_t prefix_len;
    uint8_t metric;
} RipngEntry;

void _ripng(uint8_t *packet, uint32_t length);

void check_ripng_entry(RipngEntry *);

#define RIPNGPORT 0x0209 // 521

#endif