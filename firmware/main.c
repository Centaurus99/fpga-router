#include "lookup/lookup.h"
#include "lookup/memhelper.h"
#include <dma.h>
#include <gpio.h>
#include <printf.h>
#include <router.h>
#include <stdint.h>
#include <uart.h>
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

extern void _prefix_query_all(int dep, int nid, const in6_addr addr,
                              RoutingTableEntry *checking_entry, int *count, bool checking_all, in6_addr ip);

in6_addr checking_addr = {0};
bool checking_all = 1;
RoutingTableEntry checking_entry[100];
extern RoutingTableEntry routing_table[];
extern int entry_count;

u32 len, if_index, route_type;
in6_addr addr, nexthop;
char op;
char ipbuffer[48], info[100];
bool error;
unsigned int forward_speed[2][4]; // 0.01 MB/s

void draw_speed() {
    char tmp[10];
    for (int p = 0; p < 2; ++p) {
        for (int i = 0; i < 4; ++i) {
            sprintf(tmp, "%4d.%02d", forward_speed[p][i] / 100, forward_speed[p][i] % 100);
            for (int j = 0; j < 7; ++j) {
                update_pos(2 - p, 52 + 18 + 10 * i + j, tmp[j], p ? VGA_YELLOW : VGA_BLUE);
            }
        }
    }
}

void display() {
    flush();

    sprintf(buffer, "Welcome to IPv6 router manager!");
    for (int i = 0; buffer[i]; ++i)
        update_pos(0, i, buffer[i], VGA_PURPLE);
    sprintf(buffer, "Usage: [a]dd [d]elete [c]heck [e]xit");
    for (int i = 0; buffer[i]; ++i)
        if (i == 8 || i == 14 || i == 23 || i == 31)
            update_pos(1, i, buffer[i], VGA_GREEN);
        else
            update_pos(1, i, buffer[i], VGA_BLUE);

    sprintf(buffer, "            Port| %7s | %7s | %7s | %7s", "0", "1", "2", "3");
    for (int i = 0; buffer[i]; ++i)
        update_pos(0, 52 + i, buffer[i], VGA_PINK);
    sprintf(buffer, " In Speed (MB/s)| %7s | %7s | %7s | %7s", "", "", "", "");
    for (int i = 0; buffer[i]; ++i)
        update_pos(1, 52 + i, buffer[i], VGA_PINK);
    sprintf(buffer, "Out Speed (MB/s)| %7s | %7s | %7s | %7s", "", "", "", "");
    for (int i = 0; buffer[i]; ++i)
        update_pos(2, 52 + i, buffer[i], VGA_PINK);

    draw_speed();

    if (checking_all) {
        sprintf(buffer, "<Checking all entries>", ipbuffer);
    } else {
        printip(&checking_addr, ipbuffer);
        sprintf(buffer, "<Checking %s>", ipbuffer);
    }
    for (int i = 0; buffer[i]; ++i)
        update_pos(2, i, buffer[i], VGA_GREEN);

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

    int c = 0;
    _prefix_query_all(0, 0, checking_addr, checking_entry, &c, checking_all, (in6_addr){{{0}}});
    int n = 5;
    m = 0;
    for (int i = 0; i < c; ++i) {
        RoutingTableEntry *entry = checking_entry + i;
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
    if (!_getip(&nexthop)) {
        sprintf(info, "Invalid IP nexthop; Usage: a [addr] [len] [if_index] [nexthop] [route_type]");
        return 0;
    }
    route_type = _getdec();
    RoutingTableEntry entry = {
        .addr = addr, .len = len, .if_index = if_index, .nexthop = nexthop, .route_type = route_type};
    update(1, entry);

    printprefix(&addr, len, buffer);
    printip(&nexthop, buffer + 100);
    sprintf(info, "Added %s %d %s %d", buffer, if_index, buffer + 100, route_type);
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
        .addr = addr, .len = len, .if_index = 0, .nexthop = {{{0}}}, .route_type = route_type};
    update(0, entry);
    printip(&addr, ipbuffer);
    sprintf(info, "Deleted %s %d %d", ipbuffer, len, route_type);
    return 1;
}

