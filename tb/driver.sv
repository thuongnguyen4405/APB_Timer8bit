class driver;
    mailbox #(packet) s2d_mb;
    virtual dut_if dut_vif;
    event xfer_done;

    function new(virtual dut_if dut_vif, mailbox #(packet) s2d_mb);
        this.dut_vif = dut_vif;
        this.s2d_mb = s2d_mb;
    endfunction

    task run();
        packet pkt;
        dut_vif.psel = 0;
        dut_vif.penable = 0;
        dut_vif.pwrite = 0;
        dut_vif.paddr = 0;
        dut_vif.pwdata = 0;

        wait (dut_vif.presetn === 1'b1);
        forever begin
            s2d_mb.get(pkt);
            // Setup phase: drive on a falling edge to avoid a race with DUT.
            @(negedge dut_vif.pclk);
            dut_vif.psel = 1;
            dut_vif.penable = 0;
            dut_vif.pwrite = (pkt.transfer == packet::WRITE);
            dut_vif.paddr = pkt.addr;
            dut_vif.pwdata = pkt.data;

            // Access phase.
            @(negedge dut_vif.pclk);
            dut_vif.penable = 1;
            @(posedge dut_vif.pclk);
            #1; // sample read data after the clock edge settles
            if (pkt.transfer == packet::READ)
                pkt.data = dut_vif.prdata;

            @(negedge dut_vif.pclk);
            dut_vif.psel = 0;
            dut_vif.penable = 0;
            -> xfer_done;
            $display("%0t: [driver] Completed %s addr=%h data=%h",
                     $time, pkt.transfer.name(), pkt.addr, pkt.data);
        end
    endtask
endclass
