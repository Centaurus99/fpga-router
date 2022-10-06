`timescale 1ns / 1ps `default_nettype none

module config_address (
    input wire clk,
    input wire reset,

    input wire        we,
    input wire [47:0] mac_in,

    output reg [ 47:0] mac_reg,
    output reg [127:0] ip_reg
);

    logic [127:0] ip_eui64_comb;

    eui64 eui64_i (
        .mac(mac_in),
        .ip (ip_eui64_comb)
    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            mac_reg <= 48'b0;
            ip_reg  <= 128'b0;
        end else if (we) begin
            mac_reg <= mac_in;
            ip_reg  <= ip_eui64_comb;
        end
    end

endmodule
