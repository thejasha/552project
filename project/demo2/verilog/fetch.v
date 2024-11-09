/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (PC_in, PC_next, instruction, clk, rst);

   // TODO: Your code here

   input wire [15:0] PC_in; //word algined PC counter
   input wire clk, rst;

   output wire [15:0] PC_next; //word algined PC counter
   output wire [15:0] instruction; //the instruction that we are going to be using


   wire [15:0] pc_temp;

   //initialize pc
   dff pc [15:0] (.q(pc_temp), .d(PC_in), .clk(clk), .rst(rst));

   //From pc get the next instruction from memory, and add PC by 2

   //the add 2 for the pc
   fulladder16 fa(.A(pc_temp), .B(16'h0002), .S(PC_next), .Cout());


   //will get the instruction from memory based on  the pc_in, won't need data in
   memory2c instruction_mem(.data_out(instruction), .data_in(16'b0), .addr(pc_temp), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));

endmodule
`default_nettype wire


