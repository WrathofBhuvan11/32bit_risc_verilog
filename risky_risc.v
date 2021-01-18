module risky_risc(
   input rst, clk,
   output reg succ
);
    wire [23:0] instrw;
    wire [15:0] aluoutxw, aluoutaw;
    wire cb, done;
    reg [2:0] addr;
    reg cin, en;
    reg [15:0] aluoutx, aluouta;
    reg [23:0] instr; 
    blk_mem_gen_0 inputX (
      .clka(clk),    // input wire clka
      .ena(en),      // input wire ena
      .addra(addr),  // input wire [2 : 0] addra
      .douta(instrw)  // output wire [23 : 0] douta
    );
     s3rb RISC(//input
         .opcode(instr[23:20]),
         .operand1(instr[19:16]),
         .operand2(instr[15:0]),
         .rst(rst), .clk(clk), 
         .cin(cin),
         //output
         .aluout(aluoutaw),
         .cb(cb), .done(done)
      );

    blk_mem_gen_1 outputX (
      .clka(clk),    // input wire clka
      .ena(en),      // input wire ena
      .addra(addr),  // input wire [2 : 0] addra
      .douta(aluoutxw)  // output wire [15 : 0] douta
    );
  
   
    
    always @ (posedge clk) begin
        if (rst) begin
            addr <= 0;
            succ <= 0;
            en <= 1;
            cin <= 0;
        end
        else begin
            instr <= instrw;
            if (done) begin
                addr <= addr + 1;
                succ <= (aluoutxw == aluoutaw);
            end
        end
    end
    
endmodule