module ID_EX(
BSrc_in, BSrc_out, InvB_in, InvB_out, InvA_in, InvA_out, ALUCtrl_in, ALUCtrl_out, BranchCtrl_in, BranchCtrl_out, branch_in, branch_out, SLBI_in, 
SLBI_out, SetCtrl3_in, SetCtrl3_out, BTR_in, BTR_out, ReadData1_in, ReadData1_out, ReadData2_in, ReadData2_out, fourExtend_in, fourExtend_out,
sevenExtend_in, sevenExtend_out, shifted_in, shifted_out, MemWrt_in, MemWrt_out, ALUJMP_in, ALUJMP_out, PC_or_add_in, PC_or_add_out, halt_in, 
halt_out, word_align_jump_in, word_align_jump_out, RegWrt_in, RegWrt_out, RegSrc_in, RegSrc_out, pc2_in, pc2_out
);

/*
what to model for
execute iDUU3(.BSrc(Bsrc), .InvB(InvB), .InvA(InvA), .ALUCtrl(ALUOpr), .ReadData1(read_data_1), .ReadData2(read_data_2), 
        .fourExtend(i_1), .sevenExtend(i_2), .shifted(to_shift), .BranchCtrl(branch_command), 
        .branch(branching), .SLBI(SLBI), .SetCtrl3(SetCtrl), 
        .BTR(BTR), .ALU(Alu_result), .BInput(Binput), .branchtake(branchtake));
*/

/*FROM Decode TO EX*/
    input wire [1:0]BSrc_in; //4 to 1 muxm controller
    output wire [1:0]BSrc_out;

    input wire InvB_in; //invert b controll
    output wire InvB_out; 
    
    input wire InvA_in; //invert a controll
    output wire InvA_out; 
    
    input wire [2:0] ALUCtrl_in; //ALU controll
    output wire [2:0] ALUCtrl_out; 
    
    input wire [1:0] BranchCtrl_in;
    output wire [1:0] BranchCtrl_out;
    
    input wire branch_in; //is a branch command
    output wire branch_out;
    
    input wire SLBI_in;
    output wire SLBI_out;
    
    input wire [2:0] SetCtrl3_in;
    output wire [2:0] SetCtrl3_out;
    
    input wire BTR_in; //bit reverse
    output wire BTR_out; 

    input wire [15:0] ReadData1_in; //reg output 1
    output wire [15:0] ReadData1_out; 
    
    input wire [15:0] ReadData2_in; // reg output 2
    output wire [15:0] ReadData2_out; 
    
    input wire [15:0] fourExtend_in; //the extended that comes from [4:0]
    output wire [15:0] fourExtend_out;
    
    input wire [15:0] sevenExtend_in; //the extend that comes from [7:0]
    output wire [15:0] sevenExtend_out;
    
    input wire [15:0] shifted_in; //shifted 8 bits unsigned
    output wire [15:0] shifted_out; 

/*FROM IF/ID flop TO EX*/
    //shouldn't be anything

/*STFF not used in MEM*/
 
    //To EX_MEM
    input reg MemWrt_in; //if we are writing to meme
    output reg MemWrt_out; //if we are writing to meme
    
    input reg ALUJMP_in; //if we are jumping form the result of alu
    output reg ALUJMP_out; //if we are jumping form the result of alu
    
    input reg PC_or_add_in; //if we r taking the pc or the addition for pc and another number
    output reg PC_or_add_out; //if we r taking the pc or the addition for pc and another number
    
    input reg halt_in;
    output reg halt_out;

    input wire [15:0] word_align_jump_in;
    output wire [15:0] word_align_jump_out;

    //To MEM_WB
    input wire RegWrt_in;
    output wire RegWrt_out;

    //To WB
    input wire [1:0] RegSrc_in;
    output wire [1:0] RegSrc_out;

    //TODO PC FROM IF/ID needs to be passed down
    input wire [15:0] pc2_in; //pc + 2
    output wire [15:0] pc2_out; 

dff [15:0] ();

endmodule