`timescale 1ns/1ps

interface my_if (input logic clk);
    logic rst_n;
    logic [7:0] data_in;
    logic [7:0] data_out;

    clocking cb @(posedge clk);
        output data_in;
        input data_out;
    endclocking
endinterface

module dut (my_if intf);
    always_ff @(posedge intf.clk or negedge intf.rst_n) begin
        if (!intf.rst_n)
            intf.data_out <= 0;
        else
            intf.data_out <= intf.data_in + 1;
    end
endmodule

class Driver;
    virtual my_if vif;

    function new(virtula my_if vif);
        this.vif = vif;
    endfunction

    task drive();
        repeat (5) begin
            @(posedge vif.clk);
            vif.cb.data_in <= $urandom_range(0, 255);
            $display("[%0t][Driver] Send data_in = %0d", $time, vif.cb.data_in);
        end
    endtask
endclass

class Monitor;
    virtual my_if vif;

    function new(virtula my_if vif);
        this.vif = vif;
    endfunction

    task monitor();
        forever begin
            @(posedge vif.clk);
            $display("[%0t][Monitor] data_out = %0d", $time, vif.cb.data_out);
        end
    endtask
endclass

module tb;
    logic clk;
    my_if intf(clk); //Instantiate interface with real signals
    dut u_dut(.intf(intf));

    initial clk = 0;
    always #5 clk = ~clk;

    //Send interface towards the signal
    initial begin
        Driver drv = new(intf);
        Monitor mon = new(intf);

        intf.rst_n = 0;
        repeat(2) @(posedge clk);
        intf.rst_n = 1;

        fork
            drv.drive();
            mon.monitor();
        join_none

        #100 $finish;
    end
endmodule