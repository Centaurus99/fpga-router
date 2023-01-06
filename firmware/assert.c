#include <assert.h>
#include <printf.h>

void assert(bool c){
    if (!c) {
        printf("Assertion failed!");
    }
}

void assert_id(bool c, unsigned char id){
    if (!c) {
        printf("Assertion failed! id = %d", id);
    }
}