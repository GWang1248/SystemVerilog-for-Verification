//Randomizaition check macro
`define SV_RAND_CHECK(r) \
	do begin \
		if (!(r)) begin \
			$display("%s: %0d: Randomization failed \"%s\"", \
			`__FILE__, `__LINE__, `"r`");\
			$finish;\
		end \
	end while (0)

class Packet;
	rand bit [2:0] data;
	randc bit [2:0] addr;

	rand bit [3:0] d_array [];
	rand bit [3:0] queue [$];

	constraint c_array { d_array.size() > 5; d_array.size() < 10; }
	constraint c_queue { queue.size() == 4; }
	//Constraint value of array to be index itself
	constraint c_val {foreach (d_array[i]) d_array[i] == i;}

	function void display();
		$display ("d_array[%0d] = 0x%0h", i, d_array[i]);
	endfunction
endclass

module tb;
	initial begin
		Packet pkt = new();
		for (int i = 0; i < 10; i++) begin
			`SV_RAND_CHECK(pkt.randomize());
			$display("itr = %0d data = 0x0%h", i, pkt.data);
			$display("itr = %0d data = 0x0%h", i, pkt.addr);
		end
		pkt.display();
		$display("queue = %p", pkt.queue);
	end
endmodule