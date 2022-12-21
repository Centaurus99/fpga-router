#include <vga.h>

extern char char_bitmap[95][VGA_C_H];

int line = 0;

bool update_pos(int n, int m, char c, char color) {
#ifdef ENABLE_VGA
    if (n >= VGA_ROW || m >= VGA_COL) return 0;
    int t = VGA_PAD_T + n * VGA_C_H;
    int l = VGA_PAD_L + m * VGA_C_W;
    for (int i = 0; i < VGA_C_H; i++) {
        for (int j = 0; j < VGA_C_W; j++) {
            VGA_DATA(t + i, l + j) = (char_bitmap[c-' '][i] & (1<<(VGA_C_W - j - 1))) ? 0 : color;
        }
    }
    return 1;
#endif
}

void flush() {
#ifdef ENABLE_VGA
    line = 0;
    for (int i = 0; i < VGA_H; i++) {
        for (int j = 0; j < VGA_W; j+=4) {
            VGA_DATA_4(i, j) = 0;
        }
    }
#endif
}

// bool display_line(char *s) {
// #ifdef ENABLE_VGA
//     if (line >= VGA_ROW - 3) return 0;
//     for (int i = 0; i < VGA_COL; i++) {
//         if (s[i] == 0 ) break;
//         update_pos(line, i, s[i]);
//     }
//     line++;
//     return 1;
// #endif
// }