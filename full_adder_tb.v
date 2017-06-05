`timescale 1ns/1ps

module full_adder_tb;
   reg A, B, CI;
   wire S, CO;
   
   FULL_ADDER fa_inst_1(.S(S), .CO(CO), .A(A), .B(B), .CI(CI));
   
   initial
     begin
	A = 0; B = 0; CI = 0;
	#5 A = 1; B = 0; CI = 0;
	#5 A = 1; B = 0; CI = 1;
	#5 A = 0; B = 1; CI = 0;
	#5 A = 0; B = 1; CI = 1;
	#5 A = 1; B = 1; CI = 0;
	#5 A = 1; B = 1; CI = 1;
	#5 A = 0; B = 0; CI = 0;
     end
   
endmodule
