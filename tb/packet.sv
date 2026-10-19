class packet;
    typedef enum bit {READ = 0, WRITE = 1} transfer_enum;
    bit [1:0] addr;
    bit [7:0] data;
    transfer_enum transfer;

    function new();
    endfunction
endclass
