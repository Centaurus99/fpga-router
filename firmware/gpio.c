#include <stdbool.h>
#include <gpio.h>
#include <printf.h>

char gpio_decode(int d) {
    switch (d) {
        case 0x1: return '0';
        case 0x2: return '1';
        case 0x4: return '2';
        case 0x8: return '3';
        case 0x10: return '4';
        case 0x20: return '5';
        case 0x40: return '6';
        case 0x80: return '7';
        case 0x100: return '8';
        case 0x200: return '9';
        case 0x400: return 'a';
        case 0x800: return 'b';
        case 0x1000: return 'c';
        case 0x2000: return 'd';
        case 0x4000: return 'e';
        case 0x8000: return 'f';
        case 0x10000: return '\n';
        case 0x20000: return ' ';
        case 0x40000: return ':';
        case 0x80000: return '\b';
        default: return '?';
    }
}

char _getchar_gpio() {
    int d = GPIO_DATA;
    while (d & 0xff000000) {d = GPIO_DATA;}
    return gpio_decode(d);
}