#ifndef _RIPNG_H_
#define _RIPNG_H_

#include <header.h>
#include <stdint.h>
#include <timer.h>

#ifdef TIME_DEBUG
typedef struct {
    uint32_t temp;
    uint32_t time;
    uint32_t receive_temp;
    uint32_t receive_time;
    uint32_t receive_request_temp;
    uint32_t receive_request_time;
    uint32_t receive_response_temp;
    uint32_t receive_response_time;
    uint32_t receive_checksum_temp;
    uint32_t receive_checksum_time;
    uint32_t receive_table_temp;
    uint32_t receive_table_time;
    uint32_t receive_update_temp;
    uint32_t receive_update_time;
    uint32_t send_temp;
    uint32_t send_time;
} Ripng_time_checker;
extern Ripng_time_checker checker;
#endif

typedef struct {
    bool triggered_update;
    bool checksum;
} Ripng_mode;
extern Ripng_mode ripng_mode;

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

void receive_ripng(uint8_t *packet, uint16_t length);

int send_all_ripngentries(uint8_t *packet, uint8_t port, in6_addr dest_ip, uint16_t dest_port, bool use_gua, bool allow_interrupt);

void debug_ripng();

void ripng_init();

void ripng_timeout(Timer *t, int i);

#define RIPNGPORT 0x0209 // 521

#define RipngEntryNum(len) (uint32_t)(((len) - sizeof(EtherHeader) - sizeof(IP6Header) - sizeof(UDPHeader) - sizeof(RipngHead)) / sizeof(RipngEntry))
#define RipngHead_PTR(packet) (RipngHead *)(((uint8_t *)packet) + sizeof(EtherHeader) + sizeof(IP6Header) + sizeof(UDPHeader))
#define RipngEntries_PTR(packet) (RipngEntry *)(((uint8_t *)packet) + sizeof(EtherHeader) + sizeof(IP6Header) + sizeof(UDPHeader) + sizeof(RipngHead))

#define RIPNG_REQUEST 0x1
#define RIPNG_RESPONSE 0x2

#define METRIC_INF 0x10

#define MTU 1500

#define MAXRipngEntryNum RipngEntryNum(MTU)
#define RipngLength(num) ((uint16_t)(num * sizeof(RipngEntry) + sizeof(RipngHead)))
#define RipngUDPLength(num) ((uint16_t)(RipngLength(num) + sizeof(UDPHeader)))
#define RipngIP6Length(num) ((uint16_t)(RipngUDPLength(num) + sizeof(IP6Header)))
#define RipngETHLength(num) ((uint16_t)(RipngIP6Length(num) + sizeof(EtherHeader)))

#endif