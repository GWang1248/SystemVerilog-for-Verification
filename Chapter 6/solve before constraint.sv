class Packet;
	rand bit a;
	rand bit [1:0] b;

	constraint c_ab {
		a -> b == 3'h3;
		//Tells the solver that "a" has to be solved before "b"
		//Therefore b value depends on a
		//If a = 0, then b is randomized, if a = 1, then b = 3 only
		solve a before b;
	}
endclass

module tb;
	initial begin
		Packet pkt = new();
		for (int i = 0; i < 8; i++) begin
			pkt.randomize();
			$display("a = %0d, b = %0d", pkt.a, pkt.b);
		end
	end
endmodule