class count_up_test extends base_test;
    randc bit [1:0] rd_addr;

    constraint c_addr {
        rd_addr inside {2'b00, 2'b01};
    }

    virtual task run_scenario();
        bit [7:0] rdata;

        // Enable directed count-up.
        write(8'h00, 8'h01);
        // Two constrained-random APB read addresses.
        repeat (2) begin
            assert (this.randomize())
                else $fatal(1, "Randomize failed");
            read({6'h00, rd_addr}, rdata);
            $display("[UP] Read addr=%h data=%h", rd_addr, rdata);
        end
    endtask
endclass
