// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y,D,S, LnR);
   // output list
   output [31:0] Y;
   // input list
   input [31:0]  D;
   input [31:0]  S;
   input 	 LnR;

   wire [31:0] 	 shift_out;
   wire 	 mux_select;

   OR32_1x1 or_27(.Y(mux_select), .I({S[31:5], 5'h0}));
   BARREL_SHIFTER32 shifter(.Y(shift_out), .D(D), .S(S[4:0]), .LnR(LnR));
   MUX32_2x1 mux(.Y(Y), .I1(32'h0), .I0(shift_out), .S(mux_select));
  
endmodule // SHIFT32


// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,S, LnR);
   // output list
   output [31:0] Y;
   // input list
   input [31:0]  D;
   input [4:0] 	 S;
   input 	 LnR;

   wire [31:0] 	 left_o, right_o;

   SHIFT32_R right(.Y(right_o), .D(D), .S(S));
   SHIFT32_L left(.Y(left_o), .D(D), .S(S));

   MUX32_2x1 mux(.Y(Y), .I1(left_o), .I0(right_o), .S(LnR));

endmodule // BARREL_SHIFTER32


// Right shifter
module SHIFT32_R(Y,D,S);
   // output list
   output [31:0] Y;
   // input list
   input [31:0]  D;
   input [4:0] 	 S;

   wire [31:0] 	 L0, L1, L2, L3, L4;
   wire [31:0] 	 Y;
   
   genvar 	 i;
   
   //Level 0 of Shifter, Shift by 1-bit
   MUX1_2x1 muxL0_0(.Y(L0[31]), .I1(1'b0), .I0(D[31]), .S(S[0]));

   generate
      for(i = 30; i >= 0; i = i - 1)
	begin : mux21_L0_32_gen_loop
	   MUX1_2x1 mux_L0(.Y(L0[i]), .I1(D[i+1]), .I0(D[i]), .S(S[0]));
	end
   endgenerate
   

   //Level 1 of Shifter, Shift by 2-bits
   generate
      for(i = 31; i > 29; i = i - 1)
	begin : mux21_L1_32_gen_loop1
	   MUX1_2x1 mux_L1(.Y(L1[i]), .I1(1'b0), .I0(L0[i]), .S(S[1]));
	end
   endgenerate

   generate
      for(i = 29; i >= 0; i = i - 1)
	begin : mux21_L1_32_gen_loop2
	   MUX1_2x1 mux_L1_2(.Y(L1[i]), .I1(L0[i+2]), .I0(L0[i]), .S(S[1]));
	end
   endgenerate
   

   //Level 2 of Shifter, Shift by 4-bits
   generate
      for(i = 31; i > 27; i = i - 1)
	begin : mux21_L2_32_gen_loop1
	   MUX1_2x1 mux_L2(.Y(L2[i]), .I1(1'b0), .I0(L1[i]), .S(S[2]));
	end
   endgenerate

   generate
      for(i = 27; i >= 0; i = i - 1)
	begin : mux21_L2_32_gen_loop2
	   MUX1_2x1 mux_L2_2(.Y(L2[i]), .I1(L1[i+4]), .I0(L1[i]), .S(S[2]));
	end
   endgenerate
   

   //Level 3 of Shifter, Shift by 8-bits
   generate
      for(i = 31; i > 23; i = i - 1)
	begin : mux21_L3_32_gen_loop1
	   MUX1_2x1 mux_L3(.Y(L3[i]), .I1(1'b0), .I0(L2[i]), .S(S[3]));
	end
   endgenerate

   generate
      for(i = 23; i >= 0; i = i - 1)
	begin : mux21_L3_32_gen_loop2
	   MUX1_2x1 mux_L3_2(.Y(L3[i]), .I1(L2[i+8]), .I0(L2[i]), .S(S[3]));
	end
   endgenerate
   

   //Level 4 of Shifter, Shift by 16-bits
   generate
      for(i = 31; i > 15; i = i - 1)
	begin : mux21_L4_32_gen_loop1
	   MUX1_2x1 mux_L4(.Y(L4[i]), .I1(1'b0), .I0(L3[i]), .S(S[4]));
	end
   endgenerate

   generate
      for(i = 15; i >= 0; i = i - 1)
	begin : mux21_L4_32_gen_loop2
	   MUX1_2x1 mux_L4_2(.Y(L4[i]), .I1(L3[i+16]), .I0(L3[i]), .S(S[4]));
	end
   endgenerate

   assign Y = L4;

endmodule // SHIFT32_R


// Left shifter
module SHIFT32_L(Y,D,S);
   // output list
   output [31:0] Y;
   // input list
   input [31:0]  D;
   input [4:0] 	 S;

   wire [31:0] 	 L0, L1, L2, L3, L4;
   wire [31:0] 	 Y;
   
   genvar 	 i;
   
   //Level 0 of Shifter, Shift by 1-bit
   MUX1_2x1 muxL0_0(.Y(L0[0]), .I1(1'b0), .I0(D[0]), .S(S[0]));

   generate
      for(i = 1; i < 32; i = i + 1)
	begin : mux21_L0_32_gen_loop
	   MUX1_2x1 mux_L0(.Y(L0[i]), .I1(D[i-1]), .I0(D[i]), .S(S[0]));
	end
   endgenerate
   

   //Level 1 of Shifter, Shift by 2-bits
   generate
      for(i = 0; i < 2; i = i + 1)
	begin : mux21_L1_32_gen_loop1
	   MUX1_2x1 mux_L1(.Y(L1[i]), .I1(1'b0), .I0(L0[i]), .S(S[1]));
	end
   endgenerate

   generate
      for(i = 2; i < 32; i = i + 1)
	begin : mux21_L1_32_gen_loop2
	   MUX1_2x1 mux_L1_2(.Y(L1[i]), .I1(L0[i-2]), .I0(L0[i]), .S(S[1]));
	end
   endgenerate
   

   //Level 2 of Shifter, Shift by 4-bits
   generate
      for(i = 0; i < 4; i = i + 1)
	begin : mux21_L2_32_gen_loop1
	   MUX1_2x1 mux_L2(.Y(L2[i]), .I1(1'b0), .I0(L1[i]), .S(S[2]));
	end
   endgenerate

   generate
      for(i = 4; i < 32; i = i + 1)
	begin : mux21_L2_32_gen_loop2
	   MUX1_2x1 mux_L2_2(.Y(L2[i]), .I1(L1[i-4]), .I0(L1[i]), .S(S[2]));
	end
   endgenerate
   

   //Level 3 of Shifter, Shift by 8-bits
   generate
      for(i = 0; i < 8; i = i + 1)
	begin : mux21_L3_32_gen_loop1
	   MUX1_2x1 mux_L3(.Y(L3[i]), .I1(1'b0), .I0(L2[i]), .S(S[3]));
	end
   endgenerate

   generate
      for(i = 8; i < 32; i = i + 1)
	begin : mux21_L3_32_gen_loop2
	   MUX1_2x1 mux_L3_2(.Y(L3[i]), .I1(L2[i-8]), .I0(L2[i]), .S(S[3]));
	end
   endgenerate
   

   //Level 4 of Shifter, Shift by 16-bits
   generate
      for(i = 0; i < 16; i = i + 1)
	begin : mux21_L4_32_gen_loop1
	   MUX1_2x1 mux_L4(.Y(L4[i]), .I1(1'b0), .I0(L3[i]), .S(S[4]));
	end
   endgenerate

   generate
      for(i = 16; i < 32; i = i + 1)
	begin : mux21_L4_32_gen_loop2
	   MUX1_2x1 mux_L4_2(.Y(L4[i]), .I1(L3[i-16]), .I0(L3[i]), .S(S[4]));
	end
   endgenerate

   assign Y = L4;

endmodule // SHIFT32_L


