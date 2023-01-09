`timescale 1ns / 1ps `default_nettype none

`include "../forwarding_table.vh"

module forwarding_bram_controller #(
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32
) (
    // clk and reset
    input wire clk_i,
    input wire rst_i,

    // wishbone slave interface
    input  wire                             wb_cyc_i,
    input  wire                             wb_stb_i,
    output reg                              wb_ack_o,
    input  wire [  WISHBONE_ADDR_WIDTH-1:0] wb_adr_i,
    input  wire [  WISHBONE_DATA_WIDTH-1:0] wb_dat_i,
    output reg  [  WISHBONE_DATA_WIDTH-1:0] wb_dat_o,
    input  wire [WISHBONE_DATA_WIDTH/8-1:0] wb_sel_i,
    input  wire                             wb_we_i,

    // Forwarding table BRAM interface
    output reg                               ft_en  [PIPELINE_LENGTH-1:0],
    output reg                               ft_we  [PIPELINE_LENGTH-1:0],
    output reg      [CHILD_ADDR_WIDTH - 1:0] ft_addr[PIPELINE_LENGTH-1:0],
    output FTE_node                          ft_din [PIPELINE_LENGTH-1:0],
    input  FTE_node                          ft_dout[PIPELINE_LENGTH-1:0]
);
    // 解析 Wishbone 总线地址
    logic [                   3:0] bram_pipeline;
    logic [                   1:0] inner_place;
    logic [CHILD_ADDR_WIDTH - 1:0] bram_num;
    always_comb begin
        bram_pipeline = wb_adr_i[WISHBONE_ADDR_WIDTH-5:WISHBONE_ADDR_WIDTH-8];
        inner_place   = wb_adr_i[3:2];
        bram_num      = wb_adr_i[WISHBONE_ADDR_WIDTH-9:4];
    end

    // 根据 sel 获取 mask
    reg [WISHBONE_DATA_WIDTH-1:0] data_mask;
    always_comb begin
        for (int i = 0; i < WISHBONE_DATA_WIDTH / 8; i = i + 1) begin
            data_mask[i*8+:8] = wb_sel_i[i] ? 8'hff : 8'h00;
        end
    end

    // 聚合请求信号
    wire is_request = wb_cyc_i & wb_stb_i;

    // 判断地址类型, 连接地址信号和使能信号
    always_comb begin
        for (int i = 0; i < PIPELINE_LENGTH; i++) begin
            ft_addr[i] = bram_num;
            ft_en[i]   = 1'b0;
        end
        ft_en[bram_pipeline] = is_request;
    end

    // 连接 RAM 数据输出至总线数据输出
    always_comb begin
        wb_dat_o = '0;
        unique case (inner_place)
            2'b00: wb_dat_o = {ft_dout[bram_pipeline].leaf_map, ft_dout[bram_pipeline].child_map};
            2'b01: wb_dat_o = {ft_dout[bram_pipeline].tag, 6'b0};
            2'b10: wb_dat_o = ft_dout[bram_pipeline].child_base_addr;
            2'b11: wb_dat_o = ft_dout[bram_pipeline].leaf_base_addr;
        endcase
    end

    // 连接总线数据输入至 RAM 数据输入
    always_comb begin
        for (int i = 0; i < PIPELINE_LENGTH; i++) begin
            ft_din[i] = ft_dout[i];
        end
        unique case (inner_place)
            2'b00: begin
                {ft_din[bram_pipeline].leaf_map, ft_din[bram_pipeline].child_map} =  ({
                    ft_din[bram_pipeline].leaf_map,
                    ft_din[bram_pipeline].child_map
                } & (~data_mask)) | (wb_dat_i & data_mask);
            end
            2'b01: begin
                ft_din[bram_pipeline].tag = (({ft_dout[bram_pipeline].tag, 6'b0} & (~data_mask)) | (wb_dat_i & data_mask))>>6;
            end
            2'b10: begin
                ft_din[bram_pipeline].child_base_addr = (ft_dout[bram_pipeline].child_base_addr & (~data_mask)) | (wb_dat_i & data_mask);
            end
            2'b11: begin
                ft_din[bram_pipeline].leaf_base_addr = (ft_dout[bram_pipeline].leaf_base_addr & (~data_mask)) | (wb_dat_i & data_mask);
            end
        endcase
    end

    typedef enum {
        ST_IDLE,
        ST_WAIT,
        ST_READ,
        ST_WRITE
    } slave_state_t;

    slave_state_t state;

    // 连接 ack 信号
    always_comb begin
        wb_ack_o = is_request && ((state == ST_READ) || (state == ST_WRITE));
    end

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            for (int i = 0; i < PIPELINE_LENGTH; i++) begin
                ft_we[i] <= 1'b0;
            end
            state <= ST_IDLE;
        end else begin
            case (state)
                ST_IDLE: begin
                    if (is_request) begin
                        state <= ST_WAIT;
                    end
                end
                ST_WAIT: begin
                    if (wb_we_i == 1'b0) begin
                        state <= ST_READ;
                    end else begin
                        ft_we[bram_pipeline] <= 1'b1;
                        state                <= ST_WRITE;
                    end
                end
                ST_READ: begin
                    state <= ST_IDLE;
                end
                ST_WRITE: begin
                    ft_we[bram_pipeline] <= 1'b0;
                    state                <= ST_IDLE;
                end
                default: begin
                    // 理论上不能来这里
                    state <= ST_IDLE;
                end
            endcase
        end
    end

endmodule
