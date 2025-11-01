module tb;

    //Declare sample variable to be tested
    bit [1:0] mode;
    bit [2:0] cfg;

    bit clk;
    always #20 clk = ~clk;

    //Define a covergroup that is sampled at every posedge
    covergroup cg @(posedge clk);
        coverpoint mode;
    endgroup

    //Initiate
    cg cg_inst;

    //Assign random values to two variables
    initial begin
        cg_inst = new();

        for (int i = 0; i < 5; i++) begin
            @(negedge clk);
            mode = $random;
            cfg = $random;
            $display("[%0t] mode = 0x%0h cgf = 0x%0h",$time, mode, cfg);
        end
    end

    //At the end of 500ns, print out coverage
    initial begin
        #500 $display ("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
        $finish;
    end
endmodule