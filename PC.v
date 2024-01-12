module PC #(
    parameter DATA_LEN = 32
) (
    input wire  clk, rst,
    input wire [DATA_LEN - 1 : 0] data_in,
    input wire                    freeze,
    output reg [DATA_LEN - 1 : 0] data_out
);

    always @(posedge clk or negedge rst) begin
        if(~rst)
            data_out <= 'b0;
        else begin
            if(freeze) begin
                data_out <= data_out;
            end
            else
                data_out <= data_in;
        end    
    end

    
endmodule