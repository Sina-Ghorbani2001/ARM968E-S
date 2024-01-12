module EX_Stage #(
    parameter DATA_LEN = 32,
    parameter ADDRESS_LEN = 32
) (
    input  wire                                    clk, rst,
    input  wire  [ADDRESS_LEN - 1 : 0]             PC_in,
    input  wire                                    MEM_R_EN, MEM_W_EN,
    input  wire   [3 : 0]                          EXE_CMD,
    input  wire   [DATA_LEN - 1 : 0]               Val_Rn, Val_Rm,
    input  wire                                    imm,
    input  wire   [11 : 0]                         offset,
    input  wire   [23 : 0]                         Signed_imm_24,
    input  wire                                    carry_in,
    input  wire                                    S,
    output wire   [DATA_LEN - 1 : 0]               ALU_Res,
    output wire   [DATA_LEN - 1 : 0]               Branch_Address,
    output reg                                     N_stat, Z_stat, C_stat, V_stat
);

    wire [DATA_LEN - 1 : 0] Val2;
    wire                    N, Z, C, V;
    ALU #(
        .DATA_LEN(DATA_LEN)
    ) ALU(
        .Val1(Val_Rn),
        .Val2(Val2),
        .EXE_CMD(EXE_CMD),
        .carry_in(carry_in),
        .ALU_Res(ALU_Res),
        .carry_out(C),
        .Z(Z),
        .N(N),
        .V(V)
    );

    Val2_Generator #(
        .DATA_LEN(DATA_LEN)
    ) Val2_Generator(
        .offset(offset),
        .imm(imm),
        .Val_Rm(Val_Rm),
        .MEM_R_EN(MEM_R_EN),
        .MEM_W_EN(MEM_W_EN),
        .Val2(Val2)
    );

    assign Branch_Address = PC_in + {(Signed_imm_24[23] ? 6'b111111 : 6'b000000), Signed_imm_24, 2'b0};

    always @(negedge clk or negedge rst) begin
        if(~rst) begin
            N_stat <= 1'b0;
            Z_stat <= 1'b0;
            C_stat <= 1'b0;
            V_stat <= 1'b0;
        end
        else begin
            if(S) begin
                N_stat <= N;
                Z_stat <= Z;
                C_stat <= C;
                V_stat <= V;
            end
            else begin
                N_stat <= N_stat;
                Z_stat <= Z_stat;
                C_stat <= C_stat;
                V_stat <= V_stat;
            end         
        end
    end

endmodule

