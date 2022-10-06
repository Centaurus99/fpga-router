`include "frame_datapath.vh"

module icmpv6_checksum (
    input frame_beat beat,
    output wire [15:0] sum
)

    reg [23:0] sum_reg;
    sum_reg = sum_reg + beat.data.ip6.next_hdr;
    sum_reg = sum_reg + {beat.data.ip6.payload_len[7:0], beat.data.ip6.payload_len[15:8]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 9 - 1:8 * 8], beat.data.ip6[8 * 10 - 1:8 * 9]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 11 - 1:8 * 10], beat.data.ip6[8 * 12 - 1:8 * 11]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 13 - 1:8 * 12], beat.data.ip6[8 * 14 - 1:8 * 13]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 15 - 1:8 * 14], beat.data.ip6[8 * 16 - 1:8 * 15]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 17 - 1:8 * 16], beat.data.ip6[8 * 18 - 1:8 * 17]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 19 - 1:8 * 18], beat.data.ip6[8 * 20 - 1:8 * 19]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 21 - 1:8 * 20], beat.data.ip6[8 * 22 - 1:8 * 21]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 23 - 1:8 * 22], beat.data.ip6[8 * 24 - 1:8 * 23]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 25 - 1:8 * 24], beat.data.ip6[8 * 26 - 1:8 * 25]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 27 - 1:8 * 26], beat.data.ip6[8 * 28 - 1:8 * 27]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 29 - 1:8 * 28], beat.data.ip6[8 * 30 - 1:8 * 29]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 31 - 1:8 * 30], beat.data.ip6[8 * 32 - 1:8 * 31]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 33 - 1:8 * 32], beat.data.ip6[8 * 34 - 1:8 * 33]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 35 - 1:8 * 34], beat.data.ip6[8 * 36 - 1:8 * 35]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 37 - 1:8 * 36], beat.data.ip6[8 * 38 - 1:8 * 37]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 39 - 1:8 * 38], beat.data.ip6[8 * 40 - 1:8 * 39]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 41 - 1:8 * 40], beat.data.ip6[8 * 42 - 1:8 * 41]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 43 - 1:8 * 42], beat.data.ip6[8 * 44 - 1:8 * 43]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 45 - 1:8 * 44], beat.data.ip6[8 * 46 - 1:8 * 45]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 47 - 1:8 * 46], beat.data.ip6[8 * 48 - 1:8 * 47]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 49 - 1:8 * 48], beat.data.ip6[8 * 50 - 1:8 * 49]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 51 - 1:8 * 50], beat.data.ip6[8 * 52 - 1:8 * 51]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 53 - 1:8 * 52], beat.data.ip6[8 * 54 - 1:8 * 53]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 55 - 1:8 * 54], beat.data.ip6[8 * 56 - 1:8 * 55]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 57 - 1:8 * 56], beat.data.ip6[8 * 58 - 1:8 * 57]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 59 - 1:8 * 58], beat.data.ip6[8 * 60 - 1:8 * 59]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 61 - 1:8 * 60], beat.data.ip6[8 * 62 - 1:8 * 61]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 63 - 1:8 * 62], beat.data.ip6[8 * 64 - 1:8 * 63]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 65 - 1:8 * 64], beat.data.ip6[8 * 66 - 1:8 * 65]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 67 - 1:8 * 66], beat.data.ip6[8 * 68 - 1:8 * 67]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 69 - 1:8 * 68], beat.data.ip6[8 * 70 - 1:8 * 69]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 71 - 1:8 * 70], beat.data.ip6[8 * 72 - 1:8 * 71]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 73 - 1:8 * 72], beat.data.ip6[8 * 74 - 1:8 * 73]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 75 - 1:8 * 74], beat.data.ip6[8 * 76 - 1:8 * 75]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 77 - 1:8 * 76], beat.data.ip6[8 * 78 - 1:8 * 77]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 79 - 1:8 * 78], beat.data.ip6[8 * 80 - 1:8 * 79]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 81 - 1:8 * 80], beat.data.ip6[8 * 82 - 1:8 * 81]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 83 - 1:8 * 82], beat.data.ip6[8 * 84 - 1:8 * 83]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 85 - 1:8 * 84], beat.data.ip6[8 * 86 - 1:8 * 85]};
    sum_reg = sum_reg + {beat.data.ip6[8 * 87 - 1:8 * 86], beat.data.ip6[8 * 88 - 1:8 * 87]};
    assign sum = sum_reg[15:0];

endmodule