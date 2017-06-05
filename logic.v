// Name: logic.v
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

//32-bit two's complement
module TWOSCOMP32(Y,A);

   input [31:0] A;

   output [31:0] Y;

   wire [31:0] 	 inv_o;

   NOT32 not_inst(.Y(inv_o), .A(A));
   RC_ADD_SUB_32 adder_inst(.Y(Y), .CO(), .A(inv_o), .B(32'h1), .SnA(1'b0));

endmodule

//64-bit two's complement
module TWOSCOMP64(Y,A);

   input [63:0] A;

   output [63:0] Y;

   wire [63:0] 	 inv_o;
   wire 	 co_31;

   NOT32 not_inst0 (.Y(inv_o[63:32]), .A(A[63:32]));
   NOT32 not_inst1 (.Y(inv_o[31:0]), .A(A[31:0]));

   RC_ADD_SUB_32 adder_inst0(.Y(Y[31:0]), 
                          .CO(co_31), .A(inv_o[31:0]), .B(32'h1), .SnA(1'b0));
   RC_ADD_SUB_32 adder_inst1(.Y(Y[63:32]), .CO(), .A(inv_o[63:32]), 
                          .B({{31{1'b0}},co_31}), .SnA(1'b0));

endmodule // TWOSCOMP64


// 32-bit registere +ve edge, Reset on RESET=0
module REG32(Q, D, LOAD, CLK, RESET);
   output [31:0] Q;

   input 	 CLK, LOAD;
   input [31:0]  D;
   input 	 RESET;

   genvar 	 i;

   generate
      for(i = 0; i < 32; i = i + 1)
	begin : reg32_gen_loop
	   REG1 reg1_inst(.Q(Q[i]), .Qbar(), .D(D[i]), .L(LOAD), .C(CLK), .nP(1'b1), .nR(RESET));
	end
   endgenerate   

endmodule // REG32


// 1 bit register +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module REG1(Q, Qbar, D, L, C, nP, nR);
   input D, C, L;
   input nP, nR;
   output Q,Qbar;

   wire   mux_o;

   MUX1_2x1 mux1(.Y(mux_o), .I0(Q), .I1(D), .S(L));
   D_FF dff_inst(.Q(Q), .Qbar(Qbar), .D(mux_o), .C(C), .nP(nP), .nR(nR));

endmodule // REG1


// 1 bit flipflop +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_FF(Q, Qbar, D, C, nP, nR);
   input D, C;
   input nP, nR;
   output Q,Qbar;

   wire   Y, Ybar;
   wire   Cbar;

   not not_inst(Cbar, C);   

   D_LATCH dlatch_inst(.Q(Y), .Qbar(Ybar), .D(D), .C(Cbar), .nP(nP), .nR(nR));
   SR_LATCH srlatch_inst(.Q(Q), .Qbar(Qbar), .S(Y), .R(Ybar), .C(C), .nP(nP), .nR(nR));

endmodule // D_FF


// 1 bit D latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_LATCH(Q, Qbar, D, C, nP, nR);
   input D, C;
   input nP, nR;
   output Q,Qbar;

   wire   nand1_o, nand2_o, not_o;
   
   not not_inst(not_o, D);
   nand nand1_inst(nand1_o, D, C);
   nand nand2_inst(nand2_o, not_o, C);
   nand nand3_inst(Q, nand1_o, nP, Qbar);
   nand nand4_inst(Qbar, nand2_o, nR, Q);  

endmodule // D_LATCH


// 1 bit SR latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module SR_LATCH(Q,Qbar, S, R, C, nP, nR);
   input S, R, C;
   input nP, nR;
   output Q,Qbar;

   wire   nand1_o, nand2_o;

   nand nand1_inst(nand1_o, S, C);
   nand nand2_inst(nand2_o, R, C);
   nand nand3_inst(Q, nand1_o, nP, Qbar);
   nand nand4_inst(Qbar, nand2_o, nR, Q);
   
endmodule // SR_LATCH


// 5x32 Line decoder
module DECODER_5x32(D,I);
   // output
   output [31:0] D;
   // input
   input [4:0] 	 I;

   wire [15:0] 	 Y;
   wire 	 not4_o;

   not not4(not4_o, I[4]);
   DECODER_4x16 d4x16_inst(.D(Y[15:0]), .I(I[3:0]));

   genvar 	 i;
   generate
      for(i = 0; i < 16; i = i + 1)
	begin : d5x32_gen_loop
	   and and_inst1(D[i], Y[i], not4_o);
	   and and_inst2(D[i+16], Y[i], I[4]);
	end
   endgenerate
   

endmodule // DECODER_5x32


// 4x16 Line decoder
module DECODER_4x16(D,I);
   // output
   output [15:0] D;
   // input
   input [3:0] 	 I;

   wire [7:0] 	 Y;
   wire 	 not3_o;

   not not3(not3_o, I[3]);
   DECODER_3x8 d3x8_inst(.D(Y[7:0]), .I(I[2:0]));

   genvar 	 i;
   generate
      for(i = 0; i < 8; i = i + 1)
	begin : d4x16_gen_loop
	   and and_inst1(D[i], Y[i], not3_o);
	   and and_inst2(D[i+8], Y[i], I[3]);
	end
   endgenerate

endmodule // DECODER_4x16


// 3x8 Line decoder
module DECODER_3x8(D,I);
   // output
   output [7:0] D;
   // input
   input [2:0] 	I;

   wire [3:0] 	Y;
   wire 	not2_o;

   not not2(not2_o, I[2]);
   DECODER_2x4 d2x4_inst(.D(Y[3:0]), .I(I[1:0]));

   and and0(D[0], Y[0], not2_o);
   and and1(D[1], Y[1], not2_o);
   and and2(D[2], Y[2], not2_o);
   and and3(D[3], Y[3], not2_o);
   
   and and4(D[4], Y[0], I[2]);
   and and5(D[5], Y[1], I[2]);
   and and6(D[6], Y[2], I[2]);
   and and7(D[7], Y[3], I[2]);

endmodule // DECODER_3x8


// 2x4 Line decoder
module DECODER_2x4(D,I);
   // output
   output [3:0] D;
   // input
   input [1:0] 	I;

   wire 	not0_o, not1_o;

   not not0(not0_o, I[0]);
   not not1(not1_o, I[1]);

   and and0(D[0], not0_o, not1_o);
   and and1(D[1], not1_o, I[0]);
   and and2(D[2], I[1], not0_o);
   and and3(D[3], I[1], I[0]);
   
endmodule // DECODER_2x4


module REG32_PP(Q, D, LOAD, CLK, RESET);
   parameter PATTERN = 32'h00000000;

   output [31:0] Q;

   input 	 CLK, LOAD;
   input [31:0]  D;
   input 	 RESET;

   wire [31:0] 	 qbar;

   genvar 	 i;
   generate
      for(i = 0; i < 32; i = i + 1)
	begin : reg32_gen_loop
	   if(PATTERN[i] == 0)
	     REG1 reg_inst(.Q(Q[i]), .Qbar(qbar[i]), .D(D[i]), .L(LOAD), .C(CLK), .nP(1'b1), .nR(RESET));
	   else
	     REG1 reg_inst(.Q(Q[i]), .Qbar(qbar[i]), .D(D[i]), .L(LOAD), .C(CLK), .nP(RESET), .nR(1'b1));
	end
   endgenerate
endmodule // REG32_PP

   
	   
	     
   
   
   


