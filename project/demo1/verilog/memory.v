/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (branch, alu, SgnExt, readData2, pc2, ALUJmp, jmpdsp, MemWrt, clk, rst, newPC, MemRead);

   input wire branch; //comesin anded with the conditions
   input wire jmpdsp; //secondmux
   input wire [15:0] alu; //alu output
   input wire [15:0] SgnExt; //sign extended immdiate
   input wire [15:0] readData2; //reg read daata 2
   input wire [15:0] pc2; //pc + 2
   input wire ALUJmp;
   input wire MemWrt;
   input wire         clk;
   input wire         rst;
   //input wire enable;

   output wire [15:0] newPC; //output that goes back to pc
   output wire [15:0] MemRead;
   // TODO: Your code here


   //First mux
   reg [15:0] MuxImmSrc; //mux controlled by IMMSRC
   assign MuxImmSrc = branch ? alu : SgnExt; //the mux for immscr

   //adder
   wire [15:0] adderOut; //output of the add
   fulladder16 fa(.A(pc2), .B(MuxImmSrc), .S(adderOut), .Cout());

   //branch mux
   reg [15:0] MuxBranchSrc; //mux controlled by the branch/brchcnd
   assign MuxBranchSrc = (jmpdsp || branch) ? adderOut : pc2; // the  mux for branch

   //jump mux
   assign newPC = ALUJmp ? alu : MuxBranchSrc;




   //memory part

   //call the mem block
   memory2c instruction_mem(.data_out(MemRead), .data_in(readData2), .addr(alu), .enable(1'b1), .wr(MemWrt), .createdump(1'b0), .clk(clk), .rst(rst));

   
endmodule
`default_nettype wire


