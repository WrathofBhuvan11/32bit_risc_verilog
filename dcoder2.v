
module dcoder2(
    input [3:0] opcode, op1,
    input [15:0] op2, memdatr, aluout,
    input rst, clk,
    output reg [15:0] aluop1, aluop2, memdatw,
    output reg [3:0] aluopcode, address, 
    output reg rw, cs, done, aludo
    );
    reg [2:0] state;
    /*
        state 0: init
        state 1: fetch op1 data
        state 2: fetch op2 data
        state 3: aluopcode <= opcode -> alu executes
        state 4: write back to register (op1)
    */
    always @ (posedge clk) begin
        if (rst) begin
            state <= 0;
            cs <= 0;
            aluop1 <= 0;
            aluop2 <= 0;
            aluopcode <= 0;
            done <= 0;
            aludo <= 0;
        end
        
        else begin
            case (state)
                3'b000: begin
                    cs <= 0;
                    done <= 0;
                    aluop1 <= 0;
                    aluop2 <= 0;
                    aluopcode <= 0;
                    state <= 3'b001;
                    aludo <= 0;
                end 
               
                3'b001: begin
                    state <= 3'b010;
                    if (opcode != 4'd7) begin
                        address <= op2[3:0];
                        cs <= 1;
                        rw <= 1;   
                    end
                end
                
                3'b010:begin
                    state <= 3'b011;
//                    if (opcode != 4'd7) begin
                    address <= op1;  
//                    end
                end
                
                3'b011:begin
                    state <= 3'b100;
                    if (opcode != 4'd7) begin
                        aluop2 <= memdatr; 
                    end
                end
                
                3'b100:begin
                    rw <= 0 ;
                    state <= 3'b101;
                    if (opcode != 4'd7) begin
                        aluop1 <= memdatr;
                        aludo <= 1 ;
                        aluopcode <= opcode ;
                    end
                end
               
                3'b101: state <= 3'b110;
                               
                3'b110: begin
                    state <= 3'b111;
                    cs <= 1;
                    rw <= 0;
                end
                
                3'b111:begin
                    done <= 1;
                    state <= 3'b000;
                    if (opcode != 4'd7) begin
                            memdatw <= aluout;
                            aludo <= 0;
                        end
                        else begin
                            memdatw <= op2;
                        end
                end
                
                default:state <= 3'd0;
            endcase
        end
    end
endmodule
