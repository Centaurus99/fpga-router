#ifndef _TIMER_H_
#define _TIMER_H_

#include <stdint.h>
#include <stdbool.h>
#include <lookup.h>

typedef struct {
    void (*timeout)(int);
    uint32_t interval;
    uint32_t *nxt, *pre, *start_time;
    uint32_t head, tail;
} Timer;

#endif