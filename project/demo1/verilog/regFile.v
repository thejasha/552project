/*
   CS/ECE 552, Fall '22
   Homework #3, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
module regFile (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                );

   parameter bitlength = 16;

   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [bitlength - 1:0] writeData;
   input        writeEn;

   output [bitlength - 1:0] read1Data;
   output [bitlength - 1:0] read2Data;
   output        err;

   /* YOUR CODE HERE */
   wire [bitlength - 1:0] registers [7:0];

   //so if will do a mask for each one
   wire mask_1[7:0];
   
   assign mask_1[0] = (writeRegSel == 3'b000) & writeEn;
   assign mask_1[1] = (writeRegSel == 3'b001) & writeEn;
   assign mask_1[2] = (writeRegSel == 3'b010) & writeEn;
   assign mask_1[3] = (writeRegSel == 3'b011) & writeEn;
   assign mask_1[4] = (writeRegSel == 3'b100) & writeEn;
   assign mask_1[5] = (writeRegSel == 3'b101) & writeEn;
   assign mask_1[6] = (writeRegSel == 3'b110) & writeEn;
   assign mask_1[7] = (writeRegSel == 3'b111) & writeEn;
   
   register #() ind_reg1(.clk(clk), .rst(rst), .writeData(writeData), .read(registers[0]), .writeEn(mask_1[0]));
   register  #() ind_reg2(.clk(clk), .rst(rst), .writeData(writeData), .read(registers[1]), .writeEn(mask_1[1]));
   register  #() ind_reg3(.clk(clk), .rst(rst), .writeData(writeData), .read(registers[2]), .writeEn(mask_1[2]));
   register #() ind_reg4(.clk(clk), .rst(rst), .writeData(writeData), .read(registers[3]), .writeEn(mask_1[3]));
   register #() ind_reg5(.clk(clk), .rst(rst), .writeData(writeData), .read(registers[4]), .writeEn(mask_1[4]));
   register #() ind_reg6(.clk(clk), .rst(rst), .writeData(writeData), .read(registers[5]), .writeEn(mask_1[5]));
   register #() ind_reg7(.clk(clk), .rst(rst), .writeData(writeData), .read(registers[6]), .writeEn(mask_1[6]));
   register #() ind_reg8(.clk(clk), .rst(rst), .writeData(writeData), .read(registers[7]), .writeEn(mask_1[7]));

   assign read1Data = registers[read1RegSel];
   assign read2Data = registers[read2RegSel];

   assign err = (clk === 1'bx) | (rst === 1'bx) | (writeEn === 1'bx) | (read1RegSel === 3'bxxx) | (read2RegSel === 3'bxxx) | (writeRegSel === 3'bxxx);

endmodule
