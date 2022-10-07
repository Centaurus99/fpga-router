`include ""

module tb_checksum
#(
    parameter PACKET_LENGTH = 88;
    parameter MOD = 4'd0;
)
(
    
);

    frame_beat in;
    reg [15:0] sum;

    icmpv6_checksum dut(
        .beat(in);
        .sum(sum);
    );

    #2000
    assign in.ip6 = 4'h


endmodule