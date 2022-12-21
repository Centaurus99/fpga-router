module flash #(
    parameter DATA_WIDTH = 32,  // DATA_WIDTH: wishbone data width
    parameter ADDR_WIDTH = 32,  // DATA_WIDTH: wishbone data width

    parameter RESET_UP_WAITING = 20,  // RESET_UP_WATING: reset升起后需要等待的周期数
    parameter RESET_DOWN_WAITING = 5,  // RESET_DOWN_WAITING:
    parameter READ_WAITING = 3,  // READ_WAITING: 读取的延时
    parameter WRITE_WAITING = 6,  // WRITE_WAITING: 写入的延时
    parameter CROSS_PAGE_READ_WAITING = 8,  // CROSS_PAGE_READ_WAITING: 跨页读取的延时
    parameter WRITE_TO_READ_WAITING = 4  // WRITE_TO_READ_WAITING: 写入之后读取的延时
) (
    input wire clk,
    input wire rst,
    input wire full_reset, // 预留，没有用

    // wishbone slave interface
    input  wire                    wb_cyc_i,
    input  wire                    wb_stb_i,
    output reg                     wb_ack_o,
    input  wire [  ADDR_WIDTH-1:0] wb_adr_i,
    input  wire [  DATA_WIDTH-1:0] wb_dat_i,
    output reg  [  DATA_WIDTH-1:0] wb_dat_o,
    input  wire [DATA_WIDTH/8-1:0] wb_sel_i,
    input  wire                    wb_we_i,

    // Flash 存储器信号，参考 JS28F640 芯片手册
    output reg [22:0] flash_a,  // Flash 地址，a0 仅在 8bit 模式有效，16bit 模式无意义
    inout wire [15:0] flash_d,  // Flash 数据
    output reg flash_rp_n,  // Flash 复位信号，低有效
    output reg flash_vpen,  // Flash 写保护信号，低电平时不能擦除、烧写
    output reg flash_ce_n,  // Flash 片选信号，低有效
    output reg flash_oe_n,  // Flash 读使能信号，低有效
    output reg flash_we_n,  // Flash 写使能信号，低有效
    output reg flash_byte_n // Flash 8bit 模式选择，低有效。在使用 flash 的 16 位模式时请设为 1
);
    // flash 三态门
    wire [31:0] flash_data_i_comb;
    reg  [31:0] flash_data_o_comb;
    reg         flash_data_t_comb;

    assign flash_d           = flash_data_t_comb ? 32'bz : flash_data_o_comb;
    assign flash_data_i_comb = flash_d;

    logic [7:0] waiting_reg;

    logic [20:0] past_operating_page; // 如果第一位为一，说明所有形况都需要 WAITING

    assign flash_byte_n = 1'b1;  // 长期开16bit模式
    assign flash_vpen   = 1'b1;  // 长期不写保护

    typedef enum {
        READ,
        WRITE,
        RESET
    } flash_mode;

    typedef enum {
        ST_IDLE,
        ST_WAITING,
        ST_READ,
        ST_WRITE
    } flash_state_t;

    flash_mode    mode;
    flash_state_t state;

    logic         operating_word;

    always_ff @(posedge clk) begin
        if (full_reset) begin
            operating_word <= 1'b0;
            flash_we_n     <= 1'b1;
            flash_ce_n     <= 1'b1;
            flash_oe_n     <= 1'b1;
            mode           <= READ;

            //  开始复位
            flash_rp_n     <= 1'b0;
            waiting_reg    <= RESET_UP_WAITING + RESET_DOWN_WAITING;
            state          <= ST_WAITING;
        end else if (rst) begin
            operating_word <= 1'b0;
            flash_rp_n     <= 1'b1;
            flash_we_n     <= 1'b1;
            flash_ce_n     <= 1'b0;
            flash_oe_n     <= 1'b0;
            flash_a        <= 23'b0;
            waiting_reg    <= RESET_UP_WAITING;
            mode           <= RESET;
            state          <= ST_WAITING;
        end else begin
            case (state)
                ST_WAITING: begin
                    case (mode)
                        RESET: begin
                            // reset 的等待时间，有完全 reset 和初始时的 reset 两种
                            waiting_reg <= waiting_reg - 1;
                            if (waiting_reg == RESET_UP_WAITING) begin
                                flash_rp_n <= 1'b1;
                            end else if (waiting_reg == 1) begin
                                past_operating_page[20] <= 1'b1; // 头位置一，导致所有 page 失配
                                state <= ST_IDLE;
                            end
                        end
                        READ: begin
                            // 在读的过程中，发生跨 page 读取
                            // 也可能时先写后读
                            waiting_reg <= waiting_reg - 1;
                            if (waiting_reg == 1) begin
                                flash_data_t_comb <= 1'b1;
                                flash_a           <= wb_adr_i[22:0];
                                waiting_reg       <= READ_WAITING;
                                state             <= ST_READ;
                            end
                        end
                        WRITE: begin
                            // 一般用不到，等待新情况出现
                            waiting_reg <= waiting_reg - 1;
                            if (waiting_reg == 1) begin
                                flash_data_t_comb <= 1'b0;
                                flash_a           <= wb_adr_i[22:0];
                                waiting_reg       <= WRITE_WAITING;
                                state             <= ST_WRITE;
                            end
                        end
                        default: ;
                    endcase
                end
                ST_IDLE: begin
                    // IDLE阶段：在第一次 IDLE 时 ack_o == 1
                    wb_ack_o <= 1'b0;
                    if (wb_cyc_i & wb_stb_i & !wb_ack_o) begin
                        if (mode == WRITE) begin
                            mode        <= READ;
                            waiting_reg <= WRITE_TO_READ_WAITING;
                            state       <= ST_WAITING;
                        end else begin
                            past_operating_page <= {
                                1'b0, wb_adr_i[22:3]
                            };  // 更新上次操作的 page
                            flash_data_t_comb <= 1'b1;
                            mode <= READ;
                            waiting_reg <= (past_operating_page == {1'b0, wb_adr_i[22:3]}) ? READ_WAITING : CROSS_PAGE_READ_WAITING;
                            flash_a <= wb_sel_i[1:0] == 2'b00 ? wb_adr_i[22:0] + 2 : wb_adr_i[22:0];
                            operating_word <= wb_sel_i[1:0] == 2'b00 ? 1'b1 : 1'b0;
                            state <= ST_READ;
                        end
                    end
                end
                ST_READ: begin
                    // 两个 operating_word 一定在同一个page
                    waiting_reg <= waiting_reg - 1;
                    case (operating_word)
                        1'b0: begin
                            if (waiting_reg == 1) begin
                                wb_dat_o[15:0] <= flash_data_i_comb;
                                operating_word <= 1'b1;
                                flash_a        <= flash_a + 2;
                                waiting_reg    <= READ_WAITING;
                            end
                        end
                        1'b1: begin
                            if (waiting_reg == 1 && !wb_we_i) begin
                                wb_dat_o[31:16] <= flash_data_i_comb;
                                operating_word  <= 1'b0;
                                wb_ack_o        <= 1'b1;
                                state           <= ST_IDLE;
                            end else if (waiting_reg == 1 && wb_we_i) begin
                                flash_data_t_comb <= 1'b0;
                                mode              <= WRITE;
                                waiting_reg       <= WRITE_WAITING;
                                state             <= ST_WRITE;
                                if (wb_sel_i[1:0] == 2'b00) begin
                                    operating_word <= 1'b1;
                                    flash_a <= wb_adr_i[22:0] + 2;
                                    flash_data_o_comb[15:8] <= wb_sel_i[3] == 1'b1 ? wb_dat_i[31:24] : wb_dat_o[31:24];
                                    flash_data_o_comb[7:0]  <= wb_sel_i[2] == 1'b1 ? wb_dat_i[23:16] : wb_dat_o[23:16];
                                end else begin
                                    operating_word <= 1'b0;
                                    flash_a <= wb_adr_i[22:0];
                                    flash_data_o_comb[15:8] <= wb_sel_i[1] == 1'b1 ? wb_dat_i[15:8] : wb_dat_o[15:8];
                                    flash_data_o_comb[7:0]  <= wb_sel_i[0] == 1'b1 ? wb_dat_i[7:0] : wb_dat_o[7:0];
                                end
                            end
                        end
                        default: ;
                    endcase
                end
                ST_WRITE: begin
                    waiting_reg <= waiting_reg - 1;
                    case (operating_word)
                        1'b0: begin
                            if (waiting_reg == 1) begin
                                operating_word <= 1'b1;
                                flash_a <= flash_a + 2;
                                waiting_reg <= WRITE_WAITING;
                                flash_data_o_comb[15:8] <= wb_sel_i[3] == 1'b1 ? wb_dat_i[31:24] : wb_dat_o[31:24];
                                flash_data_o_comb[7:0]  <= wb_sel_i[2] == 1'b1 ? wb_dat_i[23:16] : wb_dat_o[23:16];
                            end
                        end
                        1'b1: begin
                            if (waiting_reg == 1) begin
                                operating_word <= 1'b0;
                                wb_ack_o       <= 1'b1;
                                state          <= ST_IDLE;
                            end
                        end
                        default: ;
                    endcase
                end
                default: begin
                    state <= ST_WAITING;
                end
            endcase
        end
    end

endmodule
