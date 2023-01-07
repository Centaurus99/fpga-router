#include <timer.h>

#define now (*(volatile uint32_t *)0x200BFF8)

uint32_t pool[3][LEAF_COUNT * 2];
uint32_t pool_header = 0;

bool _timer_expired(Timer *t, uint32_t id) {
    return now - t->start_time[id] >= t->interval;
}

Timer timer_init(void (*timeout)(int), uint32_t interval, uint32_t pool_size) {
    Timer t;
    t.head = 0;
    t.tail = 0;
    t.nxt = &pool[0][pool_header];
    t.pre = &pool[1][pool_header];
    t.start_time = &pool[2][pool_header];
    pool_header += pool_size;
    return t;
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
            t->timeout(id);
            timer_stop(t, id);
        }
        id = t->nxt[id];
    }
}