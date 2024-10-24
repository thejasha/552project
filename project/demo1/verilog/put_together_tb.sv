module put_together_tb();

    // Declare signals
    logic clk, rst, err; //error will output, clk rst are inputs

    logic [15:0] instruction, read_data_1, read_data_2, i_1, i_2, word_align_jump, to_shift, data_write; //stuff form decode
    
    //externeal control singals
    logic [2:0] ALUOpr;
    logic InvB, InvA, ImmSrc, MemWrt, ALUJMP, PC_or_add, SLBI, BTR;
    logic [1:0 ]RegSrc, Bsrc;

            //alu from exe, pc input, input b from exe
    logic [15:0] input1, pcinput, input3;

    //data from Mem stage
    logic[15:0] memory_data;

    //PC stuff
    logic [15:0] pc_next_to_pc2;
    logic[15:0] pc_goes_back_fetch;



    logic from_exe;// branch control from exe
    logic [15:0] temp;//this just dont work rn, its the instructions from memeory

    //might have to code something for pc
    fetch iDUU1(.PC_in(pcinput), .PC_next(pc_next_to_pc2), .instruction(temp), .clk(clk), .rst(rst));

    decode iDUU2 (.clk(clk), .rst(rst), .err(err), .instruction(instruction), .read_data_1(read_data_1), .read_data_2(read_data_2), .i_1(i_1), .i_2(i_2), .word_align_jump(word_align_jump),  .to_shift(to_shift), 
            .data_write(data_write), .ALUOpr(ALUOpr), .Bsrc(Bsrc), .InvB(InvB), .InvA(InvA), .ImmSrc(ImmSrc), .MemWrt(MemWrt), .ALUJMP(ALUJMP), .PC_or_add(PC_or_add), .RegSrc(RegSrc), .SLBI(SLBI), .BTR(BTR));
    // execute iDUU3
    //branch need to fix, pc2 need to add
    memory iDUU4(.branch(from_exe), .alu(input1), .SgnExt(word_align_jump), .readData2(read_data_2), .pc2(pc_next_to_pc2), .ALUJmp(ALUJMP), .PC_or_add(PC_or_add), .MemWrt(MemWrt), .clk(clk), .rst(rst), .newPC(pc_goes_back_fetch), .MemRead(memory_data), .sevenext(i_2));
    wb iDUU5(.RegSrc(RegSrc), .mem_data(memory_data), .alu_data(input1), .other_data(input3), .pc_data(pc_next_to_pc2), .data_to_write(data_write));

    
    initial begin
        clk = 1'b0;
        rst = 1'b1;

        @(negedge clk);
        rst = 1'b0;
        instruction = 16'b0101100000010000;
        input1 = 16'h0001;
        pcinput = 16'h0000;
        input3 = 16'h0003;
        from_exe = 1'b0;

        //this stores 01 into RD or 000

        @(negedge clk);
        instruction = 16'b1000000000000000;

        @(negedge clk);
        instruction = 16'b0000000000000000;
     
        repeat(2) @(negedge clk);

        $stop();
    end

    always 
        #5 clk = ~clk;

endmodule