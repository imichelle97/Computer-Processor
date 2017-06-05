`timescale 1ns/1ps

module barrel_shifter_tb2;
   reg [31:0] D;
   reg [31:0] S;
   reg  LnR;   
      
   wire [31:0] Y;      
  
   SHIFT32 shift32(.Y(Y), .D(D), .S(S), .LnR(LnR));   
   
   
   initial
     begin
	S = 32'h0;
	D = 32'h1;
	LnR = 1'b1;
	
	#5 S = 32'h1;
	#5 S = 32'h2;
	#5 S = 32'h3;
	#5 S = 32'h4;
	#5 S = 32'h5;
	#5 S = 32'h6;
	#5 S = 32'h7;
	#5 S = 32'h8;
	#5 S = 32'h9;
	#5 S = 32'ha;
	#5 S = 32'hb;
	#5 S = 32'hc;
	#5 S = 32'hd;
	#5 S = 32'he;
	#5 S = 32'hf;
	#5 S = 32'h10;
	#5 S = 32'h11;
	#5 S = 32'h12;
	#5 S = 32'h13;
	#5 S = 32'h14;
	#5 S = 32'h15;
	#5 S = 32'h16;
	#5 S = 32'h17;
	#5 S = 32'h18;
	#5 S = 32'h19;
	#5 S = 32'h1a;
	#5 S = 32'h1b;
	#5 S = 32'h1c;
	#5 S = 32'h1d;
	#5 S = 32'h1e;
	#5 S = 32'h1f;
	#5 S = 32'h0;

	D = 32'h8000_0000;
	LnR = 1'b0;
	
	#5 S = 32'h1;
	#5 S = 32'h2;
	#5 S = 32'h3;
	#5 S = 32'h4;
	#5 S = 32'h5;
	#5 S = 32'h6;
	#5 S = 32'h7;
	#5 S = 32'h8;
	#5 S = 32'h9;
	#5 S = 32'ha;
	#5 S = 32'hb;
	#5 S = 32'hc;
	#5 S = 32'hd;
	#5 S = 32'he;
	#5 S = 32'hf;
	#5 S = 32'h10;
	#5 S = 32'h11;
	#5 S = 32'h12;
	#5 S = 32'h13;
	#5 S = 32'h14;
	#5 S = 32'h15;
	#5 S = 32'h16;
	#5 S = 32'h17;
	#5 S = 32'h18;
	#5 S = 32'h19;
	#5 S = 32'h1a;
	#5 S = 32'h1b;
	#5 S = 32'h1c;
	#5 S = 32'h1d;
	#5 S = 32'h1e;
	#5 S = 32'h1f;
	#5 S = 32'h0;

	#5 S = 32'h5f;
	#5 S = 32'h7f;
	#5 S = 32'hfff_ffe2;
	#5 S = 32'h0;
	

     end

endmodule
