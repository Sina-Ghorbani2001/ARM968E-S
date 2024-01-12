module IF_Stage_Reg #(
    parameter DATA_LEN = 32,
    parameter ADDRESS_LEN = 32    
) (
    input wire          clk, rst, freeze, flush,
    input wire [31 : 0] PC_in, Instruction_in,
    output reg [31 : 0] PC, Instruction
);

    always @(posedge clk or negedge rst) begin
        if(~rst) begin
            PC <= 'b0;
            Instruction <= 'b0;
        end
        else begin
            if (flush) begin
                PC <= 'b0;
                Instruction <= 'b0;
            end
            else if (freeze) begin
                PC <= PC;
                Instruction <= Instruction;
            end
            else begin
                PC <= PC_in;
                Instruction <= Instruction_in;
            end

        end
        
    end
    
endmodule