/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (RegSrc, mem_data, alu_data, Binput, pc_data, data_to_write);

   input wire [1:0] RegSrc;
   input wire [15:0] mem_data, alu_data, pc_data, Binput;
   output wire [15:0] data_to_write;
   // TODO: Your code here

   //take the mux and send the data to the register file module
   assign data_to_write = (RegSrc == 2'b00) ? pc_data : (RegSrc == 2'b01) ? mem_data : (RegSrc == 2'b10) ? alu_data : (RegSrc == 2'b11) ? Binput : 16'b0;

endmodule
`default_nettype wire
