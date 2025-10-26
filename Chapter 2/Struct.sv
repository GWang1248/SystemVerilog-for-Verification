//Create packed struct
typedef struct packed {
	bit [4] mode;
	bit [3] cfg;
	bit		en;
} st_ctrl;

module struct;

	st_ctrl ctrl_reg;

	initial begin
		//Initialize packed struct
		ctrl_reg = '{4'ha, 3'h5, 1};
		$display("ctrl_reg = %p", ctrl_reg);

		//Change the value of a member in struct
		ctrl_reg.mode = 4'h3;
		$display("ctrl_reg = %p", ctrl_reg);

		//Assign a packed value to the struct
		ctrl_reg = 8'hfa;
		$display("ctrl_reg = %p", ctrl_reg);
	end

endmodule