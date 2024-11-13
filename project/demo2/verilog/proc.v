/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
`default_nettype none
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input wire clk;
   input wire rst;

   output reg err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   clkrst my_clkrst(.clk(clk), .rst(rst), .err(err)); 

   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */

   // Declare signals
    wire [15:0] instruction, read_data_1, read_data_2, i_1, i_2, word_align_jump, to_shift, data_write; //stuff form decode
    
    //externeal control singals
    wire [2:0] ALUOpr, SetCtrl;
    wire InvB, InvA, ImmSrc, MemWrt, ALUJMP, PC_or_add, SLBI, BTR, branching, halt;
    wire [1:0]RegSrc, Bsrc, branch_command;

    //external from exe to mem
    wire branchtake;

    wire [15:0] Alu_result; //exe to mem and wb, alu result

    //input of b that goes to other stuff
    wire [15:0] Binput;

    //data from Mem stage
    wire[15:0] memory_data;

    //PC stuff
    wire [15:0] pc_next_to_pc2;
    wire [15:0] pc_goes_back_fetch;

    wire [15:0] temp;//this just dont work rn, its the instructions from memeory

    wire err1;

    //might have to code something for pc
    fetch iDUU1(.PC_in(pc_goes_back_fetch), .PC_next(pc_next_to_pc2), .instruction(instruction), .clk(clk), .rst(rst));

    decode iDUU2 (.clk(clk), .rst(rst), .err(err1), .instruction(instruction), .read_data_1(read_data_1), .read_data_2(read_data_2), .i_1(i_1), .i_2(i_2), .word_align_jump(word_align_jump),  .to_shift(to_shift), 
            .data_write(data_write), .ALUOpr(ALUOpr), .Bsrc(Bsrc), .InvB(InvB), .InvA(InvA), .ImmSrc(ImmSrc), .MemWrt(MemWrt), .ALUJMP(ALUJMP), .PC_or_add(PC_or_add), .RegSrc(RegSrc), .SLBI(SLBI), 
            .BTR(BTR), .branching(branching), .branch_command(branch_command), .SetCtrl(SetCtrl), .halt(halt));

    execute iDUU3(.BSrc(Bsrc), .InvB(InvB), .InvA(InvA), .ALUCtrl(ALUOpr), .ReadData1(read_data_1), .ReadData2(read_data_2), 
        .fourExtend(i_1), .sevenExtend(i_2), .shifted(to_shift), .BranchCtrl(branch_command), 
        .branch(branching), .SLBI(SLBI), .SetCtrl3(SetCtrl), 
        .BTR(BTR), .ALU(Alu_result), .BInput(Binput), .branchtake(branchtake));

    memory iDUU4(.branch(branchtake), .alu(Alu_result), .SgnExt(word_align_jump), .readData2(read_data_2), .pc2(pc_next_to_pc2), .ALUJmp(ALUJMP), .PC_or_add(PC_or_add), .MemWrt(MemWrt), .clk(clk), 
    .rst(rst), .newPC(pc_goes_back_fetch), .MemRead(memory_data), .sevenext(i_2), .halt(halt));
    
    wb iDUU5(.RegSrc(RegSrc), .mem_data(memory_data), .alu_data(Alu_result), .Binput(Binput), .pc_data(pc_next_to_pc2), .data_to_write(data_write));
   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
