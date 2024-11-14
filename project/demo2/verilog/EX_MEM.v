module EX_MEM(
ALU_in, ALU_out, BInput_in, BInput_out, branchtake_in, branchtake_out,
branch_out, branch_in, PC_or_add_in, PC_or_add_out, ALUJmp_in, ALUJmp_out, MemWrt_in, 
MemWrt_out, halt_in, halt_out, SgnExt_in, SgnExt_out, readData2_in, readData2_out, 
pc2_in, pc2_out, sevenext_in, sevenext_out, RegWrt_in, RegWrt_out, RegSrc_in, 
RegSrc_out, write_reg_in, write_reg_out, clk, rst);

/*
model
memory iDUU4(.branch(branchtake), .alu(Alu_result), .SgnExt(word_align_jump), .readData2(read_data_2), .pc2(pc_next_to_pc2), .ALUJmp(ALUJMP), .PC_or_add(PC_or_add), .MemWrt(MemWrt), .clk(clk), 
    .rst(rst), .newPC(pc_goes_back_fetch), .MemRead(memory_data), .sevenext(i_2), .halt(halt));
*/

input wire clk, rst;


/*FROM EX TO MEM*/

    //outputs from just ex
    input wire [15:0] ALU_in; //the alu output
    output wire [15:0] ALU_out;

    input wire [15:0] BInput_in; //the input for the b alu also goes to WB
    output wire [15:0] BInput_out;

    input wire branchtake_in; //1 when we branching and conditions pass 
    output wire branchtake_out;

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

    input wire [2:0] write_reg_in;
    output wire [2:0] write_reg_out;

    


/*Flops*/

dff ALU [15:0] (.q(ALU_out), .d(ALU_in), .clk(clk), .rst(rst));
dff BInput [15:0] (.q(BInput_out), .d(BInput_in), .clk(clk), .rst(rst));
dff branchtake(.q(branchtake_out), .d(branchtake_in), .clk(clk), .rst(rst));
dff branch(.q(branch_out), .d(branch_in), .clk(clk), .rst(rst));
dff PC_or_add(.q(PC_or_add_out), .d(PC_or_add_in), .clk(clk), .rst(rst));
dff ALUJmp(.q(ALUJmp_out), .d(ALUJmp_in), .clk(clk), .rst(rst));
dff MemWrt(.q(MemWrt_out), .d(MemWrt_in), .clk(clk), .rst(rst));
dff halt(.q(halt_out), .d(halt_in), .clk(clk), .rst(rst));
dff SgnExt [15:0] (.q(SgnExt_out), .d(SgnExt_in), .clk(clk), .rst(rst));
dff readData2 [15:0] (.q(readData2_out), .d(readData2_in), .clk(clk), .rst(rst));
dff pc2 [15:0] (.q(pc2_out), .d(pc2_in), .clk(clk), .rst(rst));
dff sevenext [15:0] (.q(sevenext_out), .d(sevenext_in), .clk(clk), .rst(rst));
dff RegWrt(.q(RegWrt_out), .d(RegWrt_in), .clk(clk), .rst(rst));
dff RegSrc [1:0] (.q(RegSrc_out), .d(RegSrc_in), .clk(clk), .rst(rst));
dff write_reg [2:0](.q(write_reg_out), .d(write_reg_in), .clk(clk), .rst(rst));

endmodule