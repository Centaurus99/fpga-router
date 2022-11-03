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
    output wire                              leaf_we,

    // Next-Hop node LUTRAM interface
    output logic         [NEXT_HOP_ADDR_WIDTH - 1:0] next_hop_addr,
    output next_hop_node                             next_hop_in,
    input  next_hop_node                             next_hop_out,
    output wire                                      next_hop_we
);
    // TODO: controller

    typedef enum {
        BRAM,
        LEAF,
        NEXTHOP
    } storetype_t;

    storetype_t                           storetype;

    reg [3:0] bram_pipeline;
    reg [4:0] inner_place;
    reg [CHILD_ADDR_WIDTH - 1:0] bram_num;
    reg [LEAF_ADDR_WIDTH - 1:0] leaf_num;
    reg [NEXT_HOP_ADDR_WIDTH - 1:0] next_hop_num;
    
    reg leaf_we_reg;
    reg next_hop_we_reg;

    assign leaf_we = leaf_we_reg;
    assign next_hop_we = next_hop_we_reg;

    always_comb begin
        if (wb_adr_i[WISHBONE_ADDR_WIDTH-1:WISHBONE_ADDR_WIDTH-4] == 4'h4) begin
            storetype = BRAM;
            bram_pipeline = wb_adr_i[WISHBONE_ADDR_WIDTH-5:WISHBONE_ADDR_WIDTH-8];
            inner_place[4:0] = {1'b0, wb_adr_i[3:0]};
            bram_num = {4'b0, wb_adr_i[WISHBONE_ADDR_WIDTH-9:4]};
            ft_addr[bram_pipeline] = bram_num;
            ft_en[bram_pipeline] = 1'b1;
            ft_we[bram_pipeline] = 1'b0;
        end else if (wb_adr_i[WISHBONE_ADDR_WIDTH-1:WISHBONE_ADDR_WIDTH-8] == 8'h50) begin
            storetype = LEAF;
            inner_place[4:0] = 5'b0;
            leaf_num = wb_adr_i[17:2];
            leaf_addr = leaf_num;
            leaf_we_reg = 1'b0;
        end else if (wb_adr_i[WISHBONE_ADDR_WIDTH-1:WISHBONE_ADDR_WIDTH-8] == 8'h51) begin
            storetype = NEXTHOP;
            inner_place[4:0] = wb_adr_i[4:0];
            next_hop_num = wb_adr_i[12:5];
            next_hop_addr = next_hop_num;
            next_hop_we_reg = 1'b0;
        end
    end
    always_comb begin
        case (storetype)
            BRAM: begin
                case (inner_place[3:2])
                    2'b00: begin
                        ft_din[bram_pipeline].child_map = wb_dat_i[15:0];
                    end
                    2'b01: begin
                        ft_din[bram_pipeline].leaf_map = wb_dat_i[15:0];
                    end
                    2'b10: begin
                        ft_din[bram_pipeline].child_base_addr = wb_dat_i[23:0];
                    end
                    2'b11: begin
                        ft_din[bram_pipeline].leaf_base_addr = wb_dat_i[15:0];
                    end
                endcase
                ft_en[bram_pipeline] = 1'b1;
                ft_we[bram_pipeline] = 1'b1;
            end
            LEAF: begin
                leaf_in = wb_dat_i[7:0];
                leaf_we_reg = 1'b1;
            end
            NEXTHOP: begin
                if(inner_place[4] == 1'b0) begin
                    next_hop_in.port = wb_dat_i[7:0];
                end else begin
                    next_hop_in.ip[8*(inner_place[3:0])+:32] = wb_dat_i;
                end
                next_hop_we_reg = 1'b1;
            end
        endcase
    end

    typedef enum {
        ST_IDLE,
        ST_WRITE,
        ST_DONE
    } state_slave;

    state_slave state = ST_IDLE;

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            wb_ack_o <= 1'b0;
            wb_dat_o <= 1'b0;
        end else begin
            case (state)
                ST_IDLE: begin
                    if (wb_stb_i == 1'b1 && wb_cyc_i == 1'b1) begin
                        // 在组合逻辑里已经开始读东西了
                        if (wb_we_i == 1'b0) begin
                            // TODO: 如何在一个周期内升起wb_ack_o，同时输出
                            wb_ack_o <= 1'b1;
                        end else begin
                            state <= ST_WRITE;
                            wb_ack_o <= 1'b0;
                        end
                    end else begin
                        wb_ack_o = 1'b0;
                    end
                end
                ST_WRITE: begin
                    case (storetype)
                        BRAM: begin
                            ft_din[bram_pipeline] <= ft_dout[bram_pipeline];
                        end
                        LEAF: begin
                            leaf_in <= leaf_out;
                        end
                        NEXTHOP: begin
                            next_hop_in <= next_hop_out;
                        end
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
