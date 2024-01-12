`timescale 1ns/1ns

module ARM #(
    parameter DATA_LEN = 32,
    parameter ADDRESS_LEN = 32,
    parameter ADDRESS_LEN_REG_FILE = 4,
    parameter SIZE_REG_FILE = 15,
    parameter MEM_ADDRESS_LINE = 64

) (
    input wire                       clk, rst
);

    // *********************************************************************
    // outputs of instruction fetch stage
    wire    [ADDRESS_LEN - 1 : 0]          IF_PC;
    wire    [DATA_LEN - 1 : 0]             IF_Instruction;

    // outputs of instruction fetch register
    wire    [ADDRESS_LEN - 1 : 0]          IF_Reg_PC;
    wire    [DATA_LEN - 1 : 0]             IF_Reg_Instruction;

    // *********************************************************************
    // outputs of instruction decode stage
    wire   [ADDRESS_LEN - 1 : 0]            ID_PC;
    wire                                    ID_Reg_B, ID_Reg_S;
    wire                                    ID_WB_EN, ID_MEM_R_EN, ID_MEM_W_EN;
    wire   [3 : 0]                          ID_EXE_CMD;
    wire                                    ID_B, ID_S;
    wire   [DATA_LEN - 1 : 0]               ID_Val_Rn, ID_Val_Rm;
    wire                                    ID_imm;
    wire   [ADDRESS_LEN_REG_FILE - 1 : 0]   ID_Dest;
    wire   [11 : 0]                         ID_offset;
    wire   [23 : 0]                         ID_Signed_imm_24;
    wire                                    ID_Two_src;

    // outputs of instruction decode register
    wire   [ADDRESS_LEN - 1 : 0]            ID_Reg_PC;
    wire                                    ID_Reg_WB_EN, ID_Reg_MEM_R_EN, ID_Reg_MEM_W_EN;
    wire   [3 : 0]                          ID_Reg_EXE_CMD;
    wire   [DATA_LEN - 1 : 0]               ID_Reg_Val_Rn, ID_Reg_Val_Rm;
    wire                                    ID_Reg_imm;
    wire   [ADDRESS_LEN_REG_FILE - 1 : 0]   ID_Reg_Dest;
    wire   [11 : 0]                         ID_Reg_offset;
    wire   [23 : 0]                         ID_Reg_Signed_imm_24;
    wire                                    ID_Reg_carry;
    wire   [ADDRESS_LEN_REG_FILE - 1 : 0]   ID_Hazard_src1;
    wire   [ADDRESS_LEN_REG_FILE - 1 : 0]   ID_Hazard_src2;
    // *********************************************************************
    // outputs of execution stage
    wire   [DATA_LEN - 1 : 0]               EX_ALU_Res;
    wire   [DATA_LEN - 1 : 0]               EX_Branch_Address;
    wire                                    EX_N_stat, EX_Z_stat, EX_C_stat, EX_V_stat;

    // outputs of execution register
    wire                                    EX_Reg_WB_EN, EX_Reg_MEM_R_EN, EX_Reg_MEM_W_EN;
    wire   [DATA_LEN - 1 : 0]               EX_Reg_ALU_Res, EX_Reg_Val_Rm;
    wire   [ADDRESS_LEN_REG_FILE - 1 : 0]   EX_Reg_Dest;

    // *********************************************************************
    // outputs of memory access stage
    wire   [DATA_LEN - 1 : 0]               MA_MEM_OUT;    
    // outputs of memory access register
    wire                                    MA_Reg_WB_EN,   MA_Reg_MEM_R_EN;
    wire   [DATA_LEN - 1 : 0]               MA_Reg_ALU_Res, MA_Reg_MEM_OUT;
    wire   [ADDRESS_LEN_REG_FILE - 1 : 0]   MA_Reg_Dest;

    // *********************************************************************
    // outputs of write back stage
    wire   [DATA_LEN - 1 : 0]               WB_Value;

    // *********************************************************************
    // output of Hazard Detection Unit
    wire                                    freeze;

    // minmax
    wire [6 : 0] detect_minmax;
    wire         minmax_flag;
    wire         minmax_flag_reg;
    wire         N_stat_reg;



    // *********************************************************************
    // Instruction Fetch

    IF_Stage #(
        .DATA_LEN(DATA_LEN),
        .ADDRESS_LEN(ADDRESS_LEN)
    ) IF_Stage(
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .Branch_taken(ID_Reg_B),
        .BranchAddr(EX_Branch_Address),
        .PC(IF_PC),
        .Instruction(IF_Instruction)
    );

    IF_Stage_Reg #(
        .DATA_LEN(DATA_LEN),
        .ADDRESS_LEN(ADDRESS_LEN)
    ) IF_Stage_Reg(
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .flush(ID_Reg_B),
        .PC_in(IF_PC),
        .Instruction_in(IF_Instruction),
        .PC(IF_Reg_PC),
        .Instruction(IF_Reg_Instruction)
    );

    assign detect_minmax = IF_Reg_Instruction[27 : 21];


    // *********************************************************************
    // Instruction Decode

    ID_Stage #(
        .DATA_LEN(DATA_LEN),
        .ADDRESS_LEN(ADDRESS_LEN),
        .ADDRESS_LEN_REG_FILE(ADDRESS_LEN_REG_FILE),
        .SIZE_REG_FILE(SIZE_REG_FILE)
    ) ID_Stage(
        .clk(clk),
        .rst(rst),
        .PC_in(IF_Reg_PC),
        .PC(ID_PC),
        .Instruction_in(IF_Reg_Instruction),
        .Hazard(freeze),
        .WB_Dest(MA_Reg_Dest),
        .WB_Value(WB_Value),
        .WB_WB_EN(MA_Reg_WB_EN),
        .SR({EX_N_stat, EX_Z_stat, EX_C_stat, EX_V_stat}),

        .WB_EN(ID_WB_EN),
        .MEM_R_EN(ID_MEM_R_EN),
        .MEM_W_EN(ID_MEM_W_EN),
        .EXE_CMD(ID_EXE_CMD),
        .B(ID_B),
        .S(ID_S),
        .Val_Rn(ID_Val_Rn),
        .Val_Rm(ID_Val_Rm),
        .imm(ID_imm),
        .Dest(ID_Dest),
        .offset(ID_offset),
        .Signed_imm_24(ID_Signed_imm_24),
        .Two_src(ID_Two_src),
        .Hazard_src1(ID_Hazard_src1),
        .Hazard_src2(ID_Hazard_src2),
        .minmax_flag(minmax_flag),
    );

    ID_Stage_Reg #(
        .DATA_LEN(DATA_LEN),
        .ADDRESS_LEN(ADDRESS_LEN),
        .ADDRESS_LEN_REG_FILE(ADDRESS_LEN_REG_FILE)
    ) ID_Stage_Reg(
        .clk(clk),
        .rst(rst),
        .PC_in(ID_PC),
        .PC(ID_Reg_PC),
        .WB_EN_in(ID_WB_EN),
        .MEM_R_EN_in(ID_MEM_R_EN),
        .MEM_W_EN_in(ID_MEM_W_EN),
        .EXE_CMD_in(ID_EXE_CMD),
        .B_in(ID_B),
        .S_in(ID_S),
        .Val_Rn_in(ID_Val_Rn),
        .Val_Rm_in(ID_Val_Rm),
        .imm_in(ID_imm),
        .Dest_in(ID_Dest),
        .offset_in(ID_offset),
        .Signed_imm_24_in(ID_Signed_imm_24),
        .flush(ID_Reg_B),
        .carry_in(EX_C_stat),

        .WB_EN(ID_Reg_WB_EN),
        .MEM_R_EN(ID_Reg_MEM_R_EN),
        .MEM_W_EN(ID_Reg_MEM_W_EN),
        .EXE_CMD(ID_Reg_EXE_CMD),
        .B(ID_Reg_B),
        .S(ID_Reg_S),
        .Val_Rn(ID_Reg_Val_Rn),
        .Val_Rm(ID_Reg_Val_Rm),
        .imm(ID_Reg_imm),
        .Dest(ID_Reg_Dest),
        .offset(ID_Reg_offset),
        .Signed_imm_24(ID_Reg_Signed_imm_24),
        .carry(ID_Reg_carry),
        .minmax_flag_in(minmax_flag),
        .minmax_flag(minmax_flag_reg)
    );
 

    // *********************************************************************
    // Execution

    EX_Stage #(
        .DATA_LEN(DATA_LEN),
        .ADDRESS_LEN(ADDRESS_LEN)
    ) EX_Stage(
        .clk(clk),
        .rst(rst),
        .PC_in(ID_Reg_PC),
        .MEM_R_EN(ID_Reg_MEM_R_EN),
        .MEM_W_EN(ID_Reg_MEM_W_EN),
        .EXE_CMD(ID_Reg_EXE_CMD),
        .Val_Rm(ID_Reg_Val_Rm),
        .Val_Rn(ID_Reg_Val_Rn),
        .imm(ID_Reg_imm),
        .offset(ID_Reg_offset),
        .Signed_imm_24(ID_Reg_Signed_imm_24),
        .carry_in(ID_Reg_carry),
        .S(ID_Reg_S), 
        .ALU_Res(EX_ALU_Res),
        .Branch_Address(EX_Branch_Address),
        .N_stat(EX_N_stat),
        .Z_stat(EX_Z_stat),
        .C_stat(EX_C_stat),
        .V_stat(EX_V_stat),
        .minmax_flag(minmax_flag_reg)
    );

    EX_Stage_Reg #(
        .DATA_LEN(DATA_LEN),
        .ADDRESS_LEN(ADDRESS_LEN)
    ) EX_Stage_Reg(
        .clk(clk),
        .rst(rst),
        .WB_EN_in(ID_Reg_WB_EN),
        .MEM_R_EN_in(ID_Reg_MEM_R_EN),
        .MEM_W_EN_in(ID_Reg_MEM_W_EN),
        .ALU_Res_in(EX_ALU_Res),
        .Val_Rm_in(ID_Reg_Val_Rm),
        .Dest_in(ID_Reg_Dest),
        .WB_EN(EX_Reg_WB_EN),
        .MEM_R_EN(EX_Reg_MEM_R_EN),
        .MEM_W_EN(EX_Reg_MEM_W_EN),
        .ALU_Res(EX_Reg_ALU_Res),
        .Val_Rm(EX_Reg_Val_Rm),
        .Dest(EX_Reg_Dest),
        .N_stat_in(EX_N_stat),
        .N_stat(N_stat_reg)
    );


    // *********************************************************************
    // Memory Access

    MA_Stage #(
        .DATA_LEN(DATA_LEN),
        .ADDRESS_LEN(ADDRESS_LEN),
        .MEM_ADDRESS_LINE(MEM_ADDRESS_LINE)
    ) MA_Stage(
        .clk(clk),
        .rst(rst),
        .ALU_Res(EX_Reg_ALU_Res),
        .Val_Rm(EX_Reg_Val_Rm),
        .MEM_W_EN(EX_Reg_MEM_W_EN),
        .MEM_R_EN(EX_Reg_MEM_R_EN),
        .MEM_OUT(MA_MEM_OUT)
    );


    MA_Stage_Reg #(
        .DATA_LEN(DATA_LEN),
        .ADDRESS_LEN(ADDRESS_LEN)
    ) MA_Stage_Reg(
        .clk(clk),
        .rst(rst),
        .WB_EN_in(EX_Reg_WB_EN),
        .MEM_R_EN_in(EX_Reg_MEM_R_EN),
        .ALU_Res_in(EX_Reg_ALU_Res),
        .MEM_OUT_in(MA_MEM_OUT),           
        .Dest_in(EX_Reg_Dest),
        .WB_EN(MA_Reg_WB_EN),
        .MEM_R_EN(MA_Reg_MEM_R_EN),
        .ALU_Res(MA_Reg_ALU_Res),
        .MEM_OUT(MA_Reg_MEM_OUT),
        .Dest(MA_Reg_Dest)
    );


    // *********************************************************************
    // Write Back

    WB_Stage #(
        .DATA_LEN(DATA_LEN)
    ) WB_Stage(
        .MEM_R_EN(MA_Reg_MEM_R_EN),
        .ALU_Res(MA_Reg_ALU_Res),
        .MEM_OUT(MA_Reg_MEM_OUT),
        .WB_Value(WB_Value)
    );

    // *********************************************************************
    // Hazard Detection Unit

    Hazard_Detection_Unit #(
        .ADDRESS_LEN_REG_FILE(ADDRESS_LEN_REG_FILE)
    ) Hazard_Detection_Unit(
        .src1(ID_Hazard_src1),
        .src2(ID_Hazard_src2),
        .Exe_Dest(ID_Reg_Dest),
        .Mem_Dest(EX_Reg_Dest),
        .Exe_WB_EN(ID_Reg_WB_EN),
        .Mem_WB_EN(EX_Reg_WB_EN),
        .Two_src(ID_Two_src),
        .Hazard_Detected(freeze),
        .detect_minmax(detect_minmax)
    );

endmodule


