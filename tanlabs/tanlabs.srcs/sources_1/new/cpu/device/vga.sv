`timescale 1ns / 1ps

`include "vga.vh"

module vga #(
    parameter WIDTH = 12,  // WIDTH: bits in register hdata & vdata
    parameter HSIZE = 800,  // HSIZE: horizontal size of visible field 
    parameter HFP = 856,  // HFP: horizontal front of pulse
    parameter HSP = 976,  // HSP: horizontal stop of pulse
    parameter HMAX = 1040,  // HMAX: horizontal max size of value
    parameter VSIZE = 600,  // VSIZE: vertical size of visible field 
    parameter VFP = 637,  // VFP: vertical front of pulse
    parameter VSP = 643,  // VSP: vertical stop of pulse
    parameter VMAX = 666,  // VMAX: vertical max size of value
    parameter HSPP = 1,  // HSPP: horizontal synchro pulse polarity (0 - negative, 1 - positive)
    parameter VSPP = 1,  // VSPP: vertical synchro pulse polarity (0 - negative, 1 - positive)
    parameter DATA_WIDTH = 32,  // DATA_WIDTH: wishbone data width
    parameter ADDR_WIDTH = 32  // DATA_WIDTH: wishbone data width
) (
    input wire cpu_clk,  // CPU 时钟
    input wire cpu_rst,  // 重置 WISHBONE 的状态
    input wire vga_clk,  // VGA 时钟
    input wire vga_rst,  // 将 VGA 扫描位置重置至 1X1，目前与 CPU 的 RESET 绑定，之后可能可以有变化

    // wishbone slave interface
    input  wire                    wb_cyc_i,
    input  wire                    wb_stb_i,
    output reg                     wb_ack_o,
    input  wire [  ADDR_WIDTH-1:0] wb_adr_i,
    input  wire [  DATA_WIDTH-1:0] wb_dat_i,
    output reg  [  DATA_WIDTH-1:0] wb_dat_o,
    input  wire [DATA_WIDTH/8-1:0] wb_sel_i,
    input  wire                    wb_we_i,

    // vga scanner interface
    output wire [2:0] video_red,    // 红色像素，3 位
    output wire [2:0] video_green,  // 绿色像素，3 位
    output wire [1:0] video_blue,   // 蓝色像素，2 位
    output wire       video_hsync,  // 行同步（水平同步）信号
    output wire       video_vsync,  // 场同步（垂直同步）信号
    output wire       video_clk,    // 像素时钟输出
    output wire       video_de      // 行数据有效信号，用于区分消隐区
);

    logic              graph_en_a;
    logic              graph_we_a;
    logic       [16:0] graph_addr_a;
    pixel_block        graph_din_a;
    pixel_block        graph_dout_a;

    logic              graph_en_b;
    logic              graph_we_b;
    logic       [16:0] graph_addr_b;
    pixel_block        graph_din_b;
    pixel_block        graph_dout_b;

    // 这个BRAM的A端口对应CPU的读写，B端口对应VGA的扫描（只用于读）

    vga_graph_data vga_graph_data_0 (
        .clka (cpu_clk),       // input wire clka
        .ena  (graph_en_a),    // input wire ena
        .wea  (graph_we_a),    // input wire [0 : 0] wea
        .addra(graph_addr_a),  // input wire [16 : 0] addra
        .dina (graph_din_a),   // input wire [31 : 0] dina
        .douta(graph_dout_a),  // output wire [31 : 0] douta
        .clkb (vga_clk),       // input wire clkb
        .enb  (graph_en_b),    // input wire enb
        .web  (graph_we_b),    // input wire [0 : 0] web
        .addrb(graph_addr_b),  // input wire [16 : 0] addrb
        .dinb (graph_din_b),   // input wire [31 : 0] dinb
        .doutb(graph_dout_b)   // output wire [31 : 0] doutb
    );

    // CPU 的 WISHBONE 读写

    typedef enum {
        ST_IDLE,
        ST_WAIT,
        ST_READ,
        ST_WRITE
    } vga_slave_state_t;

    vga_slave_state_t state;

    // 地址映射
    assign graph_en_a   = 1'b1;
    assign graph_addr_a = wb_adr_i[18:2];

    always_comb begin
        // 连接输出信号
        wb_dat_o[31:24] = wb_sel_i[3] ? graph_dout_a.pixel1 : 8'h00;
        wb_dat_o[23:16] = wb_sel_i[2] ? graph_dout_a.pixel2 : 8'h00;
        wb_dat_o[15:8]  = wb_sel_i[1] ? graph_dout_a.pixel3 : 8'h00;
        wb_dat_o[7:0]   = wb_sel_i[0] ? graph_dout_a.pixel4 : 8'h00;
    end

    always_comb begin
        // 连接写入信号
        graph_din_a.pixel1 = wb_sel_i[3] ? wb_dat_i[31:24] : graph_dout_a.pixel1;
        graph_din_a.pixel2 = wb_sel_i[2] ? wb_dat_i[23:16] : graph_dout_a.pixel2;
        graph_din_a.pixel3 = wb_sel_i[1] ? wb_dat_i[15:8] : graph_dout_a.pixel3;
        graph_din_a.pixel4 = wb_sel_i[0] ? wb_dat_i[7:0] : graph_dout_a.pixel4;
    end

    assign wb_ack_o = (wb_cyc_i & wb_stb_i) && ((state == ST_READ) || (state == ST_WRITE));

    always_ff @(posedge cpu_clk) begin
        if (cpu_rst) begin
            graph_we_a <= 1'b0;
            state      <= ST_IDLE;
        end else begin
            case (state)
                ST_IDLE: begin
                    state <= ST_WAIT;
                end
                ST_WAIT: begin
                    if (wb_cyc_i & wb_stb_i) begin
                        if (wb_we_i == 1'b0) begin
                            state <= ST_READ;
                        end else begin
                            graph_we_a <= 1'b1;
                            state      <= ST_WRITE;
                        end
                    end
                end
                ST_READ: begin
                    state <= ST_IDLE;
                end
                ST_WRITE: begin
                    graph_we_a <= 1'b0;
                    state      <= ST_IDLE;
                end
                default: begin
                    // 理论上不能来这里
                    state <= ST_IDLE;
                end
            endcase
        end
    end

    // VGA 扫描：从 BRAM 中读取数据， 组合逻辑显示到屏幕上

    // logic              is_scanner_movable;  // 横纵坐标平移信号
    // logic       [11:0] hdata;  // 图像的横坐标
    // logic       [11:0] vdata;  // 图像的纵坐标
    pixel_block color_block;  // 一团颜色
    pixel       color;  // 单一点位的颜色

    typedef enum {
        SCAN_ST_IDLE,
        SCAN_ST_READ,
        SCAN_ST_READ2,
        SCAN_ST_MOVE_READER
    } vga_reader_state_t;

    typedef enum {
        SCAN_ST_0,
        SCAN_ST_1,
        SCAN_ST_2,
        SCAN_ST_3
    } vga_scanner_state_t;

    vga_scanner_state_t scanner_state;
    vga_reader_state_t  reader_state;

    assign graph_en_b = 1'b1;
    assign graph_we_b = 1'b0;
    assign graph_addr_b = ({5'b0, read.hdata} >> 2) + ({5'b0, read.vdata} << 3) + ({5'b0, read.vdata} << 6) +  ({5'b0, read.vdata} << 7); // (hdata + vdata * 800) / 4
    assign graph_din_b = 32'h0000_0000;

    stage_vga read;

    // always_ff @(posedge vga_clk) begin
    //     if (vga_rst) begin
    //         hdata  <= 0;
    //         vdata  <= 0;
    //     end else if (is_scanner_movable) begin
    //         if (hdata == (HMAX - 1)) begin
    //             if (vdata == (VMAX - 1)) begin
    //                 hdata  <= 0;
    //                 vdata  <= 0;
    //             end else begin
    //                 hdata  <= 0;
    //                 vdata  <= vdata + 1;
    //             end
    //         end else begin
    //             hdata  <= hdata + 1;
    //         end
    //     end
    // end
    // TODO: 将 hsync 和 vsync 与原始的 hdata 和 vdata 解绑

    always_ff @(posedge vga_clk) begin
        if (vga_rst) begin
            reader_state <= SCAN_ST_IDLE;
            read.hdata   <= 0;
            read.vdata   <= 0;
            scan.valid   <= 1'b1;
        end else begin
            case (reader_state)
                SCAN_ST_IDLE: begin
                    reader_state <= SCAN_ST_READ;
                end
                SCAN_ST_READ: begin
                    reader_state <= SCAN_ST_READ2;
                end
                SCAN_ST_READ2: begin
                    // 这个时钟上升沿沿将返回数据
                    reader_state <= SCAN_ST_MOVE_READER;
                    scan.pix     <= graph_dout_b;
                    scan.hdata   <= read.hdata;
                    scan.vdata   <= read.vdata;
                end
                SCAN_ST_MOVE_READER: begin
                    reader_state <= SCAN_ST_IDLE;
                    if (read.hdata == (HMAX - 4)) begin
                        if (read.vdata == (VMAX - 1)) begin
                            read.hdata <= 0;
                            read.vdata <= 0;
                        end else begin
                            read.hdata <= 0;
                            read.vdata <= read.vdata + 1;
                        end
                    end else begin
                        read.hdata <= read.hdata + 4;
                    end
                end
            endcase
        end
    end

    stage_vga scan;

    assign color_block = scan.pix;

    always_ff @(posedge vga_clk) begin
        if (vga_rst) begin
            scanner_state <= SCAN_ST_0;
        end else begin
            case (scanner_state)
                SCAN_ST_0: begin
                    color         <= color_block.pixel1;
                    scanner_state <= SCAN_ST_1;
                end
                SCAN_ST_1: begin
                    color         <= color_block.pixel2;
                    scanner_state <= SCAN_ST_2;
                end
                SCAN_ST_2: begin
                    color         <= color_block.pixel3;
                    scanner_state <= SCAN_ST_3;
                end
                SCAN_ST_3: begin
                    color         <= color_block.pixel4;
                    scanner_state <= SCAN_ST_0;
                end
            endcase
        end
    end

    assign video_clk   = vga_clk;

    assign video_red   = color.red;  // 红色
    assign video_green = color.green;  // 绿色
    assign video_blue  = color.blue;  // 蓝色

    assign video_hsync = ((scan.hdata >= HFP) && (scan.hdata < HSP)) ? HSPP : !HSPP;
    assign video_vsync = ((scan.vdata >= VFP) && (scan.vdata < VSP)) ? VSPP : !VSPP;
    assign video_de    = ((scan.hdata < HSIZE) & (scan.vdata < VSIZE));

endmodule
