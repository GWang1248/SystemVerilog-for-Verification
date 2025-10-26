typedef enum logic [1:0] {
	ADD  =2'b00;
	SUB = 2'b01;
	INV = 2'b10;
	ORR = 2'b11;
} op_code_e;

module alu_tb;
	op_code_e opcode;

	logic [8] A, B;
	logic [8] Y;

	alu dut(.A(A), .B(B), .opcode(opcode), .Y(Y));

	initial begin
		A = 8'h0F;
		B = 8'hF0;

		for (opcode = ADD; opcode <= ORR; opcode++) begin
			#10;
			$display("[%0t] opcode = %s (value = %b) -> Y = %h", $time, opcode.name(), opcode, Y);
		end

		#10;
		$finish;
	end
endmodule