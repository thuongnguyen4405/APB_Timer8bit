// Coverage collector. Does NOT implement a full reference-model data checker.
class scoreboard;
    mailbox #(packet) m2s_mb;
    bit en_fc = 1;

    `include "coverage.sv"

    function new(mailbox #(packet) m2s_mb);
        this.m2s_mb = m2s_mb;
        APB_GROUP = new();
    endfunction

    task run();
        packet pkt;
        forever begin
            m2s_mb.get(pkt);
            $display("%0t: [scoreboard] Received %s addr=%h data=%h",
                     $time, pkt.transfer.name(), pkt.addr, pkt.data);
            if (en_fc)
                sample_apb_fc(pkt);
        end
    endtask

    function void sample_apb_fc(packet trans);
        apb_trans = trans;
        APB_GROUP.sample();
    endfunction
endclass
