#ifndef _RIPNG_H_
#define _RIPNG_H_

#include <stdint.h>
#include <lookup.h>
#include <router.h>

typedef struct {
    in6_addr addr;
    u16 route_tag;
    u8 prefix_len;
    u8 metric;
} RipngEntry;

void _ripng();

void check_ripng_entry(RipngEntry*);

#endif