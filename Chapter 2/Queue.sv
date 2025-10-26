module queue;

	//Create string queue
	string   fruits[$] =  { "orange", "apple", "lemon", "kiwi" };

	initial begin
		//Select subset of queue
		$display ("Citrus Fruit = %p", fruits[1:2]);

		//Get elements from start to end
		$display ("Fruits = %p", fruits[1:$]);

		//Add element to the end
		fruits[$+1] = "pineapple";
		$display ("Fruits = %p", fruits);

		//Delete first element
		$display ("Remove Orange = %p", fruits[1:$]);

		//Delete last element
		fruits.insert (1, "orange");
		$display ("Remove Orange = %p", fruits[0:$-1]);
	end

endmodule