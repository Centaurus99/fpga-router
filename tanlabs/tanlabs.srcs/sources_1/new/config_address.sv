`timescale 1ns / 1ps `default_nettype none

module config_address (
    input wire clk,
    input wire reset,

    input wire         we_mac,
    input wire         we_ip,
    input wire [ 47:0] mac_in,
    input wire [127:0] ip_in,

    output reg [ 47:0] mac_reg,
    output reg [127:0] ip_reg
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            mac_reg <= 48'b0;
            ip_reg  <= 128'b0;
        end else begin
            if (we_mac) begin
                mac_reg <= mac_in;
            end
            if (we_ip) begin
                ip_reg <= ip_in;
            end
        end
    end

endmodule
