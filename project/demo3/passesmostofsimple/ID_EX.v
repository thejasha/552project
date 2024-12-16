module ID_EX(
BSrc_in, BSrc_out, InvB_in, InvB_out, InvA_in, InvA_out, ALUCtrl_in, ALUCtrl_out, BranchCtrl_in, BranchCtrl_out, branch_in, branch_out, SLBI_in, 
SLBI_out, SetCtrl3_in, SetCtrl3_out, BTR_in, BTR_out, ReadData1_in, ReadData1_out, ReadData2_in, ReadData2_out, fourExtend_in, fourExtend_out,
sevenExtend_in, sevenExtend_out, shifted_in, shifted_out, MemWrt_in, MemWrt_out, ALUJMP_in, ALUJMP_out, PC_or_add_in, PC_or_add_out, halt_in, 
halt_out, word_align_jump_in, word_align_jump_out, RegWrt_in, RegWrt_out, RegSrc_in, RegSrc_out, pc2_in, pc2_out, write_reg_in, write_reg_out, SendNOP_In, 
SendNOP_Out, clk, rst, MemRd_in, MemRd_out, mem_stall, fetch_stall
);

/*
what to model for
execute iDUU3(.BSrc(Bsrc), .InvB(InvB), .InvA(InvA), .ALUCtrl(ALUOpr), .ReadData1(read_data_1), .ReadData2(read_data_2), 
        .fourExtend(i_1), .sevenExtend(i_2), .shifted(to_shift), .BranchCtrl(branch_command), 
        .branch(branching), .SLBI(SLBI), .SetCtrl3(SetCtrl), 
        .BTR(BTR), .ALU(Alu_result), .BInput(Binput), .branchtake(branchtake));
*/

input wire clk, rst;
input wire mem_stall;
input wire fetch_stall;

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
    input wire MemRd_in;
    output wire MemRd_out;

    //To WB
    input wire [1:0] RegSrc_in;
    output wire [1:0] RegSrc_out;

    //TODO PC FROM IF/ID needs to be passed down
    input wire [15:0] pc2_in; //pc + 2
    output wire [15:0] pc2_out; 

    input wire [2:0] write_reg_in;
    output wire [2:0] write_reg_out;

/*FLOPS*/
dff BSrc [1:0](.q(BSrc_out), .d(mem_stall | fetch_stall ? BSrc_out : BSrc_in), .clk(clk), .rst(rst));
dff InvB(.q(InvB_out), .d(mem_stall | fetch_stall ? InvB_out : InvB_in), .clk(clk), .rst(rst));
dff InvA(.q(InvA_out), .d(mem_stall | fetch_stall ? InvA_out : InvA_in), .clk(clk), .rst(rst));
dff ALUCtrl [2:0](.q(ALUCtrl_out), .d(mem_stall | fetch_stall ? ALUCtrl_out : ALUCtrl_in), .clk(clk), .rst(rst));
dff BranchCtrl [1:0](.q(BranchCtrl_out), .d(mem_stall | fetch_stall ? BranchCtrl_out : BranchCtrl_in), .clk(clk), .rst(rst));
dff branch(.q(branch_out), .d(mem_stall | fetch_stall ? branch_out : branch_in), .clk(clk), .rst(rst));
dff SLBI(.q(SLBI_out), .d(mem_stall | fetch_stall ? SLBI_out : SLBI_in), .clk(clk), .rst(rst));
dff SetCtrl3 [2:0](.q(SetCtrl3_out), .d(mem_stall | fetch_stall ? SetCtrl3_out : SetCtrl3_in), .clk(clk), .rst(rst));
dff BTR(.q(BTR_out), .d(mem_stall | fetch_stall ? BTR_out : BTR_in), .clk(clk), .rst(rst));
dff ReadData1 [15:0](.q(ReadData1_out), .d(mem_stall | fetch_stall ? ReadData1_out : ReadData1_in), .clk(clk), .rst(rst));

dff ReadData2 [15:0](.q(ReadData2_out), .d(mem_stall | fetch_stall ? ReadData2_out : ReadData2_in), .clk(clk), .rst(rst));
dff fourExtend [15:0](.q(fourExtend_out), .d(mem_stall | fetch_stall ? fourExtend_out : fourExtend_in), .clk(clk), .rst(rst));
dff sevenExtend [15:0](.q(sevenExtend_out), .d(mem_stall | fetch_stall ? sevenExtend_out : sevenExtend_in), .clk(clk), .rst(rst));
dff shifted [15:0](.q(shifted_out), .d(mem_stall | fetch_stall ? shifted_out : shifted_in), .clk(clk), .rst(rst));
dff MemWrt(.q(MemWrt_out), .d(mem_stall | fetch_stall ? MemWrt_out : MemWrt_in), .clk(clk), .rst(rst));
dff ALUJMP(.q(ALUJMP_out), .d(mem_stall | fetch_stall ? ALUJMP_out : ALUJMP_in), .clk(clk), .rst(rst));

dff PC_or_add(.q(PC_or_add_out), .d(mem_stall | fetch_stall ? PC_or_add_out : PC_or_add_in), .clk(clk), .rst(rst));
dff halt(.q(halt_out), .d(mem_stall | fetch_stall ? halt_out : halt_in), .clk(clk), .rst(rst));
dff word_align_jump [15:0](.q(word_align_jump_out), .d(mem_stall | fetch_stall ? word_align_jump_out : word_align_jump_in), .clk(clk), .rst(rst));
dff RegWrt(.q(RegWrt_out), .d(mem_stall | fetch_stall ? RegWrt_out : RegWrt_in), .clk(clk), .rst(rst));
dff SendNOP(.q(SendNOP_Out), .d(mem_stall | fetch_stall ? SendNOP_Out : SendNOP_In), .clk(clk), .rst(rst));
dff RegSrc [1:0](.q(RegSrc_out), .d(mem_stall | fetch_stall ? RegSrc_out : RegSrc_in), .clk(clk), .rst(rst));
dff pc2 [15:0](.q(pc2_out), .d(mem_stall | fetch_stall ? pc2_out : pc2_in), .clk(clk), .rst(rst));
dff write_reg [2:0](.q(write_reg_out), .d(mem_stall | fetch_stall ? write_reg_out : write_reg_in), .clk(clk), .rst(rst));

dff memrd(.q(MemRd_out), .d(mem_stall | fetch_stall ? MemRd_out : MemRd_in), .clk(clk), .rst(rst));

endmodule