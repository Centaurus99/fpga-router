#ifndef _DMA_H_
#define _DMA_H_

#include "stdint.h"
#include <stdbool.h>

// DMA 控制 / 存储地址
#define DMA_CTRL_ADDR 0x62000000
#define DMA_BASE_ADDR 0x68000000

#define DMA_CTRL (*(volatile uint8_t *)(DMA_CTRL_ADDR + 0))
#define DMA_LEN (*(volatile uint32_t *)(DMA_BASE_ADDR + 0))

#define DMA_PTR ((volatile uint8_t *)(DMA_BASE_ADDR + 4))

// DMA 控制寄存器的定义
#define DMA_REG_WAIT_ROUTER 0x08 /* 等待 Router 读取 */
#define DMA_REG_WAIT_CPU 0x04    /* 等待 CPU 读取 */
#define DMA_REG_ROUTER_LOCK 0x02 /* Router 锁 */
#define DMA_REG_CPU_LOCK 0x01    /* CPU 锁 */

/**
 * 请求获得 DMA 缓存区的写入锁
 * 请求不保证成功, 须读取验证
 *
 * \return 是否请求成功
 */
bool dma_lock_request();

/**
 * 告知发送完成, 将 DMA 缓存区的写入锁释放, 并拉高 [等待 Router 读取] 标志位
 */
void dma_send_finish();

/**
 * 查询 [等待 CPU 读取] 标志位
 *
 * \return 是否需要读取
 */
bool dma_read_need();

/**
 * 告知读取完成, 将拉低 [等待 CPU 读取] 标志位
 */
void dma_read_finish();

/**
 * 指定 DMA 发包端口
 * \param port 端口号, 0-3
 */
void dma_set_out_port(uint8_t port);

/**
 * DMA 串口交互程序, 用于测试
 */
void dma_demo();

#endif
