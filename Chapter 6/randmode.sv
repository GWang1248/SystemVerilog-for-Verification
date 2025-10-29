class MyClass;
	rand bit [3:0] var1;
	rand bit [1:0] var2;
endclass

module tb;
	initial begin
		MyClass f = new();
		$display("Before randomization var1 = %0d, car2 = %0d", f.var1, f.var2);

		//Turn off randomization for var1
		f.var1.rand_mode(0);

		//Turn off randomization for all rand variable in MyClass
		f.rand_mode(0);

		if (f.var1,randmode())
			$display("Randomization of var1 enabled");
		else
			$display("Randomization of var1 failed");

		f.randomize();

		$display("After randomization var1 = %0d, var2 = %0d", f.var1, f.var2);
	end
endmodule