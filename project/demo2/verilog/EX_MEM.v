module EX_MEM(
ALU_in, ALU_out, BInput_in, BInput_out, branchtake_in, branchtake_out, alu_in, alu_out,
branch_out, branch_in, PC_or_add_in, PC_or_add_out, ALUJmp_in, ALUJmp_out, MemWrt_in, 
MemWrt_out, halt_in, halt_out, SgnExt_in, SgnExt_out;, readData2_in, readData2_out, 
pc2_in, pc2_out, sevenext_in, sevenext_out, RegWrt_in, RegWrt_out, RegSrc_in, 
RegSrc_out, Binput_in, Binput_out);

/*
model
memory iDUU4(.branch(branchtake), .alu(Alu_result), .SgnExt(word_align_jump), .readData2(read_data_2), .pc2(pc_next_to_pc2), .ALUJmp(ALUJMP), .PC_or_add(PC_or_add), .MemWrt(MemWrt), .clk(clk), 
    .rst(rst), .newPC(pc_goes_back_fetch), .MemRead(memory_data), .sevenext(i_2), .halt(halt));
*/


/*FROM EX TO MEM*/

    //outputs from just ex
    input wire [15:0] ALU_in; //the alu output
    output wire [15:0] ALU_out;

    input wire [15:0] BInput_in; //the input for the b alu
    output wire [15:0] BInput_out;

    input wire branchtake_in; //1 when we branching and conditions pass 
    output wire branchtake_out;

    
    //data need into MEM
    input wire [15:0] alu_in; //alu output
    output wire [15:0] alu_out; 


/*FROM ID_EX flop TO MEM*/

    //signals need for mem
    output wire branch_out; //comesin anded with the conditions
    input wire branch_in;
  
    input wire PC_or_add_in; //secondmux
    output wire PC_or_add_out; //secondmux
    
    input wire ALUJmp_in;
    output wire ALUJmp_out;
    
    input wire MemWrt_in;
    output wire MemWrt_out;
    
    input wire halt_in;
    output wire halt_out;

    //Data needed for mem

    input wire [15:0] SgnExt_in; //sign extended immdiate
    output wire [15:0] SgnExt_out; 
    
    input wire [15:0] readData2_in; //reg read daata 2
    output wire [15:0] readData2_out; 
    
    input wire [15:0] pc2_in; //pc + 2
    output wire [15:0] pc2_out; 
    
    input wire [15:0] sevenext_in; //value for JALR add
    output wire [15:0] sevenext_out; 


/*STFF not used in MEM*/

    //To MEM_WB
    input wire RegWrt_in;
    output wire RegWrt_out;

    //To WB
    input wire [1:0] RegSrc_in;
    output wire [1:0] RegSrc_out;

    //To WB
    input wire [15:0] Binput_in;
    output wire [15:0] Binput_out;

dff [15:0] ();

endmodule