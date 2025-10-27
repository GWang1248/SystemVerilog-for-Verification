module des (intput req, clk, output reg gnt);
	always_ff @(posedge clk) begin
		if (req)
			gnt <= 1;
		else
			gnt <= 0;
	end
endmodule

interface _if (input bit clk);
	logic gnt;
	logic req;

	//Clocking blocks
	//Input sampled 3ns before posedge of clk, output driven 2ns after posedge of clk
	clocking cb @(posedge clk);
		input #1ns gnt; //Input Skew
		output #5 req; //Output Skew
	endclocking
endinterface

module tb;
	bit clk;

	//Create clock and initialize input signal
	always #10 clk = ~clk;
	initial begin
		clk <= 0;
		if0.cb.req <= 0;
	end

	//Instantiate interface
	_if if0 (.clk(clk));

	//Instantiate Designs
	des d0 ( .clk(clk),
			.req(if0.req),
			.gnt(if0.gnt));

	//Drive Stimulus
	initial begin
		for (int i = 0; i < 10; i++) begin
			bit [3:0] delay = $random;
			repeat (delay) @(posedge if0.clk);
			if0.cb.req <= ~if0.cb.req;
		end
		#20 $finish;
	end
endmodule