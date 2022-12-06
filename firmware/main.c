#include "lookup/lookup.h"
#include <stdint.h>
#include <printf.h>
#include <uart.h>
// #include <gpio.h>
#include <vga.h>


extern uint32_t _bss_begin[];
extern uint32_t _bss_end[];

extern char buffer[1025];
extern int header;
extern bool _gets();
extern char _getnonspace();
extern u32 _getdec();
extern bool _getip();
extern void printip();

extern int _prefix_query_all(const in6_addr addr, in6_addr *nexthop, u32 *if_index, u32 *route_type);

in6_addr nexthops[100], checking_addr = {0};
u32 if_indices[100], route_types[100];

void start(int argc, char *argv[]) {
    for (uint32_t *p = _bss_begin; p != _bss_end; ++p) {
        *p = 0;
    }
    init_uart();
    printf("INITIALIZED\n");

    u32 len, if_index, route_type;
    in6_addr addr, nexthop;
    char op;
    char ipbuffer[44];
    while (_gets(buffer, 1024)) {
        printf("Buffer: %s",buffer);
        header = 0;
        op = _getnonspace();
        if (op == 'e') { // exit
            printf("Exited\n");
            break;
        }
        else if (op == 'a') { // add
            if (!_getip(&addr)) continue;
            len = _getdec();
            if_index = _getdec();
            if (!_getip(&nexthop)) continue;
            route_type = _getdec();
            RoutingTableEntry entry = {
                .addr = addr, .len = len, 
                .if_index = if_index, .nexthop = nexthop,
                .route_type = route_type
            };
            update(1, entry);

            printip(&addr, ipbuffer);
            printf("Added %s %d %d ", ipbuffer, len, if_index);
            printip(&nexthop, ipbuffer);
            printf("%s\r\n", ipbuffer);
        }
        else if (op == 'd') { //delete
            if (!_getip(&addr)) continue;
            len = _getdec();
            route_type = _getdec();
            RoutingTableEntry entry = {
                .addr = addr, .len = len, 
                .if_index = 0, .nexthop = 0, .route_type = route_type
            };
            update(0, entry);
            printip(&addr, ipbuffer);
            printf("Deleted %s %d %d\r\n", ipbuffer, len, if_index);
        }
        else if (op == 'c') { // check
            if (!_getip(&addr)) continue;
            printip(&addr, ipbuffer);
            printf("Checking %s\r\n", ipbuffer);
            checking_addr = addr;
        } else  continue;

        flush();
        int n = _prefix_query_all(checking_addr, &nexthops, &if_indices, &route_types);
        for (int i = 0; i < n; ++i) {
            printip(nexthops+i, ipbuffer);
            sprintf(buffer, "%s %d %d", ipbuffer, if_indices[i], route_types[i]);
            display(buffer);
        }
    }
}
