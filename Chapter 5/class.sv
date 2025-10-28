class myPacket;
	bit [2:0] header;
	bit encode;
	bit [2:0] mode;
	bit [7:0] data;
	bit stop;

	//function new is called automatically upon creation of the object
	function new (bit [2:0] header = 3'h1, bit [2:0] mode = 5);
		//"this" indicates to assign the local variable "header" to the class variable "header"
		this.header = header;
		this.encode = 0;
		this.mode = mode;
		this.stop = 1;
	endfunction

	function display ();
		$display ("Header = 0x%0h, Encode = %0b, Mode = 0x%0h, Stop = %0b", this.header, this.encode, this.mode, this.stop);
	endfunction
endclass

class networkPkt extends myPacket;
	bit parity;
	bit [1:0] crc;

	function new();
		super.new();
		this.parity = 1;
		this.crc = 3;
	endfunction

	function display();
		super.display();
		$display ("Parity = %0b, CRC = 0x%0h", this.parity, this.crc);
	endfunction
endclass

module tb;

	//Declare an object exist for this class
	myPacket pkt0, pkt1;

	initial begin
		//Allocate a new object with class pkt (with a handle)
		pkt0 = new(3'h2, 2'h3);
		pkt0.display();

		pkt1 = new();
		pkt1.display();
	end
endmodule