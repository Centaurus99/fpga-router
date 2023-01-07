#include "lookup.h"
#include "memhelper.h"
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

char buffer[1024];

int main(int argc, char *argv[])
{
    memhelper_init();

    uint32_t len, if_index, route_type;
    in6_addr addr, nexthop;
    char addr_buffer[128];
    char nexthop_buffer[128];
    char tmp;
    while (fgets(buffer, sizeof(buffer), stdin))
    {
        if (buffer[0] == 'I')
        {
            sscanf(buffer, "%c%x%x%x%x%d%d%x%x%x%x%d", &tmp, &addr.s6_addr32[0], &addr.s6_addr32[1], &addr.s6_addr32[2], &addr.s6_addr32[3], &len, &if_index,
                   &nexthop.s6_addr32[0], &nexthop.s6_addr32[1], &nexthop.s6_addr32[2], &nexthop.s6_addr32[3], &route_type);
            //   assert(inet_pton(AF_INET6, addr_buffer, &addr) == 1);
            //   assert(inet_pton(AF_INET6, nexthop_buffer, &nexthop) == 1);
            assert(0 <= len && len <= 128);
            RoutingTableEntry entry = {
                .addr = addr, .len = len, .if_index = if_index, .nexthop = nexthop, .route_type = route_type};
            update(true, entry);
        }
        else if (buffer[0] == 'D')
        {
            sscanf(buffer, "%c%x%x%x%x%d%d", &tmp, &addr.s6_addr32[0], &addr.s6_addr32[1], &addr.s6_addr32[2], &addr.s6_addr32[3], &len, &route_type);
            //   assert(inet_pton(AF_INET6, addr_buffer, &addr) == 1);
            assert(0 <= len && len <= 128);
            RoutingTableEntry entry = {
                .addr = addr, .len = len, .if_index = 0, .nexthop = in6_addr{}, .route_type = route_type};
            update(false, entry);
            //   }
        }
        else if (buffer[0] == 'Q')
        {
            sscanf(buffer, "%c%x%x%x%x", &tmp, &addr.s6_addr32[0], &addr.s6_addr32[1], &addr.s6_addr32[2], &addr.s6_addr32[3]);
            //   assert(inet_pton(AF_INET6, addr_buffer, &addr) == 1);
            LeafInfo leaf_info;
            if (prefix_query(addr, &nexthop, &if_index, &route_type, &leaf_info) >= 0)
            {
                printf("%08x %08x %08x %08x %d %d\n",
                       nexthop.s6_addr32[0], nexthop.s6_addr32[1], nexthop.s6_addr32[2], nexthop.s6_addr32[3],
                       if_index, route_type);
            }
            else
            {
                printf("NFound\n");
            }
        }
    }
    // if (argc > 1 && argv[1][0] == 'm') {
    //     export_mem();
    // }
    return 0;
}