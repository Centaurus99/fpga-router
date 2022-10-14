`timescale 1ns / 1ps `default_nettype none

`include "frame_datapath.vh"

module icmpv6_checksum #(
    parameter PACKET_LENGTH = 88,
    parameter MOD = 4'd0
) (
    input wire clk,
    input wire reset,

    input  frame_beat in,
    output reg        in_ready,

    output frame_beat        out,
    output reg        [15:0] sum,
    input  wire              out_ready
);

    frame_beat s1, s1_reg;
    int  s1_state;
    wire s1_ready;
    assign in_ready = (s1_ready && s1_state == 0) || !in.valid;

    always_comb begin
        s1       = s1_reg;
        s1.valid = s1_reg.valid && s1_state == 0;
    end

    // 注意这样的代码只能算单包 88 Byte
    reg   [23:0] sum_reg;

    // 最后两次溢出加法的处理
    logic [23:0] sum_over_in;
    logic [23:0] sum_over_out;
    always_comb begin
        sum_over_out = {8'b0, sum_over_in[15:0]} + sum_over_in[23:16];
        sum_over_out = {8'b0, sum_over_out[15:0]} + sum_over_out[23:16];
    end

    // always_comb begin
    //     // 加上next_header和payload_len
    //     sum_reg = in.data.ip6.next_hdr;
    //     sum_reg = sum_reg + {in.data.ip6.payload_len[7:0], in.data.ip6.payload_len[15:8]};
    //     for (int i = 8; i < 72; i = i + 2) begin
    //         sum_reg = sum_reg + {in.data.ip6[8*i+:8], in.data.ip6[8*(i+1)+:8]};
    //     end
    //     sum_reg = {8'b0, sum_reg[15:0]} + sum_reg[23:16];
    //     sum_reg = {8'b0, sum_reg[15:0]} + sum_reg[23:16];
    // end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            s1_reg      <= 0;
            s1_state    <= 0;
            sum         <= 24'h000000;
            sum_reg     <= 24'h000000;
            sum_over_in <= 24'h000000;
        end else begin
            case (s1_state)
                0: begin
                    if (s1_ready) begin
                        s1_reg <= in;
                        if (in.valid && in.is_first && !in.meta.drop && in.meta.ndp_packet) begin
                            sum_reg  <= {8'b0, in.data.ip6.next_hdr};
                            s1_state <= 1;
                        end
                    end
                end
                1: begin
                    sum_reg <= sum_reg + {s1_reg.data.ip6.payload_len[7:0], s1_reg.data.ip6.payload_len[15:8]};
                    s1_state <= 8;
                end
                72: begin
                    sum_over_in <= sum_reg;
                    s1_state    <= 73;
                end
                73: begin
                    sum <= ~{sum_over_out[7:0], sum_over_out[15:8]};  // sum_reg仅仅是数值和
                    s1_state <= 0;
                end
                default: begin
                    sum_reg <= sum_reg + {s1_reg.data.ip6[8*(s1_state+0)+:8], s1_reg.data.ip6[8*(s1_state+1)+:8]}
                                       + {s1_reg.data.ip6[8*(s1_state+2)+:8], s1_reg.data.ip6[8*(s1_state+3)+:8]};
                    s1_state <= s1_state + 4;
                end
            endcase
        end
    end

    assign out      = s1;
    assign s1_ready = out_ready;

endmodule
