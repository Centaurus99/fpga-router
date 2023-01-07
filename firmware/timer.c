#include <timer.h>

#define now (*(volatile uint32_t *)0x200BFF8)

uint32_t timer_pool[3][LEAF_COUNT * 2 + 10];
uint32_t pool_header = 0;

bool _timer_expired(Timer *t, uint32_t id) {
    // printf("now = %u, start_time = %u, interval = %u %u", now, t->start_time[id], t->interval, now - t->start_time[id]);
    return now - t->start_time[id] >= t->interval;
}

Timer timer_init(uint32_t interval, uint32_t pool_size) {
    Timer t;
    t.head = 0;
    t.tail = 0;
    t.interval = interval;
    t.nxt = &timer_pool[0][pool_header];
    t.pre = &timer_pool[1][pool_header];
    t.start_time = &timer_pool[2][pool_header];
    pool_header += pool_size;
    return t;
}

void timer_set_timeout(Timer *t, void (*timeout)(Timer*, int)) {
    t->timeout = timeout;
}

// id should > 0
void timer_stop(Timer *t, uint32_t id) {
    t->nxt[t->pre[id]] = t->nxt[id];
    t->pre[t->nxt[id]] = t->pre[id];
    if (t->head == id)
        t->head = t->nxt[id];
    if (t->tail == id)
        t->tail = t->pre[id];
}

// id should > 0
void timer_start(Timer *t, uint32_t id) {
    t->start_time[id] = now;
    if (t->head == 0) {
        t->head = id;
        t->tail = id;
        t->nxt[id] = 0;
        t->pre[id] = 0;
        return;
    }
    t->pre[id] = t->tail;
    t->nxt[id] = 0;
    t->nxt[t->tail] = id;
    t->tail = id;
}

void timer_tick(Timer *t) {
    uint32_t id = t->head;
    while (id != 0) {
        if (_timer_expired(t, id)) {
            timer_stop(t, id);
            (*t->timeout)(t, id);
        }
        id = t->nxt[id];
    }
}