bool operate_c() {
    int c = 0;
    if (buffer[header] == '\n') {
        checking_all = 1;
        sprintf(info, "Checking all routing entries");
        _prefix_query_all(0, 0, checking_addr, checking_entry, &c, checking_all, (in6_addr){{{0}}});
        for (int i = 0; i < c; ++i) {
            RoutingTableEntry *entry = checking_entry + i;
            printprefix(entry->addr, entry->len, ipbuffer);
            printip(entry->nexthop, ipbuffer + 100);
            printf("Found %s %d %s %d\n", ipbuffer, entry->if_index, ipbuffer + 100, entry->route_type);
        }
        return 1;
    }
    if (!_getip(&addr)) {
        sprintf(info, "Invalid IP addr; Usage: c [addr] or only c for checking all");
        return 0;
    }
    checking_all = 0;
    printip(&addr, ipbuffer);
    checking_addr = addr;
    sprintf(info, "Checking legal routing entry of %s", ipbuffer);

    _prefix_query_all(0, 0, checking_addr, checking_entry, &c, checking_all, (in6_addr){{{0}}});
    for (int i = 0; i < c; ++i) {
        RoutingTableEntry *entry = checking_entry + i;
        printprefix(entry->addr, entry->len, ipbuffer);
        printip(entry->nexthop, ipbuffer + 100);
        printf("Found %s %d %s %d\n", ipbuffer, entry->if_index, ipbuffer + 100, entry->route_type);
    }
    return 1;
}

bool operate_q() {
    if (!_getip(&addr)) {
        sprintf(info, "Invalid IP addr; Usage: q [addr]");
        return 0;
    }
    if (prefix_query(addr, &nexthop, &if_index, &route_type)) {
        printip(&nexthop, ipbuffer);
        sprintf(info, "%08x %08x %08x %08x %d %d", nexthop.s6_addr32[0], nexthop.s6_addr32[1], nexthop.s6_addr32[2], nexthop.s6_addr32[3], if_index, route_type);
    } else {
        sprintf(info, "NFound");
    }
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
    entry.nexthop.s6_addr32[3] = 0x33230000;
    entry.route_type = 0;
    update(1, entry);
    entry.addr.s6_addr32[1] = 0x010a9704;
    entry.if_index = 1;
    entry.nexthop.s6_addr32[1] = 0x010a9704;
    entry.nexthop.s6_addr32[3] = 0x44340000;
    update(1, entry);
    entry.addr.s6_addr32[1] = 0x020a9704;
    entry.if_index = 2;
    entry.nexthop.s6_addr32[1] = 0x020a9704;
    entry.nexthop.s6_addr32[3] = 0x55450000;
    update(1, entry);
    entry.addr.s6_addr32[1] = 0x030a9704;
    entry.if_index = 3;
    entry.nexthop.s6_addr32[1] = 0x030a9704;
    entry.nexthop.s6_addr32[3] = 0x66560000;
    update(1, entry);
    entry.addr.s6_addr32[0] = 0;
    entry.addr.s6_addr32[1] = 0;
    entry.addr.s6_addr32[2] = 0;
    entry.addr.s6_addr32[3] = 0;
    entry.len = 0;
    update(1, entry);
}

extern void test();

void start(int argc, char *argv[]) {
    for (uint32_t *p = _bss_begin; p != _bss_end; ++p) {
        *p = 0;
    }
    init_uart();
    init_port_config();

    memhelper_init();
    init_direct_route();
    display();
    printf("INITIALIZED, %d\n", sizeof(TrieNode));

    while (1) {
        if (_gets(buffer, 1024)) {
            printf("Buffer: %s", buffer);
            header = 0;
            op = _getnonspace();
            if (op == 'e') { // exit
                printf("Exited\n");
                break;
            } else if (op == 'a') { // add
                error = !operate_a();
            } else if (op == 'd') { // delete
                error = !operate_d();
            } else if (op == 'c') { // check
                error = !operate_c();
            } else if (op == 'f') { // DMA Demo
                error = 0;
                sprintf(info, "---- DMA DEMO ----");
                dma_demo();
            } else if (op == 'q') { // query
                error = !operate_q();
            } else {
                error = 1;
                sprintf(info, "Invalid Operation");
            }

            printf("%s\r\n", info);
            display();
        }
    }
}
