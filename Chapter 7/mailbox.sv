//Create alias for string mailbox
typedef mailbox #(string) s_mbox;

class comp1;

	//Create mailbox handle to put item
	s_mbox names;

	task send();
		for (int i = 0; i < 3; i+) begin
			string s = $sformatf("name_%0d", i);
			#1 $display("[%0t] Comp1: Put %s", $time, s);
			names.put(s);
		end
	endtask
endclass

class comp2;

	//Create mailbox handle to receive item
	s_mbox list;

	//Loop that continuously get item from mailbox
	task receive();
		forever begin
			string s;
			list.get(s);
			$display("[%0t] Comp2: Got %s", $time, s);
		end
	endtask
endclass

module tb;

	//Declare a mailbox and two component object
	s_mbox m_mbx = new(); //Put in value inside to limit the size of a mailbox
	comp1 m_comp1 = new();
	comp2 m_comb2 = new();

	initial begin
		//Assign both object into one global mailbox
		m_comp1.names = m_mbx;
		m_comp2.list = m_mbx;

		//Start two object in parallel, one send and on receive
		fork
			m_comp1.send();
			m_comp2.receive();
		join
	end
endmodule

//put() to put data into mailbox
//get() to get data from mailbox
//try_put() to check if mailbox is full
//try_get() to check if mailbox is empty
//peek() to obtain a copy of data inside the mailbox