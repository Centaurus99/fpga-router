#ifndef _ROUTER_H_
#define _ROUTER_H_

#include <header.h>
#include <stdint.h>

// 路由器端口配置地址
#define PORT_CONFIG_ADDR(i) (0x61000000 + i * 0x00000100)

#define MAC_ADDR(i) (((PortConfig *)PORT_CONFIG_ADDR(i))->mac)
#define EUI64_CTRL(i) (((volatile PortConfig *)PORT_CONFIG_ADDR(i))->eui64_ctrl)
#define LOCAL_IP(i) (((PortConfig *)PORT_CONFIG_ADDR(i))->local_ip)
#define GUA_IP(i) (((PortConfig *)PORT_CONFIG_ADDR(i))->gua_ip)

// 路由器端口配置结构体
typedef struct {
    mac_addr mac;
    uint16_t pad1;
    uint32_t eui64_ctrl;
    uint32_t pad2;
    in6_addr local_ip;
    in6_addr gua_ip;
} PortConfig;

/**
 * 初始化各端口配置
 */
void init_port_config();

/**
 * 根据链路层目的 MAC 地址判断数据包的接收端口
 * @return 接收端口号, 若无法判断则返回 0
 */
uint8_t get_receive_port();

/**
 * 根据 ICMP 错误类型生成 ICMP 错误包
 */
void icmp_error_gen();

/**
 * 路由器收发包维护程序主循环
 */
void mainloop();

#endif