module alu(
    input [15:0] op1, op2,
    input [3:0] opcode,
    input cin, clk, rst, en,
    output reg [15:0] out,
    output reg cb
);
    always @ (posedge clk) begin
        if(rst) begin
            out <= 0;
            cb <= 0;
        end
        else if(en) begin
            case (opcode)
                4'b0000: {cb, out} <= op1 + op2 + cin;//0:add
                4'b0001: {cb, out} <= op1 - op2 - cin;//1:sub
                4'b0010: {cb, out} <= op1 + 1;        //2:inc
                4'b0011: {cb, out} <= op1 - 1;        //3:dec
                4'b0100: begin                        //4:and
                    out <= op1 & op2;
                    cb <= 0;
                end 
                4'b0101: begin                        //5:or
                    out <= op1 | op2;
                    cb <= 0;
                end 
                4'b0110: begin                       //6:neg
                    out <= ~op1;
                    cb <= 0;
                end 
                4'b1000: begin                       //7:nand
                    out <= ~(op1 & op2);
                    cb <= 0;
                end 
                4'b1001: begin                       //9:nor
                    out <= ~(op1 | op2);
                    cb <= 0;
                end 
                4'b1010: begin                       //a:xor
                    out <= op1 ^ op2;
                    cb <= 0;
                end 
                4'b1011: begin                      //b:xnor
                    out <= ~(op1 ^ op2);
                    cb <= 0;
                end 
                4'b1100: begin                      //c:lshl
                    out <= op1 << op2;
                    cb <= 0;
                end 
                4'b1101: begin                      //d:lshr
                    out <= op1 >> op2;
                    cb <= 0;
                end
                4'b1110: begin                     //e:ashl
                    out <= op1 <<< 1;
                    cb <= 0;
                end
                4'b1111: begin                    //f:ashr
                    out <= op1 >>> 1;
                    cb <= 0;
                end
            endcase
        end
//        else {cb, out} <= 17'd0 ;
    end
endmodule