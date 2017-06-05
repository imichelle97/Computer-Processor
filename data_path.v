// Name: data_path.v
// Module: DATA_PATH
// Output:  DATA : Data to be written at address ADDR
//          ADDR : Address of the memory location to be accessed
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - 32 bit processor implementing cs147sec05 instruction set
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
`define ADDRESS_WIDTH_DP 32
`define ADDRESS_INDEX_LIMIT_DP (`ADDRESS_WIDTH_DP -1)
module DATA_PATH(DATA_OUT, ADDR, ZERO, INSTRUCTION, DATA_IN, CTRL, CLK, RST);

   // output list
   output [`ADDRESS_INDEX_LIMIT:0] ADDR;
   output 			   ZERO;
   output [`DATA_INDEX_LIMIT:0]    DATA_OUT, INSTRUCTION;
   
   // input list
   input [`CTRL_WIDTH_INDEX_LIMIT:0] CTRL;
   input 			     CLK, RST;
   input [`DATA_INDEX_LIMIT:0] 	     DATA_IN;

   wire [`ADDRESS_INDEX_LIMIT_DP:0]     pc;
   wire [`ADDRESS_INDEX_LIMIT_DP:0]     sp;
   wire [`ADDRESS_INDEX_LIMIT_DP:0]     next_pc;
   wire [`ADDRESS_INDEX_LIMIT_DP:0]     next_sp;
   wire 			     pc_load;
   wire 			     sp_load;
   wire 			     pc_sel_1, pc_sel_2, pc_sel_3;
   wire 			     r1_sel_1;
   wire 			     ir_load;
   wire 			     wa_sel_1, wa_sel_2, wa_sel_3;
   wire 			     wd_sel_1, wd_sel_2, wd_sel_3;
   wire 			     op1_sel_1;
   wire 			     op2_sel_1, op2_sel_2, op2_sel_3, op2_sel_4;
   wire 			     reg_r, reg_w;
   wire [`ALU_OPRN_INDEX_LIMIT:0]    alu_oprn;
   wire 			     ma_sel_1, ma_sel_2;
   wire 			     md_sel_1;
   wire [`DATA_INDEX_LIMIT:0] 	     alu_out;
   wire [`DATA_INDEX_LIMIT:0] 	     alu_op_1;
   wire [`DATA_INDEX_LIMIT:0] 	     alu_op_2;
   

   assign {pc_load, sp_load, pc_sel_1, pc_sel_2, pc_sel_3, r1_sel_1, ir_load, wa_sel_1, wa_sel_2, wa_sel_3,
	   wd_sel_1, wd_sel_2, wd_sel_3, op1_sel_1, op2_sel_1, op2_sel_2, op2_sel_3, op2_sel_4,
	   reg_r, reg_w, alu_oprn, ma_sel_1, ma_sel_2, md_sel_1} = CTRL [28:0];   

   //Instantiate PC and SP
   defparam pc_inst.PATTERN = `INST_START_ADDR;
   REG32_PP pc_inst(.Q(pc), .D(next_pc), .LOAD(pc_load), .CLK(CLK), .RESET(RST));

   assign next_sp = alu_out;
   defparam sp_inst.PATTERN = `INIT_STACK_POINTER;
   REG32_PP sp_inst(.Q(sp), .D(next_sp), .LOAD(sp_load), .CLK(CLK), .RESET(RST));

   //Instantiate Instruction Register
   wire [`DATA_INDEX_LIMIT:0] 	     INSTRUCTION;
   reg 			     ir_CLK;
   always @(CLK)
     ir_CLK = #0.5 CLK;
   
   REG32 ir(.Q(INSTRUCTION), .D(DATA_IN), .LOAD(ir_load), .CLK(ir_CLK), .RESET(RST));

   //Parse the instruction
   wire [4:0] 			    rs;
   wire [4:0] 			    rt;
   wire [4:0] 			    rd;
   wire [4:0] 			    shamt;
   wire [15:0] 			    immediate;
   wire [31:0] 			    sign_ext_imm;
   wire [31:0] 			    zero_ext_imm;
   wire [31:0] 			    lui_imm;
   wire [25:0] 			    address;
   wire [31:0] 			    jmp_addr;

   assign rs = INSTRUCTION[25:21];
   assign rt = INSTRUCTION[20:16];
   assign rd = INSTRUCTION[15:11];
   assign shamt = INSTRUCTION[10:6];
   assign immediate = INSTRUCTION[15:0];
   assign address = INSTRUCTION[25:0];
   assign sign_ext_imm = { {16{immediate[15]}},immediate };
   assign zero_ext_imm = { {16{1'b0}},immediate };
   assign lui_imm = { immediate, {16{1'b0}} };  
   assign jmp_addr = { {6{1'b0}}, address };
	       
   
   
   
   //Instantiate the Data Path
   
   wire [`ADDRESS_INDEX_LIMIT_DP:0]     pc_plus_1;
   RC_ADD_SUB_32 pc_plus_1_i(.Y(pc_plus_1), .CO(), .A(32'h01), .B(pc), .SnA(1'b0));

   wire [`ADDRESS_INDEX_LIMIT_DP:0]     pc_mux_1;
   wire [`DATA_INDEX_LIMIT:0] 	     r1_data;
   MUX32_2x1 pc_mux_1_i(.Y(pc_mux_1), .I0(r1_data), .I1(pc_plus_1), .S(pc_sel_1));

   wire [`ADDRESS_INDEX_LIMIT_DP:0]     br_addr;
   RC_ADD_SUB_32 br_addr_adder(.Y(br_addr), .CO(), .A(pc_plus_1), .B(sign_ext_imm), .SnA(1'b0));

   wire [`ADDRESS_INDEX_LIMIT_DP:0]     pc_mux_2;
   MUX32_2x1 pc_mux_2_i(.Y(pc_mux_2), .I0(pc_mux_1), .I1(br_addr), .S(pc_sel_2));
   
   MUX32_2x1 pc_mux_3(.Y(next_pc), .I0(jmp_addr), .I1(pc_mux_2), .S(pc_sel_3));


   //Instantiate the Register File
   wire [`REG_ADDR_INDEX_LIMIT:0]    r1_addr, wr_addr;
   wire [`DATA_INDEX_LIMIT:0] 	     r2_data, wr_data;
   REGISTER_FILE_32x32 r_file(.DATA_R1(r1_data), .DATA_R2(r2_data), .ADDR_R1(r1_addr), .ADDR_R2(rt),
			      .DATA_W(wr_data), .ADDR_W(wr_addr), .READ(reg_r), .WRITE(reg_w), .CLK(CLK),
			      .RST(RST));

   MUX5_2x1 r1_addr_mux(.Y(r1_addr), .I0(rs), .I1(5'h0), .S(r1_sel_1));

   wire [`REG_ADDR_INDEX_LIMIT:0]    wa_mux_1, wa_mux_2;
   MUX5_2x1 wa_mux_1_i(.Y(wa_mux_1), .I0(rd), .I1(rt), .S(wa_sel_1));
   MUX5_2x1 wa_mux_2_i(.Y(wa_mux_2), .I0(5'h0), .I1(5'd31), .S(wa_sel_2));
   MUX5_2x1 wa_mux_3(.Y(wr_addr), .I0(wa_mux_2), .I1(wa_mux_1), .S(wa_sel_3));


   wire [`DATA_INDEX_LIMIT:0] 	     wd_mux_1, wd_mux_2;
   MUX32_2x1 wd_mux_1_i(.Y(wd_mux_1), .I0(alu_out), .I1(DATA_IN), .S(wd_sel_1));
   MUX32_2x1 wd_mux_2_i(.Y(wd_mux_2), .I0(wd_mux_1), .I1(lui_imm), .S(wd_sel_2));
   MUX32_2x1 wd_mux_3(.Y(wr_data), .I0(pc_plus_1), .I1(wd_mux_2), .S(wd_sel_3));


   //Instantiate ALU
   wire [`DATA_INDEX_LIMIT:0] 	     op2_mux_1, op2_mux_2, op2_mux_3;
   
   ALU alu_inst(.OUT(alu_out), .ZERO(ZERO), .OP1(alu_op_1), .OP2(alu_op_2), .OPRN(alu_oprn));
   
   MUX32_2x1 op1_mux_1(.Y(alu_op_1), .I0(r1_data), .I1(sp), .S(op1_sel_1));
   MUX32_2x1 op2_mux_1_i(.Y(op2_mux_1), .I0(32'h01), .I1({27'h0,shamt}), .S(op2_sel_1));
   MUX32_2x1 op2_mux_2_i(.Y(op2_mux_2), .I0(zero_ext_imm), .I1(sign_ext_imm), .S(op2_sel_2));
   MUX32_2x1 op2_mux_3_i(.Y(op2_mux_3), .I0(op2_mux_2), .I1(op2_mux_1), .S(op2_sel_3));
   MUX32_2x1 op2_mux_4(.Y(alu_op_2), .I0(op2_mux_3), .I1(r2_data), .S(op2_sel_4));

   //Instantiate Interface with Memory
   wire [`DATA_INDEX_LIMIT:0] 	     DATA_OUT;
   wire [`ADDRESS_INDEX_LIMIT_DP:0]     ma_mux_1, ADDR_mux;
   wire [`ADDRESS_INDEX_LIMIT:0] 	ADDR;
   
   
   MUX32_2x1 data_out_mux(.Y(DATA_OUT), .I0(r2_data), .I1(r1_data), .S(md_sel_1));

   MUX32_2x1 ma_mux_1_i(.Y(ma_mux_1), .I0(alu_out), .I1(sp), .S(ma_sel_1));
   MUX32_2x1 addr_mux(.Y(ADDR_mux), .I0(ma_mux_1), .I1(pc), .S(ma_sel_2));

   assign ADDR = ADDR_mux[25:0];
   

   
endmodule // DATA_PATH

