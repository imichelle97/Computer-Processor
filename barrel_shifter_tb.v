`timescale 1ns/1ps

module barrel_shifter_tb;
   reg [31:0] D_left, D_right;
   reg [4:0]  S;
   
   wire [31:0] Y_left, Y_right;
      
   SHIFT32_L shift32_l(.Y(Y_left), .D(D_left), .S(S));
   SHIFT32_R shift32_r(.Y(Y_right), .D(D_right), .S(S));
   
   
   initial
     begin
	S = 5'h0;
	D_left = 32'h1;
	D_right = 32'h8000_0000;
	#5 S = 5'h1;
	#5 S = 5'h2;
	#5 S = 5'h3;
	#5 S = 5'h4;
	#5 S = 5'h5;
	#5 S = 5'h6;
	#5 S = 5'h7;
	#5 S = 5'h8;
	#5 S = 5'h9;
	#5 S = 5'ha;
	#5 S = 5'hb;
	#5 S = 5'hc;
	#5 S = 5'hd;
	#5 S = 5'he;
	#5 S = 5'hf;
	#5 S = 5'h10;
	#5 S = 5'h11;
	#5 S = 5'h12;
	#5 S = 5'h13;
	#5 S = 5'h14;
	#5 S = 5'h15;
	#5 S = 5'h16;
	#5 S = 5'h17;
	#5 S = 5'h18;
	#5 S = 5'h19;
	#5 S = 5'h1a;
	#5 S = 5'h1b;
	#5 S = 5'h1c;
	#5 S = 5'h1d;
	#5 S = 5'h1e;
	#5 S = 5'h1f;
	#5 S = 5'h0;

	

     end

endmodule
