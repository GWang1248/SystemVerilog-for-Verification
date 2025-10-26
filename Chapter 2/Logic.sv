module logic_data_type (input logic rst);

	parameter CYCLE = 20;
	logic q, q_l, d, clk, rst_1;
	initial begin //Assign clock up and down
		clk = 0;
		forever #(CYCLE/2) clk = ~clk;
	end

	assign rst_1 = ~rst;
	not nl(q_l, q);
	my_dff dl(q, d, clk, rst_1);
	
endmodule