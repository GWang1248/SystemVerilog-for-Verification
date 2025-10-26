module typedef;

	typedef enum {RED, YELLOW, GREEN} elight;

	initial begin
		elight e_light = GREEN;
		alias light = e_light;

		$display("Light = %s", e_light.name());
	end

endmodule