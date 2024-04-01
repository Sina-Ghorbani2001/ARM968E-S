module EX_Stage_Reg #(
    parameter DATA_LEN = 32,
    parameter ADDRESS_LEN = 32,
    parameter ADDRESS_LEN_REG_FILE = 4
) (
    input  wire                                   clk, rst,
    input  wire                                   WB_EN_in, MEM_R_EN_in, MEM_W_EN_in,
    input  wire  [DATA_LEN - 1 : 0]               ALU_Res_in,
    input  wire  [DATA_LEN - 1 : 0]               Val_Rm_in,
    input  wire  [ADDRESS_LEN_REG_FILE - 1 : 0]   Dest_in,
    output reg                                    WB_EN, MEM_R_EN, MEM_W_EN,
    output reg   [DATA_LEN - 1 : 0]               ALU_Res, Val_Rm,
    output reg   [ADDRESS_LEN_REG_FILE - 1 : 0]   Dest

);


    always @(posedge clk or negedge rst) begin
        if(~rst) begin
            WB_EN <= 1'b0;
            ALU_Res <= 32'b0;
            Dest <= 4'b0;
            MEM_R_EN <= 1'b0;
            MEM_W_EN <= 1'b0;
            Val_Rm <= 32'b0;
        end
        else begin
            WB_EN <= WB_EN_in;
            ALU_Res <= ALU_Res_in;
            Dest <= Dest_in;
            MEM_R_EN <= MEM_R_EN_in;
            MEM_W_EN <= MEM_W_EN_in;
            Val_Rm <= Val_Rm_in;
        end   
    end
    
endmodule