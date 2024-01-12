module WB_Stage #(
    parameter DATA_LEN = 32
) (
    input  wire                          MEM_R_EN,
    input  wire      [DATA_LEN - 1 : 0]  ALU_Res,
    input  wire      [DATA_LEN - 1 : 0]  MEM_OUT,
    output wire      [DATA_LEN - 1 : 0]  WB_Value
);

    MUX2to1 #(
        .DATA_LEN(DATA_LEN)
    ) WB_MUX2to1 (
        .data_in0(ALU_Res),
        .data_in1(MEM_OUT),
        .sel(MEM_R_EN),
        .data_out(WB_Value)
    );

        
endmodule
