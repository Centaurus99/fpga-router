#include <assert.h>

void assert(bool c){
    if (!c)  1/0;
}