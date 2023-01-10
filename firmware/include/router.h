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

extern mac_addr static_mac[4];
extern in6_addr static_local_ip[4];
extern in6_addr static_gua_ip[4];

#define RAM_MAC_ADDR(i) (static_mac[(i)])
#define RAM_LOCAL_IP(i) (static_local_ip[(i)])
#define RAM_GUA_IP(i) (static_gua_ip[(i)])

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
 *
 * \param release_lock 为 False 时, 结束后不释放 DMA 锁, 并确保已获得 DMA 锁
 */
void mainloop(bool release_lock);

/**
 * 检查是否为链路本地地址
 *
 * \param addr IPv6 地址
 * \return 是否为链路本地地址
 */
bool check_linklocal_address(const in6_addr addr);

/**
 * 检查是否为广播地址
 *
 * \param addr IPv6 地址
 * \return 是否为广播地址
 */
bool check_multicast_address(const in6_addr addr);

/**
 * 检查是否为路由器本机的链路本地地址
 *
 * \param addr IPv6 地址
 * \return 是否为路由器本机的链路本地地址
 */
bool check_own_address(const in6_addr addr);

#endif