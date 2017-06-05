// Name: mux.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------

//1-bit 2x1 mux
module MUX1_2x1(Y,I0,I1,S);
   
   input I0, I1, S;
   
   output Y;
   
   wire   inv_o, and1_o, and2_o;
   
   not inv_inst(inv_o, S);
   and and1_inst(and1_o, I0, inv_o);
   and and2_inst(and2_o, I1, S);
   or or_inst(Y, and1_o, and2_o);
   
endmodule // MUX1_2x1

//5-bit 2x1 mux
module MUX5_2x1(Y,I0,I1,S);
   
   input [4:0] I0, I1;
   input 	S;
   
   output [4:0] Y;
   
   genvar 	 i;
   generate 
      for(i = 0; i < 5; i = i + 1)
	begin : mux21_5_gen_loop
	   MUX1_2x1 mux21_5_inst(.Y(Y[i]), .I0(I0[i]), .I1(I1[i]), .S(S));
	end
   endgenerate
   
endmodule // MUX5_2x1


//32-bit 2x1 mux
module MUX32_2x1(Y,I0,I1,S);
   
   input [31:0] I0, I1;
   input 	S;
   
   output [31:0] Y;
   
   genvar 	 i;
   generate 
      for(i = 0; i < 32; i = i + 1)
	begin : mux21_32_gen_loop
	   MUX1_2x1 mux21_32_inst(.Y(Y[i]), .I0(I0[i]), .I1(I1[i]), .S(S));
	end
   endgenerate
   
endmodule


//64-bit 2x1 mux
module MUX64_2x1(Y,I0,I1,S);
   
   input [63:0] I0, I1;
   input 	S;
   
   output [63:0] Y;
   
   genvar 	 i;
   generate 
      for(i = 0; i < 64; i = i + 1)
	begin : mux21_64_gen_loop
	   MUX1_2x1 mux21_64_inst(.Y(Y[i]), .I0(I0[i]), .I1(I1[i]), .S(S));
	end
   endgenerate
   
endmodule // MUX64_2x1


//32-bit 4x1 mux
module MUX32_4x1(Y, I0, I1, I2, I3, S);
   
   input [31:0] I0, I1, I2, I3;
   input [1:0] 	S;
   
   output [31:0] Y;
   
   wire [31:0] 	 mux1_o, mux2_o;
   
   
   MUX32_2x1 mux1(.Y(mux1_o), .I0(I0), .I1(I1), .S(S[0]));
   MUX32_2x1 mux2(.Y(mux2_o), .I0(I2), .I1(I3), .S(S[0]));
   MUX32_2x1 mux3(.Y(Y), .I0(mux1_o),.I1(mux2_o), .S(S[1]));
   
endmodule // MUX32_4x1


//32-bit 8x1 mux
module MUX32_8x1(Y, I0, I1, I2, I3, I4, I5, I6, I7, S);
   // output list
   output [31:0] Y;
   //input list
   input [31:0]  I0;
   input [31:0]  I1;
   input [31:0]  I2;
   input [31:0]  I3;
   input [31:0]  I4;
   input [31:0]  I5;
   input [31:0]  I6;
   input [31:0]  I7;
   input [2:0] 	 S;
   
   wire [31:0] 	 mux1_o, mux2_o;
   
   MUX32_4x1 mux1(.Y(mux1_o), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .S(S[1:0]));
   MUX32_4x1 mux2(.Y(mux2_o), .I0(I4), .I1(I5), .I2(I6), .I3(I7), .S(S[1:0]));
   MUX32_2x1 mux3(.Y(Y), .I0(mux1_o), .I1(mux2_o), .S(S[2]));
   
endmodule // MUX32_8x1


// 32-bit 16x1 mux
module MUX32_16x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15, S);
   // output list
   output [31:0] Y;
   //input list
   input [31:0]  I0;
   input [31:0]  I1;
   input [31:0]  I2;
   input [31:0]  I3;
   input [31:0]  I4;
   input [31:0]  I5;
   input [31:0]  I6;
   input [31:0]  I7;
   input [31:0]  I8;
   input [31:0]  I9;
   input [31:0]  I10;
   input [31:0]  I11;
   input [31:0]  I12;
   input [31:0]  I13;
   input [31:0]  I14;
   input [31:0]  I15;
   input [3:0] 	 S;

   wire [31:0] 	 mux1_o, mux2_o;

   MUX32_8x1 mux1(.Y(mux1_o), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5), .I6(I6), .I7(I7), .S(S[2:0]));
   MUX32_8x1 mux2(.Y(mux2_o), .I0(I8), .I1(I9), .I2(I10), .I3(I11), .I4(I12), .I5(I13), .I6(I14), .I7(I15), .S(S[2:0]));
   MUX32_2x1 mux3(.Y(Y), .I0(mux1_o), .I1(mux2_o), .S(S[3]));

endmodule // MUX32_16x1


// 32-bit mux
module MUX32_32x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15,
                     I16, I17, I18, I19, I20, I21, I22, I23,
                     I24, I25, I26, I27, I28, I29, I30, I31, S);
   // output list
   output [31:0] Y;
   //input list
   input [31:0]  I0, I1, I2, I3, I4, I5, I6, I7;
   input [31:0]  I8, I9, I10, I11, I12, I13, I14, I15;
   input [31:0]  I16, I17, I18, I19, I20, I21, I22, I23;
   input [31:0]  I24, I25, I26, I27, I28, I29, I30, I31;
   input [4:0] 	 S;
   
   wire [31:0] 	 mux1_o, mux2_o;
   
   MUX32_16x1 mux1(.Y(mux1_o), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5), .I6(I6), .I7(I7),
		   .I8(I8), .I9(I9), .I10(I10), .I11(I11), .I12(I12), .I13(I13), .I14(I14), .I15(I15),
		   .S(S[3:0]));
   
   MUX32_16x1 mux2(.Y(mux2_o), .I0(I16), .I1(I17), .I2(I18), .I3(I19), .I4(I20), .I5(I21), .I6(I22), .I7(I23),
		   .I8(I24), .I9(I25), .I10(I26), .I11(I27), .I12(I28), .I13(I29), .I14(I30), .I15(I31),
		   .S(S[3:0]));
   
   MUX32_2x1 mux3(.Y(Y), .I0(mux1_o), .I1(mux2_o), .S(S[4]));
   
endmodule // MUX32_32x1

   

   

