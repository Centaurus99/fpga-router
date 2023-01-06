#ifndef __CHECKSUM_H__
#define __CHECKSUM_H__

#include "router.h"
#include <stdbool.h>

/**
 * @brief 进行 IPv6 + UDP/ICMPv6 的校验和的验证和更新
 * @param packet 完整的 IPv6 packet
 * @param len 即 packet 的长度，单位是字节
 * @return 校验和无误则返回 true ，有误则返回 false
 */
bool validateAndFillChecksum(volatile uint8_t *packet, uint32_t len);

#endif