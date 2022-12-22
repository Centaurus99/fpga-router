`default_nettype none

module gpio #(
    parameter CLK_FREQ      = 50_000_000,
    parameter DATA_WIDTH    = 32,             // DATA_WIDTH: wishbone data width
    parameter ADDR_WIDTH    = 32,             // DATA_WIDTH: wishbone data width
    parameter SAMPLE_CYCLES = CLK_FREQ / 100  // 采样周期
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

    // GPIO
    input  wire [ 3:0] touch_btn,  // BTN1~BTN4，按钮开关，按下时为 1
    input  wire [31:0] dip_sw,     // 32 位拨码开关，拨到“ON”时为 1
    output wire [15:0] leds,       // 16 位 LED，输出时 1 点亮
    output wire [ 7:0] dpy0,       // 数码管低位信号，包括小数点，输出 1 点亮
    output wire [ 7:0] dpy1        // 数码管高位信号，包括小数点，输出 1 点亮 

);

    reg [15:0] leds_reg;
    reg [ 7:0] dpy0_reg;
    reg [ 7:0] dpy1_reg;

    reg [31:0] buffer      [31:0];
    reg [ 4:0] buffer_head;
    reg [ 4:0] buffer_tail;

    reg [31:0] dip_sw_reg, dip_sw_reg2;
    reg [3:0] touch_btn_reg, touch_btn_reg2;

    reg          is_read;
    reg          is_write;

    // 读写信号
    logic [31:0] buffer_data_i;
    logic [31:0] buffer_data_o;
    logic        is_btn_changed;
    logic        is_buffer_full;
    logic        is_buffer_empty;
    assign is_buffer_full = buffer_head == $unsigned(buffer_tail) + 5'b00001;
    assign is_buffer_empty = buffer_head == buffer_tail;
    assign is_btn_changed  = |{~touch_btn_reg2 & touch_btn_reg, dip_sw_reg2[15:0] ^ dip_sw_reg[15:0]};

    typedef enum {
        ST_IDLE,
        ST_UPDATE_POINTER
    } gpio_state_t;

    gpio_state_t state;

    // 扫描开关变化

    always_ff @(posedge clk) begin
        if (rst) begin
            is_write       <= 1'b0;
            buffer_data_i  <= 32'h0000_0000;
            touch_btn_reg  <= 4'b0000;
            dip_sw_reg     <= 32'h0000_0000;
            touch_btn_reg2 <= 4'b0000;
            dip_sw_reg2    <= 32'h0000_0000;
        end else begin
            touch_btn_reg  <= touch_btn;
            dip_sw_reg     <= dip_sw;
            touch_btn_reg2 <= touch_btn_reg;
            dip_sw_reg2    <= dip_sw_reg;
            if (!is_write) begin
                if (is_btn_changed) begin
                    is_write <= 1'b1;
                    buffer_data_i <= {
                        12'b0, ~touch_btn_reg2 & touch_btn_reg, dip_sw_reg2[15:0] ^ dip_sw_reg[15:0]
                    };
                end
            end else begin
                is_write      <= 1'b0;
                buffer_data_i <= 32'h0000_0000;
            end
        end
    end

    // 在时钟上升沿更新循环队列

    int   write_count;
    logic read_done;

    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 32; i++) begin
                buffer[i] <= 32'h0000_0000;
            end
            buffer_head <= 5'b00000;
            buffer_tail <= 5'b00000;
            write_count <= 0;
            read_done   <= 1'b0;
        end else begin
            if (is_write) begin
                if (!is_buffer_full) begin
                    buffer[buffer_tail] <= buffer_data_i;
                    write_count         <= SAMPLE_CYCLES;
                end
            end else begin
                if (write_count != 0) begin
                    write_count <= write_count - 1;
                    if (write_count == 1) begin
                        buffer_tail <= buffer_tail + 1;
                    end
                end
            end
            if (is_read) begin
                if (!is_buffer_empty) begin
                    buffer_data_o <= buffer[buffer_head];
                    read_done     <= 1'b1;
                end else begin
                    buffer_data_o <= 32'hff00_0000;
                end
            end else begin
                if (read_done) begin
                    buffer_head <= buffer_head + 1;
                    read_done   <= 1'b0;
                end
            end
        end
    end

    // 读写部分（由CPU操作）
    always_ff @(posedge clk) begin
        if (rst) begin
            leds_reg <= 16'h0000;
            dpy0_reg <= 8'h00;
            dpy1_reg <= 8'h00;
            is_read  <= 1'b0;
            state    <= ST_IDLE;
        end else if (wb_cyc_i & wb_stb_i) begin
            case (state)
                ST_IDLE: begin
                    case (wb_adr_i[3:0])
                        4'h0: begin
                            // 可读，不可写
                            if (!wb_we_i) begin
                                wb_ack_o <= 1'b0;
                                is_read  <= 1'b1;
                                state    <= ST_UPDATE_POINTER;
                            end
                        end
                        4'h4: begin
                            wb_ack_o <= 1'b0;
                            if (!wb_we_i) begin
                                wb_dat_o <= {16'h00, leds_reg};
                            end else begin
                                leds_reg <= wb_dat_i[15:0];
                            end
                        end
                        4'h8: begin
                            wb_ack_o <= 1'b0;
                            if (!wb_we_i) begin
                                wb_dat_o <= {16'h00, dpy0_reg, dpy1_reg};
                            end else begin
                                dpy0_reg <= wb_dat_i[15:8];
                                dpy1_reg <= wb_dat_i[7:0];
                            end
                        end
                        default: begin
                            state <= ST_IDLE;
                        end
                    endcase
                end
                ST_UPDATE_POINTER: begin
                    // 获得数据，同时等待循环队列更新指针
                    wb_ack_o <= 1'b1;
                    wb_dat_o <= buffer_data_o;
                    is_read  <= 1'b0;
                    state    <= ST_IDLE;
                end
                default: begin
                    state <= ST_IDLE;
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
