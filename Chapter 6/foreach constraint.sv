class Packet;
    rand bit [3:0] darray[];
    rand bit [3:0] queue [$];

    //Constraint size of Q
    constraint c_qsize { queue.size() == 5; }
    //Constraint element of Q and A
    constraint c_array {
        foreach (darray[i])
            darray[i] == i;
        foreach (queue[i])
            queue[i] == i + 1;
    }

    //Assign size to the array
    function new ();
        daaray = new[5];
    endfunction
endclass

module tb;

    initial begin
        Packet pkt = new();
        pkt.randomize();
        $display("array = %p queue = %p", pkt.array, pkt.queue);
    end
endmodule