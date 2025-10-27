module tb;

	initial begin
		int res, s;
		s = sum(5, 9);
		$display ("s = %0d", sum(5, 9));
      	$display ("sum(5, 9) = %0d", sum(5, 9));
      	$display ("mul(3, 1) = %0d", mul(3, 1, res));
      	$display ("res = %0d", res);
	end

	//Define functions with only return values on port
	function bit [7:0] sum;
		input int x, y;
		output sum;
		sum = x + y;
	endfunction

	//Define functions with input and return values on port
	function byte mul (input int x, y, output int res);
		res = x * y + 1;
		return x * y;
	endfunction

endmodule