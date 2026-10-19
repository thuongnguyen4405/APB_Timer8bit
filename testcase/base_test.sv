class base_test;
    environment env;
    virtual dut_if dut_vif;

    function new();
    endfunction

    function void build();
        env = new(dut_vif);
        env.build();
    endfunction

    task write(bit [7:0] addr, bit [7:0] data);
        packet pkt = new();
        pkt.addr = addr[1:0];
        pkt.data = data;
        pkt.transfer = packet::WRITE;
        env.stim.send_pkt(pkt);
        @(env.drv.xfer_done);
    endtask

    task read(bit [7:0] addr, ref bit [7:0] data);
        packet pkt = new();
        pkt.addr = addr[1:0];
        pkt.transfer = packet::READ;
        env.stim.send_pkt(pkt);
        @(env.drv.xfer_done);
        data = pkt.data;
    endtask

    virtual task run_scenario();
    endtask

    task run_test();
        build();
        fork
            env.run();
            run_scenario();
        join_any
        disable fork;
        $display("%0t: [base_test] End simulation", $time);
        $finish;
    endtask
endclass
