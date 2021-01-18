module s3rb(
    input [3:0] opcode, operand1,
    input [15:0] operand2,
    input rst, clk, cin,
    output reg [15:0] aluout,
    output reg cb, done
);
    wire [15:0] memdatw, memdatr, 
                aluop1, aluop2;
    wire rw, cs;
    wire [3:0] memaddress, aluopcode;
    wire [15:0] aluoutw;
    wire cbw, donew, aludo;
    regbnk r(
        .datin(memdatw),
        .addr(memaddress),
        .clk(clk), .rw(rw), .cs(cs), .rst(rst),
        .datout(memdatr)
    );

    dcoder2 d(
        //input ports
        .opcode(opcode),
        .op1(operand1),
        .op2(operand2),
        .memdatr(memdatr),
        .aluout(aluout),
        .rst(rst), .clk(clk),

        //output ports
        .aluop1(aluop1),
        .aluop2(aluop2),
        .memdatw(memdatw),
        .aluopcode(aluopcode),
        .address(memaddress), .aludo(aludo),
        .rw(rw), .cs(cs),  .done(donew)
    );

    alu a(
        .op1(aluop1),
        .op2(aluop2),
        .opcode(aluopcode),
        .cin(cin), .clk(clk), .rst(rst), .en(aludo),
        .out(aluoutw), .cb(cbw)
    );
    always @(posedge clk) begin
        aluout <= aluoutw;
        cb <= cbw;
        done <= donew;
    end
endmodule