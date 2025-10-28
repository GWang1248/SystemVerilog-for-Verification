//Static function cannot access non-static variable as it does not have "this" handle
//But if an object is explicitly input into the function then i is still viable to access the variable
class Packet;
    static int ctr = 0;

    function new();
        ctr++;
    endfunction

    static function get_ptk_ctr();
        $display("ctr = %0d", ctr);
    endfunction
endclass

module tb;
    Packet pkt[6];
    initial begin
        for (int i = 0; i < $size(pkt); i++) begin
            pkt[i] = new;
        end
        Packet::get_ptk_ctr(); //Static Function Call from outside
        pkt[5].get_ptk_ctr(); //Normal Function Call from object
    end
endmodule