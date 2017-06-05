// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
// Output: OUT[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
   // input list
   input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
   input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
   input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

   // output list
   output [`DATA_INDEX_LIMIT:0]    OUT; // result of the operation.
   output 			   ZERO;

   wire [31:0] 			   mul_out, shift_out, rc_out, and_out, or_out, nor_out;
   wire 			   not_out, or_gate_out, and_gate_out;
   

   //Multiplier
   MULT32 mult32(.HI(), .LO(mul_out[31:0]), .A(OP1[31:0]), .B(OP2[31:0]));

   //Shifter
   BARREL_SHIFTER32 shifter(.Y(shift_out[31:0]), .D(OP1[31:0]), .S(OP2[4:0]), .LnR(OPRN[0]));

   not not_inst(not_out, OPRN[0]);
   and and_gate_inst(and_gate_out, OPRN[3], OPRN[0]);
   or or_gate_inst(or_gate_out, not_out, and_gate_out);
   
   //Ripple Carry Adder/Subtracter
   RC_ADD_SUB_32 rc32(.Y(rc_out[31:0]), .CO(), .A(OP1[31:0]), .B(OP2[31:0]), .SnA(or_gate_out));

   //AND Logic
   AND32_2x1 and_inst(.Y(and_out[31:0]), .A(OP1[31:0]), .B(OP2[31:0]));

   //OR Logic
   OR32_2x1 or_inst(.Y(or_out[31:0]), .A(OP1[31:0]), .B(OP2[31:0]));

   //NOR Logic
   NOR32_2x1 nor_inst(.Y(nor_out[31:0]), .A(OP1[31:0]), .B(OP2[31:0]));

   //ALU Result MUX
   MUX32_16x1 alu_mux(.Y(OUT[31:0]),
		      .I0(32'hzzzz_zzzz),
		      .I1(rc_out[31:0]),
		      .I2(rc_out[31:0]),
		      .I3(mul_out[31:0]),
		      .I4(shift_out[31:0]),
		      .I5(shift_out[31:0]),
		      .I6(and_out[31:0]),
		      .I7(or_out[31:0]),
		      .I8(nor_out[31:0]),
		      .I9({31'h0,rc_out[31]}),
		      .I10(32'hzzzz_zzzz),
		      .I11(32'hzzzz_zzzz),
		      .I12(32'hzzzz_zzzz),
		      .I13(32'hzzzz_zzzz),
		      .I14(32'hzzzz_zzzz),
		      .I15(32'hzzzz_zzzz),
		      .S(OPRN[3:0]));

   NOR32_1x1 nor32(.Y(ZERO), .I(OUT[31:0]));      

endmodule // ALU