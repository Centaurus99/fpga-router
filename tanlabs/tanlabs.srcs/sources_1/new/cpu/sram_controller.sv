module sram_controller #(
    parameter CLK_FREQ   = 50_000_000,
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,

    parameter SRAM_ADDR_WIDTH = 20,
    parameter SRAM_DATA_WIDTH = 32,

    localparam SRAM_BYTES      = SRAM_DATA_WIDTH / 8,
    localparam SRAM_BYTE_WIDTH = $clog2(SRAM_BYTES)
) (
    // clk and reset
    input wire clk_i,
    input wire rst_i,

    // wishbone slave interface
    input  wire                    wb_cyc_i,
    input  wire                    wb_stb_i,
    output reg                     wb_ack_o,
    input  wire [  ADDR_WIDTH-1:0] wb_adr_i,
    input  wire [  DATA_WIDTH-1:0] wb_dat_i,
    output reg  [  DATA_WIDTH-1:0] wb_dat_o,
    input  wire [DATA_WIDTH/8-1:0] wb_sel_i,
    input  wire                    wb_we_i,

    // sram interface
    output reg  [SRAM_ADDR_WIDTH-1:0] sram_addr,
    inout  wire [SRAM_DATA_WIDTH-1:0] sram_data,
    output reg                        sram_ce_n,
    output reg                        sram_oe_n,
    output reg                        sram_we_n,
    output reg  [     SRAM_BYTES-1:0] sram_be_n
);

    wire [31:0] sram_data_i_comb;
    reg  [31:0] sram_data_o_comb;
    reg         sram_data_t_comb;

    assign sram_data        = sram_data_t_comb ? 32'bz : sram_data_o_comb;
    assign sram_data_i_comb = sram_data;

    reg sram_we_n_ddr1, sram_we_n_ddr2;
    reg request;

    always_comb begin
        sram_addr        = wb_adr_i[SRAM_ADDR_WIDTH+1 : 2];
        sram_data_o_comb = wb_dat_i;
        wb_dat_o         = sram_data_i_comb;
        request          = wb_cyc_i & wb_stb_i;
        sram_ce_n        = ~request;
        sram_oe_n        = wb_we_i;
        sram_data_t_comb = ~wb_we_i;
        sram_be_n        = ~wb_sel_i;
    end

    generate
        if (CLK_FREQ <= 60_000_000) begin
            // 两周期读写
            ODDR #(
                .DDR_CLK_EDGE("OPPOSITE_EDGE"),  // "OPPOSITE_EDGE" or "SAME_EDGE" 
                .INIT        (1'b1),             // Initial value of Q: 1'b0 or 1'b1
                .SRTYPE      ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC" 
            ) ODDR_inst (
                .Q (sram_we_n),                             // 1-bit DDR output
                .C (clk_i),                                 // 1-bit clock input
                .CE(1'b1),                                  // 1-bit clock enable input
                .D1(sram_we_n_ddr1 ^ (request & wb_we_i)),  // 1-bit data input (positive edge)
                .D2(sram_we_n_ddr2 ^ (request & wb_we_i)),  // 1-bit data input (negative edge)
                .R (),                                      // 1-bit reset
                .S ()                                       // 1-bit set
            );

            typedef enum logic [1:0] {
                STATE_IDLE,
                STATE_READ,
                STATE_WRITE
            } state_t;

            state_t state, state_n;

            always_ff @(posedge clk_i or posedge rst_i) begin
                if (rst_i) begin
                    state <= STATE_IDLE;
                end else begin
                    state <= state_n;
                end
            end

            always_comb begin
                unique case (state)
                    STATE_IDLE: begin
                        if (request) begin
                            if (wb_we_i) begin
                                state_n = STATE_WRITE;
                            end else begin
                                state_n = STATE_READ;
                            end
                        end else begin
                            state_n = STATE_IDLE;
                        end
                    end
                    STATE_READ: state_n = STATE_IDLE;
                    STATE_WRITE: state_n = STATE_IDLE;
                    default: state_n = STATE_IDLE;
                endcase
            end

            always_ff @(posedge clk_i or posedge rst_i) begin
                if (rst_i) begin
                    wb_ack_o       <= 1'b0;
                    sram_we_n_ddr1 <= 1'b1;
                    sram_we_n_ddr2 <= 1'b1;
                end else begin
                    wb_ack_o       <= 1'b0;
                    sram_we_n_ddr1 <= 1'b1;
                    sram_we_n_ddr2 <= 1'b1;
                    case (state_n)
                        STATE_READ: begin
                            wb_ack_o <= 1'b1;
                        end
                        STATE_WRITE: begin
                            wb_ack_o       <= 1'b1;
                            sram_we_n_ddr1 <= 1'b0;
                            sram_we_n_ddr2 <= 1'b0;
                        end
                        default: ;  // do nothing
                    endcase
                end
            end

        end else if (CLK_FREQ <= 110_000_000) begin
            // 三周期读写
            ODDR #(
                .DDR_CLK_EDGE("OPPOSITE_EDGE"),  // "OPPOSITE_EDGE" or "SAME_EDGE" 
                .INIT        (1'b1),             // Initial value of Q: 1'b0 or 1'b1
                .SRTYPE      ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC" 
            ) ODDR_inst (
                .Q (sram_we_n),                             // 1-bit DDR output
                .C (clk_i),                                 // 1-bit clock input
                .CE(1'b1),                                  // 1-bit clock enable input
                .D1(sram_we_n_ddr1 ^ (request & wb_we_i)),  // 1-bit data input (positive edge)
                .D2(sram_we_n_ddr2),                        // 1-bit data input (negative edge)
                .R (),                                      // 1-bit reset
                .S ()                                       // 1-bit set
            );

            typedef enum logic [2:0] {
                STATE_IDLE,
                STATE_READ1,
                STATE_READ2,
                STATE_WRITE1,
                STATE_WRITE2
            } state_t;

            state_t state, state_n;

            always_ff @(posedge clk_i or posedge rst_i) begin
                if (rst_i) begin
                    state <= STATE_IDLE;
                end else begin
                    state <= state_n;
                end
            end

            always_comb begin
                unique case (state)
                    STATE_IDLE: begin
                        if (request) begin
                            if (wb_we_i) begin
                                state_n = STATE_WRITE1;
                            end else begin
                                state_n = STATE_READ1;
                            end
                        end else begin
                            state_n = STATE_IDLE;
                        end
                    end
                    STATE_READ1: state_n = STATE_READ2;
                    STATE_READ2: state_n = STATE_IDLE;
                    STATE_WRITE1: state_n = STATE_WRITE2;
                    STATE_WRITE2: state_n = STATE_IDLE;
                    default: state_n = STATE_IDLE;
                endcase
            end

            always_ff @(posedge clk_i or posedge rst_i) begin
                if (rst_i) begin
                    wb_ack_o       <= 1'b0;
                    sram_we_n_ddr1 <= 1'b1;
                    sram_we_n_ddr2 <= 1'b1;
                end else begin
                    wb_ack_o       <= 1'b0;
                    sram_we_n_ddr1 <= 1'b1;
                    sram_we_n_ddr2 <= 1'b1;
                    case (state_n)
                        STATE_READ2: begin
                            wb_ack_o <= 1'b1;
                        end
                        STATE_WRITE1: begin
                            sram_we_n_ddr1 <= 1'b1;
                            sram_we_n_ddr2 <= 1'b0;
                        end
                        STATE_WRITE2: begin
                            wb_ack_o       <= 1'b1;
                            sram_we_n_ddr1 <= 1'b0;
                            sram_we_n_ddr2 <= 1'b1;
                        end
                        default: ;  // do nothing
                    endcase
                end
            end

        end else begin
            // 四周期读写
            typedef enum logic [2:0] {
                STATE_IDLE,
                STATE_READ1,
                STATE_READ2,
                STATE_READ3,
                STATE_WRITE1,
                STATE_WRITE2,
                STATE_WRITE3
            } state_t;

            state_t state, state_n;

            always_ff @(posedge clk_i or posedge rst_i) begin
                if (rst_i) begin
                    state <= STATE_IDLE;
                end else begin
                    state <= state_n;
                end
            end

            always_comb begin
                unique case (state)
                    STATE_IDLE: begin
                        if (request) begin
                            if (wb_we_i) begin
                                state_n = STATE_WRITE1;
                            end else begin
                                state_n = STATE_READ1;
                            end
                        end else begin
                            state_n = STATE_IDLE;
                        end
                    end
                    STATE_READ1: state_n = STATE_READ2;
                    STATE_READ2: state_n = STATE_READ3;
                    STATE_READ3: state_n = STATE_IDLE;
                    STATE_WRITE1: state_n = STATE_WRITE2;
                    STATE_WRITE2: state_n = STATE_WRITE3;
                    STATE_WRITE3: state_n = STATE_IDLE;
                    default: state_n = STATE_IDLE;
                endcase
            end

            always_ff @(posedge clk_i or posedge rst_i) begin
                if (rst_i) begin
                    wb_ack_o       <= 1'b0;
                    sram_we_n      <= 1'b1;
                    sram_we_n_ddr1 <= 1'b1;
                    sram_we_n_ddr2 <= 1'b1;
                end else begin
                    wb_ack_o <= 1'b0;
                    case (state_n)
                        STATE_READ3: begin
                            wb_ack_o <= 1'b1;
                        end
                        STATE_WRITE1: begin
                            sram_we_n <= 1'b0;
                        end
                        STATE_WRITE3: begin
                            wb_ack_o  <= 1'b1;
                            sram_we_n <= 1'b1;
                        end
                        default: ;  // do nothing
                    endcase
                end
            end

        end
    endgenerate

endmodule
