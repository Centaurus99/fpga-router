#include "lookup/lookup.h"
#include <stdint.h>
#include <printf.h>
#include <uart.h>
#include <gpio.h>
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

u32 len, if_index, route_type;
in6_addr addr, nexthop;
char op;
char ipbuffer[48], info[100];
bool error;

void display() {
    flush();

    sprintf(buffer, "Welcome to IPv6 routing table management system!");
    for (int i = 0; buffer[i]; ++i)
        update_pos(0, i, buffer[i], VGA_WHITE);
    sprintf(buffer, "Usage: [a]dd [d]elete [c]heck [e]xit");
    for (int i = 0; buffer[i]; ++i)
        if (i == 8 || i == 14 || i == 23 || i == 31)
            update_pos(1, i, buffer[i], VGA_GREEN);
        else
            update_pos(1, i, buffer[i], VGA_BLUE);
    
    printip(&checking_addr, ipbuffer);
    sprintf(buffer, "Checking %s", ipbuffer);
    for (int i = 0; buffer[i]; ++i)
        update_pos(2, i, buffer[i], VGA_WHITE);

    int c = _prefix_query_all(checking_addr, &nexthops, &if_indices, &route_types);
    int n = 4, m = 0;
    for (int i = c-1; i >=0 ; --i) {
        printip(nexthops+i, ipbuffer);
        m = 0;
        for (int j = 0; ipbuffer[j]; ++j) {
            update_pos(n, m++, ipbuffer[j], VGA_WHITE);
        }
        m = 48;
        sprintf(buffer, "%d", if_indices[i]);
        for (int j = 0; buffer[j]; ++j) {
            update_pos(n, m++, buffer[j], VGA_BLUE);
        }
        m = 64;
        sprintf(buffer, "%d", route_types[i]);
        for (int j = 0; buffer[j]; ++j) {
            update_pos(n, m++, buffer[j], VGA_BLUE);
        }
        ++n;
    }

    
    for (int j = 0; j < VGA_W; j++) {
        update_pos(3, j, '-', VGA_WHITE);
        update_pos(VGA_ROW - 3, j, '-', VGA_WHITE);
    }
    update_pos(VGA_ROW - 2, 0, '>', VGA_GREEN);

    for (int j = 0; info[j]; ++j) {
        update_pos(VGA_ROW - 1, j, info[j], error ? VGA_RED : VGA_GREEN);
    }
}

bool operate_a() {
    if (!_getip(&addr)) {
        sprintf(info, "Invalid IP addr; Usage: a [addr] [len] [if_index] [nexthop] [route_type]");
        return 0;
    }
    len = _getdec();
    if_index = _getdec();
    if (!_getip(&nexthop)){
        sprintf(info, "Invalid IP nexthop; Usage: a [addr] [len] [if_index] [nexthop] [route_type]");
        return 0;
    }
    route_type = _getdec();
    RoutingTableEntry entry = {
        .addr = addr, .len = len, 
        .if_index = if_index, .nexthop = nexthop,
        .route_type = route_type
    };
    update(1, entry);

    printip(&addr, buffer);
    printip(&nexthop, buffer+100);
    sprintf(info, "Added %s %d %d %s", buffer, len, if_index, buffer+100);
    return 1;
}

bool operate_d() {
    if (!_getip(&addr)) {
        sprintf(info, "Invalid IP addr; Usage: d [addr] [len] [route_type]");
        return 0;
    }
    len = _getdec();
    route_type = _getdec();
    RoutingTableEntry entry = {
        .addr = addr, .len = len, 
        .if_index = 0, .nexthop = 0, .route_type = route_type
    };
    update(0, entry);
    printip(&addr, ipbuffer);
    sprintf(info, "Deleted %s %d %d", ipbuffer, len, if_index);
    return 1;
}

bool operate_c() {
    if (!_getip(&addr)) {
        sprintf(info, "Invalid IP addr; Usage: c [addr]");
        return 0;
    }
    printip(&addr, ipbuffer);
    checking_addr = addr;
    sprintf(info, "Checking legal routing entry of %s\r\n", ipbuffer);
    return 1;
}

void start(int argc, char *argv[]) {
    for (uint32_t *p = _bss_begin; p != _bss_end; ++p) {
        *p = 0;
    }
    init_uart();

    display();
    printf("INITIALIZED\n");

    while (_gets(buffer, 1024)) {
        printf("Buffer: %s",buffer);
        header = 0;
        op = _getnonspace();
        if (op == 'e') { // exit
            printf("Exited\n");
            break;
        }
        else if (op == 'a') { // add
            error = !operate_a();
        }
        else if (op == 'd') { //delete
            error = !operate_d();
        }
        else if (op == 'c') { // check
            error = !operate_c();
        } else {
            error = 1;
            sprintf(info, "Invalid Operation");
        }

        printf("%s\r\n", info);
        display();
    }
}
