module ID_Stage #(
    parameter   DATA_LEN = 32,
    parameter   ADDRESS_LEN = 32, 
    parameter   ADDRESS_LEN_REG_FILE = 4,
    parameter   SIZE_REG_FILE = 15
) (
    input  wire                                   clk, rst,
    input  wire                                   Hazard,
    input  wire  [ADDRESS_LEN_REG_FILE - 1 : 0]   WB_Dest,
    input  wire  [DATA_LEN - 1 : 0]               WB_Value,
    input  wire                                   WB_WB_EN,
    input  wire  [3 : 0]                          SR,
    input  wire  [DATA_LEN - 1 : 0]               PC_in,
    input  wire  [DATA_LEN - 1 : 0]               Instruction_in,

    output wire  [DATA_LEN - 1 : 0]               PC,
    output wire                                   WB_EN, MEM_R_EN, MEM_W_EN,
    output wire  [3 : 0]                          EXE_CMD,
    output wire                                   B, S,
    output wire  [DATA_LEN - 1 : 0]               Val_Rn, Val_Rm,
    output wire                                   imm,
    output wire  [ADDRESS_LEN_REG_FILE - 1 : 0]   Dest,
    output wire  [11 : 0]                         offset,
    output wire  [23 : 0]                         Signed_imm_24,
    output wire                                   Two_src,
    output wire  [ADDRESS_LEN_REG_FILE - 1 : 0]   Hazard_src1,
    output wire  [ADDRESS_LEN_REG_FILE - 1 : 0]   Hazard_src2
);


    wire                                mem_read, mem_write, WB_Enable;
    wire                                B_before_MUX, Update_Flags;
    wire [4 : 0]                        SRC0_CTRL_MUX; 
    wire [4 : 0]                        OUT_CTRL_MUX; 
    wire                                CND_Check;
    wire [3 : 0]                        Execute_Command;                


    assign SRC0_CTRL_MUX = {mem_read, mem_write, WB_Enable, B_before_MUX, Update_Flags};
    assign MEM_R_EN = OUT_CTRL_MUX[4];
    assign MEM_W_EN = OUT_CTRL_MUX[3];
    assign WB_EN = OUT_CTRL_MUX[2];
    assign B = OUT_CTRL_MUX[1];
    assign S = OUT_CTRL_MUX[0];
    assign Hazard_src1 = Instruction_in[19 : 16];

    MUX2to1 #(.DATA_LEN(ADDRESS_LEN_REG_FILE)) MUX_SRC2_REG_FILE(
        .data_in0(Instruction_in[3 : 0]),
        .data_in1(Instruction_in[15 : 12]),
        .sel(MEM_W_EN),
        .data_out(Hazard_src2)
    );

    RegisterFile #(.ADDRESS_LEN(ADDRESS_LEN_REG_FILE),
                   .SIZE(SIZE_REG_FILE),
                   .DATA_LEN(DATA_LEN))
                   RegisterFile(
                        .clk(clk),
                        .rst(rst),
                        .src1(Hazard_src1),
                        .src2(Hazard_src2),
                        .Dest_wb(WB_Dest),
                        .Result_wb(WB_Value),
                        .writeBackEn(WB_WB_EN),
                        .reg1(Val_Rn),
                        .reg2(Val_Rm)
                   );

    Control_Unit Control_Unit (
        .mode(Instruction_in[27 : 26]),
        .opcode(Instruction_in[24 : 21]),
        .s(Instruction_in[20]),
        .Execute_Command(Execute_Command),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .WB_Enable(WB_Enable),
        .B(B_before_MUX),
        .Update_Flags(Update_Flags)
    );

    MUX2to1 #(.DATA_LEN(5)) MUX_SRC2(
        .data_in0(SRC0_CTRL_MUX),
        .data_in1(5'b0),
        .sel(~CND_Check | Hazard),                       
        .data_out(OUT_CTRL_MUX)
    );

    MUX2to1 #(.DATA_LEN(4)) MUX_EX_CMD(
        .data_in0(Execute_Command),
        .data_in1(4'b0),
        .sel(~CND_Check | Hazard),                
        .data_out(EXE_CMD)
    );

    Condition_Check Condition_Check(
        .cond(Instruction_in[31 : 28]),
        .SR(SR),
        .check(CND_Check)
    );


    assign Two_src = MEM_W_EN | (~Instruction_in[25]);

    assign imm = Instruction_in[25];
    assign offset = Instruction_in[11 : 0];
    assign Signed_imm_24 = Instruction_in[23 : 0];
    assign Dest = Instruction_in[15 :12];



    assign PC = PC_in;
    
endmodule



