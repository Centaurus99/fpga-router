`timescale 1ns / 1ps `default_nettype none

module load_flash (
    input wire clk,
    input wire rst,

    input  wire        push_btn,
    output reg  [15:0] leds,
    output reg         wait_flash,

    // 写 SRAM
    output wire        wbm_sram_cyc_o,
    output reg         wbm_sram_stb_o,
    input  wire        wbm_sram_ack_i,
    output reg  [31:0] wbm_sram_adr_o,
    output reg  [31:0] wbm_sram_dat_o,
    input  wire [31:0] wbm_sram_dat_i,
    output reg  [ 3:0] wbm_sram_sel_o,
    output reg         wbm_sram_we_o,

    // 读 Flash
    output wire        wbm_flash_read_cyc_o,
    output reg         wbm_flash_read_stb_o,
    input  wire        wbm_flash_read_ack_i,
    output reg  [31:0] wbm_flash_read_adr_o,
    output reg  [31:0] wbm_flash_read_dat_o,
    input  wire [31:0] wbm_flash_read_dat_i,
    output reg  [ 3:0] wbm_flash_read_sel_o,
    output reg         wbm_flash_read_we_o

);
    reg        push_btn_reg;
    reg        push_btn_reg2;
    reg [23:0] base_addr;

    assign wbm_flash_read_cyc_o = wbm_flash_read_stb_o;
    assign wbm_flash_read_adr_o = {8'h90, base_addr};
    assign wbm_flash_read_dat_o = 32'h00000000;
    assign wbm_flash_read_sel_o = 4'b1111;
    assign wbm_flash_read_we_o  = 1'b0;

    assign wbm_sram_cyc_o       = wbm_sram_stb_o;

    typedef enum {
        ST_IDLE,
        ST_READ,
        ST_WRITE
    } flash_crontrol_state_t;

    flash_crontrol_state_t flash_crontrol_state;

    always_ff @(posedge clk) begin
        if (rst) begin
            leds                 <= 16'h0000;
            wait_flash           <= 1'b0;
            push_btn_reg         <= 1'b0;
            push_btn_reg2        <= 1'b0;
            base_addr            <= 24'h000000;
            flash_crontrol_state <= ST_IDLE;
            wbm_flash_read_stb_o <= 1'b0;
            wbm_sram_stb_o       <= 1'b0;
            wbm_sram_adr_o       <= 32'h00000000;
            wbm_sram_dat_o       <= 32'h00000000;
            wbm_sram_sel_o       <= 4'b0000;
            wbm_sram_we_o        <= 1'b0;
        end else begin
            push_btn_reg  <= push_btn;
            push_btn_reg2 <= push_btn_reg;
            case (flash_crontrol_state)
                ST_IDLE: begin
                    if (push_btn_reg && !push_btn_reg2) begin
                        wait_flash           <= 1'b1;
                        base_addr            <= 24'h000000;
                        wbm_flash_read_stb_o <= 1'b1;
                        flash_crontrol_state <= ST_READ;
                    end
                end
                ST_READ: begin
                    leds[base_addr[22:19]^4'b1111] <= 1'b1;
                    if (wbm_flash_read_ack_i) begin
                        wbm_flash_read_stb_o <= 1'b0;
                        wbm_sram_stb_o       <= 1'b1;
                        wbm_sram_adr_o       <= {8'h80, base_addr};
                        wbm_sram_dat_o       <= wbm_flash_read_dat_i;
                        wbm_sram_sel_o       <= 4'b1111;
                        wbm_sram_we_o        <= 1'b1;
                        flash_crontrol_state <= ST_WRITE;
                    end
                end
                ST_WRITE: begin
                    if (wbm_sram_ack_i) begin
                        wbm_sram_stb_o <= 1'b0;
                        wbm_sram_adr_o <= 32'h00000000;
                        wbm_sram_dat_o <= 32'h00000000;
                        wbm_sram_sel_o <= 4'b0000;
                        wbm_sram_we_o  <= 1'b0;
                        if (base_addr == 24'h7ffffc) begin
                            base_addr            <= 24'h000000;
                            leds                 <= 16'h0000;
                            wait_flash           <= 1'b0;
                            flash_crontrol_state <= ST_IDLE;
                        end else begin
                            base_addr            <= base_addr + 24'h000004;
                            wbm_flash_read_stb_o <= 1'b1;
                            flash_crontrol_state <= ST_READ;
                        end
                    end
                end
            endcase
        end
    end

endmodule
