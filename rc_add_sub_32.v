// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// Ripple Carry 32-bit
module RC_ADD_SUB_32(Y, CO, A, B, SnA);
   input [31:0] A;
   input [31:0] B;
   input        SnA;
   
   output [31:0] Y;
   output        CO;
   
   wire [31:0] 	 xor_out;
   wire [31:0] 	 C;
   
   genvar 	 i;
   generate
      for(i = 0; i < 32; i = i + 1)
	begin : xor_32_gen_loop
	   xor xor_inst(xor_out[i], B[i], SnA);
	end
   endgenerate
   
   FULL_ADDER fa0(.S(Y[0]), .CO(C[0]), .A(A[0]), .B(xor_out[0]), .CI(SnA));
   
   generate
      for(i = 1; i < 32; i = i + 1)
	begin : full_adder_32_gen_loop
	   FULL_ADDER fa_inst(.S(Y[i]), .CO(C[i]), .A(A[i]), .B(xor_out[i]), .CI(C[i - 1]));
	end
   endgenerate
   
   assign CO = C[31];
   
endmodule // RC_ADD_SUB_32

// Ripple Carry 64-bit
module RC_ADD_SUB_64(Y, CO, A, B, SnA);
   input [63:0] A;
   input [63:0] B;
   input        SnA;
   
   output [63:0] Y;
   output        CO;
   
   wire [63:0] 	 xor_out;
   wire [63:0] 	 C;
   
   genvar 	 i;
   generate
      for(i = 0; i < 64; i = i + 1)
	begin : xor_64_gen_loop
	   xor xor_inst(xor_out[i], B[i], SnA);
	end
   endgenerate
   
   FULL_ADDER fa0(.S(Y[0]), .CO(C[0]), .A(A[0]), .B(xor_out[0]), .CI(SnA));
   
   generate
      for(i = 1; i < 64; i = i + 1)
	begin : full_adder_64_gen_loop
	   FULL_ADDER fa_inst(.S(Y[i]), .CO(C[i]), .A(A[i]), .B(xor_out[i]), .CI(C[i - 1]));
	end
   endgenerate
   
   assign CO = C[63];
   
endmodule // RC_ADD_SUB_64

