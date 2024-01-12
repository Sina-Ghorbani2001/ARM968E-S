module Condition_Check (
    input  wire [3 : 0] cond,
    input  wire [3 : 0] SR,
    output reg          check      
);

    wire N, Z, V, C;

    assign N = SR[3];
    assign Z = SR[2];
    assign C = SR[1];
    assign V = SR[0];



    always @(*) begin
        begin
            check = 0;
        end
        case (cond)
            4'b0000: check = Z;
            4'b0001: check = ~Z;
            4'b0010: check = C;
            4'b0011: check = ~C;
            4'b0100: check = N;
            4'b0101: check = ~N;
            4'b0110: check = V;
            4'b0111: check = ~V;
            4'b1000: check = C & (~Z);
            4'b1001: check = (~C) & Z;
            4'b1010: check = (N & V) | (~N & ~V);
            4'b1011: check = (N != V) ? 1 : 0;
            4'b1100: check = (Z == 0 && N == V) ? 1 : 0;
            4'b1101: check = (Z == 1 || N != V) ? 1 : 0;
            4'b1110: check = 1;
            4'b1111: check = 0;

            default: check = 0;
        endcase
    end


    
endmodule
