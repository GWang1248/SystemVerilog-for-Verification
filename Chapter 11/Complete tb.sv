`timescale 1ns/1ps
`define TxPorts 4
`define RxPorts 4
`define SV_RAND_CHECK(r) \
	do begin \
		if (!(r)) begin \
			$display("%s: %0d: Randomization failed \"%s\"", \
			`__FILE__, `__LINE__, `"r`");\
			$finish;\
		end \
	end while (0)

// Test load control information into ATM switch
interface cpu_ifc;
    logic BusMode, Sel, Rd_DS, Wr_RW, Rdy_Dtack;
    logic [11:0] Addr;
    CellCfgType DataIn, DataOut;

    modport Peripheral (input BusMode, Addr, Sel, DataIn, Rd_DS, Wr_RW,
                        output DataOut, Rdy_Dtack);

    modport Test (output BusMode, Addr, Sel, DataIn, Rd_DS, Wr_RW,
                input, DataOut, Rdy_Dtack);

endinterface: cpu_ifc

typedef struct packed {
    bit [`TxPorts - 1:0] FWD;
    bit [11:0] VPI;
} CellCfgTpe;

typedef virtual cpu_ifc.Test vCPU_T;

// Included the port from design and test, as well as clocking block
interface Utopia #(IfWidth = 8);

    logic [IfWidth - 1:0] data;
    bit clk_in, clk_out;
    bit soc, en, clav, valid, ready, reset, selected;

    ATMCellType ATMcell;

    modport TopReceive (
        input data, soc, clav,
        output clk_in, reset, ready, clk_out, en, ATMcell, data, soc, en, valid, reset, ready
    );

    modport CoreReceive (
        input clk_in, data, soc, clav, ready, reset,
        output clk_out, en, ATMcell, valid
    );

    modport CoreTransmit (
        input clk_in, clav, ATMcell, valid, reset,
        output clk_out, data, soc, en, ready
    );

    clocking cbr @(negedge clk_out);
        input clk_in, clk_out, ATMcell, valid, reset, en, ready;
        output data, soc, clav;
    endclocking: cbr
    modport TB_Rx (clocking cbr);

    clocking cbt @(negedge clk_out);
        input clk_out, clk_in, ATMcell, soc, en, valid, reset, data, ready;
        output clav;
    endclocking: cbt
    modport TB_Tx (clocking cbt);

endinterface

typedef virtual Utopia vUtopia;
typedef virtual Utopia.TB_Rx vUtopiaRx;
typedef virtual Utopia.TB_Tx vUtopiaTx;

// Included every module in layered tb
// It also generate random config; build tb env; run the test and wait for it to complete, also a wrapup to generate report

class Config;
    int nErrors, nWarnings;
    bit [31:0] numRx, numTx; //Copy of Param

    rand bit[31:0] nCells; //Total Cells
    constraint c_nCells_valid {nCells > 0;}
    constraint c_nCells_reasonable {nCells < 1000;}

    rand bit in_use_Rx[]; // Number of input/output Channel enabled
    constraint c_in_use_valid {in_use_Rx.sum();}

    rand bit [31:0] cells_per_chan[];
    constraint c_sum_ncells_sum {cells_per_chan.sum() == nCells;} // Spit cells over channles

    //Set the cell count to 0 for the unused channels
    constraint zero_unused_channels {
        foreach(cells_per_chan[i])
        {
            solve in_use_Rx[i] before cells_per_chan[i];
            if (in_use_Rx[i])
                cells_per_chan[i] inside {[1:nCells]};
            else cells_per_chan[i] == 0;
        }
    }

    extern function new(input bit [31:0] numRx, numTx);
    extern function virtual function void display(input string prefix="");
endclass: Config

class Scb_Driver_cbs extends Driver_cbs;
    Scoreboard scb;

    function new(input Scoreboard scb);
        this.scb = scb;
    endfunction: new

    // Send received cell to scb
    virtual task post_tx(input Driver drv, input UNI_cell c);
        scb.save_expected(c);
    endtask: post_tx
endclass: Scb_Driver_cbs

class Scb_Monitor_cbs extends Monitor_cbs;
    Scoreboard scb;

    function new(input Scoreboard scb);
        this.scb = scb;
    endfunction: new

    // Send received cell to scb
    virtual task post_rx(input Monitor mon, input NNI_cell c);
        scb.check_actual(c, mon.PortID);
    endtask: post_rx
endclass: Scb_Monitor_cbs

class Cov_Monitor_cbs extends Monitor_cbs;
    Coverage cov;

    function new(input Coverage cov);
        this.cov = cov;
    endfunction: new

    // Send received cell to cov
    virtual task post_rx(input Monitor mon, input NNI_cell c);
        cov.sample(mon.PortID, CellCfg.FWD);
    endtask: post_rx
endclass: Cov_Monitor_cbs

class Environment;
    UNI_generator gen[];
    mailbox gen2drv[];
    event drv2gen[];
    Driver drv[];
    Monitor mon[];
    Config cfg;
    Scoreboard scb;
    Coverage cov;
    virtual Utopia.TB_Rx Rx[];
    virtual Utopia.TB_Tx Tx[];
    int numRx, numTx;
    vCPU_T mif;
    CPU_driver cpu;

    extern function new(input vUtopia Rx[], input vUtopia Tx[], input int numRx, numTx, input vCPU_T mif);
    extern virtual function void gen_cfg();
    extern virtual function void build();
    extern virtual task run();
    extern virtual function void wrap_up();
endclass: Environment


//Construct an environment instance
function Environment::new(input vUtopia Rx[], input vUtopia Tx[], input int numRx, numTx, input vCPU_T mif);
    this.Rx = new[Rx.size()];
    foreach (Rx[i]) this.Rx[i] = Rx[i];
    this.Tx = new[Tx.size()];
    foreach (Tx[i]) this.Tx[i] = Tx[i];
    this.numRx = numRx;
    this.numTx = numTx;
    this.mif = mif;
    cfg = new(numRx, numTx);

    if ($test$plusargs("ntb_random_seed = %d")) begin
        int seed;
        $value$plusargs("ntb_random_seed = %d", seed); //look for VCS Switch to generate a random seed, and valueplusargs will withdraw it
        $display("Simulation run with random seed = %0d", seed);
    end
    else
        $display("Simulation run with default seed");
endfunction: new

//Randomize the config desc
function void Environment::gen_cfg();
    `SV_RAND_CHECK(cfg.randomize());
    cfg.display();
endfunction: gen_cfg

//Build the env object for this test only
function void Environment::build();
    cpu = new(mif, cfg);
    gen = new[numRx];
    drv = new[numRx];
    gen2drv = new[numRx];
    drv2gen = new[numRx];
    scb = new(cfg);
    cov = new();

    foreach(gen[i]) begin
        gen2drv[i] = new();
        gen[i] = new(gen2drv[i], drv2gen[i], cfg.cells_per_chan[i], i);
    end

    //Build Monitor
    mon = new[numTx];
    foeach(mon[i])
        mon[i] = new(Tx[i], i);

    //Connect sb to driver and monitor with callback
    begin
        Scb_Driver_cbs sdc = new(scb);
        Scb_Monitor_cbs smc = new(scb);
        foreach(drv[i]) drv[i].cbsq.push_back(sdc);
        foreach(mon[i]) mon[i].cbsq.push_back(smc);
    end

    //Connect coverage to monitor with callback
    begin
        Cov_Monitor_cbs smc = new(cov);
        foreach(mon[i])
            mon[i].cbsq.push_back(smc);
    end

endfunction: build

//Start the transactors
task Environment::run();
    int num_gen_running;

    cpu.run();

    num_gen_running = numRx;

    foreach(gen[i]) begin
        int j = i;
        fork
            begin
                if (cfg.in_use_Rx[j])
                    gen[j].run; //Wait for generator to finish
                num_gen_running--; //Decrement driver count
            end
            if (cfg.in_use_Rx[j]) drv[j].run();
        join_none
    end

    //For each output TX, start monitor module
    foreach(mon[i]) begin
        int j = 1;
        fork
            mon[j].run();
        join_none
    end

    //Wait for all generators to finish and then proceed
    fork:timeout_block
        wait (num_gen_running == 0)
        begin
            repeat (1_000_000) @(Rx[0].cbr);
            $display("@%0t: %m ERROR: Generator timeout", $time);
            cfg.nErrors++;
        end
    join_any
    disable timeout_block;

    repeat (1_000) @(Rx[0].cbr);
endtask: run

// Report
function void Environment::wrap_up();
    $display("@%0t: End of sim, %0d errors, %0d warnings", $time, cfg.nErrors, cfg.nWarnings);
    scb.wrap_up();
endfunction

// Test module passes signals and interfaces through portlist, actual code is in the down below interfaces and duts
program automatic test;
    #(parameter int NumRx = 4, parameter int NumTx = 4) (Utopia.TB_Rx Rx[0:NumRx - 1],
                                                        Utopia.TB_Tx Tx[0:NumTx - 1],
                                                        cpu_ifc.Test mif,
                                                        input logic rst);

    Environment env;

    initial begin
        env = new(Rx, Tx, NumRx, NumTx, mif);
        env.gen_cfg();
        env.build();
        env.run();
        env.wrap_up();
    end
endprogram

// Top level module defines real signals
module top;
    parameter int NumRx = `RxPorts;
    parameter int NumTx = `TxPorts;

    logic rst, clk;

    initial begin
        rst = 0; clk = 0;
        #5ns rst = 1;
        #5ns clk = 1;
        #5ns rst = 0; clk = 0;
        forever
            #5ns clk = ~clk;
    end

    Utopia Rx[0:NumRx - 1] (); // NumRx Utopia Interface
    Utopia Tx[0:NumTx - 1] (); // NumTx Utopia Interface
    cpu_ifc mif(); // Utopia management Interface
    squat #(NumRx, NumTx) squat (Rx, Tx, mif, rst, clk); // DUT
    test #(NumRx, NumTx) t1(Rx, Tx, mif, rst);// Test
endmodule: top