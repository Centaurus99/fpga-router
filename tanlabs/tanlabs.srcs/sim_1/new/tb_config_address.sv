`timescale 1ns / 1ps

module tb_config_address ();

    wire clk_125M;
    clock clock_i (.clk_125M(clk_125M));

    reg           reset;
    reg           we_mac;
    reg           we_ip;
    reg   [ 47:0] mac_in;

    logic [127:0] ip_eui64_comb;

    wire  [ 47:0] mac_out;
    wire  [127:0] ip_out;
    logic [127:0] ip_ans;

    initial begin
        we_mac = 0;
        we_ip  = 0;

        #10;
        reset = 1;
        #10;
        reset = 0;

        #100;
        we_mac = 1;
        we_ip  = 1;
        mac_in = {<<8{48'h00_21_2F_B5_6E_10}};  // 00:21:2F:B5:6E:10
        // 期望输出, MAC = mac_in, IPv6 = fe80::221:2fff:feb5:6e10
        ip_ans = {<<8{128'hfe80_0000_0000_0000_0221_2fff_feb5_6e10}};
        $display("Set mac_in = %h, ip generated from EUI64", mac_in);

        #10;
        we_mac = 0;
        we_ip  = 0;
        $display("Output: mac = %h; ip = %h;", mac_out, ip_out);
        $display("Expect: mac = %h; ip = %h;", mac_in, ip_ans);

        // 测试单独设置 MAC 地址
        #10;
        we_mac = 1;
        we_ip  = 0;
        mac_in = {<<8{48'h00_00_00_03_0A_01}};  // 00:00:00:03:0A:01
        $display("Set mac_in = %h, keep ip", mac_in);

        #10;
        we_mac = 0;
        we_ip  = 0;
        $display("Output: mac = %h; ip = %h;", mac_out, ip_out);
        $display("Expect: mac = %h; ip = %h;", mac_in, ip_ans);

        $finish;
    end

    eui64 eui64_i (
        .mac(mac_in),
        .ip (ip_eui64_comb)
    );

    config_address config_address_i (
        .clk  (clk_125M),
        .reset(reset),

        .we_mac (we_mac),
        .we_ip  (we_ip),
        .mac_in (mac_in),
        .ip_in  (ip_eui64_comb),
        .mac_reg(mac_out),
        .ip_reg (ip_out)
    );

endmodule
