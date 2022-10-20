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

    frame_beat s1;
    int  s1_state;
    wire s1_ready;
    assign in_ready = (s1_ready && s1_state == 0) || !in.valid;

    always_comb begin
        s1.valid = s1_state == 0;
    end

    // 娉ㄦ剰杩欐牱鐨勪唬鐮佸彧鑳界畻鍗曞寘 88 Byte
    reg   [8 * 127:0] long_sum_pack = 0;
    reg   [8 * 127:0] long_sum_pack_copy = 0;
    reg   [8 * 127:0] long_sum_pack_sum = 0;
    reg   [31:0] move_reg;

    // always_comb begin
    //     // 鍔犱笂next_header鍜宲ayload_len
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
            s1_state    <= 0;
        end else begin
            case (s1_state)
                0: begin
                    if (s1_ready) begin
                        s1 <= in;
                        move_reg = 8;
                        long_sum_pack[8 * 72 - 1 : 0] = in.data.ip6[8 * 86 - 1 : 8 * 8];
                        long_sum_pack[8 * 73 - 1 : 8 * 72] = {8'h00, in.data.ip6.next_hdr};
                        long_sum_pack[8 * 74 - 1 : 8 * 73] = {in.data.ip6.payload_len[7:0], in.data.ip6.payload_len[15:8]};
                        if (in.valid && in.is_first && !in.meta.drop && in.meta.ndp_packet) begin
                            s1_state <= 10;
                        end
                    end
                end
                7: begin
                    out.data.ip6.p[31 : 16] <= long_sum_pack[15 : 0]; // sum_reg浠呬粎鏄暟鍊煎拰
                    s1_state <= 0;
                end
                default: begin
                    long_sum_pack_copy <= long_sum_pack >>> move_reg;
                    for(int i = 0; i < 128; i ++) begin
                        long_sum_pack_sum[(8 * i)+ : 8] <= long_sum_pack_copy[(8 * i)+ : 8] + long_sum_pack[(8 * i)+ : 8];
                        if({8'b0, long_sum_pack_sum[(8 * i)+ : 8]} < {8'b0, long_sum_pack_copy[(8 * i)+:8]} + {8'b0, long_sum_pack[(8 * i)+:8]}) begin
                            long_sum_pack_sum[(8 * i)+ : 8] <= long_sum_pack_sum[(8 * i)+ : 8] + 1;
                        end
                    end
                    move_reg <= move_reg * 2;
                    s1_state <= s1_state + 1;
                end
            endcase
        end
    end

    assign out      = s1;
    assign s1_ready = out_ready;

endmodule
