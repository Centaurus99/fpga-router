`timescale 1ns / 1ps `default_nettype none

`include "cpu_pipeline.vh"
`include "exception/csr_file.vh"

module paging_controller (
    input wire clk,
    input wire rst,

    input satp_t satp_r,
    input wire   SUM_r,

    // wishbone slave interface
    input  wire        wbs_cyc_i,
    input  wire        wbs_stb_i,
    output wire        wbs_ack_o,
    output reg         wbs_err_o,
    input  wire [31:0] wbs_adr_i,
    input  wire [31:0] wbs_dat_i,
    output wire [31:0] wbs_dat_o,
    input  wire [ 3:0] wbs_sel_i,
    input  wire        wbs_we_i,
    input  wire        wbs_IF,     // instruction fetch
    input  wire [ 1:0] wbs_PMODE,  // privilege mode

    // wishbone master interface
    output wire        wbm_cyc_o,
    output reg         wbm_stb_o,
    input  wire        wbm_ack_i,
    output reg  [31:0] wbm_adr_o,
    output reg  [31:0] wbm_dat_o,
    input  wire [31:0] wbm_dat_i,
    output reg  [ 3:0] wbm_sel_o,
    output reg         wbm_we_o
);
    assign wbm_cyc_o = wbm_stb_o;
    assign wbs_dat_o = wbm_dat_i;

    typedef enum logic [1:0] {
        MEM_IDLE,
        MEM_WALK1,
        MEM_WALK2,
        MEM_FINAL
    } mem_state_t;

    mem_state_t mem_state;
    PTE_t       pte;

    assign pte       = wbm_dat_i;
    assign wbs_ack_o = mem_state == MEM_FINAL && wbm_ack_i;

    always_ff @(posedge clk) begin
        if (rst) begin
            mem_state <= MEM_IDLE;
            wbs_err_o <= 1'b0;
            wbm_stb_o <= 1'b0;
            wbm_adr_o <= 32'h00000000;
            wbm_dat_o <= 32'h00000000;
            wbm_sel_o <= 4'b0000;
            wbm_we_o  <= 1'b0;
        end else begin
            wbs_err_o <= 1'b0;
            wbm_dat_o <= wbs_dat_i;
            case (mem_state)
                MEM_IDLE: begin
                    if (wbs_cyc_i && wbs_stb_i && !wbs_err_o) begin
                        if (satp_r.MODE && wbs_PMODE < 2'b11) begin
                            mem_state <= MEM_WALK1;
                            wbm_stb_o <= 1'b1;
                            wbm_adr_o <= satp_r.PPN << 12 | {wbs_adr_i[31:22], 2'b0};
                            wbm_sel_o <= 4'b1111;
                            wbm_we_o  <= 1'b0;
                        end else begin
                            mem_state <= MEM_FINAL;
                            wbm_stb_o <= 1'b1;
                            wbm_adr_o <= wbs_adr_i;
                            wbm_sel_o <= wbs_sel_i;
                            wbm_we_o  <= wbs_we_i;
                        end
                    end
                end
                MEM_WALK1: begin
                    if (wbm_ack_i) begin
                        if (pte.V == 1'b0 || (pte.R == 1'b0 && pte.W == 1'b1)) begin
                            mem_state <= MEM_IDLE;
                            wbs_err_o <= 1'b1;
                            wbm_stb_o <= 1'b0;
                        end else if (pte.R == 1'b1 || pte.X == 1'b1) begin
                            // 不支持 superpage, 抛出异常
                            mem_state <= MEM_IDLE;
                            wbs_err_o <= 1'b1;
                            wbm_stb_o <= 1'b0;
                        end else begin
                            mem_state <= MEM_WALK2;
                            wbm_stb_o <= 1'b1;
                            wbm_adr_o <= pte.PPN << 12 | {wbs_adr_i[21:12], 2'b0};
                            wbm_sel_o <= 4'b1111;
                            wbm_we_o  <= 1'b0;
                        end
                    end
                end
                MEM_WALK2: begin
                    if (wbm_ack_i) begin
                        if (pte.V == 1'b0 || (pte.R == 1'b0 && pte.W == 1'b1)) begin
                            mem_state <= MEM_IDLE;
                            wbs_err_o <= 1'b1;
                            wbm_stb_o <= 1'b0;
                        end else if (wbs_PMODE == 2'b01 && !SUM_r && pte.U == 1'b1) begin
                            // 非法访问用户页表
                            mem_state <= MEM_IDLE;
                            wbs_err_o <= 1'b1;
                            wbm_stb_o <= 1'b0;
                        end else if (wbs_IF == 1'b1 && pte.X == 1'b0) begin
                            // 不可执行
                            mem_state <= MEM_IDLE;
                            wbs_err_o <= 1'b1;
                            wbm_stb_o <= 1'b0;
                        end else if (wbs_we_i == 1'b1 && pte.W == 1'b0) begin
                            // 不可写
                            mem_state <= MEM_IDLE;
                            wbs_err_o <= 1'b1;
                            wbm_stb_o <= 1'b0;
                        end else if (wbs_we_i == 1'b0 && pte.R == 1'b0) begin
                            // 不可读
                            mem_state <= MEM_IDLE;
                            wbs_err_o <= 1'b1;
                            wbm_stb_o <= 1'b0;
                        end else begin
                            mem_state <= MEM_FINAL;
                            wbm_stb_o <= 1'b1;
                            wbm_adr_o <= pte.PPN << 12 | wbs_adr_i[11:0];
                            wbm_sel_o <= wbs_sel_i;
                            wbm_we_o  <= wbs_we_i;
                        end
                    end
                end
                MEM_FINAL: begin
                    if (wbm_ack_i) begin
                        mem_state <= MEM_IDLE;
                        wbm_stb_o <= 1'b0;
                    end
                end
                default: begin
                    mem_state <= MEM_IDLE;
                    wbm_stb_o <= 1'b0;
                end
            endcase
        end
    end

endmodule
