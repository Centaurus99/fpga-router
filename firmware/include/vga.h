#ifndef _VGA_H_
#define _VGA_H_

#include <stdbool.h>

#define VGA_W 80
#define VGA_H 60

void update_pos(int n, int m, char c); // 更新某个位置的字符

void flush(); // 重置屏幕

bool display(char *s); // 在新的一行显示字符串，如果行满了则返回 0

#endif