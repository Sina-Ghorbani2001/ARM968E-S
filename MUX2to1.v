module MUX2to1 #(
    parameter DATA_LEN = 32
) (
    input   wire [DATA_LEN - 1 : 0]              data_in1, data_in0,
    input   wire                                 sel,
    output  wire [DATA_LEN - 1 : 0]              data_out
);

    assign data_out = (sel) ? data_in1 : data_in0;
    
endmodule