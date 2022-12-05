`ifndef _VGA_VH_
`define _VGA_VH_

// 表示一个像素点
typedef struct packed {
    logic [2:0] red;
    logic [2:0] green;
    logic [1:0] blue;
} pixel;

// 表示横向的四个像素点
// 800X600的图像中一共有200X600的像素个数
typedef struct packed {
    pixel pixel1;
    pixel pixel2;
    pixel pixel3;
    pixel pixel4;
} pixel_block;

// TODO: 也许未来可以把 VGA 的扫描和显示分开，改成两张图片

// typedef struct packed {
//     pixel_block pix;
//     logic [11:0] hdata;
//     logic [11:0] vdata;
//     logic valid;
// } stage_vga;

`endif
