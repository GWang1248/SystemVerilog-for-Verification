`timescale 1ns/1ps

//Declare Memtrans Class
class MemTrans;
	logic [7:0] data_in;
	logic [3:0] addr;

	static logic [3:0] last_addr;

	//Function constructor that initialize the default value of data and addr to 0
	function new (logic [7:0] data_in = 8'h0, logic [3:0] addr = 8'h0);
		this.data_in = data_in;
		this.addr = addr;

		//Update static variable with current object handle
		MemTrans::last_addr = addr;
		//Equals to "last_addr = addr" as it is inside the class definition
		//Only use MemTrans::last_addr = addr iff outside of class scope
	endfunction

	static function print_last_address ();
		$display("Static last_address = %0h", last_addr);
	endfunction

	function display();
		$display("----------------------------------------");
        $display("		Memory Transaction Details:		");
        $display("  data_in : 0x%0h (%0d)", data_in, data_in);
        $display("  address : 0x%0h (%0d)", address, address);
        $display("----------------------------------------");
	endfunction
endclass

module tb;
	Memtrans t1, t2;

	initial begin
		t1 = new.(.addr(4'h2));
		t2 = new.(data_in(8'd3), .addr(4'h4));

		//Assign new address value to t1 object
		t1.addr = 4'hF;

		t1.display();
		t2.display();

		$display("\n=== Using Static Method ===");
		MemTrans::print_last_address(); //Dont need to point out t1 or t2 as last_address is static

		//Deallocate the object and check
		t2 = null;
		$display("t2 deallocated");
		if (t2 == NULL)
			$display("t2 deallocated successfully");
		#10 $finish;
	end
endmodule