`timescale 1ns / 1ps

module tb_config_address ();

    wire clk_125M;
    clock clock_i (.clk_125M(clk_125M));

    reg          reset;
    reg          we;
    reg  [ 47:0] mac_in;

    wire [ 47:0] mac_out;
    wire [127:0] ip_out;

    initial begin
        we = 0;

        #10;
        reset = 1;
        #10;
        reset = 0;

        #100;
        we     = 1;
        mac_in = 48'h10_6E_B5_2F_21_00;  // 00:21:2F:B5:6E:10
        $display("Set mac_in = %h", mac_in);

        #10;
        we = 0;
        // 模块输出
        $display("Output: mac = %h; ip = %h;", mac_out, ip_out);
        // 期望输出, MAC = mac_in, IPv6 = fe80::221:2fff:feb5:6e10
        $display("Expect: mac = %h; ip = %h;", mac_in,
                 128'h106e_b5fe_ff2f_2102_0000_0000_0000_80fe);

        $finish;
    end

    config_address config_address_i (
        .clk    (clk_125M),
        .reset  (reset),
        .we     (we),
        .mac_in (mac_in),
        .mac_reg(mac_out),
        .ip_reg (ip_out)
    );

endmodule
