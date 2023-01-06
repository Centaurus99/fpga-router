module branch_target_buffer #(
    parameter LOG_WAY_NUMBER = 2,
    parameter IDX_BIT = 4
) (
    input wire clk,
    input wire rst,

    input  wire [31:0] pc_r,
    output wire  [31:0] next_pc_r,

    input wire [31:0] pc_w,
    input wire [31:0] next_pc_w,
    input wire        jump,
    input wire        we
);
    localparam WAY_NUMBER = 1 << LOG_WAY_NUMBER;
    localparam SET_NUMBER = 1 << IDX_BIT;

    typedef struct packed {
        logic                  valid;
        logic [31-2-IDX_BIT:0] tag;
        logic [31-2:0]         data;
        logic [1:0]            history;
    } btb_entry;

    logic [31:0] pc_w_reg, next_pc_w_reg;
    logic we_reg, jump_reg;

    wire      [IDX_BIT-1:0] r_idx_o  [WAY_NUMBER-1:0];
    wire      [IDX_BIT-1:0] w_idx_o  [WAY_NUMBER-1:0];
    btb_entry               r_entry_i[WAY_NUMBER-1:0];
    btb_entry               w_entry_i[WAY_NUMBER-1:0];
    btb_entry               w_entry_o;
    logic                   we_o     [WAY_NUMBER-1:0];

    logic [LOG_WAY_NUMBER-1:0] tail  [SET_NUMBER-1:0];
    logic [LOG_WAY_NUMBER-1:0] new_tail;
    logic [LOG_WAY_NUMBER-1:0] w_way;
    wire [31-2-IDX_BIT:0] r_tag = pc_r[31:2+IDX_BIT];
    wire [31-2-IDX_BIT:0] w_tag = pc_w_reg[31:2+IDX_BIT];
    wire [IDX_BIT-1:0] w_idx = pc_w_reg[IDX_BIT+1:2];

    logic [31:0] next_pc_r_comb;

    genvar i;
    generate
        for (i = 0; i < WAY_NUMBER; i = i + 1) begin : gen_way
            branch_target_buffer_data branch_target_buffer_data_i (
                .a   (w_idx_o[i]),    // input wire [3 : 0] a
                .d   (w_entry_o),  // input wire [59 : 0] d
                .dpra(r_idx_o[i]),    // input wire [3 : 0] dpra
                .clk (clk),           // input wire clk
                .we  (we_o[i]),       // input wire we
                .spo (w_entry_i[i]),  // output wire [59 : 0] spo
                .dpo (r_entry_i[i])   // output wire [59 : 0] dpo
            );
            assign r_idx_o[i] = pc_r[IDX_BIT+1:2];
            assign w_idx_o[i] = w_idx;
            assign we_o[i] = we_reg & (w_way == i);
        end
    endgenerate

    always_comb begin
        next_pc_r_comb = pc_r + 4;
        for (int i = 0; i < WAY_NUMBER; ++i) begin
            if (r_entry_i[i].valid & (r_entry_i[i].tag == r_tag)) begin
                if (r_entry_i[i].history[1] == 1) begin  // 如果要跳
                    next_pc_r_comb = {r_entry_i[i].data, 2'b0};
                end
            end
        end
    end

    always_comb begin
        w_entry_o.valid = 1;
        w_entry_o.tag = w_tag;
        w_entry_o.data = next_pc_w_reg[31:2];
        w_entry_o.history = jump_reg ? 2'b10 : 2'b01;

        w_way = tail[w_idx];  // 如果都满了则覆盖到tail的位置
        if (tail[w_idx] == WAY_NUMBER - 1) new_tail = 0;
        else new_tail = tail[w_idx] + 1;
        
        for (int i = 0; i < WAY_NUMBER; ++i) begin
            if (!w_entry_i[i].valid) begin  // 如果有不valid的则写到那个位置
                w_way = i;
                break;
            end
        end

        for (int i = 0; i < WAY_NUMBER; ++i) begin
            if (w_entry_i[i].valid & (w_entry_i[i].tag == w_tag)) begin  // 如果匹配上了则覆写
                w_way = i;
                if (w_entry_i[i].data == next_pc_w_reg[31:2]) begin
                    if (jump_reg) begin
                        if (w_entry_i[i].history != 2'b11)
                            w_entry_o.history = w_entry_i[i].history + 1;
                    end else begin
                        if (w_entry_i[i].history != 2'b00)
                            w_entry_o.history = w_entry_i[i].history - 1;
                    end
                end
            end
        end
    end

    assign next_pc_r = next_pc_r_comb;
    always_ff @(posedge clk) begin
        if (rst) begin
            tail <= '{default: '0};
            // next_pc_r <= 0;
            pc_w_reg <= 0;
            next_pc_w_reg <= 0;
            we_reg <= 0;
            jump_reg <= 0;
        end else begin
            // next_pc_r <= next_pc_r_comb;
            if (we_reg) begin
                we_reg <= 0;
                tail[w_idx] <= new_tail;
            end
            if (we) begin // 打一拍 避免时序问题
                pc_w_reg <= pc_w;
                next_pc_w_reg <= next_pc_w;
                jump_reg <= jump;
                we_reg <= 1;
            end
        end
    end

endmodule

