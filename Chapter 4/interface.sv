interface myBus (input clk);
	logic [7:0] data;
	logic enable;

	modport tb (input data, clk, output enable);
	modport dut (output data, input enable, clk);
endinterface

module dut (myBus busIf);
	always_ff @(posedge busIf.clk) begin
		if (busIf.enable)
			busIf.data <= busIf.data + 1;
		else
			busIf.data <= 0;
	end
endmodule

module tb_top;
	bit clk;

	always #10 clk = ~clk;

	//Create interface object
	myBus busIf(clk);

	//Instantiate DUT
	dut dut0 (busIf.DUT);

	//Toggle enable
	initial begin
		busIf.enable <= 0;
		#10 busIf.enable <= 1;
		#40 busIf.enable <= 0;
		#20 busIf.enable <= 1;
		#100 $finish;
	end
endmodule