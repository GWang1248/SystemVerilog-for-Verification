module tb_top;
	semaphore key;

	initial begin
		key = new(1); //Specify number of keys allocated to the bucket
		fork
			personA();
			personB();
			#25 personA();
		join_none
	end

	task getRoom (bit [1:0] id);
		$display("[%0t] Trying to get a room for id: [%0d] ...", $time, id);
		key.get(1); //Specify number of keys to obtain from the bucket
		$display("[%0t] Room Key retrieved for id[%0d]", $time, id);
	endtask

	task putRoom (bit [1:0] id);
		$display ("[%0t] Leaving room id[%0d] ...", $time, id);
		key.put(1); //Specify the number of keys being pput back to the bucket
		$display ("[%0t] Room Key put back id[%0d]", $time, id);
	endtask

	task personA();
		getRoom(1);
		#20 putRoom(1);
	endtask

	task personB();
		#5 getRoom(2);
		#10 putRoom(2);
	endtask

	//try_get: Get but lower priority, and will not unblock the process if conflict
endmodule