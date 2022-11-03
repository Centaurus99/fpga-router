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
    output reg                               ft_en  [PIPELINE_LENGTH:1],
    output reg                               ft_we  [PIPELINE_LENGTH:1],
    output reg      [CHILD_ADDR_WIDTH - 1:0] ft_addr[PIPELINE_LENGTH:1],
    output FTE_node                          ft_din [PIPELINE_LENGTH:1],
    input  FTE_node                          ft_dout[PIPELINE_LENGTH:1],

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

    reg         [WISHBONE_ADDR_WIDTH-1:0] wb_adr_i_reg;
    reg                             [5:0]  inner_place;  
    reg ft_en_reg; 
    reg ft_we_reg;
    reg leaf_we_reg;
    reg next_hop_we_reg;
    always_comb begin
        if (wb_adr_i[WISHBONE_ADDR_WIDTH-1:WISHBONE_ADDR_WIDTH-4] == 4'h4) begin
            ft_addr[wb_adr_i[WISHBONE_ADDR_WIDTH-5:WISHBONE_ADDR_WIDTH-8] + 1][CHILD_ADDR_WIDTH - 1:0] = {4'b0, wb_adr_i[WISHBONE_ADDR_WIDTH-9:4]};
            inner_place[4:0] = {1'b0, wb_adr_i[3:0]}
            storetype = BRAM;
            ft_en_reg = 1'b1;
            ft_we_reg = 1'b0;
        end else if (wb_adr_i[WISHBONE_ADDR_WIDTH-1:WISHBONE_ADDR_WIDTH-8] == 8'h50) begin
            leaf_addr[LEAF_ADDR_WIDTH - 1:0] = wb_adr_i[17:2];
            inner_place[4:0] = 5'b0;
            storetype = LEAF;
            leaf_we_reg = 1'b0;
        end else if (wb_adr_i[WISHBONE_ADDR_WIDTH-1:WISHBONE_ADDR_WIDTH-8] == 8'h51) begin
            next_hop_addr[NEXT_HOP_ADDR_WIDTH - 1:0] = wb_adr_i[12:5];
            inner_place[4:0] = wb_adr_i[4:0];
            storetype = NEXTHOP;
            next_hop_we_reg = 1'b0;
        end
        // 从RAM中读取数据
        ft_en_reg = 1'b1;
        ft_we_reg = 1'b0;
    end

    always_comb begin
        case (storetype)
            BRAM:
                ft_din = ft_dout;
                case (inner_place[3:2])
                    2'b00:
                        ft_din.child_map[CHILD_MAP_SIZE-1:0] = wb_dat_i[CHILD_MAP_SIZE-1:0];
                    2'b01:
                        ft_din.leaf_map[LEAF_MAP_SIZE-1:0] = wb_dat_i[LEAF_MAP_SIZE-1:0];
                    2'b10:
                        wb_dat_o[WISHBONE_DATA_WIDTH-1:0] <= {ft_dout.child_base_addr[CHILD_ADDR_WIDTH - 1:0], 8'b0};
                    2'b11:
                        wb_dat_o[WISHBONE_DATA_WIDTH-1:0] <= {ft_dout.leaf_base_addr[LEAF_ADDR_WIDTH - 1:0], 16'b0};
                endcase 
            LEAF:
            NEXTHOP:
        endcase
    end

    typedef enum {
        ST_IDLE,
        ST_WRITE,
        ST_DONE
    } state_slave;

    state_slave state = ST_INIT;

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            wb_ack_o <= 1'b0;
            wb_dat_o <= 1'b0;
        end else begin
            case (state)
                ST_IDLE:
                    if (wb_stb_i == 1'b1 && wb_cyc_i == 1'b1) begin
                        wb_adr_i_reg <= wb_adr_i;
                        if(wb_we_i == 1'b0) begin
                            state <= ST_DONE;
                        end else begin
                            state <= ST_WRITE;
                        end
                        wb_ack_o <= 1'b0;
                    end
                    wb_ack_o <= 1'b0;
                ST_DONE:
                    if(wb_we_i == 1'b0) begin
                        case (storetype)
                            BRAM:
                                case (inner_place[3:2])
                                    2'b00:
                                        wb_dat_o[WISHBONE_DATA_WIDTH-1:0] <= {ft_dout.child_map[CHILD_MAP_SIZE - 1:0], 16'b0};
                                    2'b01:
                                        wb_dat_o[WISHBONE_DATA_WIDTH-1:0] <= {ft_dout.leaf_map[LEAF_MAP_SIZE - 1:0], 16'b0};
                                    2'b10:
                                        wb_dat_o[WISHBONE_DATA_WIDTH-1:0] <= {ft_dout.child_base_addr[CHILD_ADDR_WIDTH - 1:0], 8'b0};
                                    2'b11:
                                        wb_dat_o[WISHBONE_DATA_WIDTH-1:0] <= {ft_dout.leaf_base_addr[LEAF_ADDR_WIDTH - 1:0], 16'b0};
                                endcase 
                            LEAF:
                                wb_dat_o[WISHBONE_DATA_WIDTH-1:0] <= {leaf_out.next_hop_addr[NEXT_HOP_ADDR_WIDTH - 1:0], 24'b0}
                            NEXTHOP:
                                if(inner_place[4] == 1'b1) begin
                                    // 这里应该是port，理论上后面应该全是零，
                                    wb_dat_o[WISHBONE_DATA_WIDTH-1:0] <= {next_hop_out.port[7:0], 24'b0};
                                end else begin
                                    wb_dat_o[WISHBONE_DATA_WIDTH-1:0] <= next_hop_out.ip[8*(inner_place[3:0])+:32];
                                end
                        endcase 
                        state <= ST_IDLE;
                    end else begin 
                        state <= ST_IDLE;
                    end
                    wb_ack_o <= 1'b1;
                ST_WRITE:
                    if(wb_we_i == 1'b0) begin
                        case (storetype)
                            BRAM:
                                case (inner_place[3:2])
                                    2'b00:
                                         = {ft_dout.child_map[CHILD_MAP_SIZE - 1:0], 16'b0};
                                    2'b01:
                                        wb_dat_o[WISHBONE_DATA_WIDTH-1:0] = {ft_dout.leaf_map[LEAF_MAP_SIZE - 1:0], 16'b0};
                                    2'b10:
                                        wb_dat_o[WISHBONE_DATA_WIDTH-1:0] = {ft_dout.child_base_addr[CHILD_ADDR_WIDTH - 1:0], 8'b0};
                                    2'b11:
                                        wb_dat_o[WISHBONE_DATA_WIDTH-1:0] = {ft_dout.leaf_base_addr[LEAF_ADDR_WIDTH - 1:0], 16'b0};
                                endcase 
                            LEAF:
                                wb_dat_o[WISHBONE_DATA_WIDTH-1:0] = {leaf_out.next_hop_addr[NEXT_HOP_ADDR_WIDTH - 1:0], 24'b0}
                            NEXTHOP:
                                if(inner_place[4] == 1'b1) begin
                                    // 这里应该是port，理论上后面应该全是零，
                                    wb_dat_o[WISHBONE_DATA_WIDTH-1:0] = {next_hop_out.port[7:0], 24'b0};
                                end else begin
                                    wb_dat_o[WISHBONE_DATA_WIDTH-1:0] = next_hop_out.ip[8*(inner_place[3:0])+:32];
                                end
                        endcase 
                        state <= ST_DONE;
                    end else begin 
                        // 理论上不能来这里
                        state <= ST_IDLE;
                    end


                default:
                    // 理论上不能来这里
                    state <= ST_IDLE;
            endcase
        end
    end

    assign ft_en = ft_en_reg;
    assign ft_we = ft_we_reg;

endmodule
