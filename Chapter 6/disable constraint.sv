class MyClass;
	rand bit [3:0] sum;

	constraint c_num {
		num > 4;
		num < 9;
	}

endclass

module tb;
	initial begin
		MyClass f = new;
		$display ("Before randomization num = %0d", f.num);

		//Disable constraint
		f.c_num.constrain_mode(0);

		//Enable constraint
		f.c_num.constrain_mode(1);

		if (f.c_num.constrain_mode())
			$display ("Constraint c_num is enabled");
    	else
      		$display ("Constraint c_num is disabled");
		
		f.randomize();

		$display ("After randomization num = %0d", f.num);
	end
endmodule