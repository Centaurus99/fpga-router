`include "cpu_pipeline.vh"
`include "exception/csr_file.vh"

module cpu_pipeline (
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
    input wire mtime_int_i,  // M 时钟中断

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
    logic if_ready, id_ready, exe_ready, mem_ready;

    logic [31:0] next_pc, pc, new_pc;
    logic branch;
    logic wait_wb;

    logic [31:0] btb_pc_w, btb_next_pc_w;
    logic btb_jump, btb_we;
    branch_target_buffer #(
        .LOG_WAY_NUMBER(2),
        .IDX_BIT       (4)
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

    // 异常 & 中断
    wire     [ 1:0] PMODE;

    reg      [11:0] csr_addr;
    reg      [31:0] csr_wdata;
    reg             csr_we;
    wire     [31:0] csr_rdata;

    wire            trap_in;
    wire            trap_out;

    mepc_t          mepc_w;
    mcause_t        mcause_w;
    mtval_t         mtval_w;
    mie_t           mie_r;
    mtvec_t         mtvec_r;
    mepc_t          mepc_r;
    mip_t           mip_r;

    csr_file u_csr_file (
        .clk(clk),
        .rst(rst),

        .PMODE(PMODE),

        .csr_addr (csr_addr),
        .csr_wdata(csr_wdata),
        .csr_we   (csr_we),
        .csr_rdata(csr_rdata),

        .trap_in (trap_in),
        .trap_out(trap_out),

        .mepc_w  (mepc_w),
        .mcause_w(mcause_w),
        .mtval_w (mtval_w),
        .mie_r   (mie_r),
        .mtvec_r (mtvec_r),
        .mepc_r  (mepc_r),
        .mip_r   (mip_r),

        .mtime_int_i(mtime_int_i)
    );

    /* =========== IF start =========== */
    cpu_pipeline_if u_cpu_pipeline_if (
        .clk(clk),
        .rst(rst),

        .in_ready (if_ready),
        .out      (if_id),
        .out_ready(id_ready),

        .wb_cyc_o(wbm0_cyc_o),
        .wb_stb_o(wbm0_stb_o),
        .wb_ack_i(wbm0_ack_i),
        .wb_adr_o(wbm0_adr_o),
        .wb_dat_o(wbm0_dat_o),
        .wb_dat_i(wbm0_dat_i),
        .wb_sel_o(wbm0_sel_o),
        .wb_we_o (wbm0_we_o),

        .pc     (pc),
        .next_pc(next_pc),
        .new_pc (new_pc),
        .branch (branch),
        .wait_wb(wait_wb),
        .PMODE  (PMODE)
    );
    /* =========== IF end =========== */

    /* =========== ID start =========== */
    logic [ 4:0] exe_rd;
    logic [31:0] exe_alu_y;

    cpu_pipeline_id cpu_pipeline_id_i (
        .clk(clk),
        .rst(rst),

        .in       (if_id),
        .in_ready (id_ready),
        .out      (id_exe),
        .out_ready(exe_ready),

        .rf_raddr_a_o(rf_raddr_a_o),
        .rf_raddr_b_o(rf_raddr_b_o),
        .rf_rdata_a_i(rf_rdata_a_i),
        .rf_rdata_b_i(rf_rdata_b_i),

        .M_Interrupt(mie_r & mip_r),

        .csr_addr (csr_addr),
        .csr_wdata(csr_wdata),
        .csr_we   (csr_we),
        .csr_rdata(csr_rdata),

        .trap_in (trap_in),
        .trap_out(trap_out),

        .mepc_w  (mepc_w),
        .mcause_w(mcause_w),
        .mtval_w (mtval_w),
        .mtvec_r (mtvec_r),
        .mepc_r  (mepc_r),

        .exe_mem(exe_mem),
        .mem_wb (mem_wb),
        .wait_wb(wait_wb),

        .exe_rd   (exe_rd),
        .exe_alu_y(exe_alu_y),

        .branch       (branch),
        .new_pc       (new_pc),
        .btb_pc_w     (btb_pc_w),
        .btb_next_pc_w(btb_next_pc_w),
        .btb_jump     (btb_jump),
        .btb_we       (btb_we)
    );
    /* =========== ID end =========== */

    /* =========== EXE start =========== */
    cpu_pipeline_exe cpu_pipeline_exe_i (
        .clk(clk),
        .rst(rst),

        .in       (id_exe),
        .in_ready (exe_ready),
        .out      (exe_mem),
        .out_ready(mem_ready),

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

        .in      (exe_mem),
        .in_ready(mem_ready),
        .out     (mem_wb),

        .wb_cyc_o(wbm1_cyc_o),
        .wb_stb_o(wbm1_stb_o),
        .wb_ack_i(wbm1_ack_i),
        .wb_adr_o(wbm1_adr_o),
        .wb_dat_o(wbm1_dat_o),
        .wb_dat_i(wbm1_dat_i),
        .wb_sel_o(wbm1_sel_o),
        .wb_we_o (wbm1_we_o)
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
