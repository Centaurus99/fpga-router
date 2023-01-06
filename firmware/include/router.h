#ifndef _ROUTER_H_
#define _ROUTER_H_

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

// MAC address
typedef struct
{
    union {
        uint8_t __u6_addr8[16];
        uint16_t __u6_addr16[8];
    } __mac_u;
#define addr8 __mac_u.__u6_addr8
#define addr16 __mac_u.__u6_addr16
} mac_addr;

// IPv6 address
typedef struct
{
    union {
        uint8_t __u6_addr8[16];
        uint16_t __u6_addr16[8];
        uint32_t __u6_addr32[4];
    } __in6_u;
#define s6_addr __in6_u.__u6_addr8
#define s6_addr16 __in6_u.__u6_addr16
#define s6_addr32 __in6_u.__u6_addr32
} in6_addr;

// 以太网头
typedef struct {
    uint16_t mac_dst[3];
    uint16_t mac_src[3];
    uint16_t ethertype;
} EtherHeader;

// IPv6 头
typedef struct {
    uint8_t prefix_pad[4];
    uint16_t length;
    uint8_t next_header;
    uint8_t hop_limit;
    in6_addr ip_src;
    in6_addr ip_dst;
} IP6Header;

// ICMPv6 头
typedef struct {
    uint8_t type;
    uint8_t code;
    uint16_t checksum;
    uint16_t identifier;
    uint16_t sequence;
} ICMP6Header;

// UDP 头
typedef struct {
    uint16_t src;
    uint16_t dest;
    uint16_t length;
    uint16_t checksum;
} UDPHeader;

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