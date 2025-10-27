module priority_encoder #(parameter WIDTH = 8) (
		input logic [WIDTH - 1:0] req,
		output logic [$clog2(WIDTH) - 1:0] grant,
		output logic valid
);

	always_comb begin
		grant = '0;
		valid = 1'b0;

		for (int i = 0; i < WIDTH; i++) begin
			if (req[i]) begin
				grant = i;
				valid = 1'b1;
			end
		end
	end

endmodule