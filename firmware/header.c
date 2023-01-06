#include <header.h>

bool mac_addr_equal(mac_addr a, mac_addr b) {
    return a.mac_addr16[0] == b.mac_addr16[0] && a.mac_addr16[1] == b.mac_addr16[1] && a.mac_addr16[2] == b.mac_addr16[2];
}

bool in6_addr_equal(in6_addr a, in6_addr b) {
    return a.s6_addr32[0] == b.s6_addr32[0] && a.s6_addr32[1] == b.s6_addr32[1] && a.s6_addr32[2] == b.s6_addr32[2] && a.s6_addr32[3] == b.s6_addr32[3];
}