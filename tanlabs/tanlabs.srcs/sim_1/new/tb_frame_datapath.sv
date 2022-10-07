`timescale 1ps / 1ps

module tb_frame_datapath
#(
    parameter DATA_WIDTH = 64,
    parameter ID_WIDTH = 3
)
(
    
);

    reg reset;
    initial begin
        reset = 1;
        #6000
        reset = 0;
    end

    wire clk_125M;

    clock clock_i(
        .clk_125M(clk_125M)
    );

    wire [DATA_WIDTH - 1:0] in_data;
    wire [DATA_WIDTH / 8 - 1:0] in_keep;
    wire in_last;
    wire [DATA_WIDTH / 8 - 1:0] in_user;
    wire [ID_WIDTH - 1:0] in_id;
    wire in_valid;
    wire in_ready;

    axis_model axis_model_i(
        .clk(clk_125M),
        .reset(reset),

        .m_data(in_data),
        .m_keep(in_keep),
        .m_last(in_last),
        .m_user(in_user),
        .m_id(in_id),
        .m_valid(in_valid),
        .m_ready(in_ready)
    );

    wire [DATA_WIDTH - 1:0] out_data;
    wire [DATA_WIDTH / 8 - 1:0] out_keep;
    wire out_last;
    wire [DATA_WIDTH / 8 - 1:0] out_user;
    wire [ID_WIDTH - 1:0] out_dest;
    wire out_valid;
    wire out_ready;
    
    // FIXME: 硬编码 MAC 地址, 用于硬件调试
    wire [47:0] preset_mac[3:0];
    assign preset_mac[0] = {<<8{8'h00, 8'h00, 8'h00, 8'h03, 8'h0A, 8'h00}};
    assign preset_mac[1] = {<<8{8'h00, 8'h00, 8'h00, 8'h03, 8'h0A, 8'h01}};
    assign preset_mac[2] = {<<8{8'h00, 8'h00, 8'h00, 8'h03, 8'h0A, 8'h02}};
    assign preset_mac[3] = {<<8{8'h00, 8'h00, 8'h00, 8'h03, 8'h0A, 8'h03}};

    wire [ 47:0] mac[3:0];
    wire [127:0] ip [3:0];
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1)
        begin
            config_address config_address_i (
                .clk  (clk_125M),
                .reset(reset),

                .we     (1'b1),
                .mac_in (preset_mac[i]),
                .mac_reg(mac[i]),
                .ip_reg (ip[i])
            );
        end
    endgenerate

    // README: Instantiate your datapath.
    frame_datapath dut(
        .eth_clk(clk_125M),
        .reset(reset),
        
        .mac(mac),
        .ip(ip),

        .s_data(in_data),
        .s_keep(in_keep),
        .s_last(in_last),
        .s_user(in_user),
        .s_id(in_id),
        .s_valid(in_valid),
        .s_ready(in_ready),

        .m_data(out_data),
        .m_keep(out_keep),
        .m_last(out_last),
        .m_user(out_user),
        .m_dest(out_dest),
        .m_valid(out_valid),
        .m_ready(out_ready)
    );

    axis_receiver axis_receiver_i(
        .clk(clk_125M),
        .reset(reset),

        .s_data(out_data),
        .s_keep(out_keep),
        .s_last(out_last),
        .s_user(out_user),
        .s_dest(out_dest),
        .s_valid(out_valid),
        .s_ready(out_ready)
    );
endmodule
