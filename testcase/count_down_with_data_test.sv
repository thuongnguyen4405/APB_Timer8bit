class count_down_with_data_test extends base_test;
    randc bit [1:0] rd_addr;

    constraint c_addr {
        rd_addr inside {2'b00, 2'b01};
    }

    virtual task run_scenario();
        bit [7:0] rdata;

        // Disable counter for configuration.
        write(8'h00, 8'h00);
        // Configure initial data = 100.
        write(8'h01, 8'd100);
        // Enable counter in down direction.
        write(8'h00, 8'h03);

        repeat (2) begin
            assert (this.randomize())
                else $fatal(1, "Randomize failed");
            read({6'h00, rd_addr}, rdata);
            $display("[DOWN_DATA] addr=%h data=%h", rd_addr, rdata);
        end
    endtask
endclass
