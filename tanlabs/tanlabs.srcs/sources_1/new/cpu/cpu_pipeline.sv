`include "cpu_pipeline.vh"
`include "exception/csr_file.vh"

module cpu_pipeline #(
    parameter ENABLE_BRANCH_PREDICT = 1,
    parameter ENABLE_IF_CACHE       = 1,
    parameter ENABLE_PAGING         = 0
) (
    input wire clk,
    input wire rst,

    // Signal for TB
    // synthesis translate_off
    output wire        tb_valid,
    output wire [31:0] tb_pc,
    output wire [31:0] tb_inst,
    output wire        tb_we,
    output wire [ 4:0] tb_waddr,
    output wire [31:0] tb_wdata,
    // synthesis translate_on

    // 中断
    input wire [63:0] mtime_i,
    input wire        mtime_int_i, // M 时钟中断

    // wishbone master
    output wire        wbm0_cyc_o,
    output wire        wbm0_stb_o,
    input  wire        wbm0_ack_i,
    output wire [31:0] wbm0_adr_o,
    output wire [31:0] wbm0_dat_o,
    input  wire [31:0] wbm0_dat_i,
    output wire [ 3:0] wbm0_sel_o,
    output wire        wbm0_we_o,

    output wire        wbm1_cyc_o,
    output wire        wbm1_stb_o,
    input  wire        wbm1_ack_i,
    output wire [31:0] wbm1_adr_o,
    output wire [31:0] wbm1_dat_o,
    input  wire [31:0] wbm1_dat_i,
    output wire [ 3:0] wbm1_sel_o,
    output wire        wbm1_we_o,

    output wire [31:0] alu_a_o,
    output wire [31:0] alu_b_o,
    output wire [ 3:0] alu_op_o,
    input  wire [31:0] alu_y_i,

    output wire [ 4:0] rf_raddr_a_o,
    output wire [ 4:0] rf_raddr_b_o,
    input  wire [31:0] rf_rdata_a_i,
    input  wire [31:0] rf_rdata_b_i,

    output reg        rf_we_o,
    output reg [31:0] rf_wdata_o,
    output reg [ 4:0] rf_waddr_o
);
    stage_t if_id, id_exe, exe_mem, mem_wb;
    logic if_id_ready, id_exe_ready, exe_mem_ready;

    logic [31:0] next_pc, pc;
    wire id_flush_o, flush_branch_o, mem_flush_o;
    wire [31:0] id_flush_pc_o, flush_branch_pc_o, mem_flush_pc_o;

    /* =========== 页表总线信号 start =========== */
    wire        if_wb_cyc_o;
    wire        if_wb_stb_o;
    wire        if_wb_ack_i;
    wire        if_wb_err_i;
    wire [31:0] if_wb_adr_o;
    wire [31:0] if_wb_dat_o;
    wire [31:0] if_wb_dat_i;
    wire [ 3:0] if_wb_sel_o;
    wire        if_wb_we_o;

    wire        mem_wb_cyc_o;
    wire        mem_wb_stb_o;
    wire        mem_wb_ack_i;
    wire        mem_wb_err_i;
    wire [31:0] mem_wb_adr_o;
    wire [31:0] mem_wb_dat_o;
    wire [31:0] mem_wb_dat_i;
    wire [ 3:0] mem_wb_sel_o;
    wire        mem_wb_we_o;
    /* =========== 页表总线信号 end =========== */

    /* =========== 分支预测 start =========== */
    logic [31:0] btb_pc_w, btb_next_pc_w;
    logic btb_jump, btb_we;
    generate
        if (ENABLE_BRANCH_PREDICT) begin
            branch_target_buffer #(
                .LOG_WAY_NUMBER(2),
                .IDX_BIT       (7)
            ) u_branch_target_buffer (
                .clk      (clk),
                .rst      (rst),
                .pc_r     (pc),
                .pc_w     (btb_pc_w),
                .next_pc_w(btb_next_pc_w),
                .jump     (btb_jump),
                .we       (btb_we),

                .next_pc_r(next_pc)
            );
        end else begin
            assign next_pc = pc + 4;
        end
    endgenerate
    /* =========== 分支预测 end =========== */

    /* =========== 指令缓存 start =========== */
    wire        if_cache_cyc_o;
    wire        if_cache_stb_o;
    wire        if_cache_ack_i;
    wire        if_cache_err_i;
    wire [31:0] if_cache_adr_o;
    wire [31:0] if_cache_dat_o;
    wire [31:0] if_cache_dat_i;
    wire [ 3:0] if_cache_sel_o;
    wire        if_cache_we_o;
    reg         fencei;
    generate
        if (ENABLE_IF_CACHE) begin
            if_cache #(
                .LOG_WAY_NUMBER(2),
                .IDX_BIT       (8)
            ) u_if_cache (
                .clk      (clk),
                .rst      (rst),
                .wbm_cyc_i(if_cache_cyc_o),
                .wbm_stb_i(if_cache_stb_o),
                .wbm_ack_o(if_cache_ack_i),
                .wbm_err_o(if_cache_err_i),
                .wbm_adr_i(if_cache_adr_o),
                .wbm_dat_i(if_cache_dat_o),
                .wbm_dat_o(if_cache_dat_i),
                .wbm_sel_i(if_cache_sel_o),
                .wbm_we_i (if_cache_we_o),

                .wbs_cyc_o(if_wb_cyc_o),
                .wbs_stb_o(if_wb_stb_o),
                .wbs_ack_i(if_wb_ack_i),
                .wbs_err_i(if_wb_err_i),
                .wbs_adr_o(if_wb_adr_o),
                .wbs_dat_i(if_wb_dat_i),
                .wbs_dat_o(if_wb_dat_o),
                .wbs_sel_o(if_wb_sel_o),
                .wbs_we_o (if_wb_we_o),

                .fencei(fencei)
            );
        end else begin
            assign if_wb_cyc_o    = if_cache_cyc_o;
            assign if_wb_stb_o    = if_cache_stb_o;
            assign if_cache_ack_i = if_wb_ack_i;
            assign if_cache_err_i = if_wb_err_i;
            assign if_wb_adr_o    = if_cache_adr_o;
            assign if_wb_dat_o    = if_cache_dat_o;
            assign if_cache_dat_i = if_wb_dat_i;
            assign if_wb_sel_o    = if_cache_sel_o;
            assign if_wb_we_o     = if_cache_we_o;
        end
    endgenerate
    /* =========== 指令缓存 end =========== */

    /* =========== 异常 & 中断 start =========== */
    wire      [ 1:0] PMODE;

    reg       [11:0] csr_addr;
    reg       [31:0] csr_wdata;
    reg              csr_we;
    wire      [31:0] csr_rdata;

    satp_t           satp_r;
    wire             SUM_r;
    stvec_t          stvec_r;
    sepc_t           sepc_r;
    medeleg_t        medeleg_r;
    mtvec_t          mtvec_r;
    mepc_t           mepc_r;

    wire id_trap_in, mem_trap_in;
    wire id_trap_out;
    wire id_trap_type, mem_trap_type;

    mepc_t id_epc_w, mem_epc_w;
    mcause_t id_cause_w, mem_cause_w;
    mtval_t id_tval_w, mem_tval_w;

    wire [31:0] M_Interrupt;
    wire [31:0] S_Interrupt;

    csr_file u_csr_file (
        .clk(clk),
        .rst(rst),

        .PMODE(PMODE),

        .csr_addr (csr_addr),
        .csr_wdata(csr_wdata),
        .csr_we   (csr_we),
        .csr_rdata(csr_rdata),

        .satp_r   (satp_r),
        .SUM_r    (SUM_r),
        .stvec_r  (stvec_r),
        .sepc_r   (sepc_r),
        .medeleg_r(medeleg_r),
        .mtvec_r  (mtvec_r),
        .mepc_r   (mepc_r),

        .trap_in  (id_trap_in | mem_trap_in),
        .trap_out (id_trap_out),
        .trap_type(mem_trap_in ? mem_trap_type : id_trap_type),

        .epc_w  (mem_trap_in ? mem_epc_w : id_epc_w),
        .cause_w(mem_trap_in ? mem_cause_w : id_cause_w),
        .tval_w (mem_trap_in ? mem_tval_w : id_tval_w),

        .mtime_i    (mtime_i),
        .mtime_int_i(mtime_int_i),
        .M_Interrupt(M_Interrupt),
        .S_Interrupt(S_Interrupt)
    );
    /* =========== 异常 & 中断 end =========== */

    /* =========== 页表 start =========== */
    generate
        if (ENABLE_PAGING) begin
            paging_controller IF_paging_controller (
                .clk(clk),
                .rst(rst),

                .satp_r(satp_r),
                .SUM_r (SUM_r),

                .wbs_cyc_i(if_wb_cyc_o),
                .wbs_stb_i(if_wb_stb_o),
                .wbs_ack_o(if_wb_ack_i),
                .wbs_err_o(if_wb_err_i),
                .wbs_adr_i(if_wb_adr_o),
                .wbs_dat_i(if_wb_dat_o),
                .wbs_dat_o(if_wb_dat_i),
                .wbs_sel_i(if_wb_sel_o),
                .wbs_we_i (if_wb_we_o),
                .wbs_IF   (1'b1),
                .wbs_PMODE(PMODE),

                .wbm_cyc_o(wbm0_cyc_o),
                .wbm_stb_o(wbm0_stb_o),
                .wbm_ack_i(wbm0_ack_i),
                .wbm_adr_o(wbm0_adr_o),
                .wbm_dat_o(wbm0_dat_o),
                .wbm_dat_i(wbm0_dat_i),
                .wbm_sel_o(wbm0_sel_o),
                .wbm_we_o (wbm0_we_o)
            );
            paging_controller MEM_paging_controller (
                .clk(clk),
                .rst(rst),

                .satp_r(satp_r),
                .SUM_r (SUM_r),

                .wbs_cyc_i(mem_wb_cyc_o),
                .wbs_stb_i(mem_wb_stb_o),
                .wbs_ack_o(mem_wb_ack_i),
                .wbs_err_o(mem_wb_err_i),
                .wbs_adr_i(mem_wb_adr_o),
                .wbs_dat_i(mem_wb_dat_o),
                .wbs_dat_o(mem_wb_dat_i),
                .wbs_sel_i(mem_wb_sel_o),
                .wbs_we_i (mem_wb_we_o),
                .wbs_IF   (1'b0),
                .wbs_PMODE(exe_mem.PMODE),

                .wbm_cyc_o(wbm1_cyc_o),
                .wbm_stb_o(wbm1_stb_o),
                .wbm_ack_i(wbm1_ack_i),
                .wbm_adr_o(wbm1_adr_o),
                .wbm_dat_o(wbm1_dat_o),
                .wbm_dat_i(wbm1_dat_i),
                .wbm_sel_o(wbm1_sel_o),
                .wbm_we_o (wbm1_we_o)
            );
        end else begin
            assign wbm0_cyc_o   = if_wb_cyc_o;
            assign wbm0_stb_o   = if_wb_stb_o;
            assign if_wb_ack_i  = wbm0_ack_i;
            assign if_wb_err_i  = 1'b0;
            assign wbm0_adr_o   = if_wb_adr_o;
            assign wbm0_dat_o   = if_wb_dat_o;
            assign if_wb_dat_i  = wbm0_dat_i;
            assign wbm0_sel_o   = if_wb_sel_o;
            assign wbm0_we_o    = if_wb_we_o;

            assign wbm1_cyc_o   = mem_wb_cyc_o;
            assign wbm1_stb_o   = mem_wb_stb_o;
            assign mem_wb_ack_i = wbm1_ack_i;
            assign mem_wb_err_i = 1'b0;
            assign wbm1_adr_o   = mem_wb_adr_o;
            assign wbm1_dat_o   = mem_wb_dat_o;
            assign mem_wb_dat_i = wbm1_dat_i;
            assign wbm1_sel_o   = mem_wb_sel_o;
            assign wbm1_we_o    = mem_wb_we_o;
        end
    endgenerate
    /* =========== 页表 end =========== */

    /* =========== IF start =========== */
    cpu_pipeline_if u_cpu_pipeline_if (
        .clk(clk),
        .rst(rst),

        .out      (if_id),
        .out_ready(if_id_ready),
        .flush_i  (id_flush_o || mem_flush_o),

        .flush_pc_i(mem_flush_o ? mem_flush_pc_o : (id_flush_o ? (flush_branch_o ? flush_branch_pc_o :id_flush_pc_o) : 32'h0)),

        .wb_cyc_o(if_cache_cyc_o),
        .wb_stb_o(if_cache_stb_o),
        .wb_ack_i(if_cache_ack_i),
        .wb_err_i(if_cache_err_i),
        .wb_adr_o(if_cache_adr_o),
        .wb_dat_o(if_cache_dat_o),
        .wb_dat_i(if_cache_dat_i),
        .wb_sel_o(if_cache_sel_o),
        .wb_we_o (if_cache_we_o),

        .pc         (pc),
        .next_pc    (next_pc),
        .PMODE      (PMODE),
        .M_Interrupt(M_Interrupt),
        .S_Interrupt(S_Interrupt)
    );
    /* =========== IF end =========== */

    /* =========== ID start =========== */
    logic [ 4:0] exe_rd;
    logic [31:0] exe_alu_y;

    cpu_pipeline_id cpu_pipeline_id_i (
        .clk(clk),
        .rst(rst),

        .in               (if_id),
        .in_ready         (if_id_ready),
        .out              (id_exe),
        .out_ready        (id_exe_ready),
        .flush_i          (mem_flush_o),
        .flush_o          (id_flush_o),
        .flush_pc_o       (id_flush_pc_o),
        .flush_branch_o   (flush_branch_o),
        .flush_branch_pc_o(flush_branch_pc_o),

        .rf_raddr_a_o(rf_raddr_a_o),
        .rf_raddr_b_o(rf_raddr_b_o),
        .rf_rdata_a_i(rf_rdata_a_i),
        .rf_rdata_b_i(rf_rdata_b_i),

        .csr_addr (csr_addr),
        .csr_wdata(csr_wdata),
        .csr_we   (csr_we),
        .csr_rdata(csr_rdata),

        .trap_in  (id_trap_in),
        .trap_out (id_trap_out),
        .trap_type(id_trap_type),

        .epc_w  (id_epc_w),
        .cause_w(id_cause_w),
        .tval_w (id_tval_w),

        .stvec_r  (stvec_r),
        .sepc_r   (sepc_r),
        .medeleg_r(medeleg_r),
        .mtvec_r  (mtvec_r),
        .mepc_r   (mepc_r),

        .M_Interrupt(M_Interrupt),
        .S_Interrupt(S_Interrupt),

        .exe_mem(exe_mem),
        .mem_wb (mem_wb),

        .exe_rd   (exe_rd),
        .exe_alu_y(exe_alu_y),

        .btb_pc_w     (btb_pc_w),
        .btb_next_pc_w(btb_next_pc_w),
        .btb_jump     (btb_jump),
        .btb_we       (btb_we),

        .fencei(fencei)
    );
    /* =========== ID end =========== */

    /* =========== EXE start =========== */
    cpu_pipeline_exe cpu_pipeline_exe_i (
        .clk(clk),
        .rst(rst),

        .in       (id_exe),
        .in_ready (id_exe_ready),
        .out      (exe_mem),
        .out_ready(exe_mem_ready),
        .flush_i  (mem_flush_o),

        .alu_a_o (alu_a_o),
        .alu_b_o (alu_b_o),
        .alu_op_o(alu_op_o),
        .alu_y_i (alu_y_i),

        .exe_rd   (exe_rd),
        .exe_alu_y(exe_alu_y)
    );
    /* =========== EXE end =========== */

    /* =========== MEM start =========== */
    cpu_pipeline_mem cpu_pipeline_mem_i (
        .clk(clk),
        .rst(rst),

        .in        (exe_mem),
        .in_ready  (exe_mem_ready),
        .out       (mem_wb),
        .out_ready (1'b1),
        .flush_o   (mem_flush_o),
        .flush_pc_o(mem_flush_pc_o),

        .trap_in  (mem_trap_in),
        .trap_type(mem_trap_type),
        .epc_w    (mem_epc_w),
        .cause_w  (mem_cause_w),
        .tval_w   (mem_tval_w),

        .stvec_r  (stvec_r),
        .medeleg_r(medeleg_r),
        .mtvec_r  (mtvec_r),

        .wb_cyc_o(mem_wb_cyc_o),
        .wb_stb_o(mem_wb_stb_o),
        .wb_ack_i(mem_wb_ack_i),
        .wb_err_i(mem_wb_err_i),
        .wb_adr_o(mem_wb_adr_o),
        .wb_dat_o(mem_wb_dat_o),
        .wb_dat_i(mem_wb_dat_i),
        .wb_sel_o(mem_wb_sel_o),
        .wb_we_o (mem_wb_we_o)
    );
    /* =========== MEM end =========== */

    /* =========== WB start =========== */
    assign rf_we_o = mem_wb.rf_we && mem_wb.valid;
    assign rf_wdata_o = mem_wb.alu_y; // TODO: 为了避免混乱 exe和mem的输出不应该都用alu_y
    assign rf_waddr_o = `rd(mem_wb);
    /* =========== WB end =========== */

    /* =========== Testbench signal start=========== */
    // synthesis translate_off
    assign tb_valid = mem_wb.valid;
    assign tb_pc = mem_wb.pc;
    assign tb_inst = mem_wb.inst;
    assign tb_we = mem_wb.rf_we;
    assign tb_waddr = `rd(mem_wb);
    assign tb_wdata = mem_wb.alu_y;
    // synthesis translate_on
    /* =========== Testbench signal end =========== */

endmodule
