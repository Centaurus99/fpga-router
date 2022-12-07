/*
WAY_NUMBER 路组相联，每路有 IDX_BIT 位个表项
取指时，先查LUTRAM，如果命中了，直接组合逻辑拉高ack；如果没命中，设置miss信号
写模块空闲时(cnt=0)，看到miss信号，则从该地址开始，从SRAM读BLOCK_SIZE条指令并存到表里，读完后回到空闲状态
*/

module if_cache #(
    parameter LOG_WAY_NUMBER = 2,
    parameter IDX_BIT        = 5,
    parameter BLOCK_SIZE     = 4'h8
) (
    input wire clk,
    input wire rst,

    input  wire        wbm_cyc_i,
    input  wire        wbm_stb_i,
    output reg         wbm_ack_o,
    output reg         wbm_err_o,
    input  wire [31:0] wbm_adr_i,
    input  wire [31:0] wbm_dat_i,
    output reg  [31:0] wbm_dat_o,
    input  wire [ 3:0] wbm_sel_i,
    input  wire        wbm_we_i,

    output wire        wbs_cyc_o,
    output reg         wbs_stb_o,
    input  wire        wbs_ack_i,
    input  wire        wbs_err_i,
    output reg  [31:0] wbs_adr_o,
    output wire [31:0] wbs_dat_o,
    input  wire [31:0] wbs_dat_i,
    output wire [ 3:0] wbs_sel_o,
    output wire        wbs_we_o,

    input wire fencei
);
    assign wbs_cyc_o = wbs_stb_o;
    assign wbs_sel_o = wbm_sel_i;
    assign wbs_we_o  = wbm_we_i;
    assign wbs_dat_o = wbm_dat_i;
    localparam WAY_NUMBER = 1 << LOG_WAY_NUMBER;
    localparam SET_NUMBER = 1 << IDX_BIT;

    typedef struct packed {
        logic                  valid;
        logic [31-2-IDX_BIT:0] tag;
        logic [31:0]           data;
    } entry;


    wire  [    31-2-IDX_BIT:0] r_tag;
    wire  [       IDX_BIT-1:0] r_idx;

    logic                      miss;
    logic [LOG_WAY_NUMBER-1:0] tail       [SET_NUMBER-1:0];
    logic [LOG_WAY_NUMBER-1:0] new_tail;
    logic [LOG_WAY_NUMBER-1:0] w_way;

    wire  [    31-2-IDX_BIT:0] w_tag;
    wire  [       IDX_BIT-1:0] w_idx;

    logic [    SET_NUMBER-1:0] fenced     [WAY_NUMBER-1:0];
    entry                      r_entry_i  [WAY_NUMBER-1:0];
    entry                      w_entry_i  [WAY_NUMBER-1:0];
    wire  [      62-IDX_BIT:0] w_entry_o;

    reg                        fencei_reg;
    logic [               4:0] cnt;

    genvar i;
    generate
        wire [IDX_BIT-1:0] r_idx_o[WAY_NUMBER-1:0];
        wire [IDX_BIT-1:0] w_idx_o[WAY_NUMBER-1:0];
        wire               we_o   [WAY_NUMBER-1:0];
        for (i = 0; i < WAY_NUMBER; i = i + 1) begin : gen_way
            cache_table if_cache_table_i (
                .a   (w_idx_o[i]),    // input wire [3 : 0] a
                .d   (w_entry_o),     // input wire [59 : 0] d
                .dpra(r_idx_o[i]),    // input wire [3 : 0] dpra
                .clk (clk),           // input wire clk
                .we  (we_o[i]),       // input wire we
                .spo (w_entry_i[i]),  // output wire [59 : 0] spo
                .dpo (r_entry_i[i])   // output wire [59 : 0] dpo
            );
            assign r_idx_o[i] = r_idx;
            assign w_idx_o[i] = w_idx;
            assign we_o[i]    = wbs_ack_i & (w_way == i);
        end
    endgenerate

    /* =========== 读模块 =========== */
    assign r_tag = wbm_adr_i[31:2+IDX_BIT];
    assign r_idx = wbm_adr_i[IDX_BIT+1:2];
    always_comb begin
        wbm_dat_o = 0;
        wbm_err_o = wbm_cyc_i && wbm_stb_i && wbs_err_i && (wbm_adr_i == wbs_adr_o);
        wbm_ack_o = 0;
        miss      = 0;
        if (wbm_cyc_i && wbm_stb_i) begin
            for (int i = 0; i < WAY_NUMBER; ++i) begin
                if (!fenced[i][r_idx] && r_entry_i[i].valid && (r_entry_i[i].tag == r_tag)) begin
                    wbm_dat_o = r_entry_i[i].data;
                    wbm_ack_o = 1;
                end
            end
            if (!wbm_ack_o) begin
                miss = 1;
            end
        end
    end

    /* =========== 写模块 =========== */
    assign w_tag     = wbs_adr_o[31:2+IDX_BIT];
    assign w_idx     = wbs_adr_o[IDX_BIT+1:2];
    assign w_entry_o = {1'b1, w_tag, wbs_dat_i};

    always_comb begin
        w_way = tail[w_idx];  // 如果都满了则覆盖到tail的位置
        if (tail[w_idx] == WAY_NUMBER - 1) new_tail = 0;
        else new_tail = tail[w_idx] + 1;
        for (int i = WAY_NUMBER - 1; i >= 0; --i) begin
            if (fenced[i][w_idx] || !w_entry_i[i].valid) begin  // 如果有不valid的则写到那个位置
                w_way    = i;
                new_tail = tail[w_idx];
            end
        end
        for (int i = 0; i < WAY_NUMBER; ++i) begin
            if (!fenced[i][w_idx] && w_entry_i[i].valid && (w_entry_i[i].tag == w_tag)) begin  // 如果匹配上了则覆写
                w_way    = i;
                new_tail = tail[w_idx];
            end
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            cnt        <= 0;
            wbs_adr_o  <= 0;
            wbs_stb_o  <= 0;
            tail       <= '{default: '0};
            fenced     <= '{default: '0};
            fencei_reg <= 1'b0;
        end else begin
            if (fencei) begin
                fenced     <= '{default: '1};
                fencei_reg <= wbs_stb_o;
            end
            if (wbs_err_i | wbs_ack_i) begin
                if (wbs_err_i) begin
                    wbs_stb_o <= 0;
                    cnt       <= 0;
                end else if (wbs_ack_i) begin
                    tail[w_idx]          <= new_tail;
                    fenced[w_way][w_idx] <= 0;
                    if (miss && (wbm_adr_i != wbs_adr_o || fencei || fencei_reg)) begin
                        wbs_adr_o <= wbm_adr_i;
                        cnt       <= BLOCK_SIZE;
                    end else if (cnt) begin
                        cnt       <= cnt - 1;
                        wbs_adr_o <= wbs_adr_o + 4;
                    end else begin
                        wbs_stb_o <= 0;
                    end
                end
                if (fencei || fencei_reg) begin
                    fenced     <= '{default: '1};
                    fencei_reg <= 1'b0;
                end
            end
            if (!wbs_stb_o && miss) begin
                wbs_stb_o <= 1;
                wbs_adr_o <= wbm_adr_i;
                cnt       <= BLOCK_SIZE;
            end
        end
    end

endmodule

