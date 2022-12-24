#include <dma.h>

bool dma_lock_request() {
    DMA_CTRL = DMA_REG_CPU_LOCK;
    return (DMA_CTRL & DMA_REG_CPU_LOCK);
}

void dma_send_finish() { DMA_CTRL = DMA_REG_WAIT_ROUTER; }

bool dma_read_need() { return (DMA_CTRL & DMA_REG_WAIT_CPU); }

void dma_read_finish() { DMA_CTRL = DMA_REG_WAIT_CPU; }
