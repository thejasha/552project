module put_together_tb();

    // Declare signals
    logic clk, rst, err; //error will output, clk rst are inputs
    

    logic [15:0] data_write;

    //externeal control singals
    logic ImmSrc;

    //data from Mem stage
    logic[15:0] memory_data;

    logic [15:0] pc_next_to_pc2;

    logic[15:0] pc_goes_back_fetch;

    logic [15:0] temp;//this just dont work rn, its the instructions from memeory

    //IF_ID FLOP
    logic [15:0] instruction;
    logic [15:0] instruction_out_IF_ID;
    logic [15:0] pc_next_to_IF_ID;
    logic [15:0] pc_next_out_IF_ID;

    //ID_EX FLOP
    logic [15:0] pc_next_out_ID_EX;
    
    logic BTR_to_ID_EX;
    logic BTR_out_ID_EX;

    logic [1:0] BSrc_to_ID_EX;
    logic [1:0] BSrc_out_ID_EX;

    logic InvB_to_ID_EX;
    logic InvB_out_ID_EX;
    
    logic InvA_to_ID_EX;
    logic InvA_out_ID_EX;

    logic [15:0] read_data_1_to_ID_EX;
    logic [15:0] read_data_1_out_ID_EX;

    logic [15:0] read_data_2_to_ID_EX;
    logic [15:0] read_data_2_out_ID_EX;

    logic [15:0] i1_to_ID_EX;
    logic [15:0] i1_out_ID_EX;

    logic [15:0] i2_to_ID_EX;
    logic [15:0] i2_out_ID_EX;

    logic [15:0] word_align_jump_to_ID_EX;
    logic [15:0] word_align_jump_out_ID_EX;

    logic [15:0] to_shift_to_ID_EX;
    logic [15:0] to_shift_out_ID_EX;

    logic [2:0] ALUOpr_to_ID_EX;
    logic [2:0] ALUOpr_out_ID_EX;

    logic MemWrt_to_ID_EX;
    logic MemWrt_out_ID_EX;

    logic [1:0] branch_command_to_ID_EX;
    logic [1:0] branch_command_out_ID_EX;

    logic branching_to_ID_EX;
    logic branching_out_ID_EX;

    logic SLBI_to_ID_EX;
    logic SLBI_out_ID_EX;

    logic [2:0] SetCtrl_to_ID_EX;
    logic [2:0] SetCtrl_out_ID_EX;

    logic ALUJMP_in_ID_EX;
    logic ALUJMP_out_ID_EX;

    logic PC_or_add_in_ID_EX;
    logic PC_or_add_out_ID_EX;

    logic [1:0] RegSrc_to_ID_EX;
    logic [1:0] RegSrc_out_ID_EX;

    logic halt_to_ID_EX;
    logic halt_out_ID_EX;

    //EX_MEM FLOP
    logic branchtake_to_EX_MEM;
    logic branchtake_out_EX_MEM;

    logic [15:0] Alu_result_to_EX_MEM;
    logic [15:0] Alu_result_out_EX_MEM;

    logic [15:0] Binput_to_EX_MEM;
    logic [15:0] Binput_out_EX_MEM;

    logic branching_out_EX_MEM;

    logic PC_or_add_out_EX_MEM;

    logic ALUJMP_out_EX_MEM;

    logic MemWrt_out_EX_MEM;

    logic halt_out_EX_MEM;

    logic [15:0] word_align_jump_out_EX_MEM;
 
    logic [15:0] read_data_2_out_EX_MEM;

    logic [15:0] pc_next_out_EX_MEM;

    logic [15:0] i2_out_EX_MEM;

    logic [1:0] RegSrc_out_EX_MEM;

    // MEM_WB flop

    logic [15:0] memory_data_to_MEM_WB;
    logic [15:0] memory_data_out_MEM_WB;

    logic [15:0] pc_goes_back_fetch_in_MEM_WB;
    logic [15:0] pc_goes_back_fetch_out_MEM_WB;

    logic [1:0] RegSrc_out_MEM_WB;

    logic [15:0] Binput_out_MEM_WB;

    logic [15:0] Alu_result_out_MEM_WB;

    //

    //might have to code something for pc
    fetch iDUU1(.PC_in(pc_goes_back_fetch), .PC_next(pc_next_to_IF_ID), .instruction(temp), .clk(clk), .rst(rst));


    IF_ID latch1(.PC_next_in(pc_next_to_IF_ID), .PC_next_in_out(pc_next_out_IF_ID), .instruction_in(instruction), .instruction_out(instruction_out_IF_ID), .clk(clk), .rst(rst));


    decode iDUU2 (.clk(clk), .rst(rst), .err(err), .instruction(instruction_out_IF_ID), .read_data_1(read_data_1_to_ID_EX), .read_data_2(read_data_2_to_ID_EX), .i_1(i1_to_ID_EX), .i_2(i2_to_ID_EX), .word_align_jump(word_align_jump_to_ID_EX),  .to_shift(to_shift_to_ID_EX), 
            .data_write(data_write), .ALUOpr(ALUOpr_to_ID_EX), .Bsrc(BSrc_to_ID_EX), .InvB(InvB_to_ID_EX), .InvA(InvA_to_ID_EX), .ImmSrc(ImmSrc), .MemWrt(MemWrt_to_ID_EX), .ALUJMP(ALUJMP_in_ID_EX), .PC_or_add(PC_or_add_in_ID_EX), .RegSrc(RegSrc_to_ID_EX), .SLBI(SLBI_to_ID_EX), 
            .BTR(BTR_to_ID_EX), .branching(branching_to_ID_EX), .branch_command(branch_command_to_ID_EX), .SetCtrl(SetCtrl_to_ID_EX), .halt(halt_to_ID_EX));

    //data write will come back from memory, dont even need to latch it
    ID_EX latch2(.BSrc_in(BSrc_to_ID_EX), .BSrc_out(BSrc_out_ID_EX), .InvB_in(InvB_to_ID_EX), .InvB_out(InvB_out_ID_EX), .InvA_in(InvA_to_ID_EX), .InvA_out(InvA_out_ID_EX), .ALUCtrl_in(ALUOpr_to_ID_EX), .ALUCtrl_out(ALUOpr_out_ID_EX), .BranchCtrl_in(branch_command_to_ID_EX), .BranchCtrl_out(branch_command_out_ID_EX), 
            .branch_in(branching_to_ID_EX), .branch_out(branching_out_ID_EX), .SLBI_in(SLBI_to_ID_EX), .SLBI_out(SLBI_out_ID_EX), .SetCtrl3_in(SetCtrl_to_ID_EX), .SetCtrl3_out(SetCtrl_out_ID_EX), .BTR_in(BTR_to_ID_EX), .BTR_out(BTR_out_ID_EX), .ReadData1_in(read_data_1_to_ID_EX), .ReadData1_out(read_data_1_out_ID_EX),
            .ReadData2_in(read_data_2_to_ID_EX), .ReadData2_out(read_data_2_out_ID_EX), .fourExtend_in(i1_to_ID_EX), .fourExtend_out(i1_out_ID_EX), .sevenExtend_in(i2_to_ID_EX), .sevenExtend_out(i2_out_ID_EX), .shifted_in(to_shift_to_ID_EX), .shifted_out(to_shift_out_ID_EX), 
            .MemWrt_in(MemWrt_to_ID_EX), .MemWrt_out(MemWrt_out_ID_EX), .ALUJMP_in(ALUJMP_in_ID_EX), .ALUJMP_out(ALUJMP_out_ID_EX), .PC_or_add_in(PC_or_add_in_ID_EX), .PC_or_add_out(PC_or_add_out_ID_EX), .halt_in(halt_to_ID_EX), .halt_out(halt_out_ID_EX), .word_align_jump_in(word_align_jump_to_ID_EX), .word_align_jump_out(word_align_jump_out_ID_EX), 
            .RegWrt_in(), .RegWrt_out(), .RegSrc_in(RegSrc_to_ID_EX), .RegSrc_out(RegSrc_out_ID_EX), .pc2_in(pc_next_out_IF_ID), .pc2_out(pc_next_out_ID_EX), .clk(clk), .rst(rst));
    
    
    execute iDUU3(.BSrc(BSrc_out_ID_EX), .InvB(InvB_out_ID_EX), .InvA(InvA_out_ID_EX), .ALUCtrl(ALUOpr_out_ID_EX), .ReadData1(read_data_1_out_ID_EX), .ReadData2(read_data_2_out_ID_EX), 
        .fourExtend(i1_out_ID_EX), .sevenExtend(i2_out_ID_EX), .shifted(to_shift_out_ID_EX), .BranchCtrl(branch_command_out_ID_EX), 
        .branch(branching_out_ID_EX), .SLBI(SLBI_out_ID_EX), .SetCtrl3(SetCtrl_out_ID_EX), 
        .BTR(BTR_out_ID_EX), .ALU(Alu_result_to_EX_MEM), .BInput(Binput_to_EX_MEM), .branchtake(branchtake_to_EX_MEM));

    EX_MEM latch3(.ALU_in(Alu_result_to_EX_MEM), .ALU_out(Alu_result_out_EX_MEM), .BInput_in(Binput_to_EX_MEM), .BInput_out(Binput_out_EX_MEM), .branchtake_in(branchtake_to_EX_MEM), .branchtake_out(branchtake_out_EX_MEM),
        .branch_out(branching_out_EX_MEM), .branch_in(branching_out_ID_EX), .PC_or_add_in(PC_or_add_out_ID_EX), .PC_or_add_out(PC_or_add_out_EX_MEM), .ALUJmp_in(ALUJMP_out_ID_EX), .ALUJmp_out(ALUJMP_out_EX_MEM), .MemWrt_in(MemWrt_out_ID_EX), 
        .MemWrt_out(MemWrt_out_EX_MEM), .halt_in(halt_out_ID_EX), .halt_out(halt_out_EX_MEM), .SgnExt_in(word_align_jump_out_ID_EX), .SgnExt_out(word_align_jump_out_EX_MEM), .readData2_in(read_data_2_out_ID_EX), .readData2_out(read_data_2_out_EX_MEM), 
        .pc2_in(pc_next_out_ID_EX), .pc2_out(pc_next_out_EX_MEM), .sevenext_in(i2_out_ID_EX), .sevenext_out(i2_out_EX_MEM), .RegWrt_in(), .RegWrt_out(), .RegSrc_in(RegSrc_out_ID_EX), 
        .RegSrc_out(RegSrc_out_EX_MEM), .clk(clk), .rst(rst));


    memory iDUU4(.branch(branchtake_out_EX_MEM), .alu(Alu_result_out_EX_MEM), .SgnExt(word_align_jump_out_ID_EX), .readData2(read_data_2_out_EX_MEM), .pc2(pc_next_out_EX_MEM), .ALUJmp(ALUJMP_out_EX_MEM), .PC_or_add(PC_or_add_out_EX_MEM), .MemWrt(MemWrt_out_EX_MEM), 
    .clk(clk), .rst(rst), .newPC(pc_goes_back_fetch_in_MEM_WB), .MemRead(memory_data_to_MEM_WB), .sevenext(i2_out_EX_MEM), .halt(halt_out_EX_MEM));


    MEM_WB latch4(.RegSrc_in(RegSrc_out_ID_EX), .RegSrc_out(RegSrc_out_MEM_WB), .MemRead_in(memory_data_to_MEM_WB), .mem_data_out(memory_data_out_MEM_WB), .alu_data_in(Alu_result_out_EX_MEM), 
    .pc_data_in(pc_goes_back_fetch_in_MEM_WB), .Binput_in(Binput_out_EX_MEM), .alu_data_out(Alu_result_out_MEM_WB), .pc_data_out(pc_goes_back_fetch_out_MEM_WB), .Binput_out(Binput_out_MEM_WB), .RegWrt_in(), .RegWrt_out(), .clk(clk), .rst(rst));


    wb iDUU5(.RegSrc(RegSrc_out_MEM_WB), .mem_data(memory_data_out_MEM_WB), .alu_data(Alu_result_out_MEM_WB), .Binput(Binput_out_MEM_WB), .pc_data(pc_goes_back_fetch_out_MEM_WB), .data_to_write(data_write));



    // //CODE WITH CONNECTIONS THAT WORKED
    // fetch iDUU1(.PC_in(pc_goes_back_fetch), .PC_next(pc_next_to_pc2), .instruction(temp), .clk(clk), .rst(rst));

    // decode iDUU2 (.clk(clk), .rst(rst), .err(err), .instruction(instruction), .read_data_1(read_data_1), .read_data_2(read_data_2), .i_1(i_1), .i_2(i_2), .word_align_jump(word_align_jump),  .to_shift(to_shift), 
    //         .data_write(data_write), .ALUOpr(ALUOpr), .Bsrc(Bsrc), .InvB(InvB), .InvA(InvA), .ImmSrc(ImmSrc), .MemWrt(MemWrt), .ALUJMP(ALUJMP), .PC_or_add(PC_or_add), .RegSrc(RegSrc), .SLBI(SLBI), 
    //         .BTR(BTR), .branching(branching), .branch_command(branch_command), .SetCtrl(SetCtrl));
    
    // execute iDUU3(.BSrc(Bsrc), .InvB(InvB), .InvA(InvA), .ALUCtrl(ALUOpr), .ReadData1(read_data_1), .ReadData2(read_data_2), 
    //     .fourExtend(i_1), .sevenExtend(i_2), .shifted(to_shift), .BranchCtrl(branch_command), 
    //     .branch(branching), .SLBI(SLBI), .SetCtrl3(SetCtrl), 
    //     .BTR(BTR), .ALU(Alu_result), .BInput(Binput), .branchtake(branchtake));


    // memory iDUU4(.branch(branchtake), .alu(Alu_result), .SgnExt(word_align_jump), .readData2(read_data_2), .pc2(pc_next_to_pc2), .ALUJmp(ALUJMP), .PC_or_add(PC_or_add), .MemWrt(MemWrt), 
    // .clk(clk), .rst(rst), .newPC(pc_goes_back_fetch), .MemRead(memory_data), .sevenext(i_2));

    // wb iDUU5(.RegSrc(RegSrc), .mem_data(memory_data), .alu_data(Alu_result), .Binput(Binput), .pc_data(pc_next_to_pc2), .data_to_write(data_write));

    
    initial begin
        clk = 1'b0;
        rst = 1'b1;
        temp = 16'b0;

        @(negedge clk);
        rst = 1'b0;
        instruction = 16'b1100000000000001;

        @(negedge clk);

        @(negedge clk);

        @(negedge clk);

        $stop();
    end

    always 
        #5 clk = ~clk;

endmodule