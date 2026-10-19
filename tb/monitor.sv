class monitor;
    mailbox #(packet) m2s_mb;
    virtual dut_if dut_vif;

    function new(virtual dut_if dut_vif, mailbox #(packet) m2s_mb);
        this.dut_vif = dut_vif;
        this.m2s_mb = m2s_mb;
    endfunction

    task run();
        packet pkt;
        forever begin
            @(posedge dut_vif.pclk);
            if (dut_vif.presetn && dut_vif.psel &&
                dut_vif.penable && dut_vif.pready) begin
                pkt = new();
                pkt.addr = dut_vif.paddr;
                pkt.transfer = dut_vif.pwrite ? packet::WRITE : packet::READ;
                pkt.data = dut_vif.pwrite ? dut_vif.pwdata : dut_vif.prdata;
                m2s_mb.put(pkt);
                $display("%0t: [monitor] Captured %s addr=%h data=%h",
                         $time, pkt.transfer.name(), pkt.addr, pkt.data);
            end
        end
    endtask
endclass
