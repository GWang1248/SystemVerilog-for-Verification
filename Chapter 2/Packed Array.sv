module packed_array;

	bit [4][8] md; //Define MDPA

	initial begin
		md = 32'hface_cafe; //Assign Value

		$display("md = 0x%0h", md);

		for (int i = 0; i < $size(md); i++) //Iterate through segment of MDA and print out value
			$display("md[%0d] = %b (0x%0h)", i, md[i], md[i])
	end

endmodule