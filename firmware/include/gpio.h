#ifndef _GPIO_H_
#define _GPIO_H_

#define GPIO_BASE 0x20000000

#define GPIO_DATA (*(volatile int *)(GPIO_BASE + 0))

char _getchar_gpio();

#endif