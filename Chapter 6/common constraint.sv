class MyClass;
	rand bit [3:0] mode;

	//Constraint the randomization between 2 and 6
	constraint c_mode {
		mode > 2;
		mode <= 6;
	}
endclass

//Inside Operator
class MyClass2;
	rand bit [31:0] c;
	bit [31:0] lo, hi;
	constraint c_range {c inside {[lo:hi]};} //lo <= c <= hi
	//constraint c_range {!(c inside {[lo:hi]})} //c < lo or c >hi
endclass

//Weighted Constraint
class MyClass3;
	rand bit [2:0] typ;
	constraint dist1 { typ dist { 0 := 20, [1:5] := 50, [6:7] :/ 50}; }
endclass

module tb;
	MyClass class1;

	initial begin
		//Create new object with this handle
		class1 = new();

		for (int i = 0; i < 5; i++) begin
			class1.randomization();
			$display("mode = 0x%0h", class1.mode);
		end
	end
endmodule