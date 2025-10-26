module associative_array;

	int aa_array [int];

	initial begin
		int idx;

		//Initialize indices in mixed order
		aa_array[5] = 20;
		aa_array[8] = 10;
		aa_array[1] = 50;
		aa_array[2] = 100;

		//Find the smallest index whose value is greater than index
		aa_array.next(idx);
		$display("aa_array[%0d] = %0d", idx, aa_array[idx]);

		//Continue
		aa_array.next(idx);
    	$display("aa_array[%0d] = %0d", idx, aa_array[idx]);

		//Set index to 5 and find the largest index whose value is greater than index
		idx = 5;
		aa_array.prev(idx);
		$idsplay("aa_array[%0d] = %0d", idx, aa_array[idx]);
	end

endmodule