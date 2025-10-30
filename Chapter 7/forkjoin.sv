module tb;

	initial begin

		#1 $display ("[0%t ns] Start fork...", $time);

		fork
			#5 $display ("[0%t ns] Thread 1: Orange is named after orange", $time);

			begin
				#2 $display ("[0%t ns] Thread 2: Apple keeps the doctor away", $time);
				#4 $display ("[0%t ns] Thread 2: But not anymore", $time);
			end

			#10 $display ("[0%t ns] Thread 3: Banana is a good fruit", $time);
		join //join_any and join_none

		$display ("[0%t ns] After fork-join...", $time);
	end

endmodule