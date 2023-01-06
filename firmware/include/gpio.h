#ifndef _GPIO_H_
#define _GPIO_H_

#define GPIO_BASE 0x20000000

#define GPIO_DATA (*(volatile int *)(GPIO_BASE + 0))
#define GPIO_LED (*(volatile int *)(GPIO_BASE + 4))
#define GPIO_DPY (*(volatile int *)(GPIO_BASE + 8))

char gpio_decode(int d);

char _getchar_gpio();

#endif