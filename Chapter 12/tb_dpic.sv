module tb_shift_dpi;

    // Import C Function
    import "DPI-C" context function chandle shift_new_init(input int unsigned init_val);
    import "DPI-C" context function void shift_free(input chandle h);
    import "DPI-C" function int unsigned shift_c_init(input chandle h, input int unsigned i, input int n, input bit ld);

    chandle h1, h2;
    int unsigned r;

    initial begin
        $display("SV Test Start");

        h1 = shift_new_init(32'hDEAD_BEEF);
        h2 = shift_new_init(32'h0000_00F0);

        r = shift_c(h1, 32'h0000_0000, -8, 1'b0);
        $display("[SV] h1 call 1 => %08h", r);
        r = shift_c(h1, 32'h0000_0001, 3, 1'b1);
        $display("[SV] h1 call 2 => %08h", r);

        r = shift_c(h2, 32'h0000_0000, 4, 1'b0);
        $display("[SV] h2 call 1 => %08h", r);
        r = shift_c(h2, 32'ha5a5_a5a5, 4, 1'b1);
        $display("[SV] h2 call 2 => %08h", r);

        shift_free(h1);
        shift_free(h2);

        $display("SV Test End");
        $finish;
    end
endmodule