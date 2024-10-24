/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (branch, alu, SgnExt, readData2, pc2, ALUJmp, PC_or_add, MemWrt, clk, rst, newPC, MemRead, sevenext, halt);

   input wire branch; //comesin anded with the conditions
   input wire PC_or_add; //secondmux
   input wire [15:0] alu; //alu output
   input wire [15:0] SgnExt; //sign extended immdiate
   input wire [15:0] readData2; //reg read daata 2
   input wire [15:0] pc2; //pc + 2
   input wire [15:0] sevenext; //value for JALR add
   input wire ALUJmp;
   input wire MemWrt;
   input wire halt;
   input wire         clk;
   input wire         rst;
   //input wire enable;

   output wire [15:0] newPC; //output that goes back to pc
   output wire [15:0] MemRead;
   // TODO: Your code here


   //First mux
   wire [15:0] MuxImmSrc; //mux controlled by IMMSRC
   assign MuxImmSrc = branch ? sevenext : SgnExt; //the mux for immscr

   //adder
   wire [15:0] adderOut; //output of the add
   fulladder16 fa(.A(pc2), .B(MuxImmSrc), .S(adderOut), .Cout());

   //branch mux
   wire [15:0] MuxBranchSrc; //mux controlled by the branch/brchcnd
   assign MuxBranchSrc = (PC_or_add || branch) ? adderOut : pc2; // the  mux for branch

   //jump mux
   assign newPC = ALUJmp ? alu : MuxBranchSrc;




   //memory part

   //call the mem block
   memory2c instruction_mem(.data_out(MemRead), .data_in(readData2), .addr(alu), .enable(1'b1), .wr(MemWrt), .createdump(halt), .clk(clk), .rst(rst));

   
endmodule
`default_nettype wire


