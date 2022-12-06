#include <stdbool.h>
#include <gpio.h>
#include <vga.h>

#define GPIO_BASE 0x10000000

#define GPIO_DATA (*(volatile char *)(GPIO_BASE + 0))
#define GPIO_READY (*(volatile char *)(GPIO_BASE + 2))

char _getchar_() {
    while (!GPIO_READY);

    char c = GPIO_DATA;;

    if (c & 0b10000000) {
        return '\n';
    } else if (c & 0b01000000) {
        return ' ';
    } else if (c & 0b00100000) {
        return ':';
    } else if (c & 0b00010000) {
        return '\b';
    } else if (c > 9) {
        return 'a' + c - 10;
    } else {
        return '0' + c;
    }
}