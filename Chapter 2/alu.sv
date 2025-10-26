module alu(input logic [7:0] A, B
			input logic [1:0] opcode,
			output logic [7:0] Y);
	
	always_comb begin
		case (opcode)
			2'b00: Y = A + B;
			2'b01: Y = A - B;
			2'b10: Y = ~A;
			2'b11: Y = {7'b0, |B};
			default: Y = 8'hXX;
		endcase
	end
endmodule