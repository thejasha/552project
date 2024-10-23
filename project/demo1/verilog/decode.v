/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (/* TODO: Add appropriate inputs/outputs for your decode stage here*/);

   // TODO: Your code here
   

   // Bits 15-11 will be used to decode the control values, these will output a lot of studd

   //bit 10-8 will be send to read registers 1 (RS)

   //bits 7-5 will be sent to read register 2 (Rt)

   //WRITE REGISTER
      //mux for 10:8, 7:5, 4:2, and the number 7

   //4:0 will be sign or zero extended then muxxed

   //7:0 will be sign or zero extended then muxxed or be an 8 bit shift unsigned


   //10:0 will be sign extended for a world algin jump
   //the 1:0 of these bits will be used for alu operation




   
endmodule
`default_nettype wire
