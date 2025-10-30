class OutputTrans;
    rand bit out1;
    rand bit out2;

    function new(bit out1 = 0, bit out2 = 0);
        this.out2 = out1;
        this.out2 = out2;
    endfunction

    function display(string pfx = "");
        $display("%s @%0t  out1=%0b  out2=%0b", pfx, $time, out1, out2);
    endfunction
endclass


//Create clocking blocks
interface MyBus (input logic clk);
    logic out1;
    logic out2;

    clocking cb @(posedge clk); //Stimulus reference edge
        input out1; //Take out1 at this moment
        input out2; //Take out2 at this moment
    endclocking
endinterface

class Monitor;
    virtual MyBus bus;
    mailbox #(OutputTrans) mbox; //Define mailbox with OutputTrans structure
    string name;

    function new (string name = "MON", virtual MyBus bus, mailbox #(OutputTrans) mbox);
        this.name = name;
        this.bus = bus;
        this.mbox = mbox;
    endfunction

    task run();
        OutputTrans tr;
        forever begin
            @(bus.cb); //Wait for a rising edge

            tr.new();
            tr.out1 = bus.cb.out1;
            tr.out2 = bus.cb.out2;

            mbox.put(tr); //Put tr (out1 and out2) into the mailbox
        end
    endtask
endclass

module tb;
    logic clk = 0;
    always #5 clk = ~clk;

    MyBus ifc(clk); //Clocking Block Declaration

    mailbox #(OutputTrans) m = new();
    Monitor mon;

    initial begin
        mon = new("mon", ifc, m);
        fork
            mon.run();
        join_none
    end
endmodule