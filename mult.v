// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

//32-bit Unsigned Multiplication
module MULT32_U(HI,LO,A,B);
   
   input [31:0] A, B;
   
   output [31:0] HI, LO;
   
   wire [31:0] 	 P;
   wire [31:0] 	 s[0:31];
   wire [31:0] 	 and_o[1:31];
   wire [31:0] 	 co;
   wire [31:0] 	 LO, HI;
   
   assign co[0] = 1'b0;
   assign P[0] = s[0][0];
   AND32_2x1 and0_inst(.Y(s[0]), .A(A[31:0]), .B({32{B[0]}}));
   
   
   genvar 	 i;
   generate 
      for(i = 1; i < 32; i = i + 1)
	begin : umult_32_gen_loop
	   AND32_2x1 and32_inst(.Y(and_o[i]), 
				.A(A[31:0]),
				.B({32{B[i]}}));
	   
	   RC_ADD_SUB_32 adder_inst(.Y(s[i]),
				    .CO(co[i]),
				    .A(and_o[i]),
				    .B({co[i-1], s[i-1][31:1]}),
				    .SnA(1'b0));
	   
	   assign P[i] = s[i][0];
	   
	end
   endgenerate
   
   assign LO[31:0] = P[31:0];
   assign HI[31:0] = {co[31], s[31][31:1]};
   
endmodule


//32-bit  Signed Multiplication 
module MULT32(HI,LO,A,B);
   
   input [31:0] A, B;
   
   output [31:0] HI, LO;
   
   wire [31:0] 	 HI, LO;
   wire [31:0] 	 two_comp_mcnd, two_comp_mplr;
   wire [31:0] 	 mux_mcnd, mux_mplr;
   wire 	 select_final;
   wire [31:0] 	 umult_hi, umult_lo;
   wire [63:0] 	 two_comp_umult;
   
   TWOSCOMP32 mcnd_inst(.Y(two_comp_mcnd[31:0]), .A(A[31:0]));
   TWOSCOMP32 mplr_inst(.Y(two_comp_mplr[31:0]), .A(B[31:0]));
   
   MUX32_2x1 mcnd_mx(.Y(mux_mcnd[31:0]), .I1(two_comp_mcnd[31:0]),
		     .I0(A[31:0]), .S(B[31]));
   
   MUX32_2x1 mplr_mx(.Y(mux_mplr[31:0]), .I1(two_comp_mplr[31:0]),
		     .I0(B[31:0]), .S(B[31]));
   
   xor xor_inst(select_final, A[31], B[31]);
   
   MULT32_U umult_inst(.HI(umult_hi[31:0]), .LO(umult_lo[31:0]),
		       .A(mux_mcnd[31:0]), .B(mux_mplr[31:0]));
   
   TWOSCOMP64 umult_2_comp(.Y(two_comp_umult[63:0]), 
			   .A({umult_hi, umult_lo}));
   
   MUX64_2x1 final_mux(.Y({HI[31:0], LO[31:0]}),
                       .I1(two_comp_umult[63:0]),
                       .I0({umult_hi, umult_lo}),
                       .S(select_final));
endmodule









