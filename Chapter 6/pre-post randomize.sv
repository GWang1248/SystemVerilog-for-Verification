class Packet;
	rand bit [7:0] id;

	constraint c_id {id >= 10; id <= 50;}

	//Display before randomization
	function void pre_randomize();
		$display("This will be called just before randomization");
	endfunction

	//Display after randomization
	function void post_randomize();
		$display("This will be called after randomization");
	endfunction
endclass

module tb;
	Packet pkt = new();
	$display("Initial id = %0d", pkt.id);
	if (pkt.randomize())
		$display("Randomization successful !");
	$display("After randomization id = %0d", pkt.id);
endmodule