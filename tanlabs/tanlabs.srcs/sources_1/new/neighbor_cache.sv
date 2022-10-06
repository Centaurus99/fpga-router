// 散列表实现，遇到哈希碰撞直接删除原来的条目，所以先不做过时间自动删除等功能
// 组合逻辑，插入/修改时设we为1；查询时直接设置in_v6，下一个周期会得到结果，found=1表示存在该表项

module neighbor_cache #(
    parameter DATA_WIDTH = 176,
    parameter ADDR_WIDTH = 5
) (
    input wire clk,
    input wire reset,

    input wire         we,
    input wire [127:0] in_v6,
    input wire [ 47:0] in_mac,

    output reg [47:0] out_mac,
    output reg        found
    // output wire       ready  // 当前为空闲
);
    wire [ADDR_WIDTH - 1:0] addr;
    logic [DATA_WIDTH - 1:0] din, dout;
    logic bram_we;
    // logic bram_en;

    blk_mem_gen_0 bram_u (
        .clka (clk),      // input wire clka
        // .ena  (bram_en),  // input wire ena
        .wea  (bram_we),  // input wire wea
        .addra(addr),     // input wire [4 : 0] addra
        .dina (din),      // input wire [175 : 0] dina
        .douta(dout)      // output wire [175 : 0] douta
    );

    // typedef enum logic [3:0] {
    //     ST_INIT,
    //     ST_READ_RAM,
    //     ST_WRITE_RAM,
    //     ST_OUTPUT
    // } state_t;
    // state_t current, nxt;
    // assign ready = current == ST_INIT;

    logic [          31:0] hash0;
    logic [ADDR_WIDTH-1:0] hash;

    always_comb begin
        // 循环异或
        hash0 = in_v6[127:96] ^ in_v6[95:64] ^ in_v6[63:32] ^ in_v6[31:0];  
        hash0[7:0] = hash0[31:24] ^ hash0[23:16] ^ hash0[15:8] ^ hash0[7:0];
        hash = hash0[7:8-ADDR_WIDTH] ^ hash0[ADDR_WIDTH-1:0];
    end
    assign addr = hash;
    assign bram_we = we;
    assign din = {in_mac, in_v6};

    always_comb begin
        if (!we && in_v6 == dout[127:0]) begin
            found = 1;
            out_mac = dout[175:128];
        end else begin
            found = 0;
            out_mac = 0;
        end
    end

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
