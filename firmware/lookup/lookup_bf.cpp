#include "lookup.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <vector>

in6_addr operator &(const in6_addr &a, const in6_addr &b) {
  in6_addr ret;
  for (int i = 0; i < 16; i++) {
    ret.s6_addr[i] = a.s6_addr[i] & b.s6_addr[i];
  }
  return ret;
}

bool operator == (const in6_addr &a, const in6_addr &b) {
  for (int i = 0; i < 16; i++) {
    if (a.s6_addr[i] != b.s6_addr[i]) {
      return false;
    }
  }
  return true;
}

short ntohs(short x) {
  return ((x & 0xff) << 8) | ((x & 0xff00) >> 8);
}

int htonl(int x) {
  return ((x & 0xff) << 24) | ((x & 0xff00) << 8) | ((x & 0xff0000) >> 8) | ((x & 0xff000000) >> 24);
}

std::vector<RoutingTableEntry> routing_table;

void update(bool insert, const RoutingTableEntry entry) {
  for (auto it = routing_table.begin(); it != routing_table.end(); ++it) {
    if ((*it).addr == entry.addr && (*it).len == entry.len) {
      if (insert) {
        (*it) = entry;
      } else {
        routing_table.erase(it);
      }
      return;
    }
  }
  if (insert) {
    routing_table.push_back(entry);
  }
}

bool prefix_query(const in6_addr addr, in6_addr *nexthop, uint32_t *if_index, uint32_t *route_type) {
  RoutingTableEntry target;
  int max_len = -1;
  for (auto entry : routing_table) {
    if (max_len >= 0 && entry.len <= max_len) {
      continue;
    }
    in6_addr mask = len_to_mask(entry.len);
    if (entry.addr == (mask & addr)) {
      target = entry;
      max_len = entry.len;
    }
  }
  if (max_len >= 0) {
    *nexthop = target.nexthop;
    *if_index = target.if_index;
    *route_type = target.route_type;
    return true;
  }
  return false;
}

int mask_to_len(const in6_addr mask) {
  int len = 0, i = 0;
  for (; i < 8; ++i) {
    uint16_t now_mask = ntohs(mask.s6_addr16[i]);
    if (now_mask == 0xffff) {
      len += 16;
    } else {
      uint16_t tmp_mask = 0;
      for (int j = 0; j < 16; ++j) {
        if (now_mask & (1 << (15 - j))) {
          ++len;
          tmp_mask |= (1 << (15 - j));
        } else {
          if (tmp_mask != now_mask) {
            return -1;
          }
          break;
        }
      }
      break;
    }
  }
  for (++i; i < 8; ++i) {
    if (mask.s6_addr16[i] != 0) {
      return -1;
    }
  }
  return len;
}

in6_addr len_to_mask(int len) {
  in6_addr mask;
  for (int i = 0; i < 4; ++i) {
    if (len >= 32) {
      mask.s6_addr32[i] = 0xffffffff;
      len -= 32;
    } else {
      mask.s6_addr32[i] = htonl(((1 << len) - 1) << (32 - len));
      len = 0;
    }
  }
  return mask;
}

void export_mem(){}