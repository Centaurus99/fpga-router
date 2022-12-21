function logic [2:0] pcnt4(input [3:0] num);
    case (num)
        4'b0000: return 3'b000;
        4'b0001: return 3'b001;
        4'b0010: return 3'b001;
        4'b0011: return 3'b010;
        4'b0100: return 3'b001;
        4'b0101: return 3'b010;
        4'b0110: return 3'b010;
        4'b0111: return 3'b011;
        4'b1000: return 3'b001;
        4'b1001: return 3'b010;
        4'b1010: return 3'b010;
        4'b1011: return 3'b011;
        4'b1100: return 3'b010;
        4'b1101: return 3'b011;
        4'b1110: return 3'b011;
        4'b1111: return 3'b100;
    endcase
endfunction

function logic [3:0] pcnt8(input [7:0] num);
    return {num == 8'hff, pcnt4(num[3:0]) + pcnt4(num[7:4])};
endfunction

function logic [4:0] pcnt16(input [15:0] num);
    return {num == 16'hffff, pcnt8(num[7:0]) + pcnt8(num[15:8])};
endfunction

module alu (
    input  wire [31:0] alu_a,
    input  wire [31:0] alu_b,
    input  wire [ 3:0] alu_op,
    output reg  [31:0] alu_y
);

    logic [63:0] rol_reg;

    always_comb begin
        alu_y = 0;
        case (alu_op)
            4'b0000: alu_y = alu_a + alu_b;  // add
            4'b1000: alu_y = alu_a - alu_b;  // sub
            4'b0001: alu_y = alu_a << alu_b[4:0];  // sll
            4'b0010: alu_y = $signed(alu_a) < $signed(alu_b);  // slt
            4'b0011: alu_y = alu_a < alu_b;  // sltu
            4'b0100: alu_y = alu_a ^ alu_b;  // xor
            4'b0101: alu_y = alu_a >> alu_b[4:0];  // srl
            4'b1101: alu_y = $signed(alu_a) >>> alu_b[4:0];  // sra
            4'b0110: alu_y = alu_a | alu_b;  // or
            4'b0111: alu_y = alu_a & alu_b;  // and
            4'b1111: alu_y = alu_a & ~alu_b;  //andn
            4'b1001: begin  // ctz
                alu_y = 32'd32;
                for (int i = 0; i < 32; i++) begin
                    if (alu_a[i]) begin
                        alu_y = i;
                        break;
                    end
                end
            end
            4'b1010: begin  // pcnt
                alu_y = {alu_a == 32'hffffffff, pcnt16(alu_a[15:0]) + pcnt16(alu_a[31:16])};
            end
        endcase
    end

endmodule
