// Name: logic_32_bit.v
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
//
//4-bit NOR
module NOR4_1x1(Y, I);
   input [3:0] I;
   output      Y;

   wire        nor1_o, nor2_o;

   nor nor1(nor1_o, I[0], I[1]);
   nor nor2(nor2_o, I[2], I[3]);
   and  and3(Y, nor1_o, nor2_o);
   
endmodule // NOR4_1x1

//8-bit NOR
module NOR8_1x1(Y, I);
   input [7:0] I;
   output      Y;

   wire        nor1_o, nor2_o;

   NOR4_1x1 nor1(nor1_o, I[3:0]);
   NOR4_1x1 nor2(nor2_o, I[7:4]);
   and and3(Y, nor1_o, nor2_o);
   
endmodule // NOR8_1x1

//16-bit NOR
module NOR16_1x1(Y, I);
   input [15:0] I;
   output      Y;

   wire        nor1_o, nor2_o;

   NOR8_1x1 nor1(nor1_o, I[7:0]);
   NOR8_1x1 nor2(nor2_o, I[15:8]);
   and and3(Y, nor1_o, nor2_o);
   
endmodule // NOR16_1x1
   
//32-bit 1 output NOR
module NOR32_1x1(Y, I);
   input [31:0] I;
   output      Y;

   wire        nor1_o, nor2_o;

   NOR16_1x1 nor1(nor1_o, I[15:0]);
   NOR16_1x1 nor2(nor2_o, I[31:16]);
   and and3(Y, nor1_o, nor2_o);
   
endmodule // NOR32_1x1


//4-bit OR
module OR4_1x1(Y, I);
   input [3:0] I;
   output      Y;

   wire        or1_o, or2_o;

   or or1(or1_o, I[0], I[1]);
   or or2(or2_o, I[2], I[3]);
   or or3(Y, or1_o, or2_o);
   
endmodule // OR4_1x1

//8-bit OR
module OR8_1x1(Y, I);
   input [7:0] I;
   output      Y;

   wire        or1_o, or2_o;

   OR4_1x1 or1(or1_o, I[3:0]);
   OR4_1x1 or2(or2_o, I[7:4]);
   or or3(Y, or1_o, or2_o);
   
endmodule // OR8_1x1

//16-bit OR
module OR16_1x1(Y, I);
   input [15:0] I;
   output      Y;

   wire        or1_o, or2_o;

   OR8_1x1 or1(or1_o, I[7:0]);
   OR8_1x1 or2(or2_o, I[15:8]);
   or or3(Y, or1_o, or2_o);
   
endmodule // OR16_1x1
   
//32-bit 1 output OR
module OR32_1x1(Y, I);
   input [31:0] I;
   output      Y;

   wire        or1_o, or2_o;

   OR16_1x1 or1(or1_o, I[15:0]);
   OR16_1x1 or2(or2_o, I[31:16]);
   or or3(Y, or1_o, or2_o);
   
endmodule // OR32_1x1


//32-bit OR
module OR32_2x1(Y,A,B);

input [31:0] A;
input [31:0] B;

output [31:0] Y;

genvar i;
generate 
	for(i = 0; i < 32; i = i + 1)
	begin : or32_gen_loop
		or or_inst(Y[i], A[i], B[i]);
	end
endgenerate

endmodule

//32-bit NOR
module NOR32_2x1(Y,A,B);

input [31:0] A;
input [31:0] B;

output [31:0] Y;

genvar i;
generate 
	for(i = 0; i < 32; i = i + 1)
	begin : nor32_gen_loop
		nor nor_inst(Y[i], A[i], B[i]);
	end
endgenerate

endmodule

//32-bit AND
module AND32_2x1(Y,A,B);

input [31:0] A;
input [31:0] B;

output [31:0] Y;

genvar i;
generate 
	for(i = 0; i < 32; i = i + 1)
	begin : and32_gen_loop
		and and_inst(Y[i], A[i], B[i]);
	end
endgenerate

endmodule

//NAND MODULE
module NAND32(Y,A,B);

input [31:0] A;
input [31:0] B;

output [31:0] Y;

genvar i;
generate 
	for(i = 0; i < 32; i = i + 1)
	begin : nand32_gen_loop
		nand nand_inst(Y[i], A[i], B[i]);
	end
endgenerate

endmodule

//XOR MODULE
module XOR32(Y,A,B);

input [31:0] A;
input [31:0] B;

output [31:0] Y;

genvar i;
generate 
	for(i = 0; i < 32; i = i + 1)
	begin : xor32_gen_loop
		xor xor_inst(Y[i], A[i], B[i]);
	end
endgenerate

endmodule

//XNOR MODULE
module XNOR32(Y,A,B);

input [31:0] A;
input [31:0] B;

output [31:0] Y;

genvar i;
generate 
	for(i = 0; i < 32; i = i + 1)
	begin : xnor32_gen_loop
		xnor xnor_inst(Y[i], A[i], B[i]);
	end
endgenerate

endmodule

//BUF MODULE
module BUF32(Y,A);

input [31:0] A;

output [31:0] Y;

genvar i;
generate 
	for(i = 0; i < 32; i = i + 1)
	begin : buf32_gen_loop
		buf buf_inst(Y[i], A[i]);
	end
endgenerate

endmodule

//32-bit NOT
module NOT32(Y,A);

input [31:0] A;

output [31:0] Y;

genvar i;
generate 
	for(i = 0; i < 32; i = i + 1)
	begin : not32_gen_loop
		not not_inst(Y[i], A[i]);
	end
endgenerate

endmodule // NOT32


//32-bit Inverter
module INV32_1x1(Y,A);

input [31:0] A;

output [31:0] Y;

genvar i;
generate 
	for(i = 0; i < 32; i = i + 1)
	begin : not32_gen_loop
		not not_inst(Y[i], A[i]);
	end
endgenerate

endmodule






