
module RegisterFile #(
    parameter   ADDRESS_LEN = 4,
    parameter   SIZE = 15,
    parameter   DATA_LEN = 32
) (
    input  wire                         clk, rst,
    input  wire [ADDRESS_LEN - 1 : 0]   src1, src2, Dest_wb,
    input  wire [DATA_LEN - 1 : 0]      Result_wb,
    input  wire                         writeBackEn,
    output wire [DATA_LEN - 1 : 0]      reg1, reg2
);

    reg     [DATA_LEN - 1 : 0]  registers   [0 : SIZE - 1];

    assign reg1 = registers[src1];
    assign reg2 = registers[src2];

    integer i;
    always @(negedge clk or negedge rst) begin
        if(~rst) begin
            for(i = 0 ; i < SIZE; i = i + 1)
                registers[i] <= i;
        end
        else begin
            if(writeBackEn) begin
                registers[Dest_wb] <= Result_wb;
            end
        end
    end
    
endmodule