`timescale 1ns / 1ps
module tb_gpio;

    wire clk_50M, clk_11M0592;

    reg         push_btn;  // BTN5 按钮开关，带消抖电路，按下时为 1
    reg         reset_btn;  // BTN6 复位按钮，带消抖电路，按下时为 1

    reg  [ 3:0] touch_btn;  // BTN1~BTN4，按钮开关，按下时为 1
    reg  [31:0] dip_sw;  // 32 位拨码开关，拨到“ON”时为 1

    wire [15:0] leds;  // 16 位 LED，输出时 1 点亮
    wire [ 7:0] dpy0;  // 数码管低位信号，包括小数点，输出 1 点亮
    wire [ 7:0] dpy1;  // 数码管高位信号，包括小数点，输出 1 点亮

    logic locked, clk_10M, clk_20M;
    pll_example clock_gen (
        // Clock in ports
        .clk_in1 (clk_50M),    // 外部时钟输入
        // Clock out ports
        .clk_out1(clk_10M),    // 时钟输出 1，频率在 IP 配置界面中设置
        .clk_out2(clk_20M),    // 时钟输出 2，频率在 IP 配置界面中设置
        // Status and control signals
        .reset   (reset_btn),  // PLL 复位输入
        .locked  (locked)      // PLL 锁定指示输出，"1"表示时钟稳定，
                               // 后级电路复位信号应当由它生成（见下）
    );

    logic reset_of_clk10M;
    // 异步复位，同步释放，将 locked 信号转为后级电路的复位 reset_of_clk10M
    always_ff @(posedge clk_10M or negedge locked) begin
        if (~locked) reset_of_clk10M <= 1'b1;
        else reset_of_clk10M <= 1'b0;
    end

    logic sys_clk;
    assign sys_clk = clk_10M;

    wire sys_rst_without_bufg;
    wire sys_rst;
    // 异步复位同步释放
    reset_sync reset_sync_reset_core (
        .clk(sys_clk),
        .i  (reset_of_clk10M),
        .o  (sys_rst_without_bufg)
    );
    // 使用 BUFG 优化 reset 信号布线
    BUFG BUFG_inst_eth (
        .O(sys_rst),              // 1-bit output: Clock output
        .I(sys_rst_without_bufg)  // 1-bit input: Clock input
    );

    initial begin
        // 在这里可以自定义测试输入序列，例如：
        dip_sw    = 32'h0;
        touch_btn = 0;
        reset_btn = 0;
        push_btn  = 0;

        #100;
        reset_btn = 1;
        #100;
        reset_btn = 0;
        #1000;

        for (integer i = 0; i < 4; i ++) begin
            #100;  // 等待 100ns
            touch_btn[i] = 1;  // 按下 push_btn 按钮
            #100;  // 等待 100ns
            touch_btn[i] = 0;  // 松开 push_btn 按钮
        end

        for (integer i = 0; i < 32; i ++) begin
            #100;  // 等待 100ns
            dip_sw[i] = 1;  // 按下 push_btn 按钮
            #100;  // 等待 100ns
            dip_sw[i] = 0;  // 松开 push_btn 按钮
        end

        #10000 $finish;
    end

    // GPIO模块
    gpio gpio(

        .clk(sys_clk),
        .rst(sys_rst),

        // Wishbone slave (to MUX)
        .wb_cyc_i(),
        .wb_stb_i(),
        .wb_ack_o(),
        .wb_adr_i(),
        .wb_dat_i(),
        .wb_dat_o(),
        .wb_sel_i(),
        .wb_we_i (),

        // GPIO
        .touch_btn(touch_btn),
        .dip_sw   (dip_sw),
        .leds     (leds),
        .dpy0     (dpy0),
        .dpy1     (dpy1)
    );

    // 时钟源
    clock osc (
        .clk_11M0592(clk_11M0592),
        .clk_50M    (clk_50M)
    );

endmodule
