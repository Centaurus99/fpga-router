#include "lookup/lookup.h"
#include <stdint.h>
#include <printf.h>
#include <uart.h>
#include <gpio.h>
#include <vga.h>

char buffer[1025];
int header;

bool _gets(char *buf, int len) {
    for (int i = 0; i < len; i++) {
        buf[i] = _getchar_uart();
        if (buf[i] == '\b') {
            buf[i] = 0;
            if (i > 0) {
                buf[i-1] = 0;
                update_pos(VGA_ROW - 2, i-1 + 2, '_', VGA_GREEN);
                i -= 2;
            } else i -= 1;
        } else if (buf[i] == '\n') {
            buf[i+1] = 0;
            return 1;
        } else {
            update_pos(VGA_ROW - 2, i + 2, buf[i], VGA_WHITE);
            update_pos(VGA_ROW - 2, i + 1 + 2, '_', VGA_GREEN);
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

char hextochar(u8 x) {
    if (x < 10) return '0' + x;
    return 'a' + x - 10;
}

void printip(in6_addr *addr, char *out) {
    int n = 0;
    for (int i=0; i<16; ++i) {
        if (i>0 && (i%2 == 0)) out[n++] = ':';
        out[n++] = hextochar(addr->s6_addr[i]>>4);
        out[n++] = hextochar(addr->s6_addr[i]&0xf);
    }
    out[n] = 0;
}

void printprefix(in6_addr *addr, int len, char *out) {
    int n = 0;
    for (int i=0; i<16; ++i) {
        if (i>0 && (i%2 == 0)) {
            out[n++] = ':';
            if (i*4 >= len) {
                out[n++] = ':';
                break;
            }
        }
        out[n++] = hextochar(addr->s6_addr[i]>>4);
        out[n++] = hextochar(addr->s6_addr[i]&0xf);
    }
    sprintf(out+n, "/%d", len);
}