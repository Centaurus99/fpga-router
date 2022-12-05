`timescale 1ns / 1ps `default_nettype none

`include "csr_file.vh"

module csr_file (
    input wire clk,
    input wire rst,

    output reg [1:0] PMODE,

    input  wire [11:0] csr_addr,
    input  wire [31:0] csr_wdata,
    input  wire        csr_we,
    output reg  [31:0] csr_rdata,

    input wire trap_in,
    input wire trap_out,

    input  mepc_t   mepc_w,
    input  mcause_t mcause_w,
    input  mtval_t  mtval_w,
    output mie_t    mie_r,
    output mtvec_t  mtvec_r,
    output mepc_t   mepc_r,
    output mip_t    mip_r,

    input wire mtime_int_i
);

    mstatus_t  mstatus;
    mie_t      mie;
    mtvec_t    mtvec;
    mscratch_t mscratch;
    mepc_t     mepc;
    mcause_t   mcause;
    mtval_t    mtval;
    mip_t      mip;

    assign mie_r   = mie;
    assign mtvec_r = mtvec;
    assign mepc_r  = mepc;
    assign mip_r   = mip;

    always_comb begin
        unique case (csr_addr)
            12'h300: csr_rdata = mstatus;
            12'h304: csr_rdata = mie;
            12'h305: csr_rdata = mtvec;
            12'h340: csr_rdata = mscratch;
            12'h341: csr_rdata = mepc;
            12'h342: csr_rdata = mcause;
            12'h343: csr_rdata = mtval;
            12'h344: csr_rdata = mip;
            default: csr_rdata = 32'h00000000;
        endcase
    end

    // Read-Only CSR
    always_comb begin
        mip      = '{default: '0};
        mip.MTIP = mtime_int_i;
    end

    // Read-Write CSR
    always_ff @(posedge clk) begin
        if (rst) begin
            PMODE    <= 2'b11;
            mstatus  <= '{default: '0};
            mie      <= '{default: '0};
            mtvec    <= '{default: '0};
            mscratch <= '{default: '0};
            mepc     <= '{default: '0};
            mcause   <= '{default: '0};
            mtval    <= '{default: '0};
        end else begin
            if (csr_we) begin
                unique case (csr_addr)
                    12'h300: begin
                        mstatus      <= csr_wdata;
                        mstatus.pad0 <= '0;
                        mstatus.pad1 <= '0;
                    end
                    12'h304: begin
                        mie      <= csr_wdata;
                        mie.pad0 <= '0;
                        mie.pad1 <= '0;
                    end
                    12'h305: begin
                        mtvec      <= csr_wdata;
                        mtvec.MODE <= 2'b00;
                    end
                    12'h340: mscratch <= csr_wdata;
                    12'h341: mepc <= csr_wdata;
                    12'h342: mcause <= csr_wdata;
                    12'h343: mtval <= csr_wdata;
                endcase
            end
            if (trap_in) begin
                mepc        <= mepc_w;
                mcause      <= mcause_w;
                mtval       <= mtval_w;
                mstatus.MPP <= PMODE;
                PMODE       <= 2'b11;
            end else if (trap_out) begin
                PMODE <= mstatus.MPP;
            end
        end
    end

endmodule
