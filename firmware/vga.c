#include <vga.h>

int line = 0;

void update_pos(int n, int m, char c) {
    // TODO
}

void flush() {
    line = 0;
    for (int i = 0; i < VGA_H; i++) {
        for (int j = 0; j < VGA_W; j++) {
            update_pos(i, j, 0);
        }
    }
}

bool display(char *s) {
    if (line >= VGA_H - 1) return 0;
    for (int i = 0; i < VGA_W; i++) {
        update_pos(line, i, s[i]);
    }
    line++;
    return 1;
}