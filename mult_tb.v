`timescale 1ns/1ps

module mult_tb;
   reg [31:0] A, B   ;
   wire [31:0] HI, LO;
   
   MULT32 smult_inst(.HI(HI), .LO(LO), .A(A), .B(B));
   
   initial
     begin
	A    = 32'h0; B    = 32'h0; 
	#5 A    = 32'h1; B    = 32'h1; 
	#5 A    = 32'h2; B    = 32'h5; 
	#5 A    = 32'h0; B    = 32'h0; 
     end
   
endmodule

