class BusTransaction;
	rand int addr;
	rand bit [31:0] data;
	rand bit [1:0] burst; //Size of a transaction
	rand bit [2:0] length; //Total number of transaction

	constraint c_addr { addr % 4 == 0; } //Always align to 4-byte boundary

	function void display(int idx = 0);
    	$display ("------ Transaction %0d------", idx);
    	$display (" Addr 	= 0x%0h", addr);
    	$display (" Data 	= 0x%0h", data);
    	$display (" Burst 	= %0d bytes/xfr", burst + 1);
    	$display (" Length  = %0d", length + 1);
  	endfunction
endclass

module tb;
	int slave_start;
	int slave_end;;

	//Target to randomize the slave with addr range from 200 to 800
	initial begin
		slave_start = 32'h200;
		slave_end = 32'h800;
		BusTransaction bt = new();

		bt.randomize() with {
			addr >= slave_start;
			addr < slave_end;
			(burst + 1) * length + addr < slave_end;
		};
		bt.display();
	end
endmodule