module ALU #(
    parameter DATA_LEN = 32
) (
    input  wire  [DATA_LEN - 1 : 0]  Val1,
    input  wire  [DATA_LEN - 1 : 0]  Val2,
    input  wire  [3 : 0]             EXE_CMD,
    input  wire                      carry_in,
    output reg   [DATA_LEN - 1 : 0]  ALU_Res,
    output reg                       carry_out,
    output wire                      Z, N,
    output reg                       V 
);

    always @(*) begin
        begin
            ALU_Res = 'b0;
            V = 0;
            carry_out = 0;
        end
        case (EXE_CMD)
            4'b0001: {carry_out, ALU_Res} = Val2;
            4'b0010: begin
                {carry_out, ALU_Res} = Val1 + Val2;
                V = ((ALU_Res[31] & ~Val1[31] & ~Val2[31]) | (~ALU_Res[31] & Val1[31] & Val2[31])) ? 1 : 0;
            end 
            4'b0011: begin
                {carry_out, ALU_Res} = Val1 + Val2 + carry_in;
                V = ((ALU_Res[31] & ~Val1[31] & ~Val2[31]) | (~ALU_Res[31] & Val1[31] & Val2[31])) ? 1 : 0;
            end  
            4'b0100: begin
                {carry_out, ALU_Res} = Val1 - Val2;
                V = ((ALU_Res[31] & ~Val1[31] & ~Val2[31]) | (~ALU_Res[31] & Val1[31] & Val2[31])) ? 1 : 0;
            end 
            4'b0101: begin
               {carry_out, ALU_Res} = Val1 - Val2 - {31'b0, (~carry_in)}; 
                V = ((ALU_Res[31] & ~Val1[31] & ~Val2[31]) | (~ALU_Res[31] & Val1[31] & Val2[31])) ? 1 : 0;
            end
            4'b0110: {carry_out, ALU_Res} = Val1 & Val2;
            4'b0111: {carry_out, ALU_Res} = Val1 | Val2;
            4'b1000: {carry_out, ALU_Res} = Val1 ^ Val2;
            4'b1001: {carry_out, ALU_Res} = ~{Val2};
            default: begin
                {carry_out, ALU_Res} = 'b0;
                V = 0;
            end
        endcase
    end

    assign Z = (ALU_Res == 'b0) ? 1 : 0;
    assign N = ALU_Res[DATA_LEN - 1];


    
endmodule