/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (instruction, read_data_1, read_data_2, to_shift, i_1, i_2, word_align_jump, data_write);

   // TODO: Your code here
   input wire [15:0] instruction, data_write; //our 2 inputs, the instrcution and the data from the wb
   
   output wire [15:0] read_data_1, read_data_2, to_shift, i_1, i_2, word_align_jump; //will pu

   //values that will be the zero and signed singals
   wire [15:0] signed_i_1, zero_i_1, signed_i_2, zero_i_2;
   
   wire OExt; //will determine to zero or sign extend
   wire RegWrt; //will enable register writing
   wire RegDst; //will determine which write reg value to use in the mux
   wire ALUOpr; //
   wire [2:0] write_reg; //the selected write reg
   wire [2:0] Oper; //this is for the output of ALU operation

/*This block will determine all of the control signals*/
   // Bits 15-11 will be used to decode the control values, these will output a lot of stuff
   
   //internal
   assign OExt = (instruction[] = )? 1'b1 : 1'b0;
   assign RegWrt = (instruction[] = )? 1'b1 : 1'b0;
   assign RegDst = (instruction[] = )? 1'b1 : 1'b0;
   assign ALUOpr = (instruction[] = )? 1'b1 : 1'b0;
   //external
   assign Bsrc = (instruction[] = ) ? 1'b1 : 1'b0;
   assign InvB = (instruction[] = ) ? 1'b1 : 1'b0;
   assign InvA = (instruction[] = ) ? 1'b1 : 1'b0;
   assign ImmSrc = (instruction[] = ) ? 1'b1 : 1'b0;
   assign MemWrt = (instruction[] = ) ? 1'b1 : 1'b0;
   assign ALUJMP = (instruction[] = ) ? 1'b1 : 1'b0;
   //branch cnd will add another control in execute

// RegDst//internal
// OExt //internal
// ALUOpr//internal
// RegWrt//interneal
// Bsrc//out
// InvB//out
// InvA//out
// ImmSrc//out
// MemWrt//out

// ALUJMP I think this is from the branch control


/*This block is for the register*/
   //bit 10-8 will be send to read registers 1 (RS) //bits 7-5 will be sent to read register 2 (Rt) need to input clk rst and err
   regFile registerfile(.read1Data(read_data_1), .read2Data(read_data_2), .err(), .clk(), .rst(), .read1RegSel(instruction[10:8]), .read2RegSel(instruction[7:5]), .writeRegSel(write_reg), .writeData(data_write), .writeEn(RegWrt));
  
   //WRITE REGISTER
      //mux for 10:8, 7:5, 4:2, and the number 7 which is for doing pc to register 7
   assign write_reg = (RegDst == 2'b00) ? instruction[7:5] : (RegDst == 2'b01) ? instruction[10:8] : (RegDst == 2'b10) ? instruction[4:2] : (RegDst == 2'b11) ? 3'b111 : 3'b0;


/*This block is for sign/zero extending*/

   //4:0 will be sign or zero extended then muxxed
   assign zero_i_1 = {11'b0, instruction[4:0]};
   assign signed_i_1 = { {11{instruction[4]}}, instruction[4:0]};
    
   assign i_1 = OExt ? zero_i_1 : signed_i_1;

   //7:0 will be sign or zero extended then muxxed and have a unsigned 8 bit shifter value
   assign zero_i_2 = {8'b0, instruction[7:0]};
   assign signed_i_2 = { {8{instruction[7]}}, instruction[7:0]};
    
   assign i_2  = OExt ? zero_i_2 : signed_i_2;

   assign to_shift = instruction[7:0];

   //10:0 will be sign extended for a world algin jump
   //the 1:0 of these bits will be used for alu operation

   assign word_align_jump  = { {5{instruction[10]}}, instruction[10:0]};

   /*This block will do the ALU operation stuff*/

   wire [2:0] Oper

endmodule
`default_nettype wire
