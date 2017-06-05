// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Input:  DATA_W : Data to be written at address ADDR_W
//         ADDR_W : Address of the memory location to be written
//         ADDR_R1 : Address of the memory location to be read for DATA_R1
//         ADDR_R2 : Address of the memory location to be read for DATA_R2
//         READ    : Read signal
//         WRITE   : Write signal
//         CLK     : Clock signal
//         RST     : Reset signal
// Output: DATA_R1 : Data at ADDR_R1 address
//         DATA_R2 : Data at ADDR_R1 address
//
// Notes: - 32 bit word accessible dual read register file having 32 regsisters.
//        - Reset is done at -ve edge of the RST signal
//        - Rest of the operation is done at the +ve edge of the CLK signal
//        - Read operation is done if READ=1 and WRITE=0
//        - Write operation is done if WRITE=1 and READ=0
//        - X is the value at DATA_R* if both READ and WRITE are 0 or 1
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"

// This is going to be +ve edge clock triggered register file.
// Reset on RST=0
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                           DATA_W, ADDR_W, READ, WRITE, CLK, RST);

   // input list
   input READ, WRITE, CLK, RST;
   input [`DATA_INDEX_LIMIT:0] DATA_W;
   input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;

   // output list
   output [`DATA_INDEX_LIMIT:0]    DATA_R1;
   output [`DATA_INDEX_LIMIT:0]    DATA_R2;

   wire [31:0] 			   D;
   wire [31:0] 			   RF[0:31];
   wire [31:0] 			   load;
   wire [31:0] 			   r1_mux_o, r2_mux_o;
   
   
   
   DECODER_5x32 d5x32_inst(.D(D[31:0]), .I(ADDR_W));

   genvar 			   i;
   generate
      for(i = 0; i < 32; i = i + 1)
	begin : rfile_gen_loop
	   and and_inst(load[i], D[i], WRITE);  //Register load gated by write signal
	   REG32 reg_inst(.Q(RF[i]), .D(DATA_W), .LOAD(load[i]), .CLK(CLK), .RESET(RST));
	end
   endgenerate

   MUX32_32x1 r1_mux(.Y(r1_mux_o),
		     .I0(RF[0]),
		     .I1(RF[1]),
		     .I2(RF[2]),
		     .I3(RF[3]),
		     .I4(RF[4]),
		     .I5(RF[5]),
		     .I6(RF[6]),
		     .I7(RF[7]),
		     .I8(RF[8]),
		     .I9(RF[9]),
		     .I10(RF[10]),
		     .I11(RF[11]),
		     .I12(RF[12]),
		     .I13(RF[13]),
		     .I14(RF[14]),
		     .I15(RF[15]),
		     .I16(RF[16]),
		     .I17(RF[17]),
		     .I18(RF[18]),
		     .I19(RF[19]),
		     .I20(RF[20]),
		     .I21(RF[21]),
		     .I22(RF[22]),
		     .I23(RF[23]),
		     .I24(RF[24]),
		     .I25(RF[25]),
		     .I26(RF[26]),
		     .I27(RF[27]),
		     .I28(RF[28]),
		     .I29(RF[29]),
		     .I30(RF[30]),
		     .I31(RF[31]),
		     .S(ADDR_R1));

   MUX32_32x1 r2_mux(.Y(r2_mux_o),
		     .I0(RF[0]),
		     .I1(RF[1]),
		     .I2(RF[2]),
		     .I3(RF[3]),
		     .I4(RF[4]),
		     .I5(RF[5]),
		     .I6(RF[6]),
		     .I7(RF[7]),
		     .I8(RF[8]),
		     .I9(RF[9]),
		     .I10(RF[10]),
		     .I11(RF[11]),
		     .I12(RF[12]),
		     .I13(RF[13]),
		     .I14(RF[14]),
		     .I15(RF[15]),
		     .I16(RF[16]),
		     .I17(RF[17]),
		     .I18(RF[18]),
		     .I19(RF[19]),
		     .I20(RF[20]),
		     .I21(RF[21]),
		     .I22(RF[22]),
		     .I23(RF[23]),
		     .I24(RF[24]),
		     .I25(RF[25]),
		     .I26(RF[26]),
		     .I27(RF[27]),
		     .I28(RF[28]),
		     .I29(RF[29]),
		     .I30(RF[30]),
		     .I31(RF[31]),
		     .S(ADDR_R2));

   MUX32_2x1 r1_data_mux(.Y(DATA_R1), .I0(32'hzzzz_zzzz), .I1(r1_mux_o), .S(READ));
   MUX32_2x1 r2_data_mux(.Y(DATA_R2), .I0(32'hzzzz_zzzz), .I1(r2_mux_o), .S(READ));
   

endmodule // REGISTER_FILE_32x32

