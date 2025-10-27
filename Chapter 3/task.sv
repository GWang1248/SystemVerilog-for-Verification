module tb;

	//Static task 1
	task sum (input [7:0] a, b, output [7:0] c);
		c = a + b;
	endtask

	//Static task 2
	task sum;
		input [7:0] a, b;
		output [7:0] c;
		c = a + b;
	endtask

	initial begin
		reg [7:0] x, y, z;
		sum (x, y, z);
	end

	initial display();
	initial display();
	initial display();

	//Automatic task
	task automatic display();
		integer i = 0;
		i = i + 1;
		$display("i = %0d", i);
	endtask

endmodule