module tb_neighbor_cache #(
    parameter DATA_WIDTH = 176,
    parameter ADDR_WIDTH = 5
) ();

    // neighbor_cache Inputs
    reg          reset;

    reg          we;
    reg  [127:0] in_v6;
    reg  [ 47:0] in_mac;

    // neighbor_cache Outputs
    wire [ 47:0] out_mac;
    wire         found;

    initial begin
        #100 reset = 1;
        #500 reset = 0;

        for (int i = 0; i < 8; i = i + 1) begin
            in_v6[127:96] = $urandom();
            in_v6[95:64]  = $urandom();
            in_v6[63:32]  = $urandom();
            in_v6[31:0]   = $urandom();

            for (int j = 0; j < 32; j = j + 1) begin
                #100
                    if ($urandom & 1) begin
                        in_v6[7:0] = in_v6[7:0] - $urandom_range(2);
                        in_v6[15:8] = in_v6[15:8] - $urandom_range(2);
                        #100;
                    end else begin
                        in_v6[7:0] = in_v6[7:0] + $urandom_range(2);
                        in_v6[15:8] = in_v6[15:8] + $urandom_range(2);
                        in_mac = $urandom();
                        we = 1;
                        #100 we = 0;
                        in_mac = 0;
                    end
                #1000;
            end
        end

        #10000 $finish;
    end

    wire clk_125M;

    clock clock_i (.clk_125M(clk_125M));


    neighbor_cache #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk   (clk_125M),
        .reset (reset),
        .we    (we),
        .in_v6 (in_v6),
        .in_mac(in_mac),

        .out_mac(out_mac),
        .found  (found)
    );


endmodule
