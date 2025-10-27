module tb;

	int md [5][2] = '{'{1, 2}, '{3, 4}, {5, 6}, '{7, 8}, '{9, 10}};

	initial begin
		//Iterate first dimension by i
		foreach (md[i])
			//Iterate each element in first dimension i by j
			foreach (md[i][j])
				$display("md[%0d][%0d] = %0d", i, j, md[i][j]);
	end
endmodule