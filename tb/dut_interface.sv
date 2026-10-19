interface dut_if;
    logic       pclk;
    logic       presetn;
    logic       psel;
    logic       penable;
    logic       pwrite;
    logic [1:0] paddr;
    logic [7:0] pwdata;
    logic [7:0] prdata;
    logic       pready;
    logic       intr;
endinterface
