interface dut_if (input bit clk);
    logic valid;
    logic [7:0] data;
endinterface

module dut (dut_if bus);
    always_ff @(posedge bus.clk) begin
        bus.valid <= ~bus.valid;
        bus.data <= bus.data + 8'b1;
    end
endmodule

class Instruction;
    int dummy;
endclass

class Driver;
    virtual dut_if vif;
    mailbox #(Instruction) agt2drv;
    function new(input mailbox #(Instruction) agt2drv, virtual dut_if vif);
        this.agt2drv = agt2drv;
        this.vif = vif;
    endfunction
endclass

class Environment;
    Driver drv;
    mailbox #(Instruction) agt2drv;
    virtual dut_if vif;

    function new(input virtual dut_if vif);
        this.vif = vif;
        agt2drv = new();
        drv = new(agt2drv, vif);
    endfunction
endclass

module tb;
    bit clk = 0;
    always #5 clk = ~clk;

    dut_if bus(clk);
    dut u_dut(bus);
    
    Environment env;

    initial begin

        env = new(bus);

        #100 $finish;
    end
endmodule