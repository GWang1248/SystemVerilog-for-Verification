class Header;
    int id;
    function new (int id);
        this.id = id;
    endfunction

    function showID();
        $display("id = 0x%0d", id);
    endfunction
endclass

class Packet;
    int addr;
    int data;
    Header hdr;

    function new (int addr, int data, int id);
        hdr = new (id);
        this.addr = addr;
        this.data = data;
    endfunction

    //Deepcopy
    function copy (Packet p);
        this.addr = p.addr;
        this.data = p.data;
        this.id = p.hdr.id;
    endfunction

    function display (string name);
        $display ("[%s] addr = 0x%0h data = 0x%0h id = %0d", name, addr, data, hdr.id);
    endfunction
endclass

module tb;
    Packet p1, p2;
    initial begin
        //Create new Packet object p1
        p1 = new(32'hface, 32'h1234_5678, 26);
        p1.display("p1");

        //Shallow copy p1 into p2
        p2 = new p1;
        ps.display("p2");

        p1.addr = 32'habcd_ef12;
        p1.data = 32'h5a5a_5a5a;
        p1.hdr.id = 17;
        p1.display("p1");

        //Print out p2 to see addr and data remain unchanged
        p2.display("p2");

        //Deep copy, original header will also be copies into p2
        p2 = new p1;
        p2.copy(p1);
        ps.display(p2);
    end
endmodule