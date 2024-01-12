module Hazard_Detection_Unit #(
    parameter ADDRESS_LEN_REG_FILE = 4
) (
    input  wire  [ADDRESS_LEN_REG_FILE - 1 : 0]  src1,
    input  wire  [ADDRESS_LEN_REG_FILE - 1 : 0]  src2,
    input  wire  [ADDRESS_LEN_REG_FILE - 1 : 0]  Exe_Dest,
    input  wire  [ADDRESS_LEN_REG_FILE - 1 : 0]  Mem_Dest,
    input  wire                                  Exe_WB_EN,
    input  wire                                  Mem_WB_EN,
    input  wire                                  Two_src,
    input  wire  [6 : 0]                         detect_minmax,                                  
    output reg                                   Hazard_Detected
);

    always @(*) begin
        if((src1 == Exe_Dest) && Exe_WB_EN)
            Hazard_Detected = 1'b1;
        else if((src1 == Mem_Dest) && Mem_WB_EN)
            Hazard_Detected = 1'b1;
        else if((src2 == Exe_Dest) && Exe_WB_EN && Two_src)        
            Hazard_Detected = 1'b1;
        else if((src2 == Mem_Dest) && Mem_WB_EN && Two_src)
            Hazard_Detected = 1'b1;
        else if(detect_minmax == 7'b0010011)
            Hazard_Detected = 1'b1;    
        else
            Hazard_Detected = 1'b0;            
    end
    
endmodule