module tb;

	event event_a;

	//Triggers the event
	initial begin
		#20 -> event_a;
		$display("[%0t] Thread 1: triggered event_a", $time);
	end

	//Wait for event to be triggered
	initial begin
		$display("[%0t] Thread 2: waiting for trigger", $time);
		#20 @(event_a);
		$display("[%0t] Thread 2: triggered event_a", $time);
	end

	initial begin
		$display("[%0t] Thread 3: waiting for trigger", $time);
		wait(event_a.triggered);
		$display ("[%0t] Thread3: received event_a trigger", $time);
	end
endmodule