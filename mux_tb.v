`timescale 1ns/1ps

module mux_tb;
   reg [31:0] I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12,
	      I13, I14, I15, I16, I17, I18, I19, I20, I21, I22, I23,
	      I24, I25, I26, I27, I28, I29, I30, I31;
   reg [4:0]  S;

   wire [31:0] Y_4x1, Y_8x1, Y_16x1, Y_32x1;

   MUX32_4x1 mux_4x1(.Y(Y_4x1), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .S(S[1:0])); 

   MUX32_8x1 mux_8x1(.Y(Y_8x1), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4),
		     .I5(I5), .I6(I6), .I7(I7), .S(S[2:0]));
   
   MUX32_16x1 mux_16x1(.Y(Y_16x1), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4),
		       .I5(I5), .I6(I6), .I7(I7),.I8(I8), .I9(I9), .I10(I10),
		       .I11(I11), .I12(I12), .I13(I13),.I14(I14), .I15(I15), .S(S[3:0]));

   MUX32_32x1 mux_32x1(.Y(Y_32x1), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4),
		       .I5(I5), .I6(I6), .I7(I7),.I8(I8), .I9(I9), .I10(I10),
		       .I11(I11), .I12(I12), .I13(I13),.I14(I14), .I15(I15), 
		       .I16(I16), .I17(I17), .I18(I18),.I19(I19), .I20(I20),
		       .I21(I21), .I22(I22), .I23(I23),.I24(I24), .I25(I25),
		       .I26(I26), .I27(I27), .I28(I28),.I29(I29), .I30(I30),
		       .I31(I31), .S(S[4:0]));
     

   initial
     begin
	I0 = 32'h1111_1111;
	I1 = 32'h2222_2222;
	I2 = 32'h3333_3333;
	I3 = 32'h4444_4444;
	I4 = 32'h5555_5555;
	I5 = 32'h6666_6666;
	I6 = 32'h7777_7777;
	I7 = 32'h8888_8888;
	I8 = 32'h9999_9999;
	I9 = 32'haaaa_aaaa;
	I10 = 32'hbbbb_bbbb;
	I11 = 32'hcccc_cccc;
	I12 = 32'hdddd_dddd;
	I13 = 32'heeee_eeee;
	I14 = 32'hffff_ffff;
	I15 = 32'h1000_1000;
	I16 = 32'h1001_1001;
	I17 = 32'h1002_1002;
	I18 = 32'h1003_1003;
	I19 = 32'h1004_1004;
	I20 = 32'h1005_1005;
	I21 = 32'h1006_1006;
	I22 = 32'h1007_1007;
	I23 = 32'h1008_1008;
	I24 = 32'h1009_1009;
	I25 = 32'h100a_100a;
	I26 = 32'h100b_100b;
	I27 = 32'h100c_100c;
	I28 = 32'h100d_100d;
	I29 = 32'h100e_100e;
	I30 = 32'h100f_100f;
	I31 = 32'h1010_1010;
	S = 5'h0;
	
	#5 S    = 5'h1; 
	#5 S    = 5'h2;  
	#5 S    = 5'h3; 
	#5 S    = 5'h4;
	#5 S    = 5'h5; 
	#5 S    = 5'h6;  
	#5 S    = 5'h7; 
	#5 S    = 5'h8;
	#5 S    = 5'h9; 
	#5 S    = 5'ha;  
	#5 S    = 5'hb; 
	#5 S    = 5'hc;
	#5 S    = 5'hd; 
	#5 S    = 5'he;  
	#5 S    = 5'hf; 
	#5 S    = 5'h10;
	#5 S    = 5'h11; 
	#5 S    = 5'h12;  
	#5 S    = 5'h13; 
	#5 S    = 5'h14;
	#5 S    = 5'h15; 
	#5 S    = 5'h16;  
	#5 S    = 5'h17; 
	#5 S    = 5'h18;
	#5 S    = 5'h19; 
	#5 S    = 5'h1a;  
	#5 S    = 5'h1b; 
	#5 S    = 5'h1c;
	#5 S    = 5'h1d; 
	#5 S    = 5'h1e;  
	#5 S    = 5'h1f; 
	#5 S    = 5'h0;
	
     end

endmodule

