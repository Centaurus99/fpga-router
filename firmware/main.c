#include "lookup/lookup.h"
#include <stdint.h>
#include <printf.h>
#include <uart.h>
// #include <gpio.h>

char buffer[1025];
int header;

bool _gets(char *buf, int len) {
    for (int i = 0; i < len; i++) {
        buf[i] = _getchar();
        if (buf[i] == '\b') {
            buf[i] = 0;
            // update_pos(VGA_H - 1, i, 0);
            i -= 1;
        } else if (buf[i] == '\n') {
            buf[i+1] = 0;
            return 1;
        }
    }
    return 0;
} 

char _getnonspace() {
    while (buffer[header] == ' ') header++;
    return buffer[header++];
}

u32 _getdec() {
    u32 ret = 0;
    char c= _getnonspace();
    for (; c>='0' && c<='9'; c = buffer[header++]) {
        ret = ret * 10 + c - '0';
    }
    return ret;
}

bool _getip(in6_addr *addr) {
    while (buffer[header] == ' ') header++;
    int l = header;
    while (
        (buffer[header] >= '0' && buffer[header] <= '9') ||
        (buffer[header] >= 'a' && buffer[header] <= 'f') ||
        buffer[header] == ':'
    ) header++;
    int r = header;
    for (int i=0; i<8; ++i) addr->s6_addr16[i] = 0;

    if (r == l + 2 && buffer[l]==':' && buffer[l+1]==':') {
        return 1;
    }
    if (r - l <= 2) return 0;
    int i = 0, c = 0;
    for (; l < r; ++l) {
        if (buffer[l] == ':') {
            if (l+1 < r && buffer[l+1] == ':') {
                int n = 0;  // 后面的冒号的数量
                for (int j=l+1; j<r; j++) {
                    if (buffer[j] == ':') {
                        ++n;
                        if (j+1 < r && buffer[j+1] == ':') return 0;
                    }
                }
                if (i + n > 8) return 0;
                i = 8 - n;
                ++l;
            } else if (++i >= 8) return 0;
            c = 0;
        } else {
            if (++c > 4) return 0;
            if (buffer[l] >= '0' && buffer[l] <= '9') {
                addr->s6_addr16[i] = addr->s6_addr16[i] * 16 + buffer[l] - '0';
            } else if (buffer[l] >= 'a' && buffer[l] <= 'f') {
                addr->s6_addr16[i] = addr->s6_addr16[i] * 16 + buffer[l] - 'a' + 10;
            } else {
                return 0;
            }
        }
    }
    for (int i=0; i<8; ++i) {
        addr->s6_addr16[i] = ((addr->s6_addr16[i] & 0xff) << 8) | addr->s6_addr16[i] >> 8;  // 小端序
    }

    return i == 7;
}

extern uint32_t _bss_begin[];
extern uint32_t _bss_end[];


void start (int argc, char *argv[]) {
    for (uint32_t *p = _bss_begin; p != _bss_end; ++p) {
        *p = 0;
    }
    init_uart();
    printf("INITIALIZED\n");

    u32 len, if_index, route_type;
    in6_addr addr, nexthop;
    char op;
    while (_gets(buffer, 1024)) {
        printf("BUFFER: %s",buffer);
        header = 0;
        op = _getnonspace();
        if (op == 'e') {
            printf("EXIT\n");
            break;
        }
        else if (op == 'a') {
            if (!_getip(&addr)) continue;
            len = _getdec();
            if_index = _getdec();
            if (!_getip(&nexthop)) continue;
            route_type = 0; // FIXME
            RoutingTableEntry entry = {
                .addr = addr, .len = len, 
                .if_index = if_index, .nexthop = nexthop,
                .route_type = route_type
            };
            printf("INSERT %08x %08x %08x %08x %d %d\r\n", nexthop.s6_addr32[0], nexthop.s6_addr32[1], nexthop.s6_addr32[2], nexthop.s6_addr32[3], len, if_index);
            update(1, entry);
            printf("INSERTED %08x %08x %08x %08x %d %d\r\n", addr.s6_addr32[0], addr.s6_addr32[1], addr.s6_addr32[2], addr.s6_addr32[3], len, if_index);
        }
        else if (op == 'd') {
            if (!_getip(&addr)) continue;
            len = _getdec();
            route_type = 0; // FIXME
            RoutingTableEntry entry = {
                .addr = addr, .len = len, 
                .if_index = 0, .nexthop = 0, .route_type = route_type
            };
            update(0, entry);
            printf("DELETED %08x %08x %08x %08x %d %d\r\n", addr.s6_addr32[0], addr.s6_addr32[1], addr.s6_addr32[2], addr.s6_addr32[3], len, route_type);
        }
        else if (op == 'f') {
            if (!_getip(&addr)) continue;
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
}
