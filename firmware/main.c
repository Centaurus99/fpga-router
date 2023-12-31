#include <dma.h>
#include <gpio.h>
#include <inout.h>
#include <lookup.h>
#include <printf.h>
#include <ripng.h>
#include <router.h>
#include <stddef.h>
#include <stdint.h>
#include <timer.h>
#include <uart.h>
#include <vga.h>

#define EXTRAM_START (uint32_t *)0x80400000
#define EXTRAM_END (uint32_t *)0x80800000

extern uint32_t _bss_begin[];
extern uint32_t _bss_end[];

extern char buffer[1025];
extern int header;
extern bool _gets();
extern char _getnonspace();
extern uint32_t _getdec();
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

uint32_t len, if_index, route_type;
in6_addr addr, nexthop;
LeafInfo leaf_info;
char op;
char ipbuffer[148], info[100];
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
        printprefix(&(entry->addr), entry->len, ipbuffer);
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
        printip(&(entry->nexthop), ipbuffer);
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
            printprefix(&(entry->addr), entry->len, ipbuffer);
            printip(&(entry->nexthop), ipbuffer + 100);
            printf("Found %s if_index: %d %s route_type: %d metric: %d\r\n", ipbuffer, entry->if_index, ipbuffer + 100, entry->route_type, entry->metric);
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
        printprefix(&(entry->addr), entry->len, ipbuffer);
        printip(&(entry->nexthop), ipbuffer + 100);
        printf("Found %s if_index: %d %s route_type: %d metric: %d\r\n", ipbuffer, entry->if_index, ipbuffer + 100, entry->route_type, entry->metric);
    }
    return 1;
}

bool operate_q() {
    if (!_getip(&addr)) {
        sprintf(info, "Invalid IP addr; Usage: q [addr] [len]");
        return 0;
    }
    len = _getdec();
    if (prefix_query(addr, len, &nexthop, &if_index, &route_type) != NULL) {
        printip(&nexthop, ipbuffer);
        sprintf(info, "%08x %08x %08x %08x %d %d", nexthop.s6_addr32[0], nexthop.s6_addr32[1], nexthop.s6_addr32[2], nexthop.s6_addr32[3], if_index, route_type);
    } else {
        sprintf(info, "NFound");
    }
    return 1;
}

void init_direct_route() {
    RoutingTableEntry entry;
    entry.metric = 1;
    entry.len = 64;
    entry.nexthop.s6_addr32[0] = 0x00000000;
    entry.nexthop.s6_addr32[1] = 0x00000000;
    entry.nexthop.s6_addr32[2] = 0x00000000;
    entry.nexthop.s6_addr32[3] = 0x00000000;
    entry.route_type = 0;
    for (uint8_t port = 0; port < 4; ++port) {
        entry.if_index = port;
        entry.addr = RAM_GUA_IP(port);
        entry.addr.s6_addr32[3] = 0;
        entry.addr.s6_addr32[2] = 0;
        update(1, entry);
    }
}

extern void test();

void dpy_led_timeout(Timer *t, int i) {
    if (i == 1) {
        GPIO_DPY += 1;
    } else {
        GPIO_DPY += 0x10;
    }
    timer_start(t, i);
}

void start(int argc, char *argv[]) {
    for (uint32_t *p = _bss_begin; p != _bss_end; ++p) {
        *p = 0;
    }
    for(uint32_t *p = EXTRAM_START; p != EXTRAM_END; ++p) {
        *p = 0;
    }
    init_uart();
    init_port_config();
    dma_counter_init();

    lookup_init();
    init_direct_route();
    display();
    // Timer *dpy_timer = timer_init(SECOND, 5);
    // timer_set_timeout(dpy_timer, dpy_led_timeout);
    // timer_start(dpy_timer, 1);

    ripng_init();

    printf("INITIALIZED, %d\r\n", sizeof(TrieNode));

    while (1) {
        if (_gets(buffer, 1024)) {
            printf("Buffer: %s", buffer);
            header = 0;
            op = _getnonspace();
            if (op == 'e') { // exit
                sprintf(info, "We will not exit!");
                // break;
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
            // display();
        }
    }
}
