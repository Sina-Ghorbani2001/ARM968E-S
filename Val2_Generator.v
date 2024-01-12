module Val2_Generator #(
    parameter DATA_LEN = 32
) (
    input  wire           [11 : 0]                       offset,
    input  wire                                          imm,
    input  wire signed    [DATA_LEN - 1 : 0]             Val_Rm,
    input  wire                                          MEM_R_EN, MEM_W_EN,
    output reg            [DATA_LEN - 1 : 0]             Val2
    
);

    wire [DATA_LEN - 1 : 0] Shift_in;
    assign Shift_in = {24'b0, offset[7 : 0]};
    wire [4 : 0] bits_to_rotate;
    assign bits_to_rotate = {offset[11 : 8], 1'b0};

    always @(*) begin
        if(MEM_R_EN | MEM_W_EN) begin
            Val2 = {((offset[11]) ? 20'b1 : 20'b0), offset};
        end
        else if(imm) begin

            Val2 = Shift_in >> bits_to_rotate | Shift_in << (32 - bits_to_rotate);

        end
        else begin
            begin
                Val2 = 'b0;
            end
            case (offset[6 : 5])
                2'b00: Val2 = Val_Rm << offset[11 : 7];
                2'b01: Val2 = Val_Rm >> offset[11 : 7];
                2'b10: Val2 = Val_Rm >>> offset[11 : 7];
                2'b11: Val2 = Val_Rm >> offset[11 : 7] | Val_Rm << (32 - offset[11 : 7]);
                default: Val2 = 'b0;
            endcase
        end

    end
    
endmodule
