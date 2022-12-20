`default_nettype none

module naive_gpio #(
    parameter DATA_WIDTH = 32,  // DATA_WIDTH: wishbone data width
    parameter ADDR_WIDTH = 32   // DATA_WIDTH: wishbone data width
) (
    input wire clk,
    input wire rst,

    // wishbone slave interface
    input  wire                    wb_cyc_i,
    input  wire                    wb_stb_i,
    output reg                     wb_ack_o,
    input  wire [  ADDR_WIDTH-1:0] wb_adr_i,
    input  wire [  DATA_WIDTH-1:0] wb_dat_i,
    output reg  [  DATA_WIDTH-1:0] wb_dat_o,
    input  wire [DATA_WIDTH/8-1:0] wb_sel_i,
    input  wire                    wb_we_i,

    input  wire [ 3:0] touch_btn,  // BTN1~BTN4，按钮开关，按下时为 1
    input  wire [31:0] dip_sw,     // 32 位拨码开关，拨到“ON”时为 1
    output wire [15:0] leds,       // 16 位 LED，输出时 1 点亮
    output wire [ 7:0] dpy0,       // 数码管低位信号，包括小数点，输出 1 点亮
    output wire [ 7:0] dpy1       // 数码管高位信号，包括小数点，输出 1 点亮 

);

    reg [15:0] leds_reg;
    reg [7:0] dpy0_reg;
    reg [7:0] dpy1_reg;

    always_ff @(posedge clk) begin
        if(rst) begin
            leds_reg <= 16'h00;
            dpy0_reg <= 8'h0;
            dpy1_reg <= 8'h0;
        end else if(wb_cyc_i & wb_stb_i) begin
            wb_ack_o <= 1'b1;
            case(wb_adr_i[3:0])
                4'h0: begin 
                    if(! wb_we_i) begin
                        wb_dat_o <= dip_sw;
                    end
                end
                4'h4: begin 
                    if(! wb_we_i) begin
                        wb_dat_o <= {16'h00, leds_reg};
                    end else begin
                        leds_reg <= wb_dat_i[15:0];
                    end
                end
                4'h8: begin 
                    if(! wb_we_i) begin
                        wb_dat_o <= {28'h000, touch_btn};
                    end
                end
                4'hc: begin 
                    if(! wb_we_i) begin
                        wb_dat_o <= {16'h00, dpy0_reg, dpy1_reg};
                    end else begin
                        dpy0_reg <= wb_dat_i[15:8];
                        dpy1_reg <= wb_dat_i[7:0];
                    end
                end    
                default: begin
                    // 理论上不能到这里
                end
            endcase
        end else begin 
            wb_ack_o <= 1'b0;
        end
    end

    assign leds = leds_reg;
    assign dpy0 = dpy0_reg;
    assign dpy1 = dpy1_reg;

endmodule