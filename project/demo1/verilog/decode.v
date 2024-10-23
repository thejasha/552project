/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (instruction, read_data_1, read_data_2, write_data, i_1, i_2, word_align_jump);

   // TODO: Your code here
   input wire [15:0] instruction;
   
   output wire [15:0] read_data_1, read_data_2, write_data, i_1, i_2, word_align_jump;

   wire [15:0] signed_i_1, zero_i_1, signed_i_2, zero_i_2;
   
   wire OExt = 1'b1;

   wire [2:0] write_reg, read_reg_1, read_reg_2;
      
   // Bits 15-11 will be used to decode the control values, these will output a lot of stuff


   //bit 10-8 will be send to read registers 1 (RS)
   
   //bits 7-5 will be sent to read register 2 (Rt)

   //WRITE REGISTER
      //mux for 10:8, 7:5, 4:2, and the number 7

   
    
   assign write_reg = (RegDst == 2'b00) ? instruction[7:5] : (RegSrc == 2'b01) ? instruction[10:8] : (RegSrc == 2'b10) ? instruction[4:2] : (RegSrc == 2'b11) ? 3'b111 : 3'b0;


   //4:0 will be sign or zero extended then muxxed
   assign zero_i_1 = {11'b0, instruction[4:0]};
   assign signed_i_1 = { {11{instruction[4]}}, instruction[4:0]};
    
   assign i_1 = OExt ? zero_i_1 : signed_i_1;

   //7:0 will be sign or zero extended then muxxed and have a unsigned 8 bit shifter value
   assign zero_i_2 = {8'b0, instruction[7:0]};
   assign signed_i_2 = { {8{instruction[7]}}, instruction[7:0]};
    
   assign i_2  = OExt ? zero_i_2 : signed_i_2;

   //10:0 will be sign extended for a world algin jump
   //the 1:0 of these bits will be used for alu operation

   assign word_align_jump  = { {5{instruction[10]}}, instruction[10:0]};




   
endmodule
`default_nettype wire
