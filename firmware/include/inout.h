#ifndef _INOUT_H_
#define _INOUT_H_

#include <header.h>
#include <lookup.h>
#include <stdbool.h>
#include <stdint.h>

void timer();

char _getchar();

bool _gets(char *buf, int len);

char _getnonspace();

u32 _getdec();

bool _getip(in6_addr *addr);

char hextochar(u8 x);

void printip(in6_addr *addr, char *out);

void printprefix(in6_addr *addr, int len, char *out);

#endif