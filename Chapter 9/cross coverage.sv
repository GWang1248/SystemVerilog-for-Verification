covergroup masater_slave_interaction @(posedge clk);
    master_id_cp: coverpoint master_id {
        bins master0 = {0};
        bins master1 = {1};
        bins master2 = {2};
        bins master3 = {3};
    }
    slave_id_cp: coverpoint slave_id {
        bins slave0 = {0};
        bins slave1 = {1};
        bins slave2 = {2};
        bins slave3 = {3};
    }

    //Calculate coverage for master-slave combinations: 4x4 = 16
    ms_cross: cross master_id_cp, slave_id_cp {
        bins master0_slave1 = binsof(master_id_cp.master0) && binsof(slave_id_cp.slave1); //Check specifically for m0s1
        bins any_master_slave3 = binsof(master_id_cp) intersect binsof(slave_id_cp.slave3); //Check specifically for mxs3
        //intersect == &&
        illegal_bins bad_master_slave_config = binsof(master_id_cp.master0) && binsof(slave_id_cp.slave0); // Master 0 should not talk to Slave 0
        ignore_bins unused_master_slave_combo = binsof(master_id_cp.master3) && binsof(slave_id_cp.slave2); // Valid, but not critical to cover
    }
endgroup