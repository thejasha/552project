module ID_EX(
BSrc_in, BSrc_out, InvB_in, InvB_out, InvA_in, InvA_out, ALUCtrl_in, ALUCtrl_out, BranchCtrl_in, BranchCtrl_out, branch_in, branch_out, SLBI_in, 
SLBI_out, SetCtrl3_in, SetCtrl3_out, BTR_in, BTR_out, ReadData1_in, ReadData1_out, ReadData2_in, ReadData2_out, fourExtend_in, fourExtend_out,
sevenExtend_in, sevenExtend_out, shifted_in, shifted_out, MemWrt_in, MemWrt_out, ALUJMP_in, ALUJMP_out, PC_or_add_in, PC_or_add_out, halt_in, 
halt_out, word_align_jump_in, word_align_jump_out, RegWrt_in, RegWrt_out, RegSrc_in, RegSrc_out, pc2_in, pc2_out, write_reg_in, write_reg_out, 
SendNOP_In, SendNOP_Out, inst_in, inst_out, EXFWD1_D, EXFWD2_D, MEMFWD1_D, MEMFWD2_D, EXFWD1_E, EXFWD2_E, MEMFWD1_E, MEMFWD2_E, clk, rst
);

/*
what to model for
execute iDUU3(.BSrc(Bsrc), .InvB(InvB), .InvA(InvA), .ALUCtrl(ALUOpr), .ReadData1(read_data_1), .ReadData2(read_data_2), 
        .fourExtend(i_1), .sevenExtend(i_2), .shifted(to_shift), .BranchCtrl(branch_command), 
        .branch(branching), .SLBI(SLBI), .SetCtrl3(SetCtrl), 
        .BTR(BTR), .ALU(Alu_result), .BInput(Binput), .branchtake(branchtake));
*/

input wire clk, rst;


//forwardin
input wire [15:0] inst_in;
output wire [15:0] inst_out;
dff instr [15:0] (.q(inst_out), .d(inst_in), .clk(clk), .rst(rst));

input wire EXFWD1_D, EXFWD2_D, MEMFWD1_D, MEMFWD2_D;
output wire EXFWD1_E, EXFWD2_E, MEMFWD1_E, MEMFWD2_E;
dff fwd1(.q(EXFWD1_E), .d(EXFWD1_D), .clk(clk), .rst(rst));
dff fwd2(.q(EXFWD2_E), .d(EXFWD2_D), .clk(clk), .rst(rst));
dff fwd3(.q(MEMFWD1_E), .d(MEMFWD1_D), .clk(clk), .rst(rst));
dff fwd4(.q(MEMFWD2_E), .d(MEMFWD2_D), .clk(clk), .rst(rst));

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

/*STFF not used in EX*/
 
    //To EX_MEM
    input wire MemWrt_in; //if we are writing to meme
    output wire MemWrt_out; //if we are writing to meme
    
    input wire ALUJMP_in; //if we are jumping form the result of alu
    output wire ALUJMP_out; //if we are jumping form the result of alu
    
    input wire PC_or_add_in; //if we r taking the pc or the addition for pc and another number
    output wire PC_or_add_out; //if we r taking the pc or the addition for pc and another number
    
    input wire halt_in;
    output wire halt_out;

    input wire [15:0] word_align_jump_in;
    output wire [15:0] word_align_jump_out;

    //To MEM_WB
    input wire RegWrt_in;
    output wire RegWrt_out;
    input wire SendNOP_In;
    output wire SendNOP_Out;

    //To WB
    input wire [1:0] RegSrc_in;
    output wire [1:0] RegSrc_out;

    //TODO PC FROM IF/ID needs to be passed down
    input wire [15:0] pc2_in; //pc + 2
    output wire [15:0] pc2_out; 

    input wire [2:0] write_reg_in;
    output wire [2:0] write_reg_out;

/*FLOPS*/
dff BSrc [1:0] (.q(BSrc_out), .d(BSrc_in), .clk(clk), .rst(rst));
dff InvB(.q(InvB_out), .d(InvB_in), .clk(clk), .rst(rst));
dff InvA(.q(InvA_out), .d(InvA_in), .clk(clk), .rst(rst));
dff ALUCtrl [2:0] (.q(ALUCtrl_out), .d(ALUCtrl_in), .clk(clk), .rst(rst));
dff BranchCtrl [1:0] (.q(BranchCtrl_out), .d(BranchCtrl_in), .clk(clk), .rst(rst));
dff branch(.q(branch_out), .d(branch_in), .clk(clk), .rst(rst));
dff SLBI(.q(SLBI_out), .d(SLBI_in), .clk(clk), .rst(rst));
dff SetCtrl3 [2:0] (.q(SetCtrl3_out), .d(SetCtrl3_in), .clk(clk), .rst(rst));
dff BTR(.q(BTR_out), .d(BTR_in), .clk(clk), .rst(rst));
dff ReadData1 [15:0] (.q(ReadData1_out), .d(ReadData1_in), .clk(clk), .rst(rst));

dff ReadData2 [15:0] (.q(ReadData2_out), .d(ReadData2_in), .clk(clk), .rst(rst));
dff fourExtend [15:0] (.q(fourExtend_out), .d(fourExtend_in), .clk(clk), .rst(rst));
dff sevenExtend [15:0] (.q(sevenExtend_out), .d(sevenExtend_in), .clk(clk), .rst(rst));
dff shifted [15:0] (.q(shifted_out), .d(shifted_in), .clk(clk), .rst(rst));
dff MemWrt(.q(MemWrt_out), .d(MemWrt_in), .clk(clk), .rst(rst));
dff ALUJMP(.q(ALUJMP_out), .d(ALUJMP_in), .clk(clk), .rst(rst));

dff PC_or_add(.q(PC_or_add_out), .d(PC_or_add_in), .clk(clk), .rst(rst));
dff halt(.q(halt_out), .d(halt_in), .clk(clk), .rst(rst));
dff word_align_jump [15:0] (.q(word_align_jump_out), .d(word_align_jump_in), .clk(clk), .rst(rst));
dff RegWrt(.q(RegWrt_out), .d(RegWrt_in), .clk(clk), .rst(rst));
dff SendNOP(.q(SendNOP_Out), .d(SendNOP_In), .clk(clk), .rst(rst));
dff RegSrc [1:0](.q(RegSrc_out), .d(RegSrc_in), .clk(clk), .rst(rst));
dff pc2 [15:0] (.q(pc2_out), .d(pc2_in), .clk(clk), .rst(rst));
dff write_reg [2:0](.q(write_reg_out), .d(write_reg_in), .clk(clk), .rst(rst));

endmodule