module MA_Stage_Reg #(
    parameter DATA_LEN = 32,
    parameter ADDRESS_LEN = 32,
    parameter ADDRESS_LEN_REG_FILE = 4
) (
    input  wire                                   clk, rst,
    input  wire                                   WB_EN_in, MEM_R_EN_in, 
    input  wire  [DATA_LEN - 1 : 0]               ALU_Res_in,
    input  wire  [DATA_LEN - 1 : 0]               MEM_OUT_in,
    input  wire  [ADDRESS_LEN_REG_FILE - 1 : 0]   Dest_in,
    output reg                                    WB_EN, MEM_R_EN,
    output reg   [DATA_LEN - 1 : 0]               ALU_Res,
    output reg   [DATA_LEN - 1 : 0]               MEM_OUT,
    output reg   [ADDRESS_LEN_REG_FILE - 1 : 0]   Dest   
);

    always @(posedge clk or negedge rst) begin
        if(~rst) begin
            WB_EN <= 1'b0;
            MEM_R_EN <= 1'b0;
            ALU_Res <= 32'b0;
            MEM_OUT <= 32'b0;
            Dest <= 4'b0;
            
        end
        else begin
            WB_EN <= WB_EN_in;
            MEM_R_EN <= MEM_R_EN_in;
            ALU_Res <= ALU_Res_in;
            MEM_OUT <= MEM_OUT_in;
            Dest <= Dest_in;
        end   
    end


    
endmodule