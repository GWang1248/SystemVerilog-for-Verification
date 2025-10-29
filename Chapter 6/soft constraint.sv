class Packet;
	rand bit [3:0] data;

	constraint c_data {
		soft data >= 4; //Soft Constraint
		data <= 12;
	}
endclass

module tb;
	initial begin
		Packet pkt = new();
		for (int i = 0; i < 5; i++) begin
			pkt.randomize() with { data == 2; }; //Added Hard Constraint
			$display("pkt = 0x%0h", pkt.data);
		end
	end
endmodule