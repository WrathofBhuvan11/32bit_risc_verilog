module dcoder(
    input [3:0] opcode, op1,
    input [15:0] op2, memdat, aluout,
    input rst, clk,
    output reg [15:0] aluop1, aluop2, datout,
    output reg [3:0] aluopcode, address, 
    output reg rw, cs, done
);
    reg [1:0] state;
    reg op12;
    always @ (posedge clk) begin
        if(rst) begin
            state <= 0;
            cs <= 0;
            op12 <= 0;
            aluop1 <= 0;
            aluop2 <= 0;
            datout <= 0;
            aluopcode <= 0;
            address <= 0;
            rw <= 1;
            cs <= 0;
            done <= 0;
        end
        else begin
            case (state)
                2'b00: begin
                //init
                    done <= 0;
                    state <= 2'b01;
                    op12 <= 0;
                    cs <= 0;
                    rw <= 1;
                    
                end
                2'b01: begin
                //fetch data from ram    
                    cs <= 1;
                    op12 <= ~op12;
                    if (opcode == 4'b0111) begin //load immediate data 
                        rw <= 0;
                        address <= op1;
                        datout <= op2;
                        if(op12)
                            state <= 2'b10;
                        else
                            state <= 2'b01;
                    end
                    else begin
                        if(!op12) begin
                            address <= op1;
                            rw <= 1;
                            aluop1 <= memdat;
                            state <= 2'b01;
                        end 
                        else begin
                            address <= op2[3:0];
                            rw <= 1;
                            aluop2 <= memdat;
                            state <= 2'b10;
                        end
                    end
                end
                2'b10: begin
                //
                    if(opcode != 4'b0111) aluopcode <= opcode;
                    
                    state <= 2'b11;

                    
                end
                2'b11: begin
                    if(opcode != 4'b0111) begin
                        address <= op1;
                        rw <= 0;
                        datout <= aluout;
                    end
                    state <= 2'b00;
                    done <= 1;
                end
            endcase
        end
    end
endmodule