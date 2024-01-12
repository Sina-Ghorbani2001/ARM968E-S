module WB_Stage_Reg #(
    parameter DATA_LEN = 32,
    parameter ADDRESS_LEN = 32    
) (
    input wire           clk, rst,
    input wire  [31 : 0] PC_in,
    output reg  [31 : 0] PC
);

    always @(posedge clk or negedge rst) begin
        if(~rst) begin
            PC <= 'b0;
        end
        else begin
            PC <= PC_in;
        end
        
    end
    
endmodule