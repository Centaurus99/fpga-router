`timescale 1ns / 1ps

`include "../../sources_1/new/forwarding_table.vh"

module tb_forwarding_table #(
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32
) ();

    wire clk_125M, clk_100M;
    clock clock_i (
        .clk_125M(clk_125M),
        .clk_100M(clk_100M)
    );

    reg                reset;

    frame_beat         in;
    wire               in_ready;

    frame_beat         forwarded;
    wire               forwarded_ready;
    logic      [127:0] forwarded_next_hop_ip;

    logic      [127:0] const_ip;
    assign const_ip = {<<8{128'h2a0e_aa06_0497_0a00_0000_0000_1234_5678}};

    wire                             cpu_clk;
    wire                             wb_cyc_i;
    wire                             wb_stb_i;
    reg                              wb_ack_o;
    wire [  WISHBONE_ADDR_WIDTH-1:0] wb_adr_i;
    wire [  WISHBONE_DATA_WIDTH-1:0] wb_dat_i;
    reg  [  WISHBONE_DATA_WIDTH-1:0] wb_dat_o;
    wire [WISHBONE_DATA_WIDTH/8-1:0] wb_sel_i;
    wire                             wb_we_i;

    initial begin
        #10;
        reset = 1;
        #10;
        reset = 0;

        #1000;
        $finish;
    end

    typedef enum {
        ST_INIT,
        ST_SENT
    } state_t;

    state_t state;

    always_ff @(posedge clk_125M) begin
        if (reset) begin
            state <= ST_INIT;
            in    <= '{default: 0};
        end else begin
            case (state)
                ST_INIT: begin
                    in.valid        <= 1;
                    in.is_first     <= 1;
                    in.data.ip6.dst <= const_ip;
                    state           <= ST_SENT;
                end
                ST_SENT: begin
                    if (in_ready) begin
                        in    <= '{default: 0};
                        state <= ST_INIT;
                    end
                end
            endcase
        end
    end

    forwarding_table #(
        .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
        .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH)
    ) forwarding_table_i (
        .clk     (clk_125M),
        .reset   (reset),
        .in      (in),
        .in_ready(in_ready),

        .out        (forwarded),
        .next_hop_ip(forwarded_next_hop_ip),
        .out_ready  (forwarded_ready),

        .cpu_clk (clk_100M),
        .wb_cyc_i(wb_cyc_i),
        .wb_stb_i(wb_stb_i),
        .wb_ack_o(wb_ack_o),
        .wb_adr_i(wb_adr_i),
        .wb_dat_i(wb_dat_i),
        .wb_dat_o(wb_dat_o),
        .wb_sel_i(wb_sel_i),
        .wb_we_i (wb_we_i)
    );

endmodule
