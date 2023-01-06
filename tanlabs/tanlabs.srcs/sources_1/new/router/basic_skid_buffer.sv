`timescale 1ns / 1ps `default_nettype none

// 最基础的 Skid Buffer, 用于防止 ready 信号超时
// 参考：https://zipcpu.com/blog/2019/05/22/skidbuffer.html

`include "frame_datapath.vh"

module basic_skid_buffer (
    input wire clk,
    input wire reset,

    input  frame_beat in_data,
    output reg        in_ready,

    output frame_beat out_data,
    input  wire       out_ready
);
    // Buffer
    frame_beat r_data;

    always_comb begin
        in_ready = ~r_data.valid;
        if (r_data.valid) begin
            out_data = r_data;
        end else begin
            out_data = in_data;
        end
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            r_data <= '{default: '0};
        end else begin
            if ((in_data.valid && in_ready) && (out_data.valid && !out_ready)) begin
                r_data <= in_data;
            end else if (out_ready) begin
                r_data <= '{default: '0};
            end
        end
    end

endmodule
