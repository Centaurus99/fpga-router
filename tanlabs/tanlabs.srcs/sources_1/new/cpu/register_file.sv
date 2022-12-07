module register_file (
    input  wire clk,
    input  wire reset,

    input  wire [ 4:0] waddr,  
    input  wire [31:0] wdata,  
    input  wire        we,     
    input  wire [ 4:0] raddr_a,
    output wire [31:0] rdata_a,
    input  wire [ 4:0] raddr_b,
    output wire [31:0] rdata_b
);

    reg [31:0] regs [31:0];

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            regs <= '{default:32'b0};
        end
        else if (we) begin
            if (waddr != 0)
                regs[waddr] <= wdata;
        end
    end

    assign rdata_a = (we && waddr == raddr_a) ? wdata : regs[raddr_a];
    assign rdata_b = (we && waddr == raddr_b) ? wdata : regs[raddr_b];

endmodule
