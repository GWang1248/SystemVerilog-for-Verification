//implication constraint
class MyClass1;
	rand bit [3:0] mode;
	rand bit mod_en;

	//If 5 <= mode <= 11, then mod_en = 1
	constraint c_mode { mode inside {[4'h5:4'hB]} -> mod_en == 1; }
	//constraint c_mode { (mode == 1) <-> (mod_en == 1); }
endclass

//if-else constraint
class MyClass2;
	rand bit [3:0] mode;
	rand bit mod_en;

	constraint c_mode {
		if (mode inside {[4'h5:4'hB]})
			mod_en == 1;
		else {
			if (mode == 4'h1) {
				mod_en == 1;
			}
			else {
				mod_en == 0;
			}
		}
	}
endclass

module tb;
	initial begin
		MyClass1 abc = new;
		for (int i = 0; i < 10; i++) begin
			abc.randomize();
			$display ("mode=0x%0h mod_en=0x%0h", abc.mode, abc.mod_en);
		end
	end
endmodule