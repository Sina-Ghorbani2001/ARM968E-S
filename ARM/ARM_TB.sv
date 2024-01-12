`timescale 1ns/1ns

module ARM_TB (

);
    reg clk = 0, rst = 1;
    localparam DATA_LEN = 32;
    localparam ADDRESS_LEN = 32;
    localparam ADDRESS_LEN_REG_FILE = 4;
    localparam SIZE_REG_FILE = 15;

    ARM #(
        .DATA_LEN(DATA_LEN),
        .ADDRESS_LEN(ADDRESS_LEN),
        .ADDRESS_LEN_REG_FILE(ADDRESS_LEN_REG_FILE),
        .SIZE_REG_FILE(SIZE_REG_FILE)
    ) ARM(
        .clk(clk),
        .rst(rst)
    );

    always #10 clk = ~clk;

    initial begin
        #1 rst = 0;
        #5 rst = 1;
        for (int i = 0 ; i < 50 ; i = i + 1 ) begin
            @(posedge clk);
        end
        rst = 0;
        #5 rst = 1; 
        #100 $stop;
    end
    
endmodule