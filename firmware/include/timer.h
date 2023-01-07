#ifndef _TIMER_H_
#define _TIMER_H_

#include <stdint.h>
#include <stdbool.h>
#include <printf.h>
#include <lookup.h>

typedef struct _Timer {
    void (*timeout)(struct _Timer*, int);
    uint32_t interval;
    uint32_t *nxt, *pre, *start_time;
    uint32_t head, tail;
} Timer;

Timer timer_init(uint32_t interval, uint32_t pool_size);

void timer_set_timeout(Timer *t, void (*timeout)(Timer*, int));

void timer_stop(Timer *t, uint32_t id);

void timer_start(Timer *t, uint32_t id);

void timer_tick(Timer *t);

#endif