#include "lookup/lookup.h"
#include <stdint.h>
#include <stdio.h>
#include <uart.h>

char _getchar();

char _getop() {
    char c = _getchar();
    while (c != 'E' && c != 'I' && c != 'D' && c != 'Q') c= _getchar();
    return c;
}

u32 _gethex() {
    u32 ret = 0;
    char c = _getchar();
    while (!((c>='0' && c<='9') || (c>='a' && c<='f'))) c = _getchar();
    for (; (c>='0' && c<='9') || (c>='a' && c<='f'); c = _getchar()) {
        ret = ret * 16 + (c>'9' ? c-'a'+10 : c-'0');
    }
    return ret;
}

u32 _getdec() {
    u32 ret = 0;
    char c= _getchar();
    while (!(c>='0' && c<='9')) c = _getchar();
    for (; c>='0' && c<='9'; c = _getchar()) {
        ret = ret * 10 + c-'0';
    }
    return ret;
}

void _getip(in6_addr *addr) {
    for (int i = 0; i < 4; i++) {
        addr->s6_addr32[i] = _gethex();
    }
}

bool _gets(char *buf, int size) {
    for (int i = 0; i < size; i++) {
        buf[i] = _getchar();
    }
    return 1;
}

extern uint32_t _bss_begin[];
extern uint32_t _bss_end[];

char buffer[1024];

void start (int argc, char *argv[]) {
    for (uint32_t *p = _bss_begin; p != _bss_end; ++p) {
        *p = 0;
    }
    init_uart();
    printf("INITIALIZED\n");

    u32 len, if_index, route_type;
    in6_addr addr, nexthop;
    char op;
    while (1) {
        op = _getop();
        if (op == 'E') {
            printf("EXIT\n");
            break;
        }
        else if (op == 'I') {
            _getip(&addr);
            len = _getdec();
            if_index = _getdec();
            _getip(&nexthop);
            route_type = _getdec();
            RoutingTableEntry entry = {
                .addr = addr, .len = len, 
                .if_index = if_index, .nexthop = nexthop,
                .route_type = route_type
            };
            update(1, entry);
            printf("INSERTED %08x %08x %08x %08x %d %d\r\n", addr.s6_addr32[0], addr.s6_addr32[1], addr.s6_addr32[2], addr.s6_addr32[3], len, if_index);
        }
        else if (op == 'D') {
            _getip(&addr);
            len = _getdec();
            route_type = _getdec();
            RoutingTableEntry entry = {
                .addr = addr, .len = len, 
                .if_index = 0, .nexthop = 0, .route_type = route_type
            };
            update(0, entry);
            printf("DELETED %08x %08x %08x %08x %d %d\r\n", addr.s6_addr32[0], addr.s6_addr32[1], addr.s6_addr32[2], addr.s6_addr32[3], len, route_type);
        }
        else if (op == 'Q') {
            _getip(&addr);
            if (prefix_query(addr, &nexthop, &if_index, &route_type)) {
                printf("Y %08x %08x %08x %08x %d %d\r\n",
                       nexthop.s6_addr32[0], nexthop.s6_addr32[1], nexthop.s6_addr32[2], nexthop.s6_addr32[3],
                       if_index, route_type);
            }
            else {
                printf("N\r\n");
            }
        }
    }
    return 0;
}
