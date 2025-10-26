module dynamic_array;

	//Create dynamic Array
	int array[];

	initial begin
		//Truncate the dynamic array size to 5
		array = new[5];
		array = '{31, 67, 10, 4, 99};

		foreach (array[i])
			$display("array[%0d] = %0d", i, array[i]);
	end

endmodule