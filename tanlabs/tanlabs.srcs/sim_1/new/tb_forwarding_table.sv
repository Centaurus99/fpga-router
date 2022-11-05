`timescale 1ns / 1ps

`include "../../sources_1/new/forwarding_table.vh"

module tb_forwarding_table #(
    // Wishbone 总线参数
    parameter WISHBONE_DATA_WIDTH = 32,
    parameter WISHBONE_ADDR_WIDTH = 32,
    parameter TEST_ROUNDS = 4,
    parameter SIMPLE_TEST = 0
) ();

    wire clk_125M, clk_100M;
    clock clock_i (
        .clk_125M(clk_125M),
        .clk_100M(clk_100M)
    );

    reg                reset;

    frame_beat         in;
    wire               in_ready;

    // 模块输出
    frame_beat         forwarded;
    wire               forwarded_ready;
    logic      [127:0] forwarded_next_hop_ip;
    assign forwarded_ready = 1'b1;

    // IP for SIMPLE-TEST
    logic [127:0] const_ip[TEST_ROUNDS-1:0];
    assign const_ip[0] = {<<8{128'h2a0e_aa06_0497_0a00_41b7_0000_1234_5678}};
    assign const_ip[1] = {<<8{128'h2a0e_aa06_0497_0a01_41b7_0000_1234_5678}};
    assign const_ip[2] = {<<8{128'h2a0e_aa06_0497_0a02_41b7_0000_1234_5678}};
    assign const_ip[3] = {<<8{128'h2a0e_aa06_0497_0a03_41b7_0000_1234_5678}};

    wire                             cpu_clk;
    reg                              wb_cyc_i;
    reg                              wb_stb_i;
    reg                              wb_ack_o;
    reg  [  WISHBONE_ADDR_WIDTH-1:0] wb_adr_i;
    reg  [  WISHBONE_DATA_WIDTH-1:0] wb_dat_i;
    reg  [  WISHBONE_DATA_WIDTH-1:0] wb_dat_o;
    reg  [WISHBONE_DATA_WIDTH/8-1:0] wb_sel_i;
    reg                              wb_we_i;

    // 读取文件
    int fd, fd_in, fd_ans;
    int ret, ret_in, ret_ans;
    initial begin
        if (SIMPLE_TEST) begin
            fd = $fopen("mem.txt", "r");
        end else begin
            fd     = $fopen("forsim_mem.txt", "r");
            fd_in  = $fopen("forsim_input.txt", "r");
            fd_ans = $fopen("forsim_answer.txt", "r");
        end
        reset = 1;
        #20;
        reset = 0;
    end

    typedef enum {
        ST_WRITE_RAM,
        ST_SEND,
        ST_SEND_WAIT,
        ST_DONE
    } state_t;

    state_t state_write, state_send;

    int                           write_count;
    reg [WISHBONE_DATA_WIDTH-1:0] ram_addr;
    reg [WISHBONE_DATA_WIDTH-1:0] ram_data;

    // 写入内存
    always_ff @(posedge clk_100M or posedge reset) begin
        if (reset) begin
            state_write <= ST_WRITE_RAM;
            write_count <= 0;
        end else begin
            case (state_write)
                ST_WRITE_RAM: begin
                    if (write_count == 0 || wb_ack_o) begin
                        write_count <= write_count + 1;
                        ret = $fscanf(fd, "%x%x", ram_addr, ram_data);
                        if (ret != 2) begin
                            wb_cyc_i    <= 1'b0;
                            wb_stb_i    <= 1'b0;
                            state_write <= ST_DONE;
                        end else begin
                            wb_cyc_i    <= 1'b1;
                            wb_stb_i    <= 1'b1;
                            wb_we_i     <= 1'b1;
                            wb_sel_i    <= 4'b1111;
                            wb_adr_i    <= ram_addr;
                            wb_dat_i    <= ram_data;
                            state_write <= ST_WRITE_RAM;
                        end
                    end
                end
                ST_DONE: begin
                    state_write <= ST_DONE;
                end
            endcase
        end
    end

    generate
        if (SIMPLE_TEST) begin
            // 使用 mem.txt 和固定几个 IP 地址的简单测试
            int send_count;
            always_ff @(posedge clk_125M or posedge reset) begin
                if (reset) begin
                    state_send <= ST_SEND;
                    in         <= '{default: 0};
                    send_count <= 0;
                end else begin
                    if (state_write == ST_DONE) begin
                        case (state_send)
                            // 发送 const_ip 为 dst 的包
                            ST_SEND: begin
                                in.valid        <= 1;
                                in.is_first     <= 1;
                                in.data.ip6.dst <= const_ip[send_count];
                                send_count      <= send_count + 1;
                                state_send      <= ST_SEND_WAIT;
                            end
                            // 等待收包, 共计发包 TETS_ROUNDS 次
                            ST_SEND_WAIT: begin
                                if (in_ready) begin
                                    in <= '{default: 0};
                                    if (send_count == TEST_ROUNDS) begin
                                        state_send <= ST_DONE;
                                    end else begin
                                        state_send <= ST_SEND;
                                    end
                                end
                            end
                            ST_DONE: begin
                                state_send <= ST_DONE;
                                #1000;
                                $finish;
                            end
                        endcase
                    end
                end
            end
        end else begin
            // 软件根据随机数据生成的测试
            string         opcode;
            logic  [127:0] ip_in;
            logic [127:0] ip_ans, port_ans, route_type_ans;
            always_ff @(posedge clk_125M or posedge reset) begin
                if (reset) begin
                    state_send     <= ST_SEND;
                    in             <= '{default: 0};
                    ip_in          <= '0;
                    ip_ans         <= '0;
                    port_ans       <= '0;
                    route_type_ans <= '0;
                end else begin
                    if (state_write == ST_DONE) begin
                        case (state_send)
                            ST_SEND: begin
                                // 读取开头为 Q 的行, 作为查询地址
                                ret_in = $fscanf(fd_in, "%s", opcode);
                                if (ret_in != 1) begin
                                    state_send <= ST_DONE;
                                end else if (opcode != "Q") begin
                                    $fgets(opcode, fd_in);
                                    state_send <= ST_SEND;
                                end else begin
                                    ret_in = $fscanf(
                                        fd_in,
                                        "%x%x%x%x",
                                        ip_in[31:0],
                                        ip_in[63:32],
                                        ip_in[95:64],
                                        ip_in[127:96]
                                    );
                                    if (ret_in != 4) begin
                                        $display("INPUT FILE ERROR! data is not enough!");
                                        state_send <= ST_DONE;
                                    end else begin
                                        in.valid        <= 1;
                                        in.is_first     <= 1;
                                        in.data.ip6.dst <= ip_in;
                                        state_send      <= ST_SEND_WAIT;
                                    end
                                end
                            end
                            ST_SEND_WAIT: begin
                                // 成功发出后输入置零
                                if (in_ready) begin
                                    in <= '{default: 0};
                                end
                                // 在收到查完的包之后, 读取 answer 中的答案进行比对
                                if (forwarded.valid) begin
                                    $display("Tested: ip_in:%x, next_hop_ip:%x, port:%x", ip_in,
                                             forwarded_next_hop_ip, forwarded.meta.dest);
                                    ret_ans = $fscanf(
                                        fd_ans,
                                        "%x%x%x%x%x%x",
                                        ip_ans[31:0],
                                        ip_ans[63:32],
                                        ip_ans[95:64],
                                        ip_ans[127:96],
                                        port_ans,
                                        route_type_ans
                                    );
                                    if (ret_ans != 6) begin
                                        $display("ANSWER FILE ERROR! data is not enough!");
                                        state_send <= ST_DONE;
                                    end else begin
                                        // 直连路由, next_hop_ip 为目标地址
                                        if (route_type_ans == 0) begin
                                            if (ip_in != forwarded_next_hop_ip) begin
                                                $display("ERROR! ip_ans:%x, next_hop_ip:%x", ip_in,
                                                         forwarded_next_hop_ip);
                                            end else begin
                                                $display("PASS!");
                                            end
                                            // 静态或动态路由, next_hop_ip 由答案给出
                                        end else begin
                                            if (ip_ans != forwarded_next_hop_ip) begin
                                                $display("ERROR! ip_ans:%x, next_hop_ip:%x",
                                                         ip_ans, forwarded_next_hop_ip);
                                            end else if (port_ans != forwarded.meta.dest) begin
                                                $display("ERROR! port_ans:%x, port:%x", port_ans,
                                                         forwarded.meta.dest);
                                            end else begin
                                                $display("PASS!");
                                            end
                                        end
                                        state_send <= ST_SEND;
                                    end
                                end
                            end
                            ST_DONE: begin
                                state_send <= ST_DONE;
                                #1000;
                                $finish;
                            end
                        endcase
                    end
                end
            end
        end
    endgenerate

    forwarding_table #(
        .WISHBONE_DATA_WIDTH(WISHBONE_DATA_WIDTH),
        .WISHBONE_ADDR_WIDTH(WISHBONE_ADDR_WIDTH)
    ) forwarding_table_i (
        .clk     (clk_125M),
        .reset   (reset),
        .in      (in),
        .in_ready(in_ready),

        .out        (forwarded),
        .next_hop_ip(forwarded_next_hop_ip),
        .out_ready  (forwarded_ready),

        .cpu_clk (clk_100M),
        .wb_cyc_i(wb_cyc_i),
        .wb_stb_i(wb_stb_i),
        .wb_ack_o(wb_ack_o),
        .wb_adr_i(wb_adr_i),
        .wb_dat_i(wb_dat_i),
        .wb_dat_o(wb_dat_o),
        .wb_sel_i(wb_sel_i),
        .wb_we_i (wb_we_i)
    );

endmodule
