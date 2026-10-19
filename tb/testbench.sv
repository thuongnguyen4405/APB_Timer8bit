`timescale 1ns/1ps
module testbench;
    import test_pkg::*;

    dut_if d_if();

    basic_counter u_dut (
        .pclk(d_if.pclk),
        .presetn(d_if.presetn),
        .psel(d_if.psel),
        .penable(d_if.penable),
        .pwrite(d_if.pwrite),
        .paddr(d_if.paddr),
        .pwdata(d_if.pwdata),
        .prdata(d_if.prdata),
        .pready(d_if.pready),
        .intr(d_if.intr)
    );

    wire [7:0] internal_count = u_dut.u_counter.count;

    initial begin
        d_if.presetn = 0;
        #100ns d_if.presetn = 1;
    end

    initial begin
        d_if.pclk = 0;
        forever #10ns d_if.pclk = ~d_if.pclk;
    end

    initial begin
        #1ms;
        $fatal(1, "[testbench] Timeout: testbench may be stuck");
    end

    base_test base;
    count_up_test up;
    count_down_test down;
    count_up_with_data_test up_data;
    count_down_with_data_test down_data;

    initial begin
        base = new();
        if ($test$plusargs("count_up_test")) begin
            up = new();
            base = up;
        end else if ($test$plusargs("count_down_test")) begin
            down = new();
            base = down;
        end else if ($test$plusargs("count_up_with_data_test")) begin
            up_data = new();
            base = up_data;
        end else if ($test$plusargs("count_down_with_data_test")) begin
            down_data = new();
            base = down_data;
        end else begin
            $display("[testbench] No plusarg selected; default base_test only.");
        end
        base.dut_vif = d_if;
        base.run_test();
    end
endmodule
