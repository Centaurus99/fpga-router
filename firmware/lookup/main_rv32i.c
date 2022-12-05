#include "lookup.h"

extern void WRITE_SERIAL(char s);
extern char READ_SERIAL();

void _puts(const char *s, int size) {
    for (int i = 0; i < size; ++ i) {
        WRITE_SERIAL(s[i]);
    }
}

bool _gets(char *buf, int size) {
    for (int i = 0; i < size; i++) {
        buf[i] = READ_SERIAL();
    }
    return 1;
}

char buffer[1024];

int main(int argc, char *argv[]) {
    u32 len, if_index, route_type;
    in6_addr addr, nexthop;
    char op;
    while(op = READ_SERIAL()) {
        if (op == 'E') {
            _puts("EXIT", 4);
            break;
        }
        else if (op == 'I') {
            _gets(buffer, 16 + 1 + 1 + 16 + 1);
            RoutingTableEntry entry = {
                .addr = *(in6_addr*)buffer, .len = (u32)buffer[16], 
                .if_index = (u32)buffer[17], .nexthop = *(in6_addr*)(buffer+18),
                .route_type = (u32)buffer[34]
            };
            update(1, entry);
        }
        else if (op == 'D') {
            _gets(buffer, 16 + 1 + 1);
            RoutingTableEntry entry = {
                .addr = *(in6_addr*)buffer, .len = (u32)buffer[16], 
                .if_index = 0, .nexthop = 0, .route_type = (u32)buffer[17]
            };
            update(0, entry);
        }
        else if (op == 'Q') {
            _gets(buffer, 16);
            addr = *(in6_addr*)buffer;
            if (prefix_query(addr, &nexthop, &if_index, &route_type)) {
                _puts("Y", 1);
                _puts((char*)&nexthop, 16);
                _puts((char*)if_index, 1);
                _puts((char*)route_type, 1);
            }
            else {
                _puts("N", 1);
            }
        }
    }
    return 0;
}