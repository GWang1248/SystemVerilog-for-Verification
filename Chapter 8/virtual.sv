class Packet;
	int addr;

	function new (int addr);
		this.addr = addr;
	endfunction

	virtual function void display();
		$display("[Base] addr=0x%0h", addr);
	endfunction
endclass

//Create child class based on parent class Packet
class ExtPacket extends Packet;
	int data;

	function new(int addr, data);
		super.new(addr); //Calls the new function in parent class to reach this.addr = addr
		this.data = data;
	endfunction

	function display();
		$display ("[Child] addr=0x%0h data=0x%0h", addr, data);
	endfunction
endclass

module tb;
	Packet bc;
	ExtPacket sc;

	initial begin
		sc = new(32'hfeed_feed, 32'h1234_5678);

		if ($cast(sc, bc))
			$display("Cast Success");
			
		bc = sc; //Switch from base to child by =
		bc.display();
	end
endmodule