class Packet;
	rand bit [3:0] a;

	constraint c1 { a > 5; }
	static constraint c2 { a > 12; }
endclass

module tb;
	initial begin
		Packet pkt1 = new();
		Packet pkt2 = new();
		Packet pkt3 = new();

		pkt1.c1.constraint_mode(0);
		pkt2.c2.constraint_mode(0);

		for (int i = 0; i < 5; i++) begin
     		pkt1.randomize();
      		pkt2.randomize();
			pkt3.randomize();
      		$display ("pkt1.a = %0d, pkt2.a = %0d, pkt3.a = %0d", pkt1.a, pkt2.a, pkt3.a);
    	end
	end
endmodule