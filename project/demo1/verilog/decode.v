/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (clk, rst, err, instruction, read_data_1, read_data_2, to_shift, i_1, i_2, word_align_jump, data_write, ALUOpr, Bsrc, InvB, InvA, ImmSrc, MemWrt, 
         ALUJMP, PC_or_add, RegSrc, SLBI, BTR, branching, branch_command, SetCtrl);


   // TODO: Your code here
   input wire clk, rst;
   output wire err;

   input wire [15:0] instruction, data_write; //our 2 inputs, the instrcution and the data from the wb
   
   output wire [15:0] read_data_1, read_data_2, to_shift, i_1, i_2, word_align_jump; //will pu

   //values that will be the zero and signed singals
   wire [15:0] signed_i_1, zero_i_1, signed_i_2, zero_i_2;
   
   //internal
   reg OExt; //will determine to zero or sign extend
   reg RegWrt; //will enable register writing
   reg [1:0] RegDst; //will determine which write reg value to use in the mux
   //external
   output reg BTR;
   output reg [2:0] ALUOpr; //will be used with [1:0] to creater Oper
   output reg [1:0] Bsrc; //will select which data to use for the slot b of the alu
   output reg InvB; //will determine if we are subtracting b
   output reg InvA; //will determine if we are subtracting a
   output reg ImmSrc; //add jump or alu output MIGHT NEED TO CHANGE i think this is from the branch control
   output reg MemWrt; //if we are writing to meme
   output reg ALUJMP; //if we are jumping form the result of alu
   output reg PC_or_add; //if we r taking the pc or the addition for pc and another number
   output reg [1:0] RegSrc; //choose the singal for the mux for the wb
   output reg SLBI; //will decide if we are using the shift or command
   output reg branching; //will tell exe if we are going to be doing a branch command
   output reg [1:0] branch_command; //will specifiy the branch command
   output reg [2:0] SetCtrl;


   wire [2:0] write_reg; //the selected write reg

   // wire [2:0] Oper; //this is for the output of ALU operation

/*This block will determine all of the control signals*/
   // Bits 15-11 will be used to decode the control values, these will output a lot of stuff

   //will look at the 15:13 bits first then go from there since it seems most of the instructions split from that
     
   always @(*) begin
       //defualt
         //ubterbak
         OExt = 1'b0;
         RegWrt = 1'b0;
         RegDst = 2'b00;
         //external
         branching = 1'b0;
         branch_command = 2'b00;
         SLBI = 1'b0;
         ALUOpr = 3'b000;
         Bsrc = 2'b00;
         InvB = 1'b0;
         InvA = 1'b0;
         ImmSrc = 1'b0;
         MemWrt = 1'b0;
         ALUJMP = 1'b0;
         PC_or_add = 1'b0;
         RegSrc = 2'b00;
         BTR = 1'b0;
         SetCtrl = 3'b000;

      case (instruction[15:13])
        
         default: begin //default will be 000
         
         end

         /**/
         /**/

         3'b010: begin //I-1 type instructions, ADDI, SUBI, XORI, ANDNI
            //These singals below will be true for all the case

            //0ext = 0 want signed extended // defaulted
            //RegDst = 2'b00; //want 7:5 to write reg // defaulted
            RegWrt = 1'b1; //need to write to rd Bsrc = 2'b01; //want I-1 (4:0)
            Bsrc = 2'b01; //want I-1 (4:0)
            RegSrc = 2'b10; //write back the result from the alu

            case(instruction[12:11])
               default: begin //2'b00 ADDI Rd <- Rs + I(sign ext.)
                  ALUOpr = 3'b100; //add is 100;
               end

               2'b01: begin // SUBI  Rd <- I(sign ext.) - Rs same as -R2 + I
                  InvA = 1'b1; //want to do complement of Rs so we have subtraction
                  ALUOpr = 3'b100; //add is 100;
               end

               2'b10: begin // XORI Rd <- Rs XOR I(zero ext.)
                  OExt = 1'b1; //want zero extended
                  ALUOpr = 3'b111; //xor is 111;
               end

               2'b11: begin // ANDI Rd <- Rs AND ~I(zero ext.)
                  OExt = 1'b1; //want zero extended
                  InvB = 1'b1; //want to do the complement of the Immediate
                  ALUOpr = 3'b101; //AND is 101;
               end
            endcase
         end

         /**/
         /**/

         3'b101: begin //I-1 type instructions shifting rotate
            //signals below will be true for all cases

            //RegDst = 2'b00; //want to write to reg 7:5 default
            RegWrt = 1'b1; //enable writing
            Bsrc = 2'b01; //take the extended 4:0 but we will only use 3:0 (lowk it doesnt even matter, could also use 7:0)
            RegSrc = 2'b10; //write back the result of alu
            case(instruction[12:11])
               default: begin //2'b00 ROLI  Rd <- Rs <<(rotate) I(lowest 4 bits)  //doesnt really matter if we sign or zero extend the immediate
               // ALUOpr = 3'b000 rotate left is our default
               end

               2'b01: begin //SLLI  Rd <- Rs << I(lowest 4 bits)
                  ALUOpr = 3'b001; //shift left logic is 001
               end

               2'b10: begin //RORI  Rd <- Rs >>(rotate) I(lowest 4 bits)
                 
                   ALUOpr = 3'b010; //rotate right
               end

               2'b11: begin //SRLI  Rd <- Rs >> I(lowest 4 bits)
                    ALUOpr = 3'b011; //shift right logic is 011 
               end   
            endcase    
         end

         /**/
         /**/

         3'b100: begin //Load sotre I-1 Type instructions
            case(instruction[12:11])
               default: begin //2'b00 ST immediate Mem[Rs + I(sign ext.)] <- Rd
                  //OExt = 0 sign extend
                  MemWrt = 1'b1; //want to write the data that is in [7:5], in this case Rd is techincally Rt
                  Bsrc = 2'b01; //take the sign extended immediate
                  
                  ALUOpr = 3'b100; //ADD is 100;
               end

               2'b01: begin //LD  Rd <- Mem[Rs + I(sign ext.)]
                  //OExt = 0 sign extend
                  //RegDst = 2'b00; //write to Rd [7:5] default
                  RegWrt = 1'b1; //enable writing
                  Bsrc = 2'b01; //take the sign extended immediate
                  RegSrc = 2'b01; //take data from memory and send to wb

                  //reading mem or wb doesnt matter
                  ALUOpr = 3'b100; //ADD is 100;
               end

               2'b01: begin //STU  Mem[Rs + I(sign ext.)] <- RdRs <- Rs + I(sign ext.)
                  //OExt = 0 sign extend
                  MemWrt = 1'b1; //want to write the data in [7:5], in this case Rd is techincally Rt
                  Bsrc = 2'b01; //take the sign extended immediate

                  //write the address to RS now
                  RegSrc = 2'b10; //result of alu is address so we will write back this
                  RegWrt = 1'b1; //enable writing
                  RegDst = 2'b01; //RS will be the write register

                  ALUOpr = 3'b100; //ADD is 100;
               end

               2'b10: begin //SLBI //Rs <- (Rs << 8) | I(zero ext.) NOT DONE
                  //NEED TO WORK ON, SHIFT THEN OR IT TODO
                     //make ALU shift by 8, then OR
                  SLBI = 1'b1; //make it do the shift
                  ALUOpr = 3'b110; //make it or

                  RegDst = 2'b01; //pick RS for the write
                  OExt = 1'b1; //need to zero extend the I
                  RegSrc = 2'b10; //pick the data from the alu to write back
                  RegWrt = 1'b1; //need to write the data 

               end
            endcase
         end

         /**/
         /**/

         3'b110: begin //All R type and a Load instruction
            case(instruction[12:11])
               default: begin // LBI //Rs <- I(sign ext.) done
                  RegWrt = 1'b1; //need to write to the register
                  RegDst = 2'b01; //want to load into RS so REGDST needs to take 10:8 whiuch wil be select 1
                  
                  Bsrc = 2'b01; //want to signed 7:0 to go to write back
                  RegSrc = 2'b11;

               end 

               2'b01: begin  // BTR  Rd[bit i] <- Rs[bit 15-i] for i=0..15
                  //TODO
                  RegDst = 2'b10; // pick the write reg as 4:2
                  RegWrt = 1'b1; //write to the register
                  RegSrc = 2'b10; //take the alu result and send it to register
                  BTR = 1'b1; //command that will tell the alu to inverse everything
               end 

               2'b11: begin //logic stuff
                  // following singals is the same for all cases
                  // Bsrc = 2'b00; //use Rt for ALU B input default
                  RegDst = 2'b10; //writeing to 4:2
                  RegWrt = 1'b1; //enable writing
                  RegSrc = 2'b10; // want the result of alu 

                  case(instruction[1:0])
                     default: begin //2'b00 ADD Rd <- Rs + Rt
                           ALUOpr = 3'b100; //ADD is 100;
                     end

                     2'b01: begin //SUB  Rd <- Rt - Rs
                          InvA = 1'b1; // want to subtract rs, so it will be -rs + rt

                         ALUOpr = 3'b100; //ADD is 100; will do subtraction since we inverted
                           
                     end

                     2'b10: begin //XOR  Rd <- Rs XOR Rt
                           ALUOpr = 3'b111; //Xor is 111;
                           
                     end

                     2'b11: begin //ANDN  Rd <- Rs AND ~Rt
                          InvB = 1'b1; //want inverse of Rt
                           
                          ALUOpr = 3'b101; //AND is 101;
                      end 
                  endcase
               end

               2'b10: begin //shifting stuff
                        case(instruction[1:0])
                        default: begin //2'b00  ROL Rd <- Rs << (rotate) Rt (lowest 4 bits)
                           RegDst = 2'b10; //writeing to 4:2
                           RegWrt = 1'b1; //enable writing
                           RegSrc = 2'b10; // want the result of alu 

                           // ALUOpr = 3'b000; defualt is rotate left
                        end
 
                        2'b01: begin // SLL Rd <- Rs << Rt (lowest 4 bits)
                           RegDst = 2'b10; //writeing to 4:2
                           RegWrt = 1'b1; //enable writing
                           RegSrc = 2'b10; // want the result of alu 

                           ALUOpr = 3'b001; //shift left                          
                        end

                        2'b10: begin //ROR Rd <- Rs >> (rotate) Rt (lowest 4 bits)
                           RegDst = 2'b10; //writeing to 4:2
                           RegWrt = 1'b1; //enable writing
                           RegSrc = 2'b10; // want the result of alu 

                           ALUOpr = 3'b010; //rotate right                              
                        end

                        2'b11: begin // SRL Rd <- Rs >> Rt (lowest 4 bits)
                           RegDst = 2'b10; //writeing to 4:2
                           RegWrt = 1'b1; //enable writing
                           RegSrc = 2'b10; // want the result of alu 

                           ALUOpr = 3'b011; //shift right logic                                 
                        end
                     endcase
               end 
            endcase
         end

         /**/
         /**/

         3'b111: begin //compare instructions
            RegWrt = 1'b1; //write to register
            RegSrc = 2'b10; //take the alu output for the writeback
            RegDst = 2'b10; //write to 4:2
            case(instruction[12:11])
               default: begin //2'b00 SEQ  if (Rs == Rt) then Rd <- 1 else Rd <- 0
                  SetCtrl = 3'b100;
               end 

               2'b01: begin  //SLT  if (Rs < Rt) then Rd <- 1 else Rd <- 0
                  SetCtrl = 3'b101;
               end 

               2'b11: begin //SLE  if (Rs <= Rt) then Rd <- 1 else Rd <- 0
                  SetCtrl = 3'b110;
               end

               2'b10: begin //SCO  if (Rs + Rt) generates carry out then Rd <- 1 else Rd <- 08
                  SetCtrl = 3'b111; 
               end 
            endcase
         end

         /**/
         /**/
         
         3'b011: begin
            ALUOpr = 3'b100; //add all
            branching = 1'b1;
            branch_command = 2'b01;
            case(instruction[12:11]) //if any of the bracnhes are true then we do the same thing each time only thing alu operation
               default: begin //beqz will be 00 case if (Rs == 0) then PC <- PC + 2 + I(sign ext.)
                  // branch_command = 2'b00; default
               end

               2'b01: begin //bnez if (Rs != 0) then PC <- PC + 2 + I(sign ext.)
                 branch_command = 2'b01;
               end

               2'b10: begin //bltz  if (Rs < 0) then PC <- PC + 2 + I(sign ext.)
                  InvB = 1'b1;
                  branch_command = 2'b10;
               end

               2'b11: begin //bgez  if (Rs >= 0) then PC <- PC + 2 + I(sign ext.)
                  InvB = 1'b1;
                  branch_command = 2'b11;
               end
            endcase
         end

         /**/
         /**/

         3'b001: begin //jump instructions, jtype and i
         //we have 2 jump displacement, J and JAL
         //then we have 2 jump i1s, JR and JALR

          ALUOpr = 3'b100; //will use addition for 2 of these, but the other 2 are don't cares
            case(instruction[12:11])
               default: begin //2'b11 case JALR //R7 <- PC + 2 //PC <- Rs + I(sign ext.) 
                  //RegSrc is already 0
                  Bsrc = 2'b10; //mux to take alu output
                  ALUJMP = 1'b1; //mux to set pc to ALU output

               
                  RegDst = 2'b11;  //for pc to  r7, wb mux will be for 0, then we have write data be that pc, and make write register 7
                  RegWrt = 1'b1; //make it write
               end

               2'b00: begin //J    
                  //want ImmSRC to be 0 so adds with pc want the next mux to be 1 then alu jump to be 0, 
                  //ImmSRC already 0
                  //alu jump alreay 0

                  PC_or_add = 1'b1;
               end

               2'b01: begin //JR // PC <- Rs + I(sign ext.)
                  //want sign extend //Oext = 0
               
                  Bsrc = 2'b10; //mux to take alu output
                  ALUJMP = 1'b1; //mux to take alu output
               end

               2'b10: begin //JAL 
                  //same as J but now store Pc into R7
                     //want ImmSRC to be 0 so adds with pc want the next mux to be 1 then alu jump to be 0, 
                  //RegSrc is already 0

                  PC_or_add = 1'b1;
                  
                  RegDst = 2'b11;  //for pc to  r7, wb mux will be for 0, then we have write data be that pc, and make write register 7
                  RegWrt = 1'b1; //make it write
               end
            endcase
         end
        
      endcase
   end

/*This block is for the register*/
   //bit 10-8 will be send to read registers 1 (RS) //bits 7-5 will be sent to read register 2 (Rt) need to input clk rst and err
   regFile registerfile(.read1Data(read_data_1), .read2Data(read_data_2), .err(err), .clk(clk), .rst(rst), .read1RegSel(instruction[10:8]), .read2RegSel(instruction[7:5]), .writeRegSel(write_reg), .writeData(data_write), .writeEn(RegWrt));
  
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

   // assign Oper = {ALUOpr, instruction[1:0]}; //TODO this doesn't make sense, why would we not just send a 3'bit aluopr out of the decoder

endmodule
`default_nettype wire
