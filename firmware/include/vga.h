#ifndef _VGA_H_
#define _VGA_H_

#include <stdbool.h>

#define VGA_BASE 0x30000000

#define VGA_W 800
#define VGA_H 600

#define VGA_DATA(n, m) (*(volatile char *)(VGA_BASE + (n) * VGA_W + (m)))
#define VGA_DATA_4(n, m) (*(volatile int *)(VGA_BASE + (n) * VGA_W + (m)))

#define VGA_C_W 7
#define VGA_C_H 14
#define VGA_LINE_H 14
#define VGA_COL 110
#define VGA_ROW 42
#define VGA_PAD_L 8
#define VGA_PAD_T 8

#define VGA_BLACK 0
#define VGA_WHITE 0xff
#define VGA_RED 0b11101101
#define VGA_GREEN 0b00011100
#define VGA_BLUE 0b01010111

bool update_pos(int n, int m, char c, char color); // 更新某个位置的字符

void flush(); // 重置屏幕

bool display_line(char *s); // 在新的一行显示字符串，如果行满了则返回 0

#endif