module test(PAddr, PWrite, PSel, PWData, PEnable, rst, clk); //Post Declarations

	task write(reg [15:0] addr, reg [31:0] data); //Task to drive APB Pin

		@(posedge clk) //Drive Control Bus
			PAddr <= 16'h50;
			PWData <= 32'h50;
			PWrite <= 1'b1;
			PSel <= 1'b1;

		@(posedge clk) //Toggle on PEnable
			PEnable <= 1'b1;
		@(posedge clk) //Toggle off PEnable
			PEnable <= 1'b0;
	endtask

	inital begin
		//Drive Reset for Once
		reset(); //Reset
		write(16'h50, 32'h50); //Check data in task

		if (top.mem.memory[16'h50] == 32'h50) //Result Checking
			$display("Success");
		else
			$display("Error, wrong in memory");
		$finish;
	end
endmodule