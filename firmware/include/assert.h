#ifndef _ASSERT_H_
#define _ASSERT_H_

#include <stdbool.h>

void assert(bool c) {
    if (!c)  1/0;
}

#endif