class Item;
	rand bit [7:0] id;

	constrain c_id { id < 25; }
endclass

module tb;
	initial begin
		Item item = new();
		item.randomize() with {id == 10};
		$display("Item id = %0d", item.id);
	end
endmodule