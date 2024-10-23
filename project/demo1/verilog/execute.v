/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (/* TODO: Add appropriate inputs/outputs for your execute stage here*/);

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


   //outputs
   output wire [15:0] ALU; //the alu output
   output wire [15:0] BInput; //the input for the b alu
   output wire BrchCnd;

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

   //alu code
   alu alu1(.InA(ReadData1), .InB(BInput), .Cin(), .Oper(), .invA(), .invB(), .sign(1'b1), .Out(), .Zero(), .Ofl());
               






endmodule
`default_nettype wire
