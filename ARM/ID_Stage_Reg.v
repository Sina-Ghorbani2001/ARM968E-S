module ID_Stage_Reg #(
    parameter DATA_LEN = 32,
    parameter ADDRESS_LEN = 32,
    parameter ADDRESS_LEN_REG_FILE = 4
) (
    input  wire                                   clk, rst,
    input  wire  [ADDRESS_LEN - 1 : 0]            PC_in,
    input  wire                                   WB_EN_in, MEM_R_EN_in, MEM_W_EN_in,
    input  wire  [3 : 0]                          EXE_CMD_in,
    input  wire                                   B_in, S_in,
    input  wire  [DATA_LEN - 1 : 0]               Val_Rn_in, Val_Rm_in,
    input  wire                                   imm_in,
    input  wire  [ADDRESS_LEN_REG_FILE - 1 : 0]   Dest_in,
    input  wire  [11 : 0]                         offset_in,
    input  wire  [23 : 0]                         Signed_imm_24_in,
    input  wire                                   flush,
    input  wire                                   carry_in,
    output reg   [ADDRESS_LEN - 1 : 0]            PC,
    output reg                                    WB_EN, MEM_R_EN, MEM_W_EN,
    output reg   [3 : 0]                          EXE_CMD,
    output reg                                    B, S,
    output reg   [DATA_LEN - 1 : 0]               Val_Rn, Val_Rm,
    output reg                                    imm,
    output reg   [ADDRESS_LEN_REG_FILE - 1 : 0]   Dest,
    output reg   [11 : 0]                         offset,
    output reg   [23 : 0]                         Signed_imm_24,
    output reg                                    carry,
    input  wire  minmax_flag_in,
    output reg   minmax_flag

);

    

    always @(posedge clk or negedge rst) begin
        if(~rst) begin
            PC <= 'b0;
            WB_EN <= 0;
            MEM_R_EN <= 0;
            MEM_W_EN <= 0;
            EXE_CMD <= 'b0;
            B <= 0;
            S <= 0;
            Val_Rn <= 'b0;
            Val_Rm <= 'b0;
            imm <= 'b0;
            Dest <= 'b0;
            offset <= 'b0;
            Signed_imm_24 <= 'b0;
            carry <= 1'b0;
            minmax_flag <= 0;
        end
        else begin
            if(flush) begin
                PC <= 'b0;
                WB_EN <= 0;
                MEM_R_EN <= 0;
                MEM_W_EN <= 0;
                EXE_CMD <= 'b0;
                B <= 0;
                S <= 0;
                Val_Rn <= 'b0;
                Val_Rm <= 'b0;
                imm <= 'b0;
                Dest <= 'b0;
                offset <= 'b0;
                Signed_imm_24 <= 'b0;
                carry <= 1'b0;
                minmax_flag <= 0;

            end
            else begin
                PC <= PC_in;
                WB_EN <= WB_EN_in;
                MEM_R_EN <= MEM_R_EN_in;
                MEM_W_EN <= MEM_W_EN_in;
                EXE_CMD <= EXE_CMD_in;
                B <= B_in;
                S <= S_in;
                Val_Rn <= Val_Rn_in;
                Val_Rm <= Val_Rm_in;
                imm <= imm_in;
                Dest <= Dest_in;
                offset <= offset_in;
                Signed_imm_24 <= Signed_imm_24_in;
                carry <= carry_in;
                minmax_flag <= minmax_flag_in;

            end
        end
        
    end
    
endmodule
