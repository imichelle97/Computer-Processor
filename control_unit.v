// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: RF_DATA_W  : Data to be written at register file address RF_ADDR_W
//         RF_ADDR_W  : Register file address of the memory location to be written
//         RF_ADDR_R1 : Register file address of the memory location to be read for RF_DATA_R1
//         RF_ADDR_R2 : Registere file address of the memory location to be read for RF_DATA_R2
//         RF_READ    : Register file Read signal
//         RF_WRITE   : Register file Write signal
//         ALU_OP1    : ALU operand 1
//         ALU_OP2    : ALU operand 2
//         ALU_OPRN   : ALU operation code
//         MEM_ADDR   : Memory address to be read in
//         MEM_READ   : Memory read signal
//         WRITE  : Memory write signal
//         
// Input:  RF_DATA_R1 : Data at ADDR_R1 address
//         RF_DATA_R2 : Data at ADDR_R1 address
//         ALU_RESULT    : ALU output data
//         CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Control unit synchronize operations of a processor
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(CTRL, READ, WRITE, ZERO, INSTRUCTION, CLK, RST); 
   
   // Output signals
   // Control signals for data path 
   output [31:0] CTRL;
   
   // Control for memory
   output 	 READ, WRITE;
   
   // Input signals from data path
   input 	 ZERO;
   input [31:0]  INSTRUCTION;
   
   // Clock and Reset
   input 	 CLK, RST;
   
   reg 		 READ, WRITE;
   
   // State nets
   wire [2:0] 	 proc_state;
   
   // Internal Wires
   reg [5:0] 	 opcode;
   reg [4:0] 	 rs;
   reg [4:0] 	 rt;
   reg [4:0] 	 rd;
   reg [4:0] 	 shamt;
   reg [5:0] 	 funct;
   reg [15:0] 	 immediate;
   reg [31:0] 	 sign_ext_imm;
   reg [31:0] 	 zero_ext_imm;
   reg [31:0] 	 lui_imm;
   reg [25:0] 	 address;
   reg [31:0] 	 jmp_addr;
   
   reg 		 r_type, i_type, j_type;
   reg 		 i_logical, i_arithmetic;
   reg 		 push_instr, pop_instr;
   reg 		 jal_instr, jr_instr, jmp_instr;
   reg 		 lw_instr, sw_instr, lui_instr;
   reg 		 beq_instr, bne_instr;
   reg 		 srl_instr, sll_instr;
   reg 		 add_instr, addi_instr, sub_instr, mul_instr, muli_instr;
   reg 		 and_instr, andi_instr, or_instr, ori_instr, nor_instr;
   reg 		 slt_instr, slti_instr;
   
   reg 		 pc_load;
   reg 		 sp_load;
   reg 		 pc_sel_1, pc_sel_2, pc_sel_3;
   reg 		 r1_sel_1;
   reg 		 ir_load;
   reg 		 wa_sel_1, wa_sel_2, wa_sel_3;
   reg 		 wd_sel_1, wd_sel_2, wd_sel_3;
   reg 		 op1_sel_1;
   reg 		 op2_sel_1, op2_sel_2, op2_sel_3, op2_sel_4;
   reg 		 reg_r, reg_w;
   reg [`ALU_OPRN_INDEX_LIMIT:0] alu_oprn;
   reg 				 ma_sel_1, ma_sel_2;
   reg 				 md_sel_1;
   
   wire [31:0] 			 CTRL;
   
   assign CTRL = {3'h0, pc_load, sp_load, pc_sel_1, pc_sel_2, pc_sel_3, r1_sel_1, ir_load,
		  wa_sel_1, wa_sel_2, wa_sel_3, wd_sel_1, wd_sel_2, wd_sel_3, op1_sel_1, 
		  op2_sel_1, op2_sel_2, op2_sel_3, op2_sel_4, reg_r, reg_w, alu_oprn, 
		  ma_sel_1, ma_sel_2, md_sel_1};
   
   
   
   //Initial State
   initial
     begin
	READ = 0;
	WRITE = 0;
	pc_load = 1'b0;
	sp_load = 1'b0;
	ir_load = 1'b0;
	
     end
   
   PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));
   
   always @ (proc_state or negedge RST)
     if (RST == 0) begin
	READ = 0;
	WRITE = 0;
	pc_load = 1'b0;
	sp_load = 1'b0;
	ir_load = 1'b0;
     end
     else
       begin	     
	  case(proc_state)
	    
	    `PROC_FETCH: 
	      begin 
		 // PC to memory address to fetch instruction
		 ma_sel_2 = 1'b1;
	       	 
		 // Fetch instruction by sending read request to memory
		 READ = 1'b1;
		 WRITE = 1'b0;
		 
		 // Turn off register file read/write at this stage
		 reg_r = 1'b0;
		 reg_w = 1'b0;
		 
		 // Prepare to load instruction register
		 ir_load = 1'b1;
		 
		 // Turn off pc_load
		 #3 pc_load = 1'b0;
		 sp_load = 1'b0;
		 
		 
	      end
	    `PROC_DECODE: 
	      begin	     
		 
		 // Parse the instruction to each field for decode
		 #1
		   opcode = INSTRUCTION[31:26];
		 funct  = INSTRUCTION[5:0];
		 
		 #0.5
		   //R_TYPE
		   r_type = (opcode == 6'h00);
		 
		 //I-TYPE
		 i_type = (opcode == 6'h08) ||
			  (opcode == 6'h1d) ||	
			  (opcode == 6'h0c) ||	
			  (opcode == 6'h0d) ||	
			  (opcode == 6'h0f) ||	
			  (opcode == 6'h0a) ||	
			  (opcode == 6'h04) ||	
			  (opcode == 6'h05) ||	
			  (opcode == 6'h23) ||	
			  (opcode == 6'h2b); 
		 
		 i_logical = (opcode == 6'h0c) ||	
			     (opcode == 6'h0d);
		 
		 i_arithmetic = i_type && !i_logical;
		 
		 //J_TYPE
		 j_type = (opcode == 6'h02) ||
			  (opcode == 6'h03) ||	
			  (opcode == 6'h1b) ||	
			  (opcode == 6'h1c);
		 
		 //DECODE INSTRUCTIONS
		 push_instr = (opcode == 6'h1b);			
		 pop_instr = (opcode == 6'h1c);
		 
		 jmp_instr = (opcode == 6'h02);			
		 jal_instr = (opcode == 6'h03);
		 jr_instr = (opcode == 6'h00) && (funct == 6'h08);
		 
		 lw_instr = (opcode == 6'h23);
		 sw_instr = (opcode == 6'h2b);
		 lui_instr = (opcode == 6'h0f);
		 
		 beq_instr = (opcode == 6'h04);
		 bne_instr = (opcode == 6'h05);
		 
		 srl_instr = (opcode == 6'h00) && (funct == 6'h02);
		 sll_instr = (opcode == 6'h00) && (funct == 6'h01);
		 
		 add_instr = (opcode == 6'h00) && (funct == 6'h20);
		 addi_instr = (opcode == 6'h08);
		 sub_instr = (opcode == 6'h00) && (funct == 6'h22);
		 mul_instr = (opcode == 6'h00) && (funct == 6'h2c);
		 muli_instr = (opcode == 6'h1d);
		 
		 and_instr = (opcode == 6'h00) && (funct == 6'h24);
		 andi_instr = (opcode == 6'h0c);
		 or_instr = (opcode == 6'h00) && (funct == 6'h25);
		 ori_instr = (opcode == 6'h0d);
		 nor_instr = (opcode == 6'h00) && (funct == 6'h27);
		 
		 slt_instr = (opcode == 6'h00) && (funct == 6'h2a);
		 slti_instr = opcode == 6'h0a;
		 
		 
		 // R1 Address of register file is from instruction rs field except for the push instruction
		 // it is hardwired to 0
		 #0.5
		   r1_sel_1 = (push_instr)? 1'b1 : 1'b0;
		 
		 // Write address of register file is R31 for jal, R0 for pop, rt for I-type and rd for R-type
		 wa_sel_3 = (jal_instr || pop_instr)? 1'b0 : 1'b1;
		 wa_sel_1 = (i_type)? 1'b1 : 1'b0;
		 wa_sel_2 = (jal_instr)? 1'b1 : 1'b0;
	       	 
		 // Write data for register file mostly come from ALU except:
		 // * R31 = PC + 1 for jal
		 // * immediate on upper 16 bits for lui
		 //  * Memory  data for lw and pop (R0)
		 wd_sel_1 = (pop_instr || lw_instr)? 1'b1 : 1'b0;
		 wd_sel_2 = (lui_instr)? 1'b1 : 1'b0;
		 wd_sel_3 = (jal_instr)? 1'b0 : 1'b1;
		 
		 // Read register file only for all R-tyoe, I-type except lui, and push
		 reg_r = r_type || (i_type && !lui_instr) || push_instr;	
		 
		 // Turn off memory read/write and instruction load  at this stage
		 #1
		   READ = 1'b0;
		 WRITE = 1'b0;
		 ir_load = 1'b0;	       
		 
 		 print_instruction(INSTRUCTION);
		 
	      end
	    
	    `PROC_EXE:
	      begin
		 
		 // First ALU operand comes from register file R1 except for push/pop which comes from Stack
		 // Pointer register
		 op1_sel_1 = (push_instr || pop_instr)? 1'b1 : 1'b0;
	       	 
		 // Second ALU operand comes from  the regrister file R2 except the following cases:
		 // * Always a value 1 for push and  pop
		 // * Shift amount (shamt) for sll and srl (shift instr)
		 // * Signed extend  immediate for immediate arithmetic instructions and for lw/sw address calculation
		 // * Zero extend  immediate  for immediate logical instructions
		 op2_sel_4 = (push_instr || pop_instr || sll_instr || srl_instr ||
			      addi_instr || muli_instr || slti_instr || lw_instr || sw_instr ||
			      andi_instr || ori_instr)? 1'b0 : 1'b1;
		 
		 op2_sel_3 = (push_instr || pop_instr || sll_instr || srl_instr)? 1'b1 : 1'b0;
		 op2_sel_1 = (sll_instr || srl_instr)? 1'b1 : 1'b0;
		 op2_sel_2 = (addi_instr || muli_instr || slti_instr || lw_instr || sw_instr)? 1'b1 : 1'b0;
		 
		 
		 
		 // Create ALU operation code based on instructions
		 alu_oprn = (add_instr || addi_instr || lw_instr || sw_instr || pop_instr)? 6'h01 :
			    (sub_instr || push_instr || beq_instr || bne_instr)?            6'h02 :
			    (mul_instr || muli_instr)?                                      6'h03 :
			    (srl_instr)?                                                    6'h04 :
			    (sll_instr)?                                                    6'h05 :
			    (and_instr || andi_instr)?                                      6'h06 :
			    (or_instr || ori_instr)?                                        6'h07 :
			    (nor_instr)?                                                    6'h08 :
			    (slt_instr || slti_instr)?                                      6'h09 : 6'h00;
	      end 
	    
	    `PROC_MEM: 
	      begin
		 // Memory address is calculated by ALU for lw/sw instructions.
		 // For push instructions memory address is from Stach Pointer register
		 // For pop instruction memory address come from ALU for the value of SP+1
		 ma_sel_2 = (push_instr || lw_instr || sw_instr || pop_instr)? 1'b0 : 1'b1;
		 ma_sel_1 = (push_instr)? 1'b1 : 1'b0;
		 
		 
		 // Memory write data come form rt for sw and from R0 for push
		 md_sel_1 = (push_instr)? 1'b1 : 1'b0;	       
		 
		 // Memory read lw and  pop, meemory write for sw and push
		 READ = lw_instr || pop_instr;
		 WRITE = sw_instr || push_instr;
		 
	      end
	    
	    `PROC_WB:
	      begin
		 // Write register file for:
		 // * R-type instructions except jr
		 // * I-type instructions except bne, beq, and sw
		 // * jal (R31)
		 // * pop (R0)
		 reg_w = (r_type && !jr_instr) ||
			 (i_type && !beq_instr && !bne_instr && !sw_instr) ||
			 jal_instr ||
			 pop_instr;
		 
		 // SP is updated with ALU value: SP+1 for pop and SP-1 for push
		 // SP_REG = (push_instr || pop_instr)? ALU_RESULT[25:0] : SP_REG;
		 
		 sp_load = (push_instr || pop_instr);
		 
		 
		 // Update the PC:
		 // * with jump address for jmp and jal
		 // * with branch  address for taken branch
		 // * register value for jr
		 // * PC+1 for all other cases
		 pc_load = 1'b1;
		 pc_sel_3 = (jmp_instr || jal_instr)? 1'b0 : 1'b1;
		 pc_sel_2 = ((beq_instr && ZERO) || (bne_instr && !ZERO))? 1'b1 : 1'b0;
		 pc_sel_1 = (jr_instr)? 1'b0 : 1'b1;
	       	 
	      end 
	    
	    default:
	      begin
		 
	      end
	    
	  endcase
	  
       end // else: !if(RST == 0)
   
   task print_instruction;
      input [`DATA_INDEX_LIMIT:0] inst;
      
      reg [5:0] 		  opcode;
      reg [4:0] 		  rs;
      reg [4:0] 		  rt;
      reg [4:0] 		  rd;
      reg [4:0] 		  shamt;
      reg [5:0] 		  funct;
      reg [15:0] 		  immediate;
      reg [25:0] 		  address;
      
      begin
	 //parse the instruction
	 //R-type
	 {opcode, rs, rt, rd, shamt, funct} = inst;
	 //I-Type
	 {opcode, rs, rt, immediate} = inst;
	 //J-Type
	 {opcode, address} = inst;
	 
	 $write("@ %6dns -> [0X%08h] ", $time, inst);
	 
	 case(opcode)
	   //R-Type
	   6'h00 : begin
	      case(funct)
		6'h20 : $write("add r[%02d], r[%02d], r[%02d];", rs, rt, rd);
		6'h22 : $write("sub r[%02d], r[%02d], r[%02d];", rs, rt, rd);
		6'h2c : $write("mul r[%02d], r[%02d], r[%02d];", rs, rt, rd);
		6'h24 : $write("and r[%02d], r[%02d], r[%02d];", rs, rt, rd);
		6'h25 : $write("or r[%02d], r[%02d], r[%02d];", rs, rt, rd);
		6'h27 : $write("nor r[%02d], r[%02d], r[%02d];", rs, rt, rd);
		6'h2a : $write("slt r[%02d], r[%02d], r[%02d];", rs, rt, rd);
		6'h00 : $write("sll r[%02d], %2d, r[%02d];", rs, shamt, rd);
		6'h02 : $write("srl r[%02d], 0X%02h, r[%02d];", rs, shamt, rd);
		6'h08 : $write("jr r[%02d];", rs);
		default: $write("");
	      endcase
           end
	   
	   // I-type
	   6'h08 : $write("addi r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
	   6'h1d : $write("muli r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
	   6'h0c : $write("andi r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
	   6'h0d : $write("ori r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
	   6'h0f : $write("lui r[%02d], 0X%04h;", rt, immediate);
	   6'h0a : $write("slti r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
	   6'h04 : $write("beq r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
	   6'h05 : $write("bne r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
	   6'h23 : $write("lw r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
	   6'h2b : $write("sw r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
	   
	   // J-Type
	   6'h02 : $write("jmp 0X%07h;", address);
	   6'h03 : $write("jal 0X%07h;", address);
	   6'h1b : $write("push;");
	   6'h1c : $write("pop;");
	   default: $write("");
	 endcase
	 $write("\n");
      end
   endtask
   
endmodule

//------------------------------------------------------------------------------------------
// Module: CONTROL_UNIT
// Output: STATE      : State of the processor
//         
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
module PROC_SM(STATE,CLK,RST);
   // list of inputs
   input CLK, RST;
   // list of outputs
   output [2:0] STATE;
   
   reg [2:0] 	STATE;
   reg [2:0] 	NEXT_STATE;
   
   //initialization of state
   initial
     begin
	NEXT_STATE = `PROC_FETCH;
     end
   
   //reset signal handling
   always @ (negedge RST)
     begin
	NEXT_STATE = `PROC_FETCH;
        STATE = 3'hx;
     end
   
   //state switching
   always @ (posedge CLK)
     begin
	STATE = NEXT_STATE;
     end
   
   //Action on state switching
   always @ (STATE)
     //always @ (posedge CLK)
     begin
	case(STATE)
	  `PROC_FETCH  : NEXT_STATE = `PROC_DECODE;
	  `PROC_DECODE : NEXT_STATE = `PROC_EXE;
	  `PROC_EXE    : NEXT_STATE = `PROC_MEM;
	  `PROC_MEM    : NEXT_STATE = `PROC_WB;
	  `PROC_WB     : NEXT_STATE = `PROC_FETCH;
	  default      : NEXT_STATE = `PROC_FETCH;
	endcase
     end
   
endmodule
