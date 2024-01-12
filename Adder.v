module Adder #(
    parameter DATA_LEN = 32
) (
    input  wire [DATA_LEN - 1 : 0] data_in1, data_in2,
    output wire [DATA_LEN - 1 : 0] data_out
);

    assign data_out = data_in1 + data_in2;
    
endmodule