// Included INSIDE class scoreboard (see scoreboard.sv).
// Coverage model reconstructed from user screenshots.
packet apb_trans;

covergroup APB_GROUP;
    option.per_instance = 1;

    apb_transfer: coverpoint apb_trans.transfer {
        bins apb_read  = {packet::READ};
        bins apb_write = {packet::WRITE};
    }

    apb_address: coverpoint apb_trans.addr {
        bins CCR_addr = {2'b00};
        bins CDR_addr = {2'b01};
    }

    apb_data: coverpoint apb_trans.data
        iff (apb_trans.transfer == packet::WRITE) {
        bins count_up   = {8'h01};
        bins count_down = {8'h03};
        bins data_value = {8'd100};
    }

    apb_transaction: cross apb_transfer, apb_address;

    count_up_feature: cross apb_transfer, apb_address, apb_data {
        bins write_ccr_up =
            binsof(apb_transfer.apb_write) &&
            binsof(apb_address.CCR_addr) &&
            binsof(apb_data.count_up);
        ignore_bins unrelated =
            binsof(apb_transfer.apb_read) ||
            binsof(apb_address.CDR_addr) ||
            binsof(apb_data.count_down) ||
            binsof(apb_data.data_value);
    }

    count_down_feature: cross apb_transfer, apb_address, apb_data {
        bins write_ccr_down =
            binsof(apb_transfer.apb_write) &&
            binsof(apb_address.CCR_addr) &&
            binsof(apb_data.count_down);
        ignore_bins unrelated =
            binsof(apb_transfer.apb_read) ||
            binsof(apb_address.CDR_addr) ||
            binsof(apb_data.count_up) ||
            binsof(apb_data.data_value);
    }

    counter_with_data_feature: cross apb_transfer, apb_address, apb_data {
        bins write_cdr_data =
            binsof(apb_transfer.apb_write) &&
            binsof(apb_address.CDR_addr) &&
            binsof(apb_data.data_value);
        ignore_bins unrelated =
            binsof(apb_transfer.apb_read) ||
            binsof(apb_address.CCR_addr) ||
            binsof(apb_data.count_up) ||
            binsof(apb_data.count_down);
    }
endgroup
