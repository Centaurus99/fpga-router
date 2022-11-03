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
    assign forwarded_ready = 1'b1;

    logic [127:0] const_ip;
    assign const_ip = {<<8{128'h2a0e_aa06_0497_0a01_0000_0000_1234_5678}};

    wire                             cpu_clk;
    reg                              wb_cyc_i;
    reg                              wb_stb_i;
    reg                              wb_ack_o;
    reg  [  WISHBONE_ADDR_WIDTH-1:0] wb_adr_i;
    reg  [  WISHBONE_DATA_WIDTH-1:0] wb_dat_i;
    reg  [  WISHBONE_DATA_WIDTH-1:0] wb_dat_o;
    reg  [WISHBONE_DATA_WIDTH/8-1:0] wb_sel_i;
    reg                              wb_we_i;

    int                              fd;
    initial begin
        fd    = $fopen("mem.txt", "r");
        reset = 1;
        #20;
        reset = 0;

        #1000;
        $finish;
    end

    typedef enum {
        ST_WRITE_RAM,
        ST_SENT,
        ST_SENT_WAIT,
        ST_DONE
    } state_t;

    state_t                           state;

    int                               write_count;
    int                               ret;
    reg     [WISHBONE_DATA_WIDTH-1:0] ram_addr;
    reg     [WISHBONE_DATA_WIDTH-1:0] ram_data;

    always_ff @(posedge clk_100M or posedge reset) begin
        if (reset) begin
            state       <= ST_WRITE_RAM;
            in          <= '{default: 0};
            write_count <= 0;
        end else begin
            case (state)
                ST_WRITE_RAM: begin
                    if (write_count == 0 || wb_ack_o) begin
                        write_count <= write_count + 1;
                        ret = $fscanf(fd, "%x%x", ram_addr, ram_data);
                        if (ret != 2) begin
                            wb_cyc_i <= 1'b0;
                            wb_stb_i <= 1'b0;
                            state    <= ST_SENT;
                        end else begin
                            wb_cyc_i <= 1'b1;
                            wb_stb_i <= 1'b1;
                            wb_we_i  <= 1'b1;
                            wb_sel_i <= 4'b1111;
                            wb_adr_i <= ram_addr;
                            wb_dat_i <= ram_data;
                            state    <= ST_WRITE_RAM;
                        end
                    end
                end
                ST_SENT: begin
                    in.valid        <= 1;
                    in.is_first     <= 1;
                    in.data.ip6.dst <= const_ip;
                    state           <= ST_SENT;
                end
                ST_SENT_WAIT: begin
                    if (in_ready) begin
                        in    <= '{default: 0};
                        state <= ST_DONE;
                    end
                end
                ST_DONE: begin
                    state <= ST_DONE;
                    #100;
                    $finish;
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
