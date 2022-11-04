`timescale 1ns / 1ps `default_nettype none

`include "forwarding_table.vh"

module forwarding_ram_controller #(
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
    input  FTE_node                          ft_dout[PIPELINE_LENGTH-1:0],

    // Leaf node LUTRAM interface
    output logic     [LEAF_ADDR_WIDTH - 1:0] leaf_addr,
    output leaf_node                         leaf_in,
    input  leaf_node                         leaf_out,
    output reg                               leaf_we,

    // Next-Hop node LUTRAM interface
    output logic         [NEXT_HOP_ADDR_WIDTH - 1:0] next_hop_addr,
    output next_hop_node                             next_hop_in,
    input  next_hop_node                             next_hop_out,
    output reg                                       next_hop_we
);
    // 解析 Wishbone 总线地址
    logic [                      7:0] addr_type;
    logic [                      3:0] bram_pipeline;
    logic [                      4:0] inner_place;

    logic [   CHILD_ADDR_WIDTH - 1:0] bram_num;
    logic [    LEAF_ADDR_WIDTH - 1:0] leaf_num;
    logic [NEXT_HOP_ADDR_WIDTH - 1:0] next_hop_num;

    always_comb begin
        addr_type     = wb_adr_i[WISHBONE_ADDR_WIDTH-1:WISHBONE_ADDR_WIDTH-8];
        bram_pipeline = wb_adr_i[WISHBONE_ADDR_WIDTH-5:WISHBONE_ADDR_WIDTH-8];
        inner_place   = wb_adr_i[4:0];
        bram_num      = wb_adr_i[WISHBONE_ADDR_WIDTH-9:4];
        leaf_num      = wb_adr_i[WISHBONE_ADDR_WIDTH-9:2];
        next_hop_num  = wb_adr_i[WISHBONE_ADDR_WIDTH-9:5];
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

    typedef enum {
        BRAM,
        LEAF,
        NEXTHOP,
        NONE
    } storetype_t;

    storetype_t storetype;

    // 判断地址类型, 连接地址信号和使能信号
    always_comb begin
        for (int i = 0; i < PIPELINE_LENGTH; i++) begin
            ft_addr[i] = bram_num;
            ft_en[i]   = 1'b0;
        end
        leaf_addr     = leaf_num;
        next_hop_addr = next_hop_num;

        unique casez (addr_type)
            8'h4?: begin
                storetype            = BRAM;
                ft_en[bram_pipeline] = is_request;
            end
            8'h50: begin
                storetype = LEAF;
            end
            8'h51: begin
                storetype = NEXTHOP;
            end
            default: begin
                storetype = NONE;
            end
        endcase
    end

    // 连接 RAM 数据输出至总线数据输出
    always_comb begin
        wb_dat_o = '0;
        case (storetype)
            BRAM: begin
                unique case (inner_place[3:2])
                    2'b00: wb_dat_o = ft_dout[bram_pipeline].child_map;
                    2'b01: wb_dat_o = ft_dout[bram_pipeline].leaf_map;
                    2'b10: wb_dat_o = ft_dout[bram_pipeline].child_base_addr;
                    2'b11: wb_dat_o = ft_dout[bram_pipeline].leaf_base_addr;
                endcase
            end
            LEAF: begin
                wb_dat_o = leaf_out;
            end
            NEXTHOP: begin
                case (inner_place[4:2])
                    3'b000: wb_dat_o = next_hop_out.ip[31:0];
                    3'b001: wb_dat_o = next_hop_out.ip[63:32];
                    3'b010: wb_dat_o = next_hop_out.ip[95:64];
                    3'b011: wb_dat_o = next_hop_out.ip[127:96];
                    3'b100: wb_dat_o = next_hop_out.port;
                    3'b101: wb_dat_o = next_hop_out.route_type;
                    // default 为 0
                endcase
            end
        endcase
    end

    // 连接总线数据输入至 RAM 数据输入
    always_comb begin
        for (int i = 0; i < PIPELINE_LENGTH; i++) begin
            ft_din[i] = ft_dout[i];
        end
        leaf_in     = leaf_out;
        next_hop_in = next_hop_out;

        case (storetype)
            BRAM: begin
                unique case (inner_place[3:2])
                    2'b00: begin
                        ft_din[bram_pipeline].child_map = (ft_dout[bram_pipeline].child_map & (~data_mask)) | (wb_dat_i & data_mask);
                    end
                    2'b01: begin
                        ft_din[bram_pipeline].leaf_map = (ft_dout[bram_pipeline].leaf_map & (~data_mask)) | (wb_dat_i & data_mask);
                    end
                    2'b10: begin
                        ft_din[bram_pipeline].child_base_addr = (ft_dout[bram_pipeline].child_base_addr & (~data_mask)) | (wb_dat_i & data_mask);
                    end
                    2'b11: begin
                        ft_din[bram_pipeline].leaf_base_addr = (ft_dout[bram_pipeline].leaf_base_addr & (~data_mask)) | (wb_dat_i & data_mask);
                    end
                endcase
            end
            LEAF: begin
                leaf_in = leaf_out & (~data_mask) | (wb_dat_i & data_mask);
            end
            NEXTHOP: begin
                case (inner_place[4:2])
                    3'b000: begin
                        next_hop_in.ip[31:0] = (next_hop_out.ip[31:0] & (~data_mask)) | (wb_dat_i & data_mask);
                    end
                    3'b001: begin
                        next_hop_in.ip[63:32] = (next_hop_out.ip[63:32] & (~data_mask)) | (wb_dat_i & data_mask);
                    end
                    3'b010: begin
                        next_hop_in.ip[95:64] = (next_hop_out.ip[95:64] & (~data_mask)) | (wb_dat_i & data_mask);
                    end
                    3'b011: begin
                        next_hop_in.ip[127:96] = (next_hop_out.ip[127:96] & (~data_mask)) | (wb_dat_i & data_mask);
                    end
                    3'b100: begin
                        next_hop_in.port = (next_hop_out.port & (~data_mask)) | (wb_dat_i & data_mask);
                    end
                    3'b101: begin
                        next_hop_in.route_type = route_type_t'(({next_hop_out.route_type} & (~data_mask)) | (wb_dat_i & data_mask));
                    end
                    // default 为 next_hop_in = next_hop_out
                endcase
            end
        endcase
    end

    typedef enum {
        ST_IDLE,
        ST_READ,
        ST_WRITE
    } state_slave;

    state_slave state;

    // 连接 ack 信号
    always_comb begin
        wb_ack_o = is_request && ((state == ST_READ) || (state == ST_WRITE));
    end

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            for (int i = 0; i < PIPELINE_LENGTH; i++) begin
                ft_we[i] <= 1'b0;
            end
            leaf_we     <= 1'b0;
            next_hop_we <= 1'b0;
            state       <= ST_IDLE;
        end else begin
            case (state)
                ST_IDLE: begin
                    if (is_request) begin
                        if (wb_we_i == 1'b0) begin
                            state <= ST_READ;
                        end else begin
                            case (storetype)
                                BRAM: ft_we[bram_pipeline] <= 1'b1;
                                LEAF: leaf_we <= 1'b1;
                                NEXTHOP: next_hop_we <= 1'b1;
                            endcase
                            state <= ST_WRITE;
                        end
                    end
                end
                ST_READ: begin
                    state <= ST_IDLE;
                end
                ST_WRITE: begin
                    case (storetype)
                        BRAM: ft_we[bram_pipeline] <= 1'b0;
                        LEAF: leaf_we <= 1'b0;
                        NEXTHOP: next_hop_we <= 1'b0;
                    endcase
                    state <= ST_IDLE;
                end
                default: begin
                    // 理论上不能来这里
                    state <= ST_IDLE;
                end
            endcase
        end
    end

endmodule
