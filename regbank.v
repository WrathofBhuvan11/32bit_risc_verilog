module regbnk(
    input [15:0] datin,
    input [3:0] addr,
    input clk, rw, cs, rst,
    output reg [15:0] datout
);
    reg [15:0] rgr [15:0];
    always @ (posedge clk) begin
        if(rst) begin
            datout <= 0;
            rgr[0] <= 0;
            rgr[1] <= 0;
            rgr[2] <= 0;
            rgr[3] <= 0;
            rgr[4] <= 0;
            rgr[5] <= 0;
            rgr[6] <= 0;
            rgr[7] <= 0;
            rgr[8] <= 0;
            rgr[9] <= 0;
            rgr[10] <= 0;    
            rgr[11] <= 0;
            rgr[12] <= 0;
            rgr[13] <= 0;
            rgr[14] <= 0;
            rgr[15] <= 0;
        end
        else if(cs) begin    
            if(!rw) begin
                rgr[addr] <= datin;
            end
            else begin
                datout <= rgr[addr];
            end
        end
    end
endmodule