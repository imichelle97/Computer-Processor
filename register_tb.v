`timescale 1ns/1ps

module register_tb;
 //reg CLK, LOAD, RESET;
 //reg [31:0] D;
   reg [4:0]  dec_in;
   
 //wire [31:0] Q;
   wire [31:0] dec_out;
   
      
 //REG32 reg_inst(.Q(Q), .D(D), .LOAD(LOAD), .CLK(CLK), .RESET(RESET));
   DECODER_5x32 dec_inst(.D(dec_out), .I(dec_in));
      
   
   initial
     begin
	dec_in = 5'd0;
	#5
	  dec_in = 5'd1;
	#5
	  dec_in = 5'd2;
	#5
	  dec_in = 5'd3;
	#5
	  dec_in = 5'd4;
	#5
	  dec_in = 5'd5;
	#5
	  dec_in = 5'd6;
	#5
	  dec_in = 5'd7;
	#5
	  dec_in = 5'd8;
	#5
	  dec_in = 5'd9;
	#5
	  dec_in = 5'd10;
	#5
	  dec_in = 5'd11;
	#5
	  dec_in = 5'd12;
	#5
	  dec_in = 5'd13;
	#5
	  dec_in = 5'd14;
	#5
	  dec_in = 5'd15;
	#5
	  dec_in = 5'd16;
	#5
	  dec_in = 5'd17;
	#5
	  dec_in = 5'd18;
	#5
	  dec_in = 5'd19;
	#5
	  dec_in = 5'd20;
	#5
	  dec_in = 5'd21;
	#5
	  dec_in = 5'd22;
	#5
	  dec_in = 5'd23;
	#5
	  dec_in = 5'd24;
	#5
	  dec_in = 5'd25;
	#5
	  dec_in = 5'd26;
	#5
	  dec_in = 5'd27;
	#5
	  dec_in = 5'd28;
	#5
	  dec_in = 5'd29;
	#5
	  dec_in = 5'd30;
	#5
	  dec_in = 5'd31;
	#5
	  dec_in = 5'd0;
	
	
	
	
	
/* -----\/----- EXCLUDED -----\/-----
	CLK = 1'b0;
	LOAD = 1'b0;
	RESET = 1'b1;
	D = 32'haaaa_aaaa;

	#5
	  RESET = 1'b0;
	#5
	  RESET = 1'b1;
	#5
	  CLK = 1'b1;
	#5
	  CLK = 1'b0;
	#5
	  LOAD = 1'b1;
	#5
	  CLK = 1'b1;
	#5
	  CLK = 1'b0;
	#5
	  D = 32'h5555_5555;
	  LOAD = 1'b0;
	#5
	  CLK = 1'b1;
	#5
	  CLK = 1'b0;
	#5
	  LOAD = 1'b1;
	#5
	  CLK = 1'b1;
	  LOAD = 1'b0;
	#5
	  CLK = 1'b0;
	#5
	  CLK = 1'b1;
	#5
	  CLK = 1'b0;
 -----/\----- EXCLUDED -----/\----- */
	
     end

endmodule
