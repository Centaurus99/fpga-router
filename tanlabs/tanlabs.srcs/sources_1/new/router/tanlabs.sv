`timescale 1ns / 1ps

/* Tsinghua Advanced Networking Labs */

module tanlabs #(
    parameter EXT_RAM_FOR_LEAF = 1,  // 将 ExtRAM 作为叶节点
    parameter ENABLE_VGA = 0,  // 启用 VGA (占用显存)
    parameter SIM = 0,  // 仿真模式
    parameter SYS_CLK_FREQ = 95_000_000,  // CPU 时钟频率
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32,

    parameter SRAM_ADDR_WIDTH = 20,
    parameter SRAM_DATA_WIDTH = 32,

    localparam SRAM_BYTES      = SRAM_DATA_WIDTH / 8,
    localparam SRAM_BYTE_WIDTH = $clog2(SRAM_BYTES)
) (
    input wire gtrefclk_p,
    input wire gtrefclk_n,

    // SFP:
    // +-+-+
    // |0|2|
    // +-+-+
    // |1|3|
    // +-+-+
    input  wire [3:0] sfp_rx_los,
    input  wire [3:0] sfp_rx_p,
    input  wire [3:0] sfp_rx_n,
    output wire [3:0] sfp_tx_disable,
    output wire [3:0] sfp_tx_p,
    output wire [3:0] sfp_tx_n,
    output wire [7:0] sfp_led,         // 0 1  2 3  4 5  6 7

    // unused.
    input wire sfp_sda,
    input wire sfp_scl,

    input wire clk_50M,     // 50MHz 时钟输入
    input wire clk_11M0592, // 11.0592MHz 时钟输入（备用，可不用）

    input wire push_btn,  // BTN5 按钮开关，带消抖电路，按下时为 1
    input wire reset_btn, // BTN6 复位按钮，带消抖电路，按下时为 1

    output wire [15:0] leds,
    output wire [ 7:0] dpy0,  // 数码管低位信号，包括小数点，输出 1 点亮
    output wire [ 7:0] dpy1,  // 数码管高位信号，包括小数点，输出 1 点亮

    input wire [ 3:0] touch_btn,  // BTN1~BTN4，按钮开关，按下时为 1
    input wire [15:0] dip_sw,     // 32 位拨码开关，拨到“ON”时为 1

    // CPLD 串口控制器信号
    output wire uart_rdn,        // 读串口信号，低有效
    output wire uart_wrn,        // 写串口信号，低有效
    input  wire uart_dataready,  // 串口数据准备好
    input  wire uart_tbre,       // 发送数据标志
    input  wire uart_tsre,       // 数据发送完毕标志

    // BaseRAM 信号
    inout wire [31:0] base_ram_data,  // BaseRAM 数据，低 8 位与 CPLD 串口控制器共享
    output wire [19:0] base_ram_addr,  // BaseRAM 地址
    output wire [3:0] base_ram_be_n,  // BaseRAM 字节使能，低有效。如果不使用字节使能，请保持为 0
    output wire base_ram_ce_n,  // BaseRAM 片选，低有效
    output wire base_ram_oe_n,  // BaseRAM 读使能，低有效
    output wire base_ram_we_n,  // BaseRAM 写使能，低有效

    // ExtRAM 信号
    inout wire [31:0] ext_ram_data,  // ExtRAM 数据
    output wire [19:0] ext_ram_addr,  // ExtRAM 地址
    output wire [3:0] ext_ram_be_n,  // ExtRAM 字节使能，低有效。如果不使用字节使能，请保持为 0
    output wire ext_ram_ce_n,  // ExtRAM 片选，低有效
    output wire ext_ram_oe_n,  // ExtRAM 读使能，低有效
    output wire ext_ram_we_n,  // ExtRAM 写使能，低有效

    // 直连串口信号
    output wire txd,  // 直连串口发送端
    input  wire rxd,  // 直连串口接收端

    // Flash 存储器信号，参考 JS28F640 芯片手册
    output wire [22:0] flash_a,  // Flash 地址，a0 仅在 8bit 模式有效，16bit 模式无意义
    inout wire [15:0] flash_d,  // Flash 数据
    output wire flash_rp_n,  // Flash 复位信号，低有效
    output wire flash_vpen,  // Flash 写保护信号，低电平时不能擦除、烧写
    output wire flash_ce_n,  // Flash 片选信号，低有效
    output wire flash_oe_n,  // Flash 读使能信号，低有效
    output wire flash_we_n,  // Flash 写使能信号，低有效
    output wire flash_byte_n, // Flash 8bit 模式选择，低有效。在使用 flash 的 16 位模式时请设为 1

    // 图像输出信号
    output wire [2:0] video_red,    // 红色像素，3 位
    output wire [2:0] video_green,  // 绿色像素，3 位
    output wire [1:0] video_blue,   // 蓝色像素，2 位
    output wire       video_hsync,  // 行同步（水平同步）信号
    output wire       video_vsync,  // 场同步（垂直同步）信号
    output wire       video_clk,    // 像素时钟输出
    output wire       video_de      // 行数据有效信号，用于区分消隐区

);
    wire [15:0] gpio_leds;
    wire [15:0] flash_leds;
    wire [15:0] debug_leds;
    assign leds = gpio_leds | flash_leds | debug_leds;

    localparam DATA_WIDTH = 64;
    localparam ID_WIDTH = 3;

    wire [4:0] debug_ingress_interconnect_ready;
    wire debug_datapath_fifo_ready;
    wire debug_egress_interconnect_ready;

    wire [31:0] cpu_fifo_count;  // LED 15 ~ 8
    wire [7:0] debug_forwarding_table_core;  // LED 15 ~ 8
    wire debug_forwarding_table_eth;  // LED 7
    wire debug_dma_user_error_led;  // LED 6
    wire debug_datapath_ingress_drop_led;  // LED 5
    wire [4:0] debug_egress_drop_led;  // LED 4 ~ 0

    /* =========== CLOCK and RST =========== */
    wire reset_in = reset_btn;
    wire locked;
    wire gtref_clk;  // 125MHz for the PHY/MAC IP core
    wire ref_clk;  // 200MHz for the PHY/MAC IP core
    wire core_clk;  // README: This is for CPU and other components. You can change the frequency
    wire vga_clk;  // 40MHz for the VGA
    // by re-customizing the following IP core.

    clk_wiz_0 clk_wiz_0_i (
        .ref_clk_out(ref_clk),
        .clk_out2   (core_clk),
        .clk_out3   (vga_clk),
        .reset      (1'b0),
        .locked     (locked),
        .clk_in1    (gtref_clk)
    );

    wire reset_not_sync;
    assign reset_not_sync = reset_in || !locked;  // reset components

    wire mmcm_locked_out;
    wire rxuserclk_out;
    wire rxuserclk2_out;
    wire userclk_out;
    wire userclk2_out;
    wire pma_reset_out;
    wire gt0_pll0outclk_out;
    wire gt0_pll0outrefclk_out;
    wire gt0_pll1outclk_out;
    wire gt0_pll1outrefclk_out;
    wire gt0_pll0lock_out;
    wire gt0_pll0refclklost_out;
    wire gtref_clk_out;
    wire gtref_clk_buf_out;

    assign gtref_clk = gtref_clk_buf_out;
    wire eth_clk = userclk2_out;  // README: This is the main clock for frame processing logic,
    // 125MHz generated by the PHY/MAC IP core. 8 AXI-Streams are in this clock domain.

    wire reset_eth_not_sync;
    assign reset_eth_not_sync = reset_in || !mmcm_locked_out;
    wire reset_eth_without_bufg;
    wire reset_eth;

    reset_sync reset_sync_reset_eth (
        .clk(eth_clk),
        .i  (reset_eth_not_sync),
        .o  (reset_eth_without_bufg)
    );

    BUFG BUFG_inst_eth (
        .I(reset_eth_without_bufg),  // 1-bit input: Clock input
        .O(reset_eth)                // 1-bit output: Clock output
    );

    wire reset_core_from_eth;  // eth 复位时 CPU 也须保持复位
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF(4),
        .INIT_SYNC_FF(0),
        .RST_ACTIVE_HIGH(1)
    ) xpm_cdc_async_rst_inst (
        .dest_arst(reset_core_from_eth),
        .dest_clk (core_clk),
        .src_arst (reset_eth)
    );

    wire wait_flash;  // 正在加载 flash, CPU 其余组件复位
    wire reset_core_not_sync;
    assign reset_core_not_sync = reset_not_sync | reset_core_from_eth;
    wire reset_core_without_bufg;  // 被用于 flash / SRAM 的复位
    wire reset_core;  // 需等待 flash 加载完成后才能结束复位

    reset_sync reset_sync_reset_core (
        .clk(core_clk),
        .i  (reset_core_not_sync),
        .o  (reset_core_without_bufg)
    );

    BUFG BUFG_inst_core (
        .I(reset_core_without_bufg | wait_flash),  // 1-bit input: Clock input
        .O(reset_core)                             // 1-bit output: Clock output
    );

    /* =========== ETH =========== */
    wire [7:0] eth_tx8_data [0:4];
    wire       eth_tx8_last [0:4];
    wire       eth_tx8_ready[0:4];
    wire       eth_tx8_user [0:4];
    wire       eth_tx8_valid[0:4];

    wire [7:0] eth_rx8_data [0:4];
    wire       eth_rx8_last [0:4];
    wire       eth_rx8_user [0:4];
    wire       eth_rx8_valid[0:4];

    genvar i;
    generate
        if (!SIM) begin : phy_mac_ip_cores
            // Instantiate 4 PHY/MAC IP cores.

            assign sfp_tx_disable[0] = 1'b0;
            axi_ethernet_0 axi_ethernet_0_i (
                .mac_irq    (),
                .tx_mac_aclk(),
                .rx_mac_aclk(),
                .tx_reset   (),
                .rx_reset   (),

                .glbl_rst(reset_not_sync),

                .mmcm_locked_out       (mmcm_locked_out),
                .rxuserclk_out         (rxuserclk_out),
                .rxuserclk2_out        (rxuserclk2_out),
                .userclk_out           (userclk_out),
                .userclk2_out          (userclk2_out),
                .pma_reset_out         (pma_reset_out),
                .gt0_pll0outclk_out    (gt0_pll0outclk_out),
                .gt0_pll0outrefclk_out (gt0_pll0outrefclk_out),
                .gt0_pll1outclk_out    (gt0_pll1outclk_out),
                .gt0_pll1outrefclk_out (gt0_pll1outrefclk_out),
                .gt0_pll0lock_out      (gt0_pll0lock_out),
                .gt0_pll0refclklost_out(gt0_pll0refclklost_out),
                .gtref_clk_out         (gtref_clk_out),
                .gtref_clk_buf_out     (gtref_clk_buf_out),

                .ref_clk(ref_clk),

                .s_axi_lite_resetn(~reset_eth),
                .s_axi_lite_clk   (eth_clk),
                .s_axi_araddr     (0),
                .s_axi_arready    (),
                .s_axi_arvalid    (0),
                .s_axi_awaddr     (0),
                .s_axi_awready    (),
                .s_axi_awvalid    (0),
                .s_axi_bready     (0),
                .s_axi_bresp      (),
                .s_axi_bvalid     (),
                .s_axi_rdata      (),
                .s_axi_rready     (0),
                .s_axi_rresp      (),
                .s_axi_rvalid     (),
                .s_axi_wdata      (0),
                .s_axi_wready     (),
                .s_axi_wvalid     (0),

                .s_axis_tx_tdata (eth_tx8_data[0]),
                .s_axis_tx_tlast (eth_tx8_last[0]),
                .s_axis_tx_tready(eth_tx8_ready[0]),
                .s_axis_tx_tuser (eth_tx8_user[0]),
                .s_axis_tx_tvalid(eth_tx8_valid[0]),

                .m_axis_rx_tdata (eth_rx8_data[0]),
                .m_axis_rx_tlast (eth_rx8_last[0]),
                .m_axis_rx_tuser (eth_rx8_user[0]),
                .m_axis_rx_tvalid(eth_rx8_valid[0]),

                .s_axis_pause_tdata (0),
                .s_axis_pause_tvalid(0),

                .rx_statistics_statistics_data (),
                .rx_statistics_statistics_valid(),
                .tx_statistics_statistics_data (),
                .tx_statistics_statistics_valid(),

                .tx_ifg_delay (8'h00),
                .status_vector(),
                .signal_detect(~sfp_rx_los[0]),

                .sfp_rxn(sfp_rx_n[0]),
                .sfp_rxp(sfp_rx_p[0]),
                .sfp_txn(sfp_tx_n[0]),
                .sfp_txp(sfp_tx_p[0]),

                .mgt_clk_clk_n(gtrefclk_n),
                .mgt_clk_clk_p(gtrefclk_p)
            );

            for (i = 1; i < 4; i = i + 1) begin
                assign sfp_tx_disable[i] = 1'b0;
                axi_ethernet_noshared axi_ethernet_noshared_i (
                    .mac_irq    (),
                    .tx_mac_aclk(),
                    .rx_mac_aclk(),
                    .tx_reset   (),
                    .rx_reset   (),

                    .glbl_rst(reset_not_sync),

                    .mmcm_locked          (mmcm_locked_out),
                    .mmcm_reset_out       (),
                    .rxuserclk            (rxuserclk_out),
                    .rxuserclk2           (rxuserclk2_out),
                    .userclk              (userclk_out),
                    .userclk2             (userclk2_out),
                    .pma_reset            (pma_reset_out),
                    .rxoutclk             (),
                    .txoutclk             (),
                    .gt0_pll0outclk_in    (gt0_pll0outclk_out),
                    .gt0_pll0outrefclk_in (gt0_pll0outrefclk_out),
                    .gt0_pll1outclk_in    (gt0_pll1outclk_out),
                    .gt0_pll1outrefclk_in (gt0_pll1outrefclk_out),
                    .gt0_pll0lock_in      (gt0_pll0lock_out),
                    .gt0_pll0refclklost_in(gt0_pll0refclklost_out),
                    .gt0_pll0reset_out    (),
                    .gtref_clk            (gtref_clk_out),
                    .gtref_clk_buf        (gtref_clk_buf_out),

                    .ref_clk(ref_clk),

                    .s_axi_lite_resetn(~reset_eth),
                    .s_axi_lite_clk   (eth_clk),
                    .s_axi_araddr     (0),
                    .s_axi_arready    (),
                    .s_axi_arvalid    (0),
                    .s_axi_awaddr     (0),
                    .s_axi_awready    (),
                    .s_axi_awvalid    (0),
                    .s_axi_bready     (0),
                    .s_axi_bresp      (),
                    .s_axi_bvalid     (),
                    .s_axi_rdata      (),
                    .s_axi_rready     (0),
                    .s_axi_rresp      (),
                    .s_axi_rvalid     (),
                    .s_axi_wdata      (0),
                    .s_axi_wready     (),
                    .s_axi_wvalid     (0),

                    .s_axis_tx_tdata (eth_tx8_data[i]),
                    .s_axis_tx_tlast (eth_tx8_last[i]),
                    .s_axis_tx_tready(eth_tx8_ready[i]),
                    .s_axis_tx_tuser (eth_tx8_user[i]),
                    .s_axis_tx_tvalid(eth_tx8_valid[i]),

                    .m_axis_rx_tdata (eth_rx8_data[i]),
                    .m_axis_rx_tlast (eth_rx8_last[i]),
                    .m_axis_rx_tuser (eth_rx8_user[i]),
                    .m_axis_rx_tvalid(eth_rx8_valid[i]),

                    .s_axis_pause_tdata (0),
                    .s_axis_pause_tvalid(0),

                    .rx_statistics_statistics_data (),
                    .rx_statistics_statistics_valid(),
                    .tx_statistics_statistics_data (),
                    .tx_statistics_statistics_valid(),

                    .tx_ifg_delay (8'h00),
                    .status_vector(),
                    .signal_detect(~sfp_rx_los[i]),

                    .sfp_rxn(sfp_rx_n[i]),
                    .sfp_rxp(sfp_rx_p[i]),
                    .sfp_txn(sfp_tx_n[i]),
                    .sfp_txp(sfp_tx_p[i])
                );
            end
        end else begin : axis_models
            // For simulation.
            assign gtref_clk_buf_out = gtrefclk_p;
            assign userclk2_out      = gtrefclk_p;
            assign mmcm_locked_out   = 1'b1;

            assign sfp_tx_disable    = 0;
            assign sfp_tx_p          = 0;
            assign sfp_tx_n          = 0;

            wire [    DATA_WIDTH - 1:0] in_data;
            wire [DATA_WIDTH / 8 - 1:0] in_keep;
            wire                        in_last;
            wire [DATA_WIDTH / 8 - 1:0] in_user;
            wire [      ID_WIDTH - 1:0] in_id;
            wire                        in_valid;
            wire                        in_ready;

            axis_model axis_model_i (
                .clk  (eth_clk),
                .reset(reset_eth),

                .m_data (in_data),
                .m_keep (in_keep),
                .m_last (in_last),
                .m_user (in_user),
                .m_id   (in_id),
                .m_valid(in_valid),
                .m_ready(in_ready)
            );

            wire [    DATA_WIDTH - 1:0] sim_tx_data [0:3];
            wire [DATA_WIDTH / 8 - 1:0] sim_tx_keep [0:3];
            wire                        sim_tx_last [0:3];
            wire                        sim_tx_ready[0:3];
            wire [DATA_WIDTH / 8 - 1:0] sim_tx_user [0:3];
            wire                        sim_tx_valid[0:3];

            axis_interconnect_egress axis_interconnect_sim_in_i (
                .ACLK   (eth_clk),
                .ARESETN(~reset_eth),

                .S00_AXIS_ACLK   (eth_clk),
                .S00_AXIS_ARESETN(~reset_eth),
                .S00_AXIS_TVALID (in_valid),
                .S00_AXIS_TREADY (in_ready),
                .S00_AXIS_TDATA  (in_data),
                .S00_AXIS_TKEEP  (in_keep),
                .S00_AXIS_TLAST  (in_last),
                .S00_AXIS_TDEST  (in_id),
                .S00_AXIS_TUSER  (in_user),

                .M00_AXIS_ACLK   (eth_clk),
                .M00_AXIS_ARESETN(~reset_eth),
                .M00_AXIS_TVALID (sim_tx_valid[0]),
                .M00_AXIS_TREADY (sim_tx_ready[0]),
                .M00_AXIS_TDATA  (sim_tx_data[0]),
                .M00_AXIS_TKEEP  (sim_tx_keep[0]),
                .M00_AXIS_TLAST  (sim_tx_last[0]),
                .M00_AXIS_TDEST  (),
                .M00_AXIS_TUSER  (sim_tx_user[0]),

                .M01_AXIS_ACLK   (eth_clk),
                .M01_AXIS_ARESETN(~reset_eth),
                .M01_AXIS_TVALID (sim_tx_valid[1]),
                .M01_AXIS_TREADY (sim_tx_ready[1]),
                .M01_AXIS_TDATA  (sim_tx_data[1]),
                .M01_AXIS_TKEEP  (sim_tx_keep[1]),
                .M01_AXIS_TLAST  (sim_tx_last[1]),
                .M01_AXIS_TDEST  (),
                .M01_AXIS_TUSER  (sim_tx_user[1]),

                .M02_AXIS_ACLK   (eth_clk),
                .M02_AXIS_ARESETN(~reset_eth),
                .M02_AXIS_TVALID (sim_tx_valid[2]),
                .M02_AXIS_TREADY (sim_tx_ready[2]),
                .M02_AXIS_TDATA  (sim_tx_data[2]),
                .M02_AXIS_TKEEP  (sim_tx_keep[2]),
                .M02_AXIS_TLAST  (sim_tx_last[2]),
                .M02_AXIS_TDEST  (),
                .M02_AXIS_TUSER  (sim_tx_user[2]),

                .M03_AXIS_ACLK   (eth_clk),
                .M03_AXIS_ARESETN(~reset_eth),
                .M03_AXIS_TVALID (sim_tx_valid[3]),
                .M03_AXIS_TREADY (sim_tx_ready[3]),
                .M03_AXIS_TDATA  (sim_tx_data[3]),
                .M03_AXIS_TKEEP  (sim_tx_keep[3]),
                .M03_AXIS_TLAST  (sim_tx_last[3]),
                .M03_AXIS_TDEST  (),
                .M03_AXIS_TUSER  (sim_tx_user[3]),

                .M04_AXIS_ACLK   (eth_clk),
                .M04_AXIS_ARESETN(~reset_eth),
                .M04_AXIS_TVALID (),
                .M04_AXIS_TREADY (1'b1),
                .M04_AXIS_TDATA  (),
                .M04_AXIS_TKEEP  (),
                .M04_AXIS_TLAST  (),
                .M04_AXIS_TDEST  (),
                .M04_AXIS_TUSER  (),

                .S00_DECODE_ERR()
            );

            for (i = 0; i < 4; i = i + 1) begin
                axis_dwidth_converter_64_8 axis_dwidth_converter_64_8_i (
                    .aclk   (eth_clk),
                    .aresetn(~reset_eth),

                    .s_axis_tvalid(sim_tx_valid[i]),
                    .s_axis_tready(sim_tx_ready[i]),
                    .s_axis_tdata (sim_tx_data[i]),
                    .s_axis_tkeep (sim_tx_keep[i]),
                    .s_axis_tlast (sim_tx_last[i]),
                    .s_axis_tuser (sim_tx_user[i]),

                    .m_axis_tvalid(eth_rx8_valid[i]),
                    .m_axis_tready(debug_ingress_interconnect_ready[i]),  // FIXME
                    .m_axis_tdata (eth_rx8_data[i]),
                    .m_axis_tkeep (),
                    .m_axis_tlast (eth_rx8_last[i]),
                    .m_axis_tuser (eth_rx8_user[i])
                );
            end

            wire [    DATA_WIDTH - 1:0] out_data;
            wire [DATA_WIDTH / 8 - 1:0] out_keep;
            wire                        out_last;
            wire [DATA_WIDTH / 8 - 1:0] out_user;
            wire [      ID_WIDTH - 1:0] out_dest;
            wire                        out_valid;
            wire                        out_ready;

            axis_interconnect_ingress axis_interconnect_sim_out_i (
                .ACLK   (eth_clk),
                .ARESETN(~reset_eth),

                .S00_AXIS_ACLK   (eth_clk),
                .S00_AXIS_ARESETN(~reset_eth),
                .S00_AXIS_TVALID (eth_tx8_valid[0]),
                .S00_AXIS_TREADY (eth_tx8_ready[0]),
                .S00_AXIS_TDATA  (eth_tx8_data[0]),
                .S00_AXIS_TKEEP  (1'b1),
                .S00_AXIS_TLAST  (eth_tx8_last[0]),
                .S00_AXIS_TID    (3'd0),
                .S00_AXIS_TUSER  (eth_tx8_user[0]),

                .S01_AXIS_ACLK   (eth_clk),
                .S01_AXIS_ARESETN(~reset_eth),
                .S01_AXIS_TVALID (eth_tx8_valid[1]),
                .S01_AXIS_TREADY (eth_tx8_ready[1]),
                .S01_AXIS_TDATA  (eth_tx8_data[1]),
                .S01_AXIS_TKEEP  (1'b1),
                .S01_AXIS_TLAST  (eth_tx8_last[1]),
                .S01_AXIS_TID    (3'd1),
                .S01_AXIS_TUSER  (eth_tx8_user[1]),

                .S02_AXIS_ACLK   (eth_clk),
                .S02_AXIS_ARESETN(~reset_eth),
                .S02_AXIS_TVALID (eth_tx8_valid[2]),
                .S02_AXIS_TREADY (eth_tx8_ready[2]),
                .S02_AXIS_TDATA  (eth_tx8_data[2]),
                .S02_AXIS_TKEEP  (1'b1),
                .S02_AXIS_TLAST  (eth_tx8_last[2]),
                .S02_AXIS_TID    (3'd2),
                .S02_AXIS_TUSER  (eth_tx8_user[2]),

                .S03_AXIS_ACLK   (eth_clk),
                .S03_AXIS_ARESETN(~reset_eth),
                .S03_AXIS_TVALID (eth_tx8_valid[3]),
                .S03_AXIS_TREADY (eth_tx8_ready[3]),
                .S03_AXIS_TDATA  (eth_tx8_data[3]),
                .S03_AXIS_TKEEP  (1'b1),
                .S03_AXIS_TLAST  (eth_tx8_last[3]),
                .S03_AXIS_TID    (3'd3),
                .S03_AXIS_TUSER  (eth_tx8_user[3]),

                .S04_AXIS_ACLK   (eth_clk),
                .S04_AXIS_ARESETN(~reset_eth),
                .S04_AXIS_TVALID (1'b0),
                .S04_AXIS_TREADY (),
                .S04_AXIS_TDATA  (0),
                .S04_AXIS_TKEEP  (1'b1),
                .S04_AXIS_TLAST  (1'b0),
                .S04_AXIS_TID    (3'd4),
                .S04_AXIS_TUSER  (1'b0),

                .M00_AXIS_ACLK   (eth_clk),
                .M00_AXIS_ARESETN(~reset_eth),
                .M00_AXIS_TVALID (out_valid),
                .M00_AXIS_TREADY (out_ready),
                .M00_AXIS_TDATA  (out_data),
                .M00_AXIS_TKEEP  (out_keep),
                .M00_AXIS_TLAST  (out_last),
                .M00_AXIS_TID    (out_dest),
                .M00_AXIS_TUSER  (out_user),

                .S00_ARB_REQ_SUPPRESS(0),
                .S01_ARB_REQ_SUPPRESS(0),
                .S02_ARB_REQ_SUPPRESS(0),
                .S03_ARB_REQ_SUPPRESS(0),
                .S04_ARB_REQ_SUPPRESS(0),

                .S00_FIFO_DATA_COUNT(),
                .S01_FIFO_DATA_COUNT(),
                .S02_FIFO_DATA_COUNT(),
                .S03_FIFO_DATA_COUNT(),
                .S04_FIFO_DATA_COUNT()
            );

            axis_receiver axis_receiver_i (
                .clk  (eth_clk),
                .reset(reset_eth),

                .s_data (out_data),
                .s_keep (out_keep),
                .s_last (out_last),
                .s_user (out_user),
                .s_dest (out_dest),
                .s_valid(out_valid),
                .s_ready(out_ready)
            );
        end
    endgenerate

    wire [7:0] internal_tx_data;
    wire       internal_tx_last;
    wire       internal_tx_user;
    wire       internal_tx_valid;
    assign eth_rx8_data[4]  = internal_tx_data;
    assign eth_rx8_last[4]  = internal_tx_last;
    assign eth_rx8_user[4]  = internal_tx_user;
    assign eth_rx8_valid[4] = internal_tx_valid;

    wire [7:0] internal_rx_data = eth_tx8_data[4];
    wire internal_rx_last = eth_tx8_last[4];
    wire internal_rx_user = eth_tx8_user[4];
    wire internal_rx_valid = eth_tx8_valid[4];
    wire internal_rx_ready;
    assign eth_tx8_ready[4] = internal_rx_ready;

    // README: internal_tx_* and internal_rx_* are left for internal use.
    // You can connect them with your CPU to transfer frames between the router part and the CPU part,
    // and you may need to write some logic to receive from internal_rx_*, store data to some memory,
    // read data from some memory, and send to internal_tx_*.
    // You can also transfer frames in other ways.
    // assign internal_tx_data  = 0;
    // assign internal_tx_last  = 0;
    // assign internal_tx_user  = 0;
    // assign internal_tx_valid = 0;
    // assign internal_rx_ready = 0;

    wire [7:0] out_led;
    led_delayer led_delayer_i (
        .clk(eth_clk),
        .reset(reset_eth),
        .in_led({
            (eth_tx8_valid[3] & eth_tx8_ready[3]) | eth_rx8_valid[3],
            ~sfp_rx_los[3],
            (eth_tx8_valid[2] & eth_tx8_ready[2]) | eth_rx8_valid[2],
            ~sfp_rx_los[2],
            (eth_tx8_valid[1] & eth_tx8_ready[1]) | eth_rx8_valid[1],
            ~sfp_rx_los[1],
            (eth_tx8_valid[0] & eth_tx8_ready[0]) | eth_rx8_valid[0],
            ~sfp_rx_los[0]
        }),
        .out_led(out_led)
    );
    assign sfp_led = out_led;

    wire [    DATA_WIDTH - 1:0] eth_rx_data;
    wire [DATA_WIDTH / 8 - 1:0] eth_rx_keep;
    wire                        eth_rx_last;
    wire [DATA_WIDTH / 8 - 1:0] eth_rx_user;
    wire [      ID_WIDTH - 1:0] eth_rx_id;
    wire                        eth_rx_valid;

    axis_interconnect_ingress axis_interconnect_ingress_i (
        .ACLK   (eth_clk),
        .ARESETN(~reset_eth),

        .S00_AXIS_ACLK   (eth_clk),
        .S00_AXIS_ARESETN(~reset_eth),
        .S00_AXIS_TVALID (eth_rx8_valid[0]),
        .S00_AXIS_TREADY (debug_ingress_interconnect_ready[0]),
        .S00_AXIS_TDATA  (eth_rx8_data[0]),
        .S00_AXIS_TKEEP  (1'b1),
        .S00_AXIS_TLAST  (eth_rx8_last[0]),
        .S00_AXIS_TID    (3'd0),
        .S00_AXIS_TUSER  (eth_rx8_user[0]),

        .S01_AXIS_ACLK   (eth_clk),
        .S01_AXIS_ARESETN(~reset_eth),
        .S01_AXIS_TVALID (eth_rx8_valid[1]),
        .S01_AXIS_TREADY (debug_ingress_interconnect_ready[1]),
        .S01_AXIS_TDATA  (eth_rx8_data[1]),
        .S01_AXIS_TKEEP  (1'b1),
        .S01_AXIS_TLAST  (eth_rx8_last[1]),
        .S01_AXIS_TID    (3'd1),
        .S01_AXIS_TUSER  (eth_rx8_user[1]),

        .S02_AXIS_ACLK   (eth_clk),
        .S02_AXIS_ARESETN(~reset_eth),
        .S02_AXIS_TVALID (eth_rx8_valid[2]),
        .S02_AXIS_TREADY (debug_ingress_interconnect_ready[2]),
        .S02_AXIS_TDATA  (eth_rx8_data[2]),
        .S02_AXIS_TKEEP  (1'b1),
        .S02_AXIS_TLAST  (eth_rx8_last[2]),
        .S02_AXIS_TID    (3'd2),
        .S02_AXIS_TUSER  (eth_rx8_user[2]),

        .S03_AXIS_ACLK   (eth_clk),
        .S03_AXIS_ARESETN(~reset_eth),
        .S03_AXIS_TVALID (eth_rx8_valid[3]),
        .S03_AXIS_TREADY (debug_ingress_interconnect_ready[3]),
        .S03_AXIS_TDATA  (eth_rx8_data[3]),
        .S03_AXIS_TKEEP  (1'b1),
        .S03_AXIS_TLAST  (eth_rx8_last[3]),
        .S03_AXIS_TID    (3'd3),
        .S03_AXIS_TUSER  (eth_rx8_user[3]),

        .S04_AXIS_ACLK   (eth_clk),
        .S04_AXIS_ARESETN(~reset_eth),
        .S04_AXIS_TVALID (eth_rx8_valid[4]),
        .S04_AXIS_TREADY (debug_ingress_interconnect_ready[4]),
        .S04_AXIS_TDATA  (eth_rx8_data[4]),
        .S04_AXIS_TKEEP  (1'b1),
        .S04_AXIS_TLAST  (eth_rx8_last[4]),
        .S04_AXIS_TID    (3'd4),
        .S04_AXIS_TUSER  (eth_rx8_user[4]),

        .M00_AXIS_ACLK   (eth_clk),
        .M00_AXIS_ARESETN(~reset_eth),
        .M00_AXIS_TVALID (eth_rx_valid),
        .M00_AXIS_TREADY (1'b1),
        .M00_AXIS_TDATA  (eth_rx_data),
        .M00_AXIS_TKEEP  (eth_rx_keep),
        .M00_AXIS_TLAST  (eth_rx_last),
        .M00_AXIS_TID    (eth_rx_id),
        .M00_AXIS_TUSER  (eth_rx_user),

        .S00_ARB_REQ_SUPPRESS(0),
        .S01_ARB_REQ_SUPPRESS(0),
        .S02_ARB_REQ_SUPPRESS(0),
        .S03_ARB_REQ_SUPPRESS(0),
        .S04_ARB_REQ_SUPPRESS(0),

        .S00_FIFO_DATA_COUNT(),
        .S01_FIFO_DATA_COUNT(),
        .S02_FIFO_DATA_COUNT(),
        .S03_FIFO_DATA_COUNT(),
        .S04_FIFO_DATA_COUNT()
    );

    wire [    DATA_WIDTH - 1:0] dp_rx_data;
    wire [DATA_WIDTH / 8 - 1:0] dp_rx_keep;
    wire                        dp_rx_last;
    wire [DATA_WIDTH / 8 - 1:0] dp_rx_user;
    wire [      ID_WIDTH - 1:0] dp_rx_id;
    wire                        dp_rx_valid;
    wire                        dp_rx_ready;

    frame_datapath_fifo #(
        .ENABLE(1),  // README: enable this if your datapath may block.
        .DATA_WIDTH(DATA_WIDTH),
        .ID_WIDTH(ID_WIDTH)
    ) frame_datapath_fifo_i (
        .eth_clk(eth_clk),
        .reset  (reset_eth),

        .s_data (eth_rx_data),
        .s_keep (eth_rx_keep),
        .s_last (eth_rx_last),
        .s_user (eth_rx_user),
        .s_id   (eth_rx_id),
        .s_valid(eth_rx_valid),
        .s_ready(debug_datapath_fifo_ready),

        .drop_led(debug_datapath_ingress_drop_led),

        .m_data (dp_rx_data),
        .m_keep (dp_rx_keep),
        .m_last (dp_rx_last),
        .m_user (dp_rx_user),
        .m_id   (dp_rx_id),
        .m_valid(dp_rx_valid),
        .m_ready(dp_rx_ready)
    );

    wire [         DATA_WIDTH - 1:0] dp_tx_data;
    wire [     DATA_WIDTH / 8 - 1:0] dp_tx_keep;
    wire                             dp_tx_last;
    wire [     DATA_WIDTH / 8 - 1:0] dp_tx_user;
    wire [           ID_WIDTH - 1:0] dp_tx_dest;
    wire                             dp_tx_valid;

    // MMIO 端口配置, 见下面的 Router MMIO
    wire [                     47:0] mac                  [3:0];
    wire [                    127:0] local_ip             [3:0];
    wire [                    127:0] gua_ip               [3:0];

    // Router Slave
    wire                             wb_router_cyc_i;
    wire                             wb_router_stb_i;
    wire                             wb_router_ack_o;
    wire [  WISHBONE_ADDR_WIDTH-1:0] wb_router_adr_i;
    wire [  WISHBONE_DATA_WIDTH-1:0] wb_router_dat_i;
    wire [  WISHBONE_DATA_WIDTH-1:0] wb_router_dat_o;
    wire [WISHBONE_DATA_WIDTH/8-1:0] wb_router_sel_i;
    wire                             wb_router_we_i;

    wire                             wb_router_sram_cyc_i;
    wire                             wb_router_sram_stb_i;
    wire                             wb_router_sram_ack_o;
    wire [  WISHBONE_ADDR_WIDTH-1:0] wb_router_sram_adr_i;
    wire [  WISHBONE_DATA_WIDTH-1:0] wb_router_sram_dat_i;
    wire [  WISHBONE_DATA_WIDTH-1:0] wb_router_sram_dat_o;
    wire [WISHBONE_DATA_WIDTH/8-1:0] wb_router_sram_sel_i;
    wire                             wb_router_sram_we_i;

    // README: Instantiate your datapath.
    frame_datapath #(
        .EXT_RAM_FOR_LEAF(EXT_RAM_FOR_LEAF),
        .DATA_WIDTH(DATA_WIDTH),
        .ID_WIDTH(ID_WIDTH),
        .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
        .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH),
        .SRAM_ADDR_WIDTH(SRAM_ADDR_WIDTH),
        .SRAM_DATA_WIDTH(SRAM_DATA_WIDTH)
    ) frame_datapath_i (
        .eth_clk(eth_clk),
        .reset  (reset_eth),

        .mac     (mac),
        .local_ip(local_ip),
        .gua_ip  (gua_ip),

        .s_data (dp_rx_data),
        .s_keep (dp_rx_keep),
        .s_last (dp_rx_last),
        .s_user (dp_rx_user),
        .s_id   (dp_rx_id),
        .s_valid(dp_rx_valid),
        .s_ready(dp_rx_ready),

        .m_data (dp_tx_data),
        .m_keep (dp_tx_keep),
        .m_last (dp_tx_last),
        .m_user (dp_tx_user),
        .m_dest (dp_tx_dest),
        .m_valid(dp_tx_valid),
        .m_ready(1'b1),

        // README: You will need to add some signals for your CPU to control the datapath,
        // or access the forwarding table or the address resolution cache.
        .cpu_clk  (core_clk),
        .cpu_reset(reset_core),
        .wb_cyc_i (wb_router_cyc_i),
        .wb_stb_i (wb_router_stb_i),
        .wb_ack_o (wb_router_ack_o),
        .wb_adr_i (wb_router_adr_i),
        .wb_dat_i (wb_router_dat_i),
        .wb_dat_o (wb_router_dat_o),
        .wb_sel_i (wb_router_sel_i),
        .wb_we_i  (wb_router_we_i),

        .wb_sram_cyc_i(wb_router_sram_cyc_i),
        .wb_sram_stb_i(wb_router_sram_stb_i),
        .wb_sram_ack_o(wb_router_sram_ack_o),
        .wb_sram_adr_i(wb_router_sram_adr_i),
        .wb_sram_dat_i(wb_router_sram_dat_i),
        .wb_sram_dat_o(wb_router_sram_dat_o),
        .wb_sram_sel_i(wb_router_sram_sel_i),
        .wb_sram_we_i (wb_router_sram_we_i),

        .sram_addr(ext_ram_addr),
        .sram_data(ext_ram_data),
        .sram_ce_n(ext_ram_ce_n),
        .sram_oe_n(ext_ram_oe_n),
        .sram_we_n(ext_ram_we_n),
        .sram_be_n(ext_ram_be_n),

        .debug_led_cpu(debug_forwarding_table_core),
        .debug_led_eth(debug_forwarding_table_eth)
    );

    wire [    DATA_WIDTH - 1:0] eth_tx_data [0:4];
    wire [DATA_WIDTH / 8 - 1:0] eth_tx_keep [0:4];
    wire                        eth_tx_last [0:4];
    wire                        eth_tx_ready[0:4];
    wire [DATA_WIDTH / 8 - 1:0] eth_tx_user [0:4];
    wire                        eth_tx_valid[0:4];

    axis_interconnect_egress axis_interconnect_egress_i (
        .ACLK   (eth_clk),
        .ARESETN(~reset_eth),

        .S00_AXIS_ACLK   (eth_clk),
        .S00_AXIS_ARESETN(~reset_eth),
        .S00_AXIS_TVALID (dp_tx_valid),
        .S00_AXIS_TREADY (debug_egress_interconnect_ready),
        .S00_AXIS_TDATA  (dp_tx_data),
        .S00_AXIS_TKEEP  (dp_tx_keep),
        .S00_AXIS_TLAST  (dp_tx_last),
        .S00_AXIS_TDEST  (dp_tx_dest),
        .S00_AXIS_TUSER  (dp_tx_user),

        .M00_AXIS_ACLK   (eth_clk),
        .M00_AXIS_ARESETN(~reset_eth),
        .M00_AXIS_TVALID (eth_tx_valid[0]),
        .M00_AXIS_TREADY (eth_tx_ready[0]),
        .M00_AXIS_TDATA  (eth_tx_data[0]),
        .M00_AXIS_TKEEP  (eth_tx_keep[0]),
        .M00_AXIS_TLAST  (eth_tx_last[0]),
        .M00_AXIS_TDEST  (),
        .M00_AXIS_TUSER  (eth_tx_user[0]),

        .M01_AXIS_ACLK   (eth_clk),
        .M01_AXIS_ARESETN(~reset_eth),
        .M01_AXIS_TVALID (eth_tx_valid[1]),
        .M01_AXIS_TREADY (eth_tx_ready[1]),
        .M01_AXIS_TDATA  (eth_tx_data[1]),
        .M01_AXIS_TKEEP  (eth_tx_keep[1]),
        .M01_AXIS_TLAST  (eth_tx_last[1]),
        .M01_AXIS_TDEST  (),
        .M01_AXIS_TUSER  (eth_tx_user[1]),

        .M02_AXIS_ACLK   (eth_clk),
        .M02_AXIS_ARESETN(~reset_eth),
        .M02_AXIS_TVALID (eth_tx_valid[2]),
        .M02_AXIS_TREADY (eth_tx_ready[2]),
        .M02_AXIS_TDATA  (eth_tx_data[2]),
        .M02_AXIS_TKEEP  (eth_tx_keep[2]),
        .M02_AXIS_TLAST  (eth_tx_last[2]),
        .M02_AXIS_TDEST  (),
        .M02_AXIS_TUSER  (eth_tx_user[2]),

        .M03_AXIS_ACLK   (eth_clk),
        .M03_AXIS_ARESETN(~reset_eth),
        .M03_AXIS_TVALID (eth_tx_valid[3]),
        .M03_AXIS_TREADY (eth_tx_ready[3]),
        .M03_AXIS_TDATA  (eth_tx_data[3]),
        .M03_AXIS_TKEEP  (eth_tx_keep[3]),
        .M03_AXIS_TLAST  (eth_tx_last[3]),
        .M03_AXIS_TDEST  (),
        .M03_AXIS_TUSER  (eth_tx_user[3]),

        .M04_AXIS_ACLK   (eth_clk),
        .M04_AXIS_ARESETN(~reset_eth),
        .M04_AXIS_TVALID (eth_tx_valid[4]),
        .M04_AXIS_TREADY (eth_tx_ready[4]),
        .M04_AXIS_TDATA  (eth_tx_data[4]),
        .M04_AXIS_TKEEP  (eth_tx_keep[4]),
        .M04_AXIS_TLAST  (eth_tx_last[4]),
        .M04_AXIS_TDEST  (),
        .M04_AXIS_TUSER  (eth_tx_user[4]),

        .S00_DECODE_ERR()
    );

    generate
        for (i = 0; i < 4; i = i + 1) begin
            egress_wrapper #(
                .DATA_WIDTH(DATA_WIDTH),
                .ID_WIDTH  (ID_WIDTH)
            ) egress_wrapper_i (
                .eth_clk(eth_clk),
                .reset  (reset_eth),

                .s_data (eth_tx_data[i]),
                .s_keep (eth_tx_keep[i]),
                .s_last (eth_tx_last[i]),
                .s_user (eth_tx_user[i]),
                .s_valid(eth_tx_valid[i]),
                .s_ready(eth_tx_ready[i]),

                .drop_led(debug_egress_drop_led[i]),

                .m_data (eth_tx8_data[i]),
                .m_last (eth_tx8_last[i]),
                .m_user (eth_tx8_user[i]),
                .m_valid(eth_tx8_valid[i]),
                .m_ready(eth_tx8_ready[i])
            );
        end
        egress_wrapper_cpu #(
            .DATA_WIDTH(DATA_WIDTH),
            .ID_WIDTH  (ID_WIDTH)
        ) egress_wrapper_cpu_i (
            .eth_clk(eth_clk),
            .reset  (reset_eth),

            .s_data (eth_tx_data[4]),
            .s_keep (eth_tx_keep[4]),
            .s_last (eth_tx_last[4]),
            .s_user (eth_tx_user[4]),
            .s_valid(eth_tx_valid[4]),
            .s_ready(eth_tx_ready[4]),

            .drop_led(debug_egress_drop_led[4]),
            .count   (cpu_fifo_count),

            .m_data (eth_tx8_data[4]),
            .m_last (eth_tx8_last[4]),
            .m_user (eth_tx8_user[4]),
            .m_valid(eth_tx8_valid[4]),
            .m_ready(eth_tx8_ready[4])
        );
    endgenerate

    /* =========== Debug =========== */
    // Debug leds
    led_delayer led_delayer_debug_i1 (
        .clk(eth_clk),
        .reset(reset_eth),
        .in_led({
            debug_forwarding_table_eth,
            debug_dma_user_error_led,
            debug_datapath_ingress_drop_led,
            debug_egress_drop_led
        }),
        .out_led(debug_leds[7:0])
    );
    // led_delayer led_delayer_debug_i2 (
    //     .clk    (core_clk),
    //     .reset  (reset_core),
    //     .in_led (debug_forwarding_table_core),
    //     .out_led(debug_leds[15:8])
    // );
    reg [7:0] cpu_fifo_led;
    always_comb begin
        unique case (cpu_fifo_count[12:10])
            8'd0: cpu_fifo_led[7:1] = 7'b0000000;
            8'd1: cpu_fifo_led[7:1] = 7'b0000001;
            8'd2: cpu_fifo_led[7:1] = 7'b0000011;
            8'd3: cpu_fifo_led[7:1] = 7'b0000111;
            8'd4: cpu_fifo_led[7:1] = 7'b0001111;
            8'd5: cpu_fifo_led[7:1] = 7'b0011111;
            8'd6: cpu_fifo_led[7:1] = 7'b0111111;
            8'd7: cpu_fifo_led[7:1] = 7'b1111111;
        endcase
        cpu_fifo_led[0] = |cpu_fifo_count;
    end
    led_delayer led_delayer_debug_i2 (
        .clk    (eth_clk),
        .reset  (reset_eth),
        .in_led (cpu_fifo_led),
        .out_led(debug_leds[15:8])
    );

    /* =========== CPU =========== */
    logic sys_clk;
    logic sys_rst;

    assign sys_clk  = core_clk;
    assign sys_rst  = reset_core;

    // 本实验不使用 CPLD 串口，禁用防止总线冲突
    assign uart_rdn = 1'b1;
    assign uart_wrn = 1'b1;

    // 时钟中断
    logic [63:0] mtime;
    logic        mtime_int;

    logic [31:0] alu_a_o;
    logic [31:0] alu_b_o;
    logic [ 3:0] alu_op_o;
    logic [31:0] alu_y_i;

    alu u_alu (
        .alu_a (alu_a_o),
        .alu_b (alu_b_o),
        .alu_op(alu_op_o),
        .alu_y (alu_y_i)
    );

    logic [ 4:0] rf_raddr_a_o;
    logic [ 4:0] rf_raddr_b_o;
    logic        rf_we_o;
    logic [31:0] rf_wdata_o;
    logic [ 4:0] rf_waddr_o;
    logic [31:0] rf_rdata_a_i;
    logic [31:0] rf_rdata_b_i;

    register_file u_register_file (
        .clk    (sys_clk),
        .reset  (sys_rst),
        .waddr  (rf_waddr_o),
        .wdata  (rf_wdata_o),
        .we     (rf_we_o),
        .raddr_a(rf_raddr_a_o),
        .raddr_b(rf_raddr_b_o),
        .rdata_a(rf_rdata_a_i),
        .rdata_b(rf_rdata_b_i)
    );

    logic        wbm0_cyc_o;
    logic        wbm0_stb_o;
    logic        wbm0_ack_i;
    logic [31:0] wbm0_adr_o;
    logic [31:0] wbm0_dat_o;
    logic [31:0] wbm0_dat_i;
    logic [ 3:0] wbm0_sel_o;
    logic        wbm0_we_o;

    logic        wbm1_cyc_o;
    logic        wbm1_stb_o;
    logic        wbm1_ack_i;
    logic [31:0] wbm1_adr_o;
    logic [31:0] wbm1_dat_o;
    logic [31:0] wbm1_dat_i;
    logic [ 3:0] wbm1_sel_o;
    logic        wbm1_we_o;

    cpu_pipeline u_cpu_pipeline (
        .clk(sys_clk),
        .rst(sys_rst),

        .mtime_i     (mtime),
        .mtime_int_i (mtime_int),
        .wbm0_ack_i  (wbm0_ack_i),
        .wbm0_dat_i  (wbm0_dat_i),
        .wbm1_ack_i  (wbm1_ack_i),
        .wbm1_dat_i  (wbm1_dat_i),
        .alu_y_i     (alu_y_i),
        .rf_rdata_a_i(rf_rdata_a_i),
        .rf_rdata_b_i(rf_rdata_b_i),

        .wbm0_cyc_o  (wbm0_cyc_o),
        .wbm0_stb_o  (wbm0_stb_o),
        .wbm0_adr_o  (wbm0_adr_o),
        .wbm0_dat_o  (wbm0_dat_o),
        .wbm0_sel_o  (wbm0_sel_o),
        .wbm0_we_o   (wbm0_we_o),
        .wbm1_cyc_o  (wbm1_cyc_o),
        .wbm1_stb_o  (wbm1_stb_o),
        .wbm1_adr_o  (wbm1_adr_o),
        .wbm1_dat_o  (wbm1_dat_o),
        .wbm1_sel_o  (wbm1_sel_o),
        .wbm1_we_o   (wbm1_we_o),
        .alu_a_o     (alu_a_o),
        .alu_b_o     (alu_b_o),
        .alu_op_o    (alu_op_o),
        .rf_raddr_a_o(rf_raddr_a_o),
        .rf_raddr_b_o(rf_raddr_b_o),
        .rf_we_o     (rf_we_o),
        .rf_wdata_o  (rf_wdata_o),
        .rf_waddr_o  (rf_waddr_o)
    );

    /* =========== Wishbone Master and MUX =========== */
    logic        wbm_cyc_o;
    logic        wbm_stb_o;
    logic        wbm_ack_i;
    logic [31:0] wbm_adr_o;
    logic [31:0] wbm_dat_o;
    logic [31:0] wbm_dat_i;
    logic [ 3:0] wbm_sel_o;
    logic        wbm_we_o;

    wire         wbm_flash_cyc_o;
    wire         wbm_flash_stb_o;
    wire         wbm_flash_ack_i;
    wire  [31:0] wbm_flash_adr_o;
    wire  [31:0] wbm_flash_dat_o;
    wire  [31:0] wbm_flash_dat_i;
    wire  [ 3:0] wbm_flash_sel_o;
    wire         wbm_flash_we_o;

    assign wbm_flash_ack_i = wbm_ack_i;
    assign wbm_flash_dat_i = wbm_dat_i;

    wb_arbiter_2 #(
        .DATA_WIDTH  (32),
        .ADDR_WIDTH  (32),
        .SELECT_WIDTH(4)
    ) u_wb_arbiter_2 (
        .clk(sys_clk),
        .rst(sys_rst),

        .wbm0_adr_i(wbm0_adr_o),
        .wbm0_dat_i(wbm0_dat_o),
        .wbm0_dat_o(wbm0_dat_i),
        .wbm0_we_i (wbm0_we_o),
        .wbm0_sel_i(wbm0_sel_o),
        .wbm0_stb_i(wbm0_stb_o),
        .wbm0_ack_o(wbm0_ack_i),
        .wbm0_cyc_i(wbm0_cyc_o),

        .wbm1_adr_i(wbm1_adr_o),
        .wbm1_dat_i(wbm1_dat_o),
        .wbm1_dat_o(wbm1_dat_i),
        .wbm1_we_i (wbm1_we_o),
        .wbm1_sel_i(wbm1_sel_o),
        .wbm1_stb_i(wbm1_stb_o),
        .wbm1_ack_o(wbm1_ack_i),
        .wbm1_cyc_i(wbm1_cyc_o),

        .wbs_adr_o(wbm_adr_o),
        .wbs_dat_i(wbm_dat_i),
        .wbs_dat_o(wbm_dat_o),
        .wbs_we_o (wbm_we_o),
        .wbs_sel_o(wbm_sel_o),
        .wbs_stb_o(wbm_stb_o),
        .wbs_ack_i(wbm_ack_i),
        .wbs_cyc_o(wbm_cyc_o)
    );

    logic        wbs0_cyc_o;
    logic        wbs0_stb_o;
    logic        wbs0_ack_i;
    logic [31:0] wbs0_adr_o;
    logic [31:0] wbs0_dat_o;
    logic [31:0] wbs0_dat_i;
    logic [ 3:0] wbs0_sel_o;
    logic        wbs0_we_o;

    logic        wbs1_cyc_o;
    logic        wbs1_stb_o;
    logic        wbs1_ack_i;
    logic [31:0] wbs1_adr_o;
    logic [31:0] wbs1_dat_o;
    logic [31:0] wbs1_dat_i;
    logic [ 3:0] wbs1_sel_o;
    logic        wbs1_we_o;

    logic        wbs2_cyc_o;
    logic        wbs2_stb_o;
    logic        wbs2_ack_i;
    logic [31:0] wbs2_adr_o;
    logic [31:0] wbs2_dat_o;
    logic [31:0] wbs2_dat_i;
    logic [ 3:0] wbs2_sel_o;
    logic        wbs2_we_o;

    wire         wbs3_cyc_o;
    wire         wbs3_stb_o;
    wire         wbs3_ack_i;
    wire  [31:0] wbs3_adr_o;
    wire  [31:0] wbs3_dat_o;
    wire  [31:0] wbs3_dat_i;
    wire  [ 3:0] wbs3_sel_o;
    wire         wbs3_we_o;

    logic        wbs4_cyc_o;
    logic        wbs4_stb_o;
    logic        wbs4_ack_i;
    logic [31:0] wbs4_adr_o;
    logic [31:0] wbs4_dat_o;
    logic [31:0] wbs4_dat_i;
    logic [ 3:0] wbs4_sel_o;
    logic        wbs4_we_o;

    logic        wbs5_cyc_o;
    logic        wbs5_stb_o;
    logic        wbs5_ack_i;
    logic [31:0] wbs5_adr_o;
    logic [31:0] wbs5_dat_o;
    logic [31:0] wbs5_dat_i;
    logic [ 3:0] wbs5_sel_o;
    logic        wbs5_we_o;

    logic        wbs6_cyc_o;
    logic        wbs6_stb_o;
    logic        wbs6_ack_i;
    logic [31:0] wbs6_adr_o;
    logic [31:0] wbs6_dat_o;
    logic [31:0] wbs6_dat_i;
    logic [ 3:0] wbs6_sel_o;
    logic        wbs6_we_o;

    logic        wbs7_cyc_o;
    logic        wbs7_stb_o;
    logic        wbs7_ack_i;
    logic [31:0] wbs7_adr_o;
    logic [31:0] wbs7_dat_o;
    logic [31:0] wbs7_dat_i;
    logic [ 3:0] wbs7_sel_o;
    logic        wbs7_we_o;

    logic        wbs8_cyc_o;
    logic        wbs8_stb_o;
    logic        wbs8_ack_i;
    logic [31:0] wbs8_adr_o;
    logic [31:0] wbs8_dat_o;
    logic [31:0] wbs8_dat_i;
    logic [ 3:0] wbs8_sel_o;
    logic        wbs8_we_o;

    wb_mux_9 wb_mux (
        .clk(sys_clk),
        .rst(sys_rst),

        // Master interface (to CPU master)
        .wbm_adr_i(wbm_adr_o | wbm_flash_adr_o),
        .wbm_dat_i(wbm_dat_o | wbm_flash_dat_o),
        .wbm_dat_o(wbm_dat_i),
        .wbm_we_i (wbm_we_o | wbm_flash_we_o),
        .wbm_sel_i(wbm_sel_o | wbm_flash_sel_o),
        .wbm_stb_i(wbm_stb_o | wbm_flash_stb_o),
        .wbm_ack_o(wbm_ack_i),
        .wbm_err_o(),
        .wbm_rty_o(),
        .wbm_cyc_i(wbm_cyc_o | wbm_flash_cyc_o),

        // Slave interface 0 (to BaseRAM controller)
        // Address range: 0x8000_0000 ~ 0x803F_FFFF
        .wbs0_addr    (32'h8000_0000),
        .wbs0_addr_msk(32'hFFC0_0000),

        .wbs0_adr_o(wbs0_adr_o),
        .wbs0_dat_i(wbs0_dat_i),
        .wbs0_dat_o(wbs0_dat_o),
        .wbs0_we_o (wbs0_we_o),
        .wbs0_sel_o(wbs0_sel_o),
        .wbs0_stb_o(wbs0_stb_o),
        .wbs0_ack_i(wbs0_ack_i),
        .wbs0_err_i('0),
        .wbs0_rty_i('0),
        .wbs0_cyc_o(wbs0_cyc_o),

        // Slave interface 1 (to ExtRAM controller)
        // Address range: 0x8040_0000 ~ 0x807F_FFFF
        .wbs1_addr    (32'h8040_0000),
        .wbs1_addr_msk(32'hFFC0_0000),

        .wbs1_adr_o(wbs1_adr_o),
        .wbs1_dat_i(wbs1_dat_i),
        .wbs1_dat_o(wbs1_dat_o),
        .wbs1_we_o (wbs1_we_o),
        .wbs1_sel_o(wbs1_sel_o),
        .wbs1_stb_o(wbs1_stb_o),
        .wbs1_ack_i(wbs1_ack_i),
        .wbs1_err_i('0),
        .wbs1_rty_i('0),
        .wbs1_cyc_o(wbs1_cyc_o),

        // Slave interface 2 (to Router RAM)
        // Address range: 0x4000_0000 ~ 0x5FFF_FFFF
        .wbs2_addr    (32'h4000_0000),
        .wbs2_addr_msk(32'hE000_0000),

        .wbs2_adr_o(wbs2_adr_o),
        .wbs2_dat_i(wbs2_dat_i),
        .wbs2_dat_o(wbs2_dat_o),
        .wbs2_we_o (wbs2_we_o),
        .wbs2_sel_o(wbs2_sel_o),
        .wbs2_stb_o(wbs2_stb_o),
        .wbs2_ack_i(wbs2_ack_i),
        .wbs2_err_i('0),
        .wbs2_rty_i('0),
        .wbs2_cyc_o(wbs2_cyc_o),

        // Slave interface 3 (to Router DMA)
        // Address range: 0x6800_0000 ~ 0x6FFF_FFFF
        .wbs3_addr    (32'h6800_0000),
        .wbs3_addr_msk(32'hF800_0000),

        .wbs3_adr_o(wbs3_adr_o),
        .wbs3_dat_i(wbs3_dat_i),
        .wbs3_dat_o(wbs3_dat_o),
        .wbs3_we_o (wbs3_we_o),
        .wbs3_sel_o(wbs3_sel_o),
        .wbs3_stb_o(wbs3_stb_o),
        .wbs3_ack_i(wbs3_ack_i),
        .wbs3_err_i('0),
        .wbs3_rty_i('0),
        .wbs3_cyc_o(wbs3_cyc_o),

        // Slave interface 4 (to Router MMIO)
        // Address range: 0x6000_0000 ~ 0x67FF_FFFF
        .wbs4_addr    (32'h6000_0000),
        .wbs4_addr_msk(32'hF800_0000),

        .wbs4_adr_o(wbs4_adr_o),
        .wbs4_dat_i(wbs4_dat_i),
        .wbs4_dat_o(wbs4_dat_o),
        .wbs4_we_o (wbs4_we_o),
        .wbs4_sel_o(wbs4_sel_o),
        .wbs4_stb_o(wbs4_stb_o),
        .wbs4_ack_i(wbs4_ack_i),
        .wbs4_err_i('0),
        .wbs4_rty_i('0),
        .wbs4_cyc_o(wbs4_cyc_o),

        // Slave interface 5 (to VGA RAM)
        // Address range: 0x3000_0000 ~ 0x30FF_FFFF
        .wbs5_addr    (32'h3000_0000),
        .wbs5_addr_msk(32'hFF00_0000),

        .wbs5_adr_o(wbs5_adr_o),
        .wbs5_dat_i(wbs5_dat_i),
        .wbs5_dat_o(wbs5_dat_o),
        .wbs5_we_o (wbs5_we_o),
        .wbs5_sel_o(wbs5_sel_o),
        .wbs5_stb_o(wbs5_stb_o),
        .wbs5_ack_i(wbs5_ack_i),
        .wbs5_err_i('0),
        .wbs5_rty_i('0),
        .wbs5_cyc_o(wbs5_cyc_o),

        // Slave interface 6 (to GPIO)
        // Address range: 0x2000_0000 ~ 0x2000_000F
        .wbs6_addr    (32'h2000_0000),
        .wbs6_addr_msk(32'hFFFF_FFF0),

        .wbs6_adr_o(wbs6_adr_o),
        .wbs6_dat_i(wbs6_dat_i),
        .wbs6_dat_o(wbs6_dat_o),
        .wbs6_we_o (wbs6_we_o),
        .wbs6_sel_o(wbs6_sel_o),
        .wbs6_stb_o(wbs6_stb_o),
        .wbs6_ack_i(wbs6_ack_i),
        .wbs6_err_i('0),
        .wbs6_rty_i('0),
        .wbs6_cyc_o(wbs6_cyc_o),

        // Slave interface 7 (to UART controller)
        // Address range: 0x1000_0000 ~ 0x1000_FFFF
        .wbs7_addr    (32'h1000_0000),
        .wbs7_addr_msk(32'hFFFF_0000),

        .wbs7_adr_o(wbs7_adr_o),
        .wbs7_dat_i(wbs7_dat_i),
        .wbs7_dat_o(wbs7_dat_o),
        .wbs7_we_o (wbs7_we_o),
        .wbs7_sel_o(wbs7_sel_o),
        .wbs7_stb_o(wbs7_stb_o),
        .wbs7_ack_i(wbs7_ack_i),
        .wbs7_err_i('0),
        .wbs7_rty_i('0),
        .wbs7_cyc_o(wbs7_cyc_o),

        // Slave interface 8 (to MMIO Register)
        // Address range: 0x0000_0000 ~ 0x0FFF_FFFF
        .wbs8_addr    (32'h0000_0000),
        .wbs8_addr_msk(32'hF000_0000),

        .wbs8_adr_o(wbs8_adr_o),
        .wbs8_dat_i(wbs8_dat_i),
        .wbs8_dat_o(wbs8_dat_o),
        .wbs8_we_o (wbs8_we_o),
        .wbs8_sel_o(wbs8_sel_o),
        .wbs8_stb_o(wbs8_stb_o),
        .wbs8_ack_i(wbs8_ack_i),
        .wbs8_err_i('0),
        .wbs8_rty_i('0),
        .wbs8_cyc_o(wbs8_cyc_o)
    );

    /* =========== Wishbone Slaves =========== */
    // Slave 0: Base SRAM
    sram_controller #(
        .CLK_FREQ       (SYS_CLK_FREQ),
        .SRAM_ADDR_WIDTH(SRAM_ADDR_WIDTH),
        .SRAM_DATA_WIDTH(SRAM_DATA_WIDTH)
    ) sram_controller_base (
        .clk_i(sys_clk),
        .rst_i(reset_core_without_bufg),

        // Wishbone slave (to MUX)
        .wb_cyc_i(wbs0_cyc_o),
        .wb_stb_i(wbs0_stb_o),
        .wb_ack_o(wbs0_ack_i),
        .wb_adr_i(wbs0_adr_o),
        .wb_dat_i(wbs0_dat_o),
        .wb_dat_o(wbs0_dat_i),
        .wb_sel_i(wbs0_sel_o),
        .wb_we_i (wbs0_we_o),

        // To SRAM chip
        .sram_addr(base_ram_addr),
        .sram_data(base_ram_data),
        .sram_ce_n(base_ram_ce_n),
        .sram_oe_n(base_ram_oe_n),
        .sram_we_n(base_ram_we_n),
        .sram_be_n(base_ram_be_n)
    );

    // Slave 1: Ext SRAM
    generate
        if (EXT_RAM_FOR_LEAF) begin
            assign wb_router_sram_cyc_i = wbs1_cyc_o;
            assign wb_router_sram_stb_i = wbs1_stb_o;
            assign wbs1_ack_i           = wb_router_sram_ack_o;
            assign wb_router_sram_adr_i = wbs1_adr_o;
            assign wb_router_sram_dat_i = wbs1_dat_o;
            assign wbs1_dat_i           = wb_router_sram_dat_o;
            assign wb_router_sram_sel_i = wbs1_sel_o;
            assign wb_router_sram_we_i  = wbs1_we_o;

        end else begin
            assign wb_router_sram_cyc_i = 1'b0;
            assign wb_router_sram_stb_i = 1'b0;
            assign wb_router_sram_adr_i = '0;
            assign wb_router_sram_dat_i = '0;
            assign wb_router_sram_sel_i = '0;
            assign wb_router_sram_we_i  = 1'b0;

            sram_controller #(
                .CLK_FREQ       (SYS_CLK_FREQ),
                .SRAM_ADDR_WIDTH(SRAM_ADDR_WIDTH),
                .SRAM_DATA_WIDTH(SRAM_DATA_WIDTH)
            ) sram_controller_ext (
                .clk_i(sys_clk),
                .rst_i(reset_core_without_bufg),

                // Wishbone slave (to MUX)
                .wb_cyc_i(wbs1_cyc_o),
                .wb_stb_i(wbs1_stb_o),
                .wb_ack_o(wbs1_ack_i),
                .wb_adr_i(wbs1_adr_o),
                .wb_dat_i(wbs1_dat_o),
                .wb_dat_o(wbs1_dat_i),
                .wb_sel_i(wbs1_sel_o),
                .wb_we_i (wbs1_we_o),

                // To SRAM chip
                .sram_addr(ext_ram_addr),
                .sram_data(ext_ram_data),
                .sram_ce_n(ext_ram_ce_n),
                .sram_oe_n(ext_ram_oe_n),
                .sram_we_n(ext_ram_we_n),
                .sram_be_n(ext_ram_be_n)
            );
        end
    endgenerate

    // Slave 2: Router RAM
    assign wb_router_cyc_i = wbs2_cyc_o;
    assign wb_router_stb_i = wbs2_stb_o;
    assign wbs2_ack_i      = wb_router_ack_o;
    assign wb_router_adr_i = wbs2_adr_o;
    assign wb_router_dat_i = wbs2_dat_o;
    assign wbs2_dat_i      = wb_router_dat_o;
    assign wb_router_sel_i = wbs2_sel_o;
    assign wb_router_we_i  = wbs2_we_o;

    // Slave 3: Router DMA
    // 见下方的 Router DMA 部分

    // Slave 4: Router MMIO
    // 见下方的 Router MMIO 部分

    // Slave 5: VGA
    // VGA 模块
    // 目前支持显示 800 x 600 的图像
    generate
        if (ENABLE_VGA) begin
            vga vga (
                .cpu_clk(sys_clk),
                .cpu_rst(sys_rst),
                .vga_clk(vga_clk),
                .vga_rst(reset_btn),

                // Wishbone slave (to MUX)
                .wb_cyc_i(wbs5_cyc_o),
                .wb_stb_i(wbs5_stb_o),
                .wb_ack_o(wbs5_ack_i),
                .wb_adr_i(wbs5_adr_o),
                .wb_dat_i(wbs5_dat_o),
                .wb_dat_o(wbs5_dat_i),
                .wb_sel_i(wbs5_sel_o),
                .wb_we_i (wbs5_we_o),

                // VGA Output
                .video_red  (video_red),
                .video_green(video_green),
                .video_blue (video_blue),
                .video_hsync(video_hsync),
                .video_vsync(video_vsync),
                .video_clk  (video_clk),
                .video_de   (video_de)
            );
        end else begin
            assign wbs5_ack_i = 1'b0;
            assign wbs5_dat_i = 32'h00000000;
        end
    endgenerate

    // Slave 6: GPIO
    // GPIO模块
    gpio #(
        .CLK_FREQ(SYS_CLK_FREQ)
    ) gpio (

        .clk(sys_clk),
        .rst(sys_rst),

        // Wishbone slave (to MUX)
        .wb_cyc_i(wbs6_cyc_o),
        .wb_stb_i(wbs6_stb_o),
        .wb_ack_o(wbs6_ack_i),
        .wb_adr_i(wbs6_adr_o),
        .wb_dat_i(wbs6_dat_o),
        .wb_dat_o(wbs6_dat_i),
        .wb_sel_i(wbs6_sel_o),
        .wb_we_i (wbs6_we_o),

        // GPIO
        .touch_btn(touch_btn),
        .dip_sw   (dip_sw),
        .leds     (gpio_leds),
        .dpy0     (dpy0),
        .dpy1     (dpy1)
    );

    // Slave 7: UART
    // 串口控制器模块
    // NOTE: 如果修改系统时钟频率，也需要修改此处的时钟频率参数
    uart_controller #(
        .CLK_FREQ(SYS_CLK_FREQ),
        .BAUD    (115200)
    ) uart_controller (
        .clk_i(sys_clk),
        .rst_i(sys_rst),

        .wb_cyc_i(wbs7_cyc_o),
        .wb_stb_i(wbs7_stb_o),
        .wb_ack_o(wbs7_ack_i),
        .wb_adr_i(wbs7_adr_o),
        .wb_dat_i(wbs7_dat_o),
        .wb_dat_o(wbs7_dat_i),
        .wb_sel_i(wbs7_sel_o),
        .wb_we_i (wbs7_we_o),

        // to UART pins
        .uart_txd_o(txd),
        .uart_rxd_i(rxd)
    );

    // Slave 8: MMIO MTIME
    mmio_mtime #(
        .CLK_FREQ(SYS_CLK_FREQ)
    ) u_mmio_mtime (
        .clk(sys_clk),
        .rst(sys_rst),

        .wb_cyc_i(wbs8_cyc_o),
        .wb_stb_i(wbs8_stb_o),
        .wb_ack_o(wbs8_ack_i),
        .wb_adr_i(wbs8_adr_o),
        .wb_dat_i(wbs8_dat_o),
        .wb_dat_o(wbs8_dat_i),
        .wb_sel_i(wbs8_sel_o),
        .wb_we_i (wbs8_we_o),

        .mtime_o    (mtime),
        .mtime_int_o(mtime_int)
    );

    /* =========== Router MMIO & DMA =========== */
    wire                             wb_mmio_cyc_o;
    wire                             wb_mmio_stb_o;
    wire                             wb_mmio_ack_i;
    wire [  WISHBONE_ADDR_WIDTH-1:0] wb_mmio_adr_o;
    wire [  WISHBONE_DATA_WIDTH-1:0] wb_mmio_dat_o;
    wire [  WISHBONE_DATA_WIDTH-1:0] wb_mmio_dat_i;
    wire [WISHBONE_DATA_WIDTH/8-1:0] wb_mmio_sel_o;
    wire                             wb_mmio_we_o;

    // DMA 控制寄存器
    wire                             dma_cpu_lock;
    wire                             dma_router_lock;
    wire                             dma_wait_cpu;
    wire                             dma_wait_router;

    wire                             dma_router_request;
    wire                             dma_router_sent_fin;
    wire                             dma_router_read_fin;

    wire                             dma_cpu_checksum_request;
    wire                             dma_router_checksum_fin;

    wishbone_cdc_handshake #(
        .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
        .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH)
    ) u_wishbone_cdc_handshake_mmio (
        .src_clk (core_clk),
        .src_rst (reset_core),
        .dest_clk(eth_clk),
        .dest_rst(reset_eth),
        .wb_cyc_i(wbs4_cyc_o),
        .wb_stb_i(wbs4_stb_o),
        .wb_ack_o(wbs4_ack_i),
        .wb_adr_i(wbs4_adr_o),
        .wb_dat_i(wbs4_dat_o),
        .wb_dat_o(wbs4_dat_i),
        .wb_sel_i(wbs4_sel_o),
        .wb_we_i (wbs4_we_o),

        .dest_wb_cyc_o(wb_mmio_cyc_o),
        .dest_wb_stb_o(wb_mmio_stb_o),
        .dest_wb_ack_i(wb_mmio_ack_i),
        .dest_wb_adr_o(wb_mmio_adr_o),
        .dest_wb_dat_o(wb_mmio_dat_o),
        .dest_wb_dat_i(wb_mmio_dat_i),
        .dest_wb_sel_o(wb_mmio_sel_o),
        .dest_wb_we_o (wb_mmio_we_o),

        .debug_led()
    );

    router_mmio #(
        .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
        .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH)
    ) u_router_mmio (
        .clk(eth_clk),
        .rst(reset_eth),

        .wb_cyc_i(wb_mmio_cyc_o),
        .wb_stb_i(wb_mmio_stb_o),
        .wb_ack_o(wb_mmio_ack_i),
        .wb_adr_i(wb_mmio_adr_o),
        .wb_dat_i(wb_mmio_dat_o),
        .wb_dat_o(wb_mmio_dat_i),
        .wb_sel_i(wb_mmio_sel_o),
        .wb_we_i (wb_mmio_we_o),

        .eth_tx8_ready({
            eth_tx8_ready[4], eth_tx8_ready[3], eth_tx8_ready[2], eth_tx8_ready[1], eth_tx8_ready[0]
        }),
        .eth_tx8_valid({
            eth_tx8_valid[4], eth_tx8_valid[3], eth_tx8_valid[2], eth_tx8_valid[1], eth_tx8_valid[0]
        }),
        .eth_rx8_ready({
            debug_ingress_interconnect_ready[4],
            debug_ingress_interconnect_ready[3],
            debug_ingress_interconnect_ready[2],
            debug_ingress_interconnect_ready[1],
            debug_ingress_interconnect_ready[0]
        }),
        .eth_rx8_valid({
            eth_rx8_valid[4], eth_rx8_valid[3], eth_rx8_valid[2], eth_rx8_valid[1], eth_rx8_valid[0]
        }),

        .mac     (mac),
        .local_ip(local_ip),
        .gua_ip  (gua_ip),

        .dma_cpu_lock_o   (dma_cpu_lock),
        .dma_router_lock_o(dma_router_lock),
        .dma_wait_cpu_o   (dma_wait_cpu),
        .dma_wait_router_o(dma_wait_router),

        .dma_router_request_i (dma_router_request),
        .dma_router_sent_fin_i(dma_router_sent_fin),
        .dma_router_read_fin_i(dma_router_read_fin),

        .dma_checksum_valid_o      (),
        .dma_cpu_checksum_request_o(dma_cpu_checksum_request),
        .dma_router_checksum_fin_i (dma_router_checksum_fin),

        .cpu_fifo_count(cpu_fifo_count)
    );

    router_dma #(
        .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
        .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH)
    ) u_router_dma (
        .cpu_clk  (core_clk),
        .cpu_reset(reset_core),

        .wb_cyc_i(wbs3_cyc_o),
        .wb_stb_i(wbs3_stb_o),
        .wb_ack_o(wbs3_ack_i),
        .wb_adr_i(wbs3_adr_o),
        .wb_dat_i(wbs3_dat_o),
        .wb_dat_o(wbs3_dat_i),
        .wb_sel_i(wbs3_sel_o),
        .wb_we_i (wbs3_we_o),

        .eth_clk  (eth_clk),
        .eth_reset(reset_eth),

        .dma_cpu_lock_i   (dma_cpu_lock),
        .dma_router_lock_i(dma_router_lock),
        .dma_wait_cpu_i   (dma_wait_cpu),
        .dma_wait_router_i(dma_wait_router),

        .dma_router_request_o (dma_router_request),
        .dma_router_sent_fin_o(dma_router_sent_fin),
        .dma_router_read_fin_o(dma_router_read_fin),

        .dma_cpu_checksum_request_i(dma_cpu_checksum_request),
        .dma_router_checksum_fin_o (dma_router_checksum_fin),

        .rx8_data (internal_rx_data),
        .rx8_last (internal_rx_last),
        .rx8_user (internal_rx_user),
        .rx8_valid(internal_rx_valid),
        .rx8_ready(internal_rx_ready),

        .tx8_data (internal_tx_data),
        .tx8_last (internal_tx_last),
        .tx8_user (internal_tx_user),
        .tx8_valid(internal_tx_valid),
        .tx8_ready(1'b1),

        .drop_led(debug_dma_user_error_led)
    );

    /* =========== Load Flash =========== */
    wire        wbm_flash_read_cyc_o;
    wire        wbm_flash_read_stb_o;
    wire        wbm_flash_read_ack_i;
    wire [31:0] wbm_flash_read_adr_o;
    wire [31:0] wbm_flash_read_dat_o;
    wire [31:0] wbm_flash_read_dat_i;
    wire [ 3:0] wbm_flash_read_sel_o;
    wire        wbm_flash_read_we_o;

    // Flash模块
    flash flash (
        .clk       (sys_clk),
        .rst       (reset_core_without_bufg),
        .full_reset(1'b0),

        // Wishbone slave (to MUX)
        .wb_cyc_i(wbm_flash_read_cyc_o),
        .wb_stb_i(wbm_flash_read_stb_o),
        .wb_ack_o(wbm_flash_read_ack_i),
        .wb_adr_i(wbm_flash_read_adr_o),
        .wb_dat_i(wbm_flash_read_dat_o),
        .wb_dat_o(wbm_flash_read_dat_i),
        .wb_sel_i(wbm_flash_read_sel_o),
        .wb_we_i (wbm_flash_read_we_o),

        // Flash
        .flash_a     (flash_a),
        .flash_d     (flash_d),
        .flash_rp_n  (flash_rp_n),
        .flash_vpen  (flash_vpen),
        .flash_ce_n  (flash_ce_n),
        .flash_oe_n  (flash_oe_n),
        .flash_we_n  (flash_we_n),
        .flash_byte_n(flash_byte_n)
    );

    load_flash #(
        .END_ADDR(EXT_RAM_FOR_LEAF ? 24'h3ffffc : 24'h7ffffc)
    ) u_load_flash (
        .clk(sys_clk),
        .rst(reset_core_without_bufg),

        .push_btn  (push_btn),
        .leds      (flash_leds),
        .wait_flash(wait_flash),

        .wbm_sram_cyc_o(wbm_flash_cyc_o),
        .wbm_sram_stb_o(wbm_flash_stb_o),
        .wbm_sram_ack_i(wbm_flash_ack_i),
        .wbm_sram_adr_o(wbm_flash_adr_o),
        .wbm_sram_dat_o(wbm_flash_dat_o),
        .wbm_sram_dat_i(wbm_flash_dat_i),
        .wbm_sram_sel_o(wbm_flash_sel_o),
        .wbm_sram_we_o (wbm_flash_we_o),

        .wbm_flash_read_cyc_o(wbm_flash_read_cyc_o),
        .wbm_flash_read_stb_o(wbm_flash_read_stb_o),
        .wbm_flash_read_ack_i(wbm_flash_read_ack_i),
        .wbm_flash_read_adr_o(wbm_flash_read_adr_o),
        .wbm_flash_read_dat_o(wbm_flash_read_dat_o),
        .wbm_flash_read_dat_i(wbm_flash_read_dat_i),
        .wbm_flash_read_sel_o(wbm_flash_read_sel_o),
        .wbm_flash_read_we_o (wbm_flash_read_we_o)
    );

endmodule
