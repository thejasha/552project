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

   wire [15:0] data_write;

    //externeal control singals
    wire ImmSrc;

    wire [15:0] temp;//this just dont work rn, its the instructions from memeory

    //IF_ID FLOP
    wire [15:0] instruction;
    wire [15:0] instruction_out_IF_ID;
    wire [15:0] pc_next_to_IF_ID;
    wire [15:0] pc_next_out_IF_ID;

    //ID_EX FLOP
    wire [15:0] pc_next_out_ID_EX;
    
    wire BTR_to_ID_EX;
    wire BTR_out_ID_EX;

    wire [1:0] BSrc_to_ID_EX;
    wire [1:0] BSrc_out_ID_EX;

    wire InvB_to_ID_EX;
    wire InvB_out_ID_EX;
    
    wire InvA_to_ID_EX;
    wire InvA_out_ID_EX;

    wire [15:0] read_data_1_to_ID_EX;
    wire [15:0] read_data_1_out_ID_EX;

    wire [15:0] read_data_2_to_ID_EX;
    wire [15:0] read_data_2_out_ID_EX;

    wire [15:0] i1_to_ID_EX;
    wire [15:0] i1_out_ID_EX;

    wire [15:0] i2_to_ID_EX;
    wire [15:0] i2_out_ID_EX;

    wire [15:0] word_align_jump_to_ID_EX;
    wire [15:0] word_align_jump_out_ID_EX;

    wire [15:0] to_shift_to_ID_EX;
    wire [15:0] to_shift_out_ID_EX;

    wire [2:0] ALUOpr_to_ID_EX;
    wire [2:0] ALUOpr_out_ID_EX;

    wire MemWrt_to_ID_EX;
    wire MemWrt_out_ID_EX;

    wire [1:0] branch_command_to_ID_EX;
    wire [1:0] branch_command_out_ID_EX;

    wire branching_to_ID_EX;
    wire branching_out_ID_EX;

    wire SLBI_to_ID_EX;
    wire SLBI_out_ID_EX;

    wire [2:0] SetCtrl_to_ID_EX;
    wire [2:0] SetCtrl_out_ID_EX;

    wire ALUJMP_in_ID_EX;
    wire ALUJMP_out_ID_EX;

    wire PC_or_add_in_ID_EX;
    wire PC_or_add_out_ID_EX;

    wire [1:0] RegSrc_to_ID_EX;
    wire [1:0] RegSrc_out_ID_EX;

    wire halt_to_ID_EX;
    wire halt_out_ID_EX;

    wire RegWrt_to_ID_EX;
    wire RegWrt_out_ID_EX;

    wire [2:0] write_reg_to_ID_EX;
    wire [2:0] write_reg_out_ID_EX;

    //EX_MEM FLOP
    wire branchtake_to_EX_MEM;
    wire branchtake_out_EX_MEM;

    wire [15:0] Alu_result_to_EX_MEM;
    wire [15:0] Alu_result_out_EX_MEM;

    wire [15:0] Binput_to_EX_MEM;
    wire [15:0] Binput_out_EX_MEM;

    wire branching_out_EX_MEM;

    wire PC_or_add_out_EX_MEM;

    wire ALUJMP_out_EX_MEM;

    wire MemWrt_out_EX_MEM;

    wire halt_out_EX_MEM;

    wire [15:0] word_align_jump_out_EX_MEM;
 
    wire [15:0] read_data_2_out_EX_MEM;

    wire [15:0] pc_next_out_EX_MEM;

    wire [15:0] i2_out_EX_MEM;

    wire RegWrt_out_EX_MEM;

    wire [1:0] RegSrc_out_EX_MEM;

    wire [2:0] write_reg_out_EX_MEM;

    // MEM_WB flop

    wire [15:0] memory_data_to_MEM_WB;
    wire [15:0] memory_data_out_MEM_WB;

    wire [15:0] pc_goes_back_fetch_in_MEM_WB;
    wire [15:0] pc_goes_back_fetch_out_MEM_WB;

    wire [1:0] RegSrc_out_MEM_WB;

    wire [15:0] Binput_out_MEM_WB;
    
    wire RegWrt_out_MEM_WB;

    wire [15:0] Alu_result_out_MEM_WB;

    wire [2:0] write_reg_out_MEM_WB;


    wire err1;

    //

    //might have to code something for pc

    wire [15:0] MUX_OUT_ONE, MUX_OUT_TWO, PC_NO_PLUS_TWO, PC_NO_PLUS_TWO_BACK;
    wire SendNop;
    assign MUX_OUT_ONE = (branchtake_out_EX_MEM | PC_or_add_out_EX_MEM | ALUJMP_out_EX_MEM)? pc_goes_back_fetch_in_MEM_WB : pc_next_to_IF_ID;
    assign MUX_OUT_TWO = (~SendNop & (instruction_out_IF_ID[15:11] != 5'b00001)) ? PC_NO_PLUS_TWO : MUX_OUT_ONE;
    wire [15:0] inst_again;
    assign inst_again = (~SendNop & (instruction_out_IF_ID[15:11] !=5'b00001)) ? instruction_out_IF_ID : instruction;

    fetch iDUU1(.PC_in(MUX_OUT_TWO), .PC_next(pc_next_to_IF_ID), .instruction(instruction), .pc_temp(PC_NO_PLUS_TWO), .clk(clk), .rst(rst));


    IF_ID latch1(.PC_next_in(pc_next_to_IF_ID), .PC_next_in_out(pc_next_out_IF_ID), .instruction_in(inst_again), .instruction_out(instruction_out_IF_ID), .PC_NO_PLUS_TWO_IN(PC_NO_PLUS_TWO), .PC_NO_PLUS_TWO_OUT(PC_NO_PLUS_TWO_BACK), .clk(clk), .rst(rst));

    // need to make the regwrt singal go thru all flops then back, same with the register write address
    wire MemWrt_Decode_Out;
    wire RegWrt_Decode_Out;
    wire NOP_Out_ID_EX;
    wire NOP_Out_ID_MEM;
    wire NOP_Out_ID_WB;

    decode iDUU2 (.clk(clk), .rst(rst), .err(err1), .instruction(instruction_out_IF_ID), .read_data_1(read_data_1_to_ID_EX), .read_data_2(read_data_2_to_ID_EX), .i_1(i1_to_ID_EX), .i_2(i2_to_ID_EX), .word_align_jump(word_align_jump_to_ID_EX),  .to_shift(to_shift_to_ID_EX), 
            .data_write(data_write), .ALUOpr(ALUOpr_to_ID_EX), .Bsrc(BSrc_to_ID_EX), .InvB(InvB_to_ID_EX), .InvA(InvA_to_ID_EX), .ImmSrc(ImmSrc), .MemWrt(MemWrt_Decode_Out), .ALUJMP(ALUJMP_in_ID_EX), .PC_or_add(PC_or_add_in_ID_EX), .RegSrc(RegSrc_to_ID_EX), .SLBI(SLBI_to_ID_EX), 
            .BTR(BTR_to_ID_EX), .branching(branching_to_ID_EX), .branch_command(branch_command_to_ID_EX), .SetCtrl(SetCtrl_to_ID_EX), .halt(halt_to_ID_EX), .RegWrt(RegWrt_Decode_Out), .write_reg_from_wb(write_reg_out_MEM_WB), .write_reg_out(write_reg_to_ID_EX), .RegWrt_from_wb(RegWrt_out_MEM_WB));

    comparator IDUUT(.inst(instruction_out_IF_ID), .execute(write_reg_out_ID_EX), .memory(write_reg_out_EX_MEM), .writeback(write_reg_out_MEM_WB), .BSrc(BSrc_to_ID_EX), .Branch(branching_to_ID_EX), .BranchEx(branching_out_ID_EX), .NOPEx(NOP_Out_ID_EX), .NOPMem(NOP_Out_ID_MEM), .NOPWB(NOP_Out_ID_WB), .sendNOP(SendNop));

    assign MemWrt_to_ID_EX = SendNop ? MemWrt_Decode_Out : 1'b0;
    assign RegWrt_to_ID_EX = SendNop ? RegWrt_Decode_Out : 1'b0;



    //data write will come back from memory, dont even need to latch it
    
    ID_EX latch2(.BSrc_in(BSrc_to_ID_EX), .BSrc_out(BSrc_out_ID_EX), .InvB_in(InvB_to_ID_EX), .InvB_out(InvB_out_ID_EX), .InvA_in(InvA_to_ID_EX), .InvA_out(InvA_out_ID_EX), .ALUCtrl_in(ALUOpr_to_ID_EX), .ALUCtrl_out(ALUOpr_out_ID_EX), .BranchCtrl_in(branch_command_to_ID_EX), .BranchCtrl_out(branch_command_out_ID_EX), 
            .branch_in(branching_to_ID_EX), .branch_out(branching_out_ID_EX), .SLBI_in(SLBI_to_ID_EX), .SLBI_out(SLBI_out_ID_EX), .SetCtrl3_in(SetCtrl_to_ID_EX), .SetCtrl3_out(SetCtrl_out_ID_EX), .BTR_in(BTR_to_ID_EX), .BTR_out(BTR_out_ID_EX), .ReadData1_in(read_data_1_to_ID_EX), .ReadData1_out(read_data_1_out_ID_EX),
            .ReadData2_in(read_data_2_to_ID_EX), .ReadData2_out(read_data_2_out_ID_EX), .fourExtend_in(i1_to_ID_EX), .fourExtend_out(i1_out_ID_EX), .sevenExtend_in(i2_to_ID_EX), .sevenExtend_out(i2_out_ID_EX), .shifted_in(to_shift_to_ID_EX), .shifted_out(to_shift_out_ID_EX), 
            .MemWrt_in(MemWrt_to_ID_EX), .MemWrt_out(MemWrt_out_ID_EX), .ALUJMP_in(ALUJMP_in_ID_EX), .ALUJMP_out(ALUJMP_out_ID_EX), .PC_or_add_in(PC_or_add_in_ID_EX), .PC_or_add_out(PC_or_add_out_ID_EX), .halt_in(halt_to_ID_EX), .halt_out(halt_out_ID_EX), .word_align_jump_in(word_align_jump_to_ID_EX), .word_align_jump_out(word_align_jump_out_ID_EX), 
            .RegWrt_in(RegWrt_to_ID_EX), .RegWrt_out(RegWrt_out_ID_EX), .RegSrc_in(RegSrc_to_ID_EX), .RegSrc_out(RegSrc_out_ID_EX), .pc2_in(pc_next_out_IF_ID), .pc2_out(pc_next_out_ID_EX), .write_reg_in(write_reg_to_ID_EX), .write_reg_out(write_reg_out_ID_EX), .SendNOP_In(SendNop), .SendNOP_Out(NOP_Out_ID_EX), .clk(clk), .rst(rst));
    
    
    execute iDUU3(.BSrc(BSrc_out_ID_EX), .InvB(InvB_out_ID_EX), .InvA(InvA_out_ID_EX), .ALUCtrl(ALUOpr_out_ID_EX), .ReadData1(read_data_1_out_ID_EX), .ReadData2(read_data_2_out_ID_EX), 
        .fourExtend(i1_out_ID_EX), .sevenExtend(i2_out_ID_EX), .shifted(to_shift_out_ID_EX), .BranchCtrl(branch_command_out_ID_EX), 
        .branch(branching_out_ID_EX), .SLBI(SLBI_out_ID_EX), .SetCtrl3(SetCtrl_out_ID_EX), 
        .BTR(BTR_out_ID_EX), .ALU(Alu_result_to_EX_MEM), .BInput(Binput_to_EX_MEM), .branchtake(branchtake_to_EX_MEM));

    EX_MEM latch3(.ALU_in(Alu_result_to_EX_MEM), .ALU_out(Alu_result_out_EX_MEM), .BInput_in(Binput_to_EX_MEM), .BInput_out(Binput_out_EX_MEM), .branchtake_in(branchtake_to_EX_MEM), .branchtake_out(branchtake_out_EX_MEM),
        .branch_out(branching_out_EX_MEM), .branch_in(branching_out_ID_EX), .PC_or_add_in(PC_or_add_out_ID_EX), .PC_or_add_out(PC_or_add_out_EX_MEM), .ALUJmp_in(ALUJMP_out_ID_EX), .ALUJmp_out(ALUJMP_out_EX_MEM), .MemWrt_in(MemWrt_out_ID_EX), 
        .MemWrt_out(MemWrt_out_EX_MEM), .halt_in(halt_out_ID_EX), .halt_out(halt_out_EX_MEM), .SgnExt_in(word_align_jump_out_ID_EX), .SgnExt_out(word_align_jump_out_EX_MEM), .readData2_in(read_data_2_out_ID_EX), .readData2_out(read_data_2_out_EX_MEM), 
        .pc2_in(pc_next_out_ID_EX), .pc2_out(pc_next_out_EX_MEM), .sevenext_in(i2_out_ID_EX), .sevenext_out(i2_out_EX_MEM), .RegWrt_in(RegWrt_out_ID_EX), .RegWrt_out(RegWrt_out_EX_MEM), .RegSrc_in(RegSrc_out_ID_EX), 
        .RegSrc_out(RegSrc_out_EX_MEM), .write_reg_in(write_reg_out_ID_EX), .write_reg_out(write_reg_out_EX_MEM), .SendNOP_In(NOP_Out_ID_EX), .SendNOP_Out(NOP_Out_ID_MEM), .clk(clk), .rst(rst));


    memory iDUU4(.branch(branchtake_out_EX_MEM), .alu(Alu_result_out_EX_MEM), .SgnExt(word_align_jump_out_ID_EX), .readData2(read_data_2_out_EX_MEM), .pc2(pc_next_out_EX_MEM), .ALUJmp(ALUJMP_out_EX_MEM), .PC_or_add(PC_or_add_out_EX_MEM), .MemWrt(MemWrt_out_EX_MEM), 
    .clk(clk), .rst(rst), .newPC(pc_goes_back_fetch_in_MEM_WB), .MemRead(memory_data_to_MEM_WB), .sevenext(i2_out_EX_MEM), .halt(halt_out_EX_MEM));


    MEM_WB latch4(.RegSrc_in(RegSrc_out_EX_MEM), .RegSrc_out(RegSrc_out_MEM_WB), .MemRead_in(memory_data_to_MEM_WB), .mem_data_out(memory_data_out_MEM_WB), .alu_data_in(Alu_result_out_EX_MEM), 
    .pc_data_in(pc_next_out_EX_MEM), .Binput_in(Binput_out_EX_MEM), .alu_data_out(Alu_result_out_MEM_WB), .pc_data_out(pc_goes_back_fetch_out_MEM_WB), .Binput_out(Binput_out_MEM_WB), .RegWrt_in(RegWrt_out_EX_MEM), .RegWrt_out(RegWrt_out_MEM_WB), 
    .write_reg_in(write_reg_out_EX_MEM), .write_reg_out(write_reg_out_MEM_WB), .SendNOP_In(NOP_Out_ID_MEM), .SendNOP_Out(NOP_Out_ID_WB), .clk(clk), .rst(rst));


    wb iDUU5(.RegSrc(RegSrc_out_MEM_WB), .mem_data(memory_data_out_MEM_WB), .alu_data(Alu_result_out_MEM_WB), .Binput(Binput_out_MEM_WB), .pc_data(pc_goes_back_fetch_out_MEM_WB), .data_to_write(data_write));


endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
