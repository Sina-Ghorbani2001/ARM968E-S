module IF_Stage #(
    parameter DATA_LEN = 32,
    parameter ADDRESS_LEN = 32 
    
) (
    input  wire          clk, rst, freeze,
    input  wire          Branch_taken,
    input  wire [31 : 0] BranchAddr,
    output wire [31 : 0] PC, Instruction
);

    wire [DATA_LEN - 1 : 0] PC_Reg_in;
    wire [DATA_LEN - 1 : 0] PC_Reg_out;


    MUX2to1 #(
        .DATA_LEN(DATA_LEN)
    ) MUX2to1(
        .data_in1(BranchAddr),
        .data_in0(PC),
        .sel(Branch_taken),
        .data_out(PC_Reg_in)
    );

    PC #(
        .DATA_LEN(DATA_LEN)
    ) myPC(
        .clk(clk),
        .rst(rst),
        .data_in(PC_Reg_in),
        .freeze(freeze),
        .data_out(PC_Reg_out)
    );

    Adder #(
        .DATA_LEN(DATA_LEN)
    ) Adder(
        .data_in1(PC_Reg_out),
        .data_in2(32'd4),
        .data_out(PC)
    );

    Ins_Mem #(
        .DATA_LEN(DATA_LEN),
        .ADDRESS_LEN(ADDRESS_LEN)
    ) Ins_Mem(
        .address(PC_Reg_out),
        .data_out(Instruction)
    );

endmodule