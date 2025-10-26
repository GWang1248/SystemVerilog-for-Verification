module array_initialization;

	int dst[2][3] = '{'{0, 1, 2}, '{3, 4, 5}}; //Initialize Array
	bit [8] src;

	initial begin
		$display("Initial Value: "); //Traverse the Array
		foreach (dst[i, j])
			$display("dst[%0d][%0d] = %0d", i, j, dst[i][j]);

		dst = '{'{9, 8, 7}, '{3{5}}}; //Reset Array Value and Traverse
		$display("New Value: ");
		foreach (dst[i, j])
			$display("dst[%0d][%0d] = %0d", i, j, dst[i][j]);

		for (int i = 0; i < $size(src); i++) //Initialize src array by for
			src[i] = i;
	end

endmodule