module tb_neighbor_cache #(
    parameter DATA_WIDTH = 176,
    parameter ADDR_WIDTH = 5
) ();

    // neighbor_cache Inputs
    reg          reset;

    reg          we;
    reg  [127:0] in_v6_r, in_v6_w;
    reg  [ 47:0] in_mac;

    // neighbor_cache Outputs
    wire [ 47:0] out_mac;
    wire         found;

    initial begin
        #10 reset = 1;
        #50 reset = 0;

        in_v6_w[127:96] = $urandom();
        in_v6_w[95:64]  = $urandom();
        in_v6_w[63:32]  = $urandom();
        in_v6_w[31:0]   = $urandom();
        for (int i = 0; i < 8; i = i + 1) begin
            in_v6_w[7:0] = i;
            in_v6_r = in_v6_w;
            // 写入5个冲突的
            for (int j = 0; j < 5; j = j + 1) begin
                #10
                    in_mac = i * 32 + j + 1;
                    we = 1;
                    #10 we = 0;
                    in_mac = 0;
                    in_v6_w[127:120] = in_v6_w[127:120] ^ (1<<j);
                    in_v6_w[119:112] = in_v6_w[119:112] ^ (1<<j);
                #20;
            end
            // 倒着读出来
            in_v6_r = in_v6_w;
            for (int j = 4; j >= 0; j = j - 1) begin
                #10
                    in_v6_r[127:120] = in_v6_r[127:120] ^ (1<<j);
                    in_v6_r[119:112] = in_v6_r[119:112] ^ (1<<j);
                #20;
            end
        end

        #100 $finish;
    end

    wire clk_125M;

    clock clock_i (.clk_125M(clk_125M));


    neighbor_cache dut (
        .clk   (clk_125M),
        .reset (reset),
        .we    (we),
        .in_v6_w (in_v6_w),
        .in_v6_r (in_v6_r),
        .in_mac(in_mac),
        .in_id_w (4'h0),
        .in_id_r (4'h0),

        .out_mac(out_mac),
        .found  (found)
    );


endmodule
