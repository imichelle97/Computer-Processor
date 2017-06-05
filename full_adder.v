// Name: full_adder.v
// Module: FULL_ADDER
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module FULL_ADDER(S, CO, A, B, CI);
   input A, B, CI;
   output S, CO;
   
   wire   ha_1_s, ha_1_c;
   wire   ha_2_c;
   
   HALF_ADDER ha_1(.Y(ha_1_s), .C(ha_1_c), .A(A), .B(B));
   HALF_ADDER ha_2(.Y(S), .C(ha_2_c), .A(ha_1_s), .B(CI));
   

   //HALF_ADDER ha_1 (ha_1_s, ha_1_c, A, B);
   //HALF_ADDER ha_2 (S, ha_2_c, ha_1_y, CI);

   or fa_or(CO, ha_2_c, ha_1_c);
   
endmodule