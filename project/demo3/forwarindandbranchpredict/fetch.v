/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (PC_in, PC_next, instruction, pc_temp, clk, rst, fetch_halt, fetch_stall);

   // TODO: Your code here

   input wire [15:0] PC_in; //word algined PC counter
   input wire clk, rst;

   output wire [15:0] PC_next; //word algined PC counter
   output wire [15:0] instruction; //the instruction that we are going to be using
   output wire [15:0] pc_temp;
   output wire fetch_halt;
   output wire fetch_stall;


   //wire [15:0] pc_temp;

   //initialize pc
   dff pc [15:0] (.q(pc_temp), .d(PC_in), .clk(clk), .rst(rst));

   //From pc get the next instruction from memory, and add PC by 2

   //the add 2 for the pc
   fulladder16 fa(.A(pc_temp), .B(16'h0002), .S(PC_next), .Cout());

   wire done, stall, cachehit; //internal wires

   //will get the instruction from memory based on  the pc_in, won't need data in
   stallmem instruction_mem(.DataOut(instruction), .Done(done), .Stall(stall), .CacheHit(cachehit), .err(fetch_halt), .Addr(pc_temp), .DataIn(16'b0), .Rd(1'b1), .Wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));

   assign fetch_stall = done ? 1'b0 : stall; //if we are done wont have a stall else, take whatever stall is giving us

endmodule
`default_nettype wire


