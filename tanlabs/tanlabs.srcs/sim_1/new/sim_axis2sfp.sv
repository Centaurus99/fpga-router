`timescale 1ps / 1ps

module sim_axis2sfp
#(
    parameter DATA_WIDTH = 64,
    parameter ID_WIDTH = 3
)
(
    input wire reset,

    input wire clk_125M,

    input wire [DATA_WIDTH - 1:0] s_data,
    input wire [DATA_WIDTH / 8 - 1:0] s_keep,
    input wire s_last,
    input wire [DATA_WIDTH / 8 - 1:0] s_user,
    input wire [ID_WIDTH - 1:0] s_dest,
    input wire s_valid,
    output wire s_ready,

    output wire [DATA_WIDTH - 1:0] m_data,
    output wire [DATA_WIDTH / 8 - 1:0] m_keep,
    output wire m_last,
    output wire [DATA_WIDTH / 8 - 1:0] m_user,
    output wire [ID_WIDTH - 1:0] m_id,
    output wire m_valid,
    input wire m_ready,

    input wire [3:0] sfp_rx_p,
    input wire [3:0] sfp_rx_n,
    output wire [3:0] sfp_tx_p,
    output wire [3:0] sfp_tx_n
);

    wire [4:0] debug_ingress_interconnect_ready;
    wire debug_datapath_fifo_ready;
    wire debug_egress_interconnect_ready;

    wire locked;
    wire gtref_clk;  // 125MHz for the PHY/MAC IP core
    wire ref_clk;  // 200MHz for the PHY/MAC IP core

    clk_wiz_0 clk_wiz_0_i(
        .ref_clk_out(ref_clk),
        .clk_out2(),
        .reset(1'b0),
        .locked(locked),
        .clk_in1(gtref_clk)
    );

    wire reset_not_sync = reset || !locked;  // reset components

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

    wire reset_eth_not_sync = reset || !mmcm_locked_out;
    wire reset_eth;
    reset_sync reset_sync_reset_eth(
        .clk(eth_clk),
        .i(reset_eth_not_sync),
        .o(reset_eth)
    );

    wire [7:0] eth_tx8_data [0:3];
    wire eth_tx8_last [0:3];
    wire eth_tx8_ready [0:3];
    wire eth_tx8_user [0:3];
    wire eth_tx8_valid [0:3];

    wire [7:0] eth_rx8_data [0:3];
    wire eth_rx8_last [0:3];
    wire eth_rx8_user [0:3];
    wire eth_rx8_valid [0:3];

    // Instantiate 4 PHY/MAC IP cores.

    axi_ethernet_0 axi_ethernet_0_i(
        .mac_irq(),
        .tx_mac_aclk(),
        .rx_mac_aclk(),
        .tx_reset(),
        .rx_reset(),

        .glbl_rst(reset_not_sync),

        .mmcm_locked_out(mmcm_locked_out),
        .rxuserclk_out(rxuserclk_out),
        .rxuserclk2_out(rxuserclk2_out),
        .userclk_out(userclk_out),
        .userclk2_out(userclk2_out),
        .pma_reset_out(pma_reset_out),
        .gt0_pll0outclk_out(gt0_pll0outclk_out),
        .gt0_pll0outrefclk_out(gt0_pll0outrefclk_out),
        .gt0_pll1outclk_out(gt0_pll1outclk_out),
        .gt0_pll1outrefclk_out(gt0_pll1outrefclk_out),
        .gt0_pll0lock_out(gt0_pll0lock_out),
        .gt0_pll0refclklost_out(gt0_pll0refclklost_out),
        .gtref_clk_out(gtref_clk_out),
        .gtref_clk_buf_out(gtref_clk_buf_out),

        .ref_clk(ref_clk),

        .s_axi_lite_resetn(~reset_eth),
        .s_axi_lite_clk(eth_clk),
        .s_axi_araddr(0),
        .s_axi_arready(),
        .s_axi_arvalid(0),
        .s_axi_awaddr(0),
        .s_axi_awready(),
        .s_axi_awvalid(0),
        .s_axi_bready(0),
        .s_axi_bresp(),
        .s_axi_bvalid(),
        .s_axi_rdata(),
        .s_axi_rready(0),
        .s_axi_rresp(),
        .s_axi_rvalid(),
        .s_axi_wdata(0),
        .s_axi_wready(),
        .s_axi_wvalid(0),

        .s_axis_tx_tdata(eth_tx8_data[0]),
        .s_axis_tx_tlast(eth_tx8_last[0]),
        .s_axis_tx_tready(eth_tx8_ready[0]),
        .s_axis_tx_tuser(eth_tx8_user[0]),
        .s_axis_tx_tvalid(eth_tx8_valid[0]),

        .m_axis_rx_tdata(eth_rx8_data[0]),
        .m_axis_rx_tlast(eth_rx8_last[0]),
        .m_axis_rx_tuser(eth_rx8_user[0]),
        .m_axis_rx_tvalid(eth_rx8_valid[0]),

        .s_axis_pause_tdata(0),
        .s_axis_pause_tvalid(0),

        .rx_statistics_statistics_data(),
        .rx_statistics_statistics_valid(),
        .tx_statistics_statistics_data(),
        .tx_statistics_statistics_valid(),

        .tx_ifg_delay(8'h00),
        .status_vector(),
        .signal_detect(1'b1),

        .sfp_rxn(sfp_rx_n[0]),
        .sfp_rxp(sfp_rx_p[0]),
        .sfp_txn(sfp_tx_n[0]),
        .sfp_txp(sfp_tx_p[0]),

        .mgt_clk_clk_n(~clk_125M),
        .mgt_clk_clk_p(clk_125M)
    );

    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1)
        begin
            axi_ethernet_noshared axi_ethernet_noshared_i(
                .mac_irq(),
                .tx_mac_aclk(),
                .rx_mac_aclk(),
                .tx_reset(),
                .rx_reset(),

                .glbl_rst(reset_not_sync),

                .mmcm_locked(mmcm_locked_out),
                .mmcm_reset_out(),
                .rxuserclk(rxuserclk_out),
                .rxuserclk2(rxuserclk2_out),
                .userclk(userclk_out),
                .userclk2(userclk2_out),
                .pma_reset(pma_reset_out),
                .rxoutclk(),
                .txoutclk(),
                .gt0_pll0outclk_in(gt0_pll0outclk_out),
                .gt0_pll0outrefclk_in(gt0_pll0outrefclk_out),
                .gt0_pll1outclk_in(gt0_pll1outclk_out),
                .gt0_pll1outrefclk_in(gt0_pll1outrefclk_out),
                .gt0_pll0lock_in(gt0_pll0lock_out),
                .gt0_pll0refclklost_in(gt0_pll0refclklost_out),
                .gt0_pll0reset_out(),
                .gtref_clk(gtref_clk_out),
                .gtref_clk_buf(gtref_clk_buf_out),

                .ref_clk(ref_clk),

                .s_axi_lite_resetn(~reset_eth),
                .s_axi_lite_clk(eth_clk),
                .s_axi_araddr(0),
                .s_axi_arready(),
                .s_axi_arvalid(0),
                .s_axi_awaddr(0),
                .s_axi_awready(),
                .s_axi_awvalid(0),
                .s_axi_bready(0),
                .s_axi_bresp(),
                .s_axi_bvalid(),
                .s_axi_rdata(),
                .s_axi_rready(0),
                .s_axi_rresp(),
                .s_axi_rvalid(),
                .s_axi_wdata(0),
                .s_axi_wready(),
                .s_axi_wvalid(0),

                .s_axis_tx_tdata(eth_tx8_data[i]),
                .s_axis_tx_tlast(eth_tx8_last[i]),
                .s_axis_tx_tready(eth_tx8_ready[i]),
                .s_axis_tx_tuser(eth_tx8_user[i]),
                .s_axis_tx_tvalid(eth_tx8_valid[i]),

                .m_axis_rx_tdata(eth_rx8_data[i]),
                .m_axis_rx_tlast(eth_rx8_last[i]),
                .m_axis_rx_tuser(eth_rx8_user[i]),
                .m_axis_rx_tvalid(eth_rx8_valid[i]),

                .s_axis_pause_tdata(0),
                .s_axis_pause_tvalid(0),

                .rx_statistics_statistics_data(),
                .rx_statistics_statistics_valid(),
                .tx_statistics_statistics_data(),
                .tx_statistics_statistics_valid(),

                .tx_ifg_delay(8'h00),
                .status_vector(),
                .signal_detect(1'b1),

                .sfp_rxn(sfp_rx_n[i]),
                .sfp_rxp(sfp_rx_p[i]),
                .sfp_txn(sfp_tx_n[i]),
                .sfp_txp(sfp_tx_p[i])
            );
        end
    endgenerate

    wire [DATA_WIDTH - 1:0] eth_rx_data;
    wire [DATA_WIDTH / 8 - 1:0] eth_rx_keep;
    wire eth_rx_last;
    wire [DATA_WIDTH / 8 - 1:0] eth_rx_user;
    wire [ID_WIDTH - 1:0] eth_rx_id;
    wire eth_rx_valid;

    axis_interconnect_ingress axis_interconnect_ingress_i(
        .ACLK(eth_clk),
        .ARESETN(~reset_eth),

        .S00_AXIS_ACLK(eth_clk),
        .S00_AXIS_ARESETN(~reset_eth),
        .S00_AXIS_TVALID(eth_rx8_valid[0]),
        .S00_AXIS_TREADY(debug_ingress_interconnect_ready[0]),
        .S00_AXIS_TDATA(eth_rx8_data[0]),
        .S00_AXIS_TKEEP(1'b1),
        .S00_AXIS_TLAST(eth_rx8_last[0]),
        .S00_AXIS_TID(3'd0),
        .S00_AXIS_TUSER(eth_rx8_user[0]),

        .S01_AXIS_ACLK(eth_clk),
        .S01_AXIS_ARESETN(~reset_eth),
        .S01_AXIS_TVALID(eth_rx8_valid[1]),
        .S01_AXIS_TREADY(debug_ingress_interconnect_ready[1]),
        .S01_AXIS_TDATA(eth_rx8_data[1]),
        .S01_AXIS_TKEEP(1'b1),
        .S01_AXIS_TLAST(eth_rx8_last[1]),
        .S01_AXIS_TID(3'd1),
        .S01_AXIS_TUSER(eth_rx8_user[1]),

        .S02_AXIS_ACLK(eth_clk),
        .S02_AXIS_ARESETN(~reset_eth),
        .S02_AXIS_TVALID(eth_rx8_valid[2]),
        .S02_AXIS_TREADY(debug_ingress_interconnect_ready[2]),
        .S02_AXIS_TDATA(eth_rx8_data[2]),
        .S02_AXIS_TKEEP(1'b1),
        .S02_AXIS_TLAST(eth_rx8_last[2]),
        .S02_AXIS_TID(3'd2),
        .S02_AXIS_TUSER(eth_rx8_user[2]),

        .S03_AXIS_ACLK(eth_clk),
        .S03_AXIS_ARESETN(~reset_eth),
        .S03_AXIS_TVALID(eth_rx8_valid[3]),
        .S03_AXIS_TREADY(debug_ingress_interconnect_ready[3]),
        .S03_AXIS_TDATA(eth_rx8_data[3]),
        .S03_AXIS_TKEEP(1'b1),
        .S03_AXIS_TLAST(eth_rx8_last[3]),
        .S03_AXIS_TID(3'd3),
        .S03_AXIS_TUSER(eth_rx8_user[3]),

        .S04_AXIS_ACLK(eth_clk),
        .S04_AXIS_ARESETN(~reset_eth),
        .S04_AXIS_TVALID(1'b0),
        .S04_AXIS_TREADY(),
        .S04_AXIS_TDATA(0),
        .S04_AXIS_TKEEP(1'b1),
        .S04_AXIS_TLAST(1'b0),
        .S04_AXIS_TID(3'd4),
        .S04_AXIS_TUSER(1'b0),

        .M00_AXIS_ACLK(eth_clk),
        .M00_AXIS_ARESETN(~reset_eth),
        .M00_AXIS_TVALID(m_valid),
        .M00_AXIS_TREADY(1'b1),
        .M00_AXIS_TDATA(m_data),
        .M00_AXIS_TKEEP(m_keep),
        .M00_AXIS_TLAST(m_last),
        .M00_AXIS_TID(m_id),
        .M00_AXIS_TUSER(m_user),

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

    wire [DATA_WIDTH - 1:0] eth_tx_data [0:3];
    wire [DATA_WIDTH / 8 - 1:0] eth_tx_keep [0:3];
    wire eth_tx_last [0:3];
    wire eth_tx_ready [0:3];
    wire [DATA_WIDTH / 8 - 1:0] eth_tx_user [0:3];
    wire eth_tx_valid [0:3];

    axis_interconnect_egress axis_interconnect_egress_i(
        .ACLK(eth_clk),
        .ARESETN(~reset_eth),

        .S00_AXIS_ACLK(eth_clk),
        .S00_AXIS_ARESETN(~reset_eth),
        .S00_AXIS_TVALID(s_valid),
        .S00_AXIS_TREADY(s_ready),
        .S00_AXIS_TDATA(s_data),
        .S00_AXIS_TKEEP(s_keep),
        .S00_AXIS_TLAST(s_last),
        .S00_AXIS_TDEST(s_dest),
        .S00_AXIS_TUSER(s_user),

        .M00_AXIS_ACLK(eth_clk),
        .M00_AXIS_ARESETN(~reset_eth),
        .M00_AXIS_TVALID(eth_tx_valid[0]),
        .M00_AXIS_TREADY(eth_tx_ready[0]),
        .M00_AXIS_TDATA(eth_tx_data[0]),
        .M00_AXIS_TKEEP(eth_tx_keep[0]),
        .M00_AXIS_TLAST(eth_tx_last[0]),
        .M00_AXIS_TDEST(),
        .M00_AXIS_TUSER(eth_tx_user[0]),

        .M01_AXIS_ACLK(eth_clk),
        .M01_AXIS_ARESETN(~reset_eth),
        .M01_AXIS_TVALID(eth_tx_valid[1]),
        .M01_AXIS_TREADY(eth_tx_ready[1]),
        .M01_AXIS_TDATA(eth_tx_data[1]),
        .M01_AXIS_TKEEP(eth_tx_keep[1]),
        .M01_AXIS_TLAST(eth_tx_last[1]),
        .M01_AXIS_TDEST(),
        .M01_AXIS_TUSER(eth_tx_user[1]),

        .M02_AXIS_ACLK(eth_clk),
        .M02_AXIS_ARESETN(~reset_eth),
        .M02_AXIS_TVALID(eth_tx_valid[2]),
        .M02_AXIS_TREADY(eth_tx_ready[2]),
        .M02_AXIS_TDATA(eth_tx_data[2]),
        .M02_AXIS_TKEEP(eth_tx_keep[2]),
        .M02_AXIS_TLAST(eth_tx_last[2]),
        .M02_AXIS_TDEST(),
        .M02_AXIS_TUSER(eth_tx_user[2]),

        .M03_AXIS_ACLK(eth_clk),
        .M03_AXIS_ARESETN(~reset_eth),
        .M03_AXIS_TVALID(eth_tx_valid[3]),
        .M03_AXIS_TREADY(eth_tx_ready[3]),
        .M03_AXIS_TDATA(eth_tx_data[3]),
        .M03_AXIS_TKEEP(eth_tx_keep[3]),
        .M03_AXIS_TLAST(eth_tx_last[3]),
        .M03_AXIS_TDEST(),
        .M03_AXIS_TUSER(eth_tx_user[3]),

        .M04_AXIS_ACLK(eth_clk),
        .M04_AXIS_ARESETN(~reset_eth),
        .M04_AXIS_TVALID(),
        .M04_AXIS_TREADY(1'b1),
        .M04_AXIS_TDATA(),
        .M04_AXIS_TKEEP(),
        .M04_AXIS_TLAST(),
        .M04_AXIS_TDEST(),
        .M04_AXIS_TUSER(),

        .S00_DECODE_ERR()
    );

    generate
        for (i = 0; i < 4; i = i + 1)
        begin
            axis_dwidth_converter_64_8 axis_dwidth_converter_64_8_i(
                .aclk(eth_clk),
                .aresetn(~reset_eth),

                .s_axis_tvalid(eth_tx_valid[i]),
                .s_axis_tready(eth_tx_ready[i]),
                .s_axis_tdata(eth_tx_data[i]),
                .s_axis_tkeep(eth_tx_keep[i]),
                .s_axis_tlast(eth_tx_last[i]),
                .s_axis_tuser(eth_tx_user[i]),

                .m_axis_tvalid(eth_tx8_valid[i]),
                .m_axis_tready(eth_tx8_ready[i]),
                .m_axis_tdata(eth_tx8_data[i]),
                .m_axis_tkeep(),
                .m_axis_tlast(eth_tx8_last[i]),
                .m_axis_tuser(eth_tx8_user[i])
            );
        end
    endgenerate
endmodule
