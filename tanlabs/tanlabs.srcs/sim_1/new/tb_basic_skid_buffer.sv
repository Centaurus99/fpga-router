`timescale 1ns / 1ps

`include "../../sources_1/new/forwarding_table.vh"

module tb_basic_skid_buffer ();

    wire clk_125M;
    clock clock_i (.clk_125M(clk_125M));

    reg        reset;
    frame_beat in_data;
    wire       in_ready;

    reg        out_ready;
    frame_beat out_data;

    initial begin
        reset     = 1'b1;
        in_data   = 'b0;
        out_ready = 1'b1;
        #13;

        reset            = 1'b0;
        in_data.valid    = 1'b1;
        in_data.data.dst = 'h1;
        out_ready        = 1'b1;
        #8;

        in_data.valid    = 1'b1;
        in_data.data.dst = 'h2;
        out_ready        = 1'b1;
        #8;

        in_data.valid    = 1'b1;
        in_data.data.dst = 'h3;
        out_ready        = 1'b0;
        #8;

        in_data.valid    = 1'b1;
        in_data.data.dst = 'h4;
        out_ready        = 1'b0;
        #8;

        in_data.valid    = 1'b1;
        in_data.data.dst = 'h5;
        out_ready        = 1'b1;
        #8;

        in_data.valid    = 1'b1;
        in_data.data.dst = 'h6;
        out_ready        = 1'b1;
        #8;

        in_data.valid    = 1'b0;
        in_data.data.dst = 'h7;
        out_ready        = 1'b1;
        #8;
        #8;
        #8;

        $finish;
    end

    basic_skid_buffer u_basic_skid_buffer (
        .clk     (clk_125M),
        .reset   (reset),
        .in_data (in_data),
        .in_ready(in_ready),

        .out_data (out_data),
        .out_ready(out_ready)
    );

endmodule
