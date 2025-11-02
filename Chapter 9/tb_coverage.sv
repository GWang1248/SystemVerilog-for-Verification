//Define class
typedef enum { ADD, SUB, MULT, DIV } opcode_e;

//Transaction one operation
class Transaction;
    rand opcode_e opcode;
    rand byte     operand1;
    rand byte     operand2;
endclass

module tb;

    bit clk;
    initial clk = 0;
    always #5 clk = ~clk;

    Transaction tr;

    covergroup cg_opcode @(posedge clk);
        option.per_instance = 1;

        //Creates coverpoint only if tr is created
        opcode_cp: coverpoint tr.opcode iff (tr != null) {
            bins add_bin = {ADD};
            bins sub_bin = {SUB};
            bins mult_bin = {MULT};
            illegal_bins div_bin = {DIV}; //Illegal div bin
        }

        operand1_cp: coverpoint tr.operand1 iff (tr != null) {
            bins min = {-128};
            bins zero = {0};
            bins max = {127};
            bins other = default;
        }

        op_addsub_op1_when_extreme: cross opcode_cp, operand1_cp {
            option.weight = 5;

            bins add_min = binsof(opcode_cp.add_bin) && binsof(operand1_cp.min);
            bins add_max = binsof(opcode_cp.add_bin) && binsof(operand1_cp.max);
            bins sub_min = binsof(opcode_cp.sub_bin) && binsof(operand1_cp.min);
            bins sub_max = binsof(opcode_cp.sub_bin) && binsof(operand1_cp.max);

            ignore_bins other = binsof(opcode_cp.mult_bin) || binsof(opcode_cp) intersect {DIV} || binsof(operand1_cp.zero);
        }
    endgroup

    cg_opcode cov = new();

    initial begin
        tr = new();
        
        repeat (200) begin
            assert(tr.randomize() with {
                opcode dist {ADD := 1, SUB := 1, MULT := 1};
                operand1 dist { -128 := 6, 0 := 2, 127 := 6, [-127:-1] := 1, [1:126] := 1 };
            })
            else
                $fatal ("Randomize Failed");
            @(posedge clk);
        end

        #1;

        $display("[TB] Functional coverage = %0.2f%%", cov.get_inst_coverage());
        $display("[TB] operand1_cp   = %0.2f%%", cov.operand1_cp.get_inst_coverage());
        $display("[TB] op_addsub_x_op1_extreme = %0.2f%%", cov.op_addsub_op1_when_extreme.get_inst_coverage());
        $display("[TB] overall cg    = %0.2f%%", cov.get_inst_coverage());
        $finish;
    end

endmodule