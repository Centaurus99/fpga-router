`timescale 1ns / 1ps `default_nettype none

`include "csr_file.vh"
`include "exception.vh"

module csr_file (
    input wire clk,
    input wire rst,

    output reg [1:0] PMODE,

    input  wire [11:0] csr_addr,
    input  wire [31:0] csr_wdata,
    input  wire        csr_we,
    output reg  [31:0] csr_rdata,

    output satp_t    satp_r,
    output wire      SUM_r,
    output stvec_t   stvec_r,
    output sepc_t    sepc_r,
    output medeleg_t medeleg_r,
    output mtvec_t   mtvec_r,
    output mepc_t    mepc_r,

    input wire trap_in,
    input wire trap_out,
    input wire trap_type,

    input mepc_t   epc_w,
    input mcause_t cause_w,
    input mtval_t  tval_w,

    input  wire [63:0] mtime_i,
    input  wire        mtime_int_i,
    output reg  [31:0] M_Interrupt,
    output reg  [31:0] S_Interrupt
);

    sstatus_t sstatus, sstatus_i;
    satp_t satp;
    sie_t sie, sie_i;
    stvec_t    stvec;
    sscratch_t sscratch;
    sepc_t     sepc;
    scause_t   scause;
    stval_t    stval;
    sip_t      sip;

    mhartid_t  mhartid;
    mstatus_t  mstatus;
    medeleg_t  medeleg;
    mideleg_t  mideleg;
    mie_t      mie;
    mtvec_t    mtvec;
    mscratch_t mscratch;
    mepc_t     mepc;
    mcause_t   mcause;
    mtval_t    mtval;
    mip_t mip, mip_i;

    assign satp_r    = satp;
    assign SUM_r     = sstatus.SUM;

    assign stvec_r   = stvec;
    assign sepc_r    = sepc;

    assign medeleg_r = medeleg;
    assign mtvec_r   = mtvec;
    assign mepc_r    = mepc;

    // Interrupts
    wire [31:0] M_Interrupt_mask = 32'h888;
    wire [31:0] S_Interrupt_mask = 32'h222;
    always_comb begin
        M_Interrupt = (PMODE < 2'b11 || mstatus.MIE) ? (M_Interrupt_mask & mip & mie) : 32'h0;
        S_Interrupt = (PMODE < 2'b01 || (PMODE == 2'b01 && sstatus.SIE)) ? (S_Interrupt_mask & sip & sie & mideleg) : 32'h0;
    end

    // Hardwired CSR
    always_comb begin
        sstatus_i    = csr_wdata;
        sstatus.SIE  = mstatus.SIE;
        sstatus.SPP  = mstatus.SPP;
        sstatus.SPIE = mstatus.SPIE;
        sstatus.SUM  = mstatus.SUM;
        sstatus.pad0 = '0;
        sstatus.pad1 = '0;
        sstatus.pad2 = '0;
        sstatus.pad3 = '0;
        sstatus.pad4 = '0;

        sie_i        = csr_wdata;
        sie.STIE     = mie.STIE;
        sie.pad0     = '0;
        sie.pad1     = '0;

        mip_i        = csr_wdata;
        mip.MTIP     = mtime_int_i;
        mip.pad0     = '0;
        mip.pad1     = '0;
        mip.pad2     = '0;
    end

    // Read-Only CSR
    always_comb begin
        mhartid  = '{default: '0};
        sip      = '{default: '0};
        sip.STIP = mip.STIP;
    end

    // Read CSR
    always_comb begin
        unique case (csr_addr)
            12'h100: csr_rdata = sstatus;
            12'h104: csr_rdata = sie;
            12'h105: csr_rdata = stvec;
            12'h140: csr_rdata = sscratch;
            12'h141: csr_rdata = sepc;
            12'h142: csr_rdata = scause;
            12'h143: csr_rdata = stval;
            12'h144: csr_rdata = sip;
            12'h180: csr_rdata = satp;

            12'hF14: csr_rdata = mhartid;
            12'h300: csr_rdata = mstatus;
            12'h302: csr_rdata = medeleg;
            12'h303: csr_rdata = mideleg;
            12'h304: csr_rdata = mie;
            12'h305: csr_rdata = mtvec;
            12'h340: csr_rdata = mscratch;
            12'h341: csr_rdata = mepc;
            12'h342: csr_rdata = mcause;
            12'h343: csr_rdata = mtval;
            12'h344: csr_rdata = mip;

            12'hC01: csr_rdata = mtime_i[31:0];
            12'hC81: csr_rdata = mtime_i[63:32];

            default: csr_rdata = 32'h00000000;
        endcase
    end

    // Write CSR
    always_ff @(posedge clk) begin
        if (rst) begin
            PMODE    <= 2'b11;

            stvec    <= '{default: '0};
            sscratch <= '{default: '0};
            sepc     <= '{default: '0};
            scause   <= '{default: '0};
            stval    <= '{default: '0};
            satp     <= '{default: '0};

            mstatus  <= '{default: '0};
            medeleg  <= '{default: '0};
            mideleg  <= '{default: '0};
            mie      <= '{default: '0};
            mtvec    <= '{default: '0};
            mscratch <= '{default: '0};
            mepc     <= '{default: '0};
            mcause   <= '{default: '0};
            mtval    <= '{default: '0};
            mip.STIP <= 1'b0;
        end else begin
            if (csr_we) begin
                unique case (csr_addr)
                    12'h100: begin
                        mstatus.SIE  <= sstatus_i.SIE;
                        mstatus.SPP  <= sstatus_i.SPP;
                        mstatus.SPIE <= sstatus_i.SPIE;
                        mstatus.SUM  <= sstatus_i.SUM;
                    end
                    12'h104: begin
                        mie.STIE <= sie_i.STIE;
                    end
                    12'h105: begin
                        stvec      <= csr_wdata;
                        stvec.MODE <= 2'b00;
                    end
                    12'h140: sscratch <= csr_wdata;
                    12'h141: sepc <= csr_wdata;
                    12'h142: scause <= csr_wdata;
                    12'h143: stval <= csr_wdata;
                    12'h180: begin
                        satp      <= csr_wdata;
                        satp.pad0 <= '0;
                    end

                    12'h300: begin
                        mstatus      <= csr_wdata;
                        mstatus.pad0 <= '0;
                        mstatus.pad1 <= '0;
                        mstatus.pad2 <= '0;
                        mstatus.pad3 <= '0;
                        mstatus.pad4 <= '0;
                    end
                    12'h302: medeleg <= csr_wdata;
                    12'h303: mideleg <= csr_wdata;
                    12'h304: begin
                        mie      <= csr_wdata;
                        mie.pad0 <= '0;
                        mie.pad1 <= '0;
                        mie.pad2 <= '0;
                    end
                    12'h305: begin
                        mtvec      <= csr_wdata;
                        mtvec.MODE <= 2'b00;
                    end
                    12'h340: mscratch <= csr_wdata;
                    12'h341: mepc <= csr_wdata;
                    12'h342: mcause <= csr_wdata;
                    12'h343: mtval <= csr_wdata;
                    12'h344: begin
                        mip.STIP <= mip_i.STIP;
                    end
                    default: ;  // do nothing
                endcase
            end
            if (trap_in) begin
                if (trap_type == 1'b1) begin  // Non-Delegated Exception
                    mepc         <= epc_w;
                    mcause       <= cause_w;
                    mtval        <= tval_w;
                    mstatus.MPIE <= mstatus.MIE;
                    mstatus.MIE  <= 1'b0;
                    mstatus.MPP  <= PMODE;
                    PMODE        <= 2'b11;
                end else begin  // Delegated Exception
                    sepc         <= epc_w;
                    scause       <= cause_w;
                    stval        <= tval_w;
                    mstatus.SPIE <= mstatus.SIE;
                    mstatus.SIE  <= 1'b0;
                    mstatus.SPP  <= PMODE[0];
                    PMODE        <= 2'b01;
                end
            end else if (trap_out) begin
                if (trap_type == 1'b1) begin  // MRET
                    mstatus.MIE <= mstatus.MPIE;
                    PMODE       <= mstatus.MPP;
                end else begin  // SRET
                    mstatus.SIE <= mstatus.SPIE;
                    if (mstatus.SPP) begin
                        PMODE <= 2'b01;
                    end else begin
                        PMODE <= 2'b00;
                    end
                end
            end
        end
    end

endmodule
