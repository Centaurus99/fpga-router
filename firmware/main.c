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
extern void printprefix();

extern int _prefix_query_all(const in6_addr addr, int *checking_leafs);

in6_addr checking_addr = {0};
int checking_leaf[64];
extern RoutingTableEntry routing_table[];

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

    int m = 0;
    sprintf(buffer, "%s", "Prefix");
    for (int i = 0; buffer[i]; ++i)
        update_pos(3, m++, buffer[i], VGA_WHITE);
    m = 44;
    sprintf(buffer, "%s", "If Index");
    for (int i = 0; buffer[i]; ++i)
        update_pos(3, m++, buffer[i], VGA_BLUE);
    m = 54;
    sprintf(buffer, "%s", "Next Hop");
    for (int i = 0; buffer[i]; ++i)
        update_pos(3, m++, buffer[i], VGA_GREEN);
    m = 98;
    sprintf(buffer, "%s", "Route Type");
    for (int i = 0; buffer[i]; ++i)
        update_pos(3, m++, buffer[i], VGA_WHITE);

    int c = _prefix_query_all(checking_addr, checking_leaf);
    int n = 5;
    m = 0;
    for (int i = c-1; i >= 0 ; --i) {
        RoutingTableEntry *entry = &routing_table[checking_leaf[i]];
        printprefix(entry->addr, entry->len, ipbuffer);
        m = 0;
        for (int j = 0; ipbuffer[j]; ++j) {
            update_pos(n, m++, ipbuffer[j], VGA_WHITE);
        }
        m = 44;
        sprintf(buffer, "%d", entry->if_index);
        for (int j = 0; buffer[j]; ++j) {
            update_pos(n, m++, buffer[j], VGA_BLUE);
        }
        m = 54;
        printip(entry->nexthop, ipbuffer);
        for (int j = 0; ipbuffer[j]; ++j) {
            update_pos(n, m++, ipbuffer[j], VGA_GREEN);
        }
        m = 98;
        sprintf(buffer, "%d", entry->route_type);
        for (int j = 0; buffer[j]; ++j) {
            update_pos(n, m++, buffer[j], VGA_WHITE);
        }
        ++n;
    }
    
    for (int j = 0; j < VGA_W; j++) {
        update_pos(4, j, '-', VGA_WHITE);
        update_pos(VGA_ROW - 3, j, '-', VGA_WHITE);
    }
    update_pos(VGA_ROW - 2, 0, '>', VGA_GREEN);
    update_pos(VGA_ROW - 2, 2, '_', VGA_GREEN);

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
        .if_index = 0, .nexthop = {{{0}}}, .route_type = route_type
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
    sprintf(info, "Checking legal routing entry of %s", ipbuffer);
    return 1;
}

void init_direct_route() {
    RoutingTableEntry entry;
    entry.addr.s6_addr32[0] = 0x06aa0e2a;
    entry.addr.s6_addr32[1] = 0x000a9704;
    entry.addr.s6_addr32[2] = 0x00000000;
    entry.addr.s6_addr32[3] = 0x00000000;
    entry.len = 64;
    entry.if_index = 0;
    entry.nexthop.s6_addr32[0] = 0x06aa0e2a;
    entry.nexthop.s6_addr32[1] = 0x000a9704;
    entry.nexthop.s6_addr32[2] = 0x00000000;
    entry.nexthop.s6_addr32[3] = 0x00000000;
    entry.route_type = 0;
    update(1, entry);
    entry.addr.s6_addr32[1] = 0x010a9704;
    entry.if_index = 1;
    entry.nexthop.s6_addr32[3] = 0x44340000;
    update(1, entry);
    entry.addr.s6_addr32[1] = 0x020a9704;
    entry.if_index = 2;
    entry.nexthop.s6_addr32[3] = 0x55450000;
    update(1, entry);
    entry.addr.s6_addr32[1] = 0x030a9704;
    entry.if_index = 3;
    entry.nexthop.s6_addr32[3] = 0x66560000;
    update(1, entry);
    entry.addr.s6_addr32[0] = 0;
    entry.addr.s6_addr32[1] = 0;
    entry.addr.s6_addr32[2] = 0;
    entry.addr.s6_addr32[3] = 0;
    entry.len = 0;
    update(1, entry);

}

void start(int argc, char *argv[]) {
    for (uint32_t *p = _bss_begin; p != _bss_end; ++p) {
        *p = 0;
    }
    init_uart();

    init_direct_route();
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
