#ifndef _ROUTER_H_
#define _ROUTER_H_

#include "header.h"
#include <stdint.h>

// 路由器端口配置地址
#define PORT_CONFIG_ADDR(i) (0x61000000 + i * 0x00000100)

// 路由器端口配置结构体
typedef struct {
    uint32_t mac[2];
    uint32_t eui64_ctrl;
    uint32_t padding;
    uint32_t local_ip[4];
    uint32_t gua_ip[4];
} PortConfig;

/**
 * 初始化各端口配置
 */
void init_port_config();

/**
 * 根据 ICMP 错误类型生成 ICMP 错误包
 */
void icmp_error_gen();

/**
 * 路由器收发包维护程序主循环
 */
void mainloop();

#endif