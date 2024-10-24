/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (BSrc, InvB, InvA, ALUCtrl, ReadData1, ReadData2, fourExtend, sevenExtend, shifted, BranchCtrl, branch, SLBI, SetCtrl3, BTR, ALU, BInput, branchtake);

   input wire [1:0]BSrc; //4 to 1 muxm controller
   input wire InvB; //invert b controll
   input wire InvA; //invert a controll
   input wire [2:0] ALUCtrl; //ALU controll
   input wire [15:0] ReadData1; //reg output 1
   input wire [15:0] ReadData2; // reg output 2
   input wire [15:0] fourExtend; //the extended that comes from [4:0]
   input wire [15:0] sevenExtend; //the extend that comes from [7:0]
   //input wire [15:0] tenExtend; //the extend that comes from [10:0]
   
   input wire [15:0] shifted; //shifted 8 bits unsigned
   input wire [1:0] BranchCtrl;
   input wire branch; //is a branch command
   input wire SLBI;
   input wire [2:0] SetCtrl3;
   input wire BTR; //bit reverse


   //outputs
   output wire [15:0] ALU; //the alu output
   output wire [15:0] BInput; //the input for the b alu
   output wire branchtake; //1 when we branching and conditions pass   

   // TODO: Your code here
   //mux for alu b input
   /*always @(*) begin
        case (BSrc)
            2'b00: BInput = ReadData2;   // Select input 'a'
            2'b01: BInput = fourExtend;   // Select input 'b'
            2'b10: BInput = sevenExtend;   // Select input 'c'
            2'b11: BInput = shifted;   // Select input 'd'
            default: BInput = 16'b0; // Default case (optional, in case of invalid sel)
        endcase
    end
   */
   assign BInput = (BSrc == 2'b00) ? ReadData2 :
               (BSrc == 2'b01) ? fourExtend :
               (BSrc == 2'b10) ? sevenExtend : shifted;


   //slbi codes
   wire [15:0] possibleslbi;
   wire [15:0] shiftedA;
   wire slbiOper;
   shifter #() shift (.In(ReadData1), .ShAmt(4'b1000), .Oper(2'b01), .Out(shiftedA));

   assign possibleslbi = (SLBI) ? shiftedA : ReadData1;

   assign slbiOper = SLBI ? 3'b110 : ALUCtrl;

   //alu code
   // Opcode   Function               Result
   // 000      rll       Rotate left
   // 001      sll       Shift left logical
   // 010      sra       Shift right arithmetic
   // 011      srl       Shift right logical
   // 100      ADD       A + B
   // 101      AND       A AND B
   // 110      OR        A OR B
   // 111      XOR       A XOR B
   wire [15:0]aluout;
   wire conditional; //greater 1 or less 0
   wire CF; //1 when there was a carry in unsigned
   wire Zero;
   wire Overflow;
   alu alu1(.InA(possibleslbi), .InB(BInput), .Cin(InvA||InvB), .Oper(ALUCtrl), .invA(InvA), .invB(InvB), .sign(InvA||InvB), .Out(aluout), .signOut(conditional), .Zero(Zero), .Ofl(Overflow), .carryFlag(CF));
               



   //brchcnd
   wire Brchcnd;

   assign Brchcnd = (BranchCtrl == 2'b00) && (Zero) || (BranchCtrl == 2'b01) && (~Zero) || (BranchCtrl == 2'b10) && (~conditional) || (BranchCtrl == 2'b11) && (conditional);
   assign branchtake = (branch && Brchcnd) ? 1'b1 : 1'b0;

   //set logic
   wire Oper; //sco control
   wire altb; //a<b for slt
   wire [15:0] coout; //output throughsco
   wire sltoper; //slt control
   wire [15:0] ltout; //output through slt
   wire seqoper; //seq control
   wire aeqb; //a=b for SEQ
   wire [15:0] seqout; //output through seq
   wire alteb; //a<=b
   wire sleoper; //sle control
   wire [15:0] sleout; //output through sle
   wire [1:0] SetCtrl;

   wire carry;
   wire SLT;
   wire SEQ;
   wire SLE;

   assign SetCtrl = SetCtrl3[2:1];
   assign carry = (SetCtrl == 2'b00);
   assign SLT = (SetCtrl == 2'b01);
   assign SEQ = (SetCtrl == 2'b10);
   assign SLE = (SetCtrl == 2'b11);


   assign Oper = {carry, CF};
   assign coout = (Oper == 2'b11) ? 16'b0000000000000001 : 16'b0000000000000000;     //1 when carry and carry flag,0ow

   assign altb = (ReadData1 < BInput);
   assign sltoper = {SLT, altb};
   assign ltout = (sltoper == 2'b11) ? 16'b0000000000000001 :  // Output 1 when Oper = 11
                (sltoper == 2'b10) ? 16'b0000000000000000 :  // Output 0 when Oper = 10
                                   coout;               // Output aluout when Oper = 00 or 01


   assign aeqb = (ReadData1 == BInput);
   assign seqoper = {SEQ, aeqb};
   assign seqout = (seqoper == 2'b11) ? 16'b0000000000000001 :  // Output 1 when Oper = 11
                (seqoper == 2'b10) ? 16'b0000000000000000 :  // Output 0 when Oper = 10
                                   ltout;               // Output aluout when Oper = 00 or 01

   assign alteb = (ReadData1 <= BInput);
   assign sleoper = {SLE, alteb};
   assign sleout = (sleoper == 2'b11) ? 16'b0000000000000001 :  // Output 1 when Oper = 11
                (sleoper == 2'b10) ? 16'b0000000000000000 :  // Output 0 when Oper = 10
                                   seqout;               // Output aluout when Oper = 00 or 01


   //btr logic
   wire [15:0]ReverseOut;
   wire [15:0] reverse = { ReadData1[0], ReadData1[1], ReadData1[2], ReadData1[3],
                      ReadData1[4], ReadData1[5], ReadData1[6], ReadData1[7],
                      ReadData1[8], ReadData1[9], ReadData1[10], ReadData1[11],
                      ReadData1[12], ReadData1[13], ReadData1[14], ReadData1[15] };
   assign ReverseOut = BTR ? reverse : aluout;

   assign ALU = SetCtrl3[0] ? sleout : ReverseOut;

endmodule
`default_nettype wire
