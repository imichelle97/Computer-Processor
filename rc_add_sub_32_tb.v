`timescale 1ns/1ps

module rc_add_sub_32_tb;
   reg [31:0] A;
   reg [31:0] B;
   reg 	      SnA;
   wire [31:0] Y;
   wire        CO;
   
   
   RC_ADD_SUB_32 rc_inst_1(.Y(Y), .CO(CO), .A(A), .B(B), .SnA(SnA));
   
   initial
     begin
	//Add Operation
	A = 32'h0; B = 32'h0; SnA = 0;		
	#5 A = 32'h1; B = 32'h0; SnA = 0;
	#5 A = 32'hAAAA_AAAA; B = 32'h5555_5555; SnA = 0;
	#5 A = 32'hFFFF_FFFF; B = 32'h1; SnA = 0;
	#5 A = 32'h0; B = 32'h0; SnA = 0;
	
	//Sub Operation
	#5 A = 32'h0; B = 32'h0; SnA = 1;
	#5 A = 32'h0; B = 32'h1; SnA = 1;
	#5 A = 32'hFFFF_FFFF; B = 32'h1; SnA = 1;
	#5 A = 32'h0; B = 32'h0; SnA = 1;
	
     end
   
endmodule
