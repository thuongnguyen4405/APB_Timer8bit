class count_down_test extends base_test;
    randc bit [1:0] rd_addr;

    constraint c_addr {
        rd_addr inside {2'b00, 2'b01};
    }

    virtual task run_scenario();
        bit [7:0] rdata;

        // Directed count-down control.
        write(8'h00, 8'h03);
        repeat (2) begin
            assert (this.randomize())
                else $fatal(1, "Randomize failed");
            read({6'h00, rd_addr}, rdata);
            $display("[DOWN] Read addr=%h data=%h", rd_addr, rdata);
        end
    endtask
endclass
