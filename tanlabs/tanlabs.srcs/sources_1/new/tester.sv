`timescale 1ns / 1ps `default_nettype none

// 上板测试工具

`include "frame_datapath.vh"

module tester #(
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32
) (
    input wire clk,
    input wire reset,

    // wishbone master interface
    output reg                              wb_cyc_o,
    output reg                              wb_stb_o,
    input  wire                             wb_ack_i,
    output reg  [  WISHBONE_ADDR_WIDTH-1:0] wb_adr_o,
    output reg  [  WISHBONE_DATA_WIDTH-1:0] wb_dat_o,
    input  wire [  WISHBONE_DATA_WIDTH-1:0] wb_dat_i,
    output reg  [WISHBONE_DATA_WIDTH/8-1:0] wb_sel_o,
    output reg                              wb_we_o
);
    logic [WISHBONE_ADDR_WIDTH-1:0] addr[0:60];
    logic [WISHBONE_DATA_WIDTH-1:0] data[0:60];

    assign addr = {
        32'h40000000,
        32'h40000004,
        32'h40000008,
        32'h4000000C,
        32'h40000010,
        32'h40000018,
        32'h40000020,
        32'h40000028,
        32'h40000030,
        32'h40000038,
        32'h41000010,
        32'h41000018,
        32'h41000020,
        32'h41000028,
        32'h41000030,
        32'h41000038,
        32'h41000040,
        32'h41000048,
        32'h42000010,
        32'h42000018,
        32'h42000020,
        32'h42000028,
        32'h42000030,
        32'h42000038,
        32'h42000040,
        32'h42000048,
        32'h43000010,
        32'h43000018,
        32'h43000020,
        32'h43000028,
        32'h43000030,
        32'h43000038,
        32'h43000040,
        32'h43000048,
        32'h44000074,
        32'h4400007C,
        32'h44000084,
        32'h4400008C,
        32'h44000094,
        32'h4400009C,
        32'h440000A4,
        32'h440000AC,
        32'h50000008,
        32'h5000000C,
        32'h50000010,
        32'h50000014,
        32'h51000000,
        32'h51000004,
        32'h5100000C,
        32'h51000020,
        32'h51000024,
        32'h5100002C,
        32'h51000030,
        32'h51000040,
        32'h51000044,
        32'h5100004C,
        32'h51000050,
        32'h51000060,
        32'h51000064,
        32'h5100006C,
        32'h51000070
    };

    assign data = {
        32'h00000004,
        32'h00000002,
        32'h00000003,
        32'h00000005,
        32'h00004000,
        32'h00000004,
        32'h00000001,
        32'h00000001,
        32'h00000400,
        32'h00000002,
        32'h00000040,
        32'h00000004,
        32'h00000001,
        32'h00000001,
        32'h00000400,
        32'h00000002,
        32'h00000400,
        32'h00000003,
        32'h00000080,
        32'h00000004,
        32'h00000200,
        32'h00000001,
        32'h00000010,
        32'h00000002,
        32'h00000001,
        32'h00000003,
        32'h0000000F,
        32'h00000007,
        32'h00000001,
        32'h00000001,
        32'h00000400,
        32'h00000002,
        32'h00000001,
        32'h00000003,
        32'h00000002,
        32'h00000001,
        32'h00000002,
        32'h00000002,
        32'h00000002,
        32'h00000003,
        32'h00000002,
        32'h00000004,
        32'h00000001,
        32'h00000002,
        32'h00000003,
        32'h00000003,
        32'h06AA0E2A,
        32'h000A9704,
        32'h33230000,
        32'h06AA0E2A,
        32'h000A9704,
        32'h44340000,
        32'h00000001,
        32'h06AA0E2A,
        32'h000A9704,
        32'h55450000,
        32'h00000002,
        32'h06AA0E2A,
        32'h000A9704,
        32'h66560000,
        32'h00000003
    };

    typedef enum {
        ST_WRITE_RAM,
        ST_DONE
    } state_t;

    state_t state_write;

    int     write_count;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state_write <= ST_WRITE_RAM;
            write_count <= 0;
            wb_cyc_o    <= 1'b0;
            wb_stb_o    <= 1'b0;
            wb_adr_o    <= '0;
            wb_dat_o    <= '0;
            wb_sel_o    <= '0;
            wb_we_o     <= 1'b0;
        end else begin
            case (state_write)
                ST_WRITE_RAM: begin
                    if (write_count == 0 || wb_ack_i) begin
                        if (write_count == 61) begin
                            wb_cyc_o    <= 1'b0;
                            wb_stb_o    <= 1'b0;
                            state_write <= ST_DONE;
                        end else begin
                            write_count <= write_count + 1;
                            wb_cyc_o    <= 1'b1;
                            wb_stb_o    <= 1'b1;
                            wb_we_o     <= 1'b1;
                            wb_sel_o    <= 4'b1111;
                            wb_adr_o    <= addr[write_count];
                            wb_dat_o    <= data[write_count];
                            state_write <= ST_WRITE_RAM;
                        end
                    end
                end
                ST_DONE: begin
                    state_write <= ST_DONE;
                end
            endcase
        end
    end

endmodule
