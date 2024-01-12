module MA_Stage #(
    parameter DATA_LEN = 32,
    parameter ADDRESS_LEN = 32,
    parameter MEM_ADDRESS_LINE = 64    
) (
    input  wire                      clk, rst,
    input  wire  [DATA_LEN - 1 : 0]  ALU_Res,
    input  wire  [DATA_LEN - 1 : 0]  Val_Rm,
    input  wire                      MEM_W_EN, MEM_R_EN,
    output wire  [DATA_LEN - 1 : 0]  MEM_OUT                      
);

    wire         [ADDRESS_LEN - 1 : 0]  Address;
    reg          [DATA_LEN - 1 : 0]     Memory[0 : MEM_ADDRESS_LINE - 1];

    assign Address = (ALU_Res - 32'd1024) >> 2;

    assign MEM_OUT =  MEM_R_EN? Memory[Address] : 'b0;

    always @(posedge clk) begin
        if(MEM_W_EN) begin
            Memory[Address] <= Val_Rm;
        end
    end

    
endmodule