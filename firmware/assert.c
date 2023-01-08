#include <assert.h>
#include <gpio.h>
#include <printf.h>

void assert(bool c) {
    if (!c) {
        printf("Assertion failed!\r\n");
    }
}

void assert_id(bool c, unsigned char id) {
    if (!c) {
        printf("Assertion failed! id = %d\r\n", id);
        GPIO_DPY = id;
    }
}