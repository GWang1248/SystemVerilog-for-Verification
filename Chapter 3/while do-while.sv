module while;

	initial begin
		int cnt = 0;
		while (cnt < 5) begin
			$display("cnt = %0d", cnt);
			cnt++;
		end

		do begin
			$display("cnt = %0d", cnt);
			cnt++;
		end while (cnt < 10)
	end

endmodule