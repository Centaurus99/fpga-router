`timescale 1ns / 1ps

module tb_config_address ();

    wire clk_125M;
    clock clock_i (.clk_125M(clk_125M));

    reg           reset;
    reg           we;
    reg   [ 47:0] mac_in;

    wire  [ 47:0] mac_out;
    wire  [127:0] ip_out;
    logic [127:0] ip_ans;

    initial begin
        we = 0;

        #10;
        reset = 1;
        #10;
        reset = 0;

        #100;
        we     = 1;
        mac_in = {<<8{48'h00_21_2F_B5_6E_10}};  // 00:21:2F:B5:6E:10
        // 期望输出, MAC = mac_in, IPv6 = fe80::221:2fff:feb5:6e10
        ip_ans = {<<8{128'hfe80_0000_0000_0000_0221_2fff_feb5_6e10}};
        $display("Set mac_in = %h", mac_in);

        #10;
        we = 0;
        // 模块输出
        $display("Output: mac = %h; ip = %h;", mac_out, ip_out);
        $display("Expect: mac = %h; ip = %h;", mac_in, ip_ans);

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
