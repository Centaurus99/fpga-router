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

    typedef enum {
        ST_INIT,  
        ST_CALC1, 
        ST_CALC2,  
        ST_CALC3,
        ST_FINISHED  
    } s1_state_t;

    frame_beat s1, s1_reg;
    s1_state_t  s1_state;
    wire s1_ready;
    assign in_ready = (s1_ready && s1_state == ST_INIT) || !in.valid;

    always_comb begin
        s1       = s1_reg;
        s1.valid = s1_reg.valid && s1_state == ST_INIT;
    end

    // 注意这样的代码只能算单包 88 Byte
    reg   [8 * 68 - 1:0] sum_reg;
    reg   [24 * 8 - 1:0] temp_sum_reg;
    reg           [23:0] sum_overflow_reg;
    reg           [23:0] sum_overflow_reg_copy;

    always_comb begin
        // 溢出处理
        sum_overflow_reg_copy = sum_overflow_reg;
        sum_overflow_reg_copy[23:0] = {8'b0, sum_overflow_reg_copy[15:0]} + {16'b0, sum_overflow_reg_copy[23:16]};
        sum_overflow_reg_copy[23:0] = {8'b0, sum_overflow_reg_copy[15:0]} + {16'b0, sum_overflow_reg_copy[23:16]};
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
            s1_reg       <= 0;
            s1_state     <= ST_INIT;
            sum          <= 16'h0000;
            sum_overflow_reg <= 24'h000000;
            sum_reg      <= 544'h0;
            temp_sum_reg <= 192'h0;
        end else begin
            case (s1_state)
                ST_INIT: begin
                    if (s1_ready) begin
                        s1_reg <= in;
                        if (in.valid && in.is_first && !in.meta.drop && in.meta.ndp_packet) begin
                            // 因为后面会反过来，这个里面也采用网络字节�?
                            if(in.data.ip6.payload_len == 16'h2000) begin
                                sum_reg  <= {in.data.ip6[8*72-1:8*8], in.data.ip6.next_hdr, 8'b0, in.data.ip6.payload_len};
                            end else if(in.data.ip6.payload_len == 16'h1800) begin
                                sum_reg  <= {in.data.ip6[8*64-1:8*8], in.data.ip6.next_hdr, 8'b0, in.data.ip6.payload_len, 64'b0};
                            end 
                            s1_state <= ST_CALC1;
                        end
                    end
                end
                ST_CALC1: begin
                    // 除去�?后一位是六合�?之外，其余的都是四合�?计算
                    for(int i = 0; i < 8; i ++) begin
                        if(i !== 7) begin 
                            temp_sum_reg[(24*i)+:24] <= {8'b0, sum_reg[(8*(8*i))+:8], sum_reg[(8*(8*i+1))+:8]} + 
                                                        {8'b0, sum_reg[(8*(8*i+2))+:8], sum_reg[(8*(8*i+3))+:8]} +
                                                        {8'b0, sum_reg[(8*(8*i+4))+:8], sum_reg[(8*(8*i+5))+:8]} +
                                                        {8'b0, sum_reg[(8*(8*i+6))+:8], sum_reg[(8*(8*i+7))+:8]};
                        end else begin
                            temp_sum_reg[(24*i)+:24] <= {8'b0, sum_reg[(8*(8*i))+:8], sum_reg[(8*(8*i+1))+:8]} + 
                                                        {8'b0, sum_reg[(8*(8*i+2))+:8], sum_reg[(8*(8*i+3))+:8]} +
                                                        {8'b0, sum_reg[(8*(8*i+4))+:8], sum_reg[(8*(8*i+5))+:8]} +
                                                        {8'b0, sum_reg[(8*(8*i+6))+:8], sum_reg[(8*(8*i+7))+:8]} + 
                                                        {8'b0, sum_reg[(8*(8*i+8))+:8], sum_reg[(8*(8*i+9))+:8]} +
                                                        {8'b0, sum_reg[(8*(8*i+10))+:8], sum_reg[(8*(8*i+11))+:8]};
                        end                            
                    end
                    s1_state <= ST_CALC2;
                end
                ST_CALC2: begin
                    temp_sum_reg[23:0] <= temp_sum_reg[23:0] + temp_sum_reg[47:24] + temp_sum_reg[71:48] + temp_sum_reg[95:72];
                    temp_sum_reg[23+96:0+96] <= temp_sum_reg[23+96:0+96] + temp_sum_reg[47+96:24+96] + temp_sum_reg[71+96:48+96] + temp_sum_reg[95+96:72+96];   
                    s1_state <= ST_CALC3;
                end
                ST_CALC3: begin
                    // 溢出处理
                    sum_overflow_reg <= temp_sum_reg[23:0] + temp_sum_reg[23+96:0+96]; 
                    s1_state <= ST_FINISHED;
                end
                ST_FINISHED: begin
                    // 计算完成
                    sum <= ~{sum_overflow_reg_copy[7:0], sum_overflow_reg_copy[15:8]};
                    s1_state <= ST_INIT;
                end
                default: begin
                    // 理论上不会到
                    s1_state <= ST_INIT;
                end
            endcase
        end
    end

    assign out      = s1;
    assign s1_ready = out_ready;

endmodule
