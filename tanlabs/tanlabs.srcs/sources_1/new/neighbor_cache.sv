// 散列表实现，遇到哈希碰撞直接删除原来的条目，所以先不做过时间自动删除等功能
// 组合逻辑，插入/修改时设we为1，设置in_v6_w和in_mac
// 查询时设置in_v6_r，下一个周期会得到结果，found=1表示存在该表项

module neighbor_cache #(
    parameter DATA_WIDTH = 176,
    parameter ADDR_WIDTH = 8
) (
    input wire clk,
    input wire reset,

    input wire         we,
    input wire [127:0] in_v6_w,
    input wire [127:0] in_v6_r,
    input wire [ 47:0] in_mac,

    output reg [47:0] out_mac,
    output reg        found
    // output wire       ready  // 当前为空闲
);
    wire [ADDR_WIDTH - 1:0] addra, addrb;
    logic [DATA_WIDTH - 1:0] dina, douta[3:0], doutb[3:0];
    // logic bram_en;

    logic wea [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; ++i) begin: brams
            blk_mem_gen_0 bram_i (
                .clka(clk),    // input wire clka
                .wea(wea[i]),      // input wire [0 : 0] wea
                .addra(addra),  // input wire [7 : 0] addra
                .dina(dina),    // input wire [175 : 0] dina
                .douta(douta[i]),  // output wire [175 : 0] douta
                .clkb(clk),    // input wire clkb
                .web(0),      // input wire [0 : 0] web
                .addrb(addrb),  // input wire [7 : 0] addrb
                .dinb(0),    // input wire [175 : 0] dinb
                .doutb(doutb[i])  // output wire [175 : 0] doutb
            );
        end
        
    endgenerate

    // logic [DATA_WIDTH - 1:0] data[3:0][31:0];

    // typedef enum logic [3:0] {
    //     ST_INIT,
    //     ST_READ_RAM,
    //     ST_WRITE_RAM,
    //     ST_OUTPUT
    // } state_t;
    // state_t current, nxt;
    // assign ready = current == ST_INIT;

    logic [31:0] hash0_r, hash0_w;
    logic [ADDR_WIDTH-1:0] hash_r, hash_w;

    always_comb begin
        // 循环异或
        hash0_r = in_v6_r[127:96] ^ in_v6_r[95:64] ^ in_v6_r[63:32] ^ in_v6_r[31:0];
        hash_r = hash0_r[31:24] ^ hash0_r[23:16] ^ hash0_r[15:8] ^ hash0_r[7:0];
        // hash_r = hash0_r[7:8-ADDR_WIDTH] ^ hash0_r[ADDR_WIDTH-1:0];

        hash0_w = in_v6_w[127:96] ^ in_v6_w[95:64] ^ in_v6_w[63:32] ^ in_v6_w[31:0];
        hash_w = hash0_w[31:24] ^ hash0_w[23:16] ^ hash0_w[15:8] ^ hash0_w[7:0];
        // hash_w = hash0_w[7:8-ADDR_WIDTH] ^ hash0_w[ADDR_WIDTH-1:0];
    end
    assign addra = hash_w;
    assign addrb = hash_r;

    wire [3:0] match_w, match_r, exist_w;
    assign match_w = {
        in_v6_w == douta[3][127:0],
        in_v6_w == douta[2][127:0],
        in_v6_w == douta[1][127:0],
        in_v6_w == douta[0][127:0]
    };
    assign match_r = {
        in_v6_r == doutb[3][127:0],
        in_v6_r == doutb[2][127:0],
        in_v6_r == doutb[1][127:0],
        in_v6_r == doutb[0][127:0]
    };
    assign exist_w = {
        douta[3] != 0,
        douta[2] != 0,
        douta[1] != 0,
        douta[0] != 0
    };

    assign dina = {in_mac, in_v6_w};

    // always_comb begin
    //     if (in_v6_r == doutb[127:0]) begin
    //         found   = 1;
    //         out_mac = doutb[175:128];
    //     end else begin
    //         found   = 0;
    //         out_mac = 0;
    //     end
    // end

    always_comb begin
        out_mac = 0;
        found   = 1;
        case (match_r)
            4'b1000: out_mac = doutb[3][175:128];
            4'b0100: out_mac = doutb[2][175:128];
            4'b0010: out_mac = doutb[1][175:128];
            4'b0001: out_mac = doutb[0][175:128];
            default: found = 0;
        endcase
    end

    always_comb begin
        if (we) begin
            case (match_w)
                4'b0001: wea[0] = 1;
                4'b0010: wea[1] = 1;
                4'b0100: wea[2] = 1;
                4'b1000: wea[3] = 1;
                default: begin
                    case (exist_w)
                        4'b0001: wea[1] = 1;
                        4'b0011: wea[2] = 1;
                        4'b0111: wea[3] = 1;
                        default: wea[0] = 1;
                    endcase
                end
            endcase
        end else begin
            wea = '{default: 0};
        end
    end

    // always_ff @(posedge clk or posedge reset) begin
    //     if (reset) begin
    //         data <= '{default: 0};
    //     end else begin
    //         if (we) begin
    //             case (match_w)
    //                 4'b0001: dina[0][hash_w] <= dina;
    //                 4'b0010: dina[1][hash_w] <= dina;
    //                 4'b0100: dina[2][hash_w] <= dina;
    //                 4'b1000: dina[3][hash_w] <= dina;
    //                 default: begin
    //                     case (exist_w)
    //                         4'b0001: data[1][hash_w] <= dina;
    //                         4'b0011: data[2][hash_w] <= dina;
    //                         4'b0111: data[3][hash_w] <= dina;
    //                         default: data[0][hash_w] <= dina;
    //                     endcase
    //                 end
    //             endcase
    //         end
    //     end
    // end

    // always_ff @(posedge clk or posedge reset) begin
    //     if (reset) current <= ST_INIT;
    //     else current <= nxt;
    // end

    // always_comb begin
    //     nxt = ST_INIT;
    //     case (current)
    //         ST_INIT: begin
    //             if (trigger) begin
    //                 if (is_query) nxt <= ST_READ_RAM;
    //                 else if (is_update) nxt <= ST_WRITE_RAM;
    //             end
    //         end
    //         ST_READ_RAM: nxt <= ST_OUTPUT;
    //         ST_OUTPUT: nxt <= ST_INIT;
    //         ST_WRITE_RAM: nxt <= ST_INIT;

    //     endcase
    // end

    // always_ff @(posedge clk) begin
    //     case (current)
    //         ST_INIT: begin
    //             bram_en <= 0;
    //             bram_we <= 0;
    //         end
    //         ST_READ_RAM: begin
    //             addr <= hash;
    //             bram_en <= 1;
    //         end
    //         ST_OUTPUT: begin
    //             if (dout[127:0] == in_v6) begin
    //                 out_mac <= dout[176:128];
    //                 found <= 1;
    //             end else begin
    //                 found <= 0;
    //             end
    //         end
    //         ST_WRITE_RAM: begin
    //             addr <= hash;
    //             din <= {in_mac, in_v6};
    //             bram_en <= 1;
    //             bram_we <= 1;
    //         end

    //     endcase
    // end

endmodule
