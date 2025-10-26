module array_locator;

	int array[9] = '{4, 7, 2, 5, 7, 1, 6, 3, 1};
	int res[$];

	initial begin
		res = array.min();
		$display("min	: %p", res);

		res = array.max();
		$display("max	: %p", res);

		res = array.unique();
		$display("unique	: %p", res);

		res = array.unique(x) with (x < 3);
		$display("unique	: %p", res);

		res = array.unique_index;
		$diaply("unique		: %p", res);
	end

endmodule