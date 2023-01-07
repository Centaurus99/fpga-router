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

Timer timer_init(void (*timeout)(int), uint32_t interval, uint32_t pool_size);

void timer_stop(Timer *t, uint32_t id);

void timer_start(Timer *t, uint32_t id);

void timer_tick(Timer *t);

#endif