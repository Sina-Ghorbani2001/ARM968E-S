
module Control_Unit (
    input  wire [1 : 0]         mode,
    input  wire [3 : 0]         opcode,
    input  wire                 s,
    output reg  [3 : 0]         Execute_Command,
    output reg                  mem_read, mem_write,
    output reg                  WB_Enable, B, Update_Flags
);

    always @(*) begin
        if(mode == 2'b01 && opcode == 4'b0100 && s == 1'b1)
            mem_read = 1'b1;
        else
            mem_read = 1'b0;    
    end

    always @(*) begin
        if(mode == 2'b01 && opcode == 4'b0100 && s == 1'b0)
            mem_write = 1'b1;
        else
            mem_write = 1'b0;    
    end

    always @(*) begin
        if((mode == 2'b00 && opcode != 4'b1010 && opcode != 4'b1000) || (mode == 2'b01 && opcode == 4'b0100 && s == 1'b1))
            WB_Enable = 1'b1;
        else
            WB_Enable = 1'b0;    
    end

    always @(*) begin
        if(mode == 2'b10)
            B = 1'b1;
        else
            B = 1'b0;            
    end

    always @(*) begin
        if(mode == 2'b10)
            Update_Flags = 1'b0;
        else
            Update_Flags = s;
    end

    always @(*) begin
        begin
            Execute_Command = 4'b0;
        end
        case (mode)
            2'b00: begin
                if(opcode == 4'b1101) //MOV
                    Execute_Command = 4'b0001;
                else if(opcode == 4'b1111) //MVN
                    Execute_Command = 4'b1001;
                else if(opcode == 4'b0100) //ADD
                    Execute_Command = 4'b0010;
                else if(opcode == 4'b0101) //ADC
                    Execute_Command = 4'b0011;
                else if(opcode == 4'b0010) //SUB
                    Execute_Command = 4'b0100;
                else if(opcode == 4'b0110) //SBC
                    Execute_Command = 4'b0101;
                else if(opcode == 4'b0000) //AND
                    Execute_Command = 4'b0110;
                else if(opcode == 4'b1100) //OR
                    Execute_Command = 4'b0111;
                else if(opcode == 4'b0001) //EOR
                    Execute_Command = 4'b1000;
                else if(opcode == 4'b1010) //CMP
                    Execute_Command = 4'b0100;
                else if(opcode == 4'b1000) //TST
                    Execute_Command = 4'b0110;
                else
                    Execute_Command = 4'b0000;

            end
            2'b01: begin
                Execute_Command = 4'b0010;
            end
            2'b10: begin
                Execute_Command = 4'b0;
            end 
            default: begin
                Execute_Command = 4'b0;
            end 
        endcase
        
    end





    
endmodule