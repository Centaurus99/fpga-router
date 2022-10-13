`include "frame_datapath.vh"

module icmpv6_checksum 
#(
    parameter PACKET_LENGTH = 88,
    parameter MOD = 4'd0
)
(
    input frame_beat beat,
    output wire [15:0] sum
);

    reg [23:0] sum_reg = 6'h000000;
    always_comb begin
        // 加上next_header和payload_len
        sum_reg = beat.data.ip6.next_hdr + {beat.data.ip6.payload_len[7:0], beat.data.ip6.payload_len[15:8]};
        // 注意这样的代码只能算单包 88 Byte
    end
    genvar i;
    generate 
    for(i = 0;i < PACKET_LENGTH;i= i + 2) begin
        always_comb begin
            sum_reg = sum_reg + {beat.data.ip6[8 * (i + 1) - 1:8 * (i)], beat.data.ip6[8 * (i + 2) - 1:8 * (i + 1)]};
        end
    end
    endgenerate
    assign sum = ~{sum_reg[7:0], sum_reg[15:8]}; // sum_reg仅仅是数值和

endmodule