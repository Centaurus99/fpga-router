module trigger(
    input wire clk,
    input wire in,
    output wire trigger
    );
    logic last_in_reg, in_reg;
    always_ff @ (posedge clk) begin
        in_reg <= in;
        last_in_reg <= in_reg;
    end

    assign trigger = in_reg & !last_in_reg;
    
endmodule
