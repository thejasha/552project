/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 3

    A multi-bit ALU module (defaults to 16-bit). It is designed to choose
    the correct operation to perform on 2 multi-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the multi-bit result
    of the operation, as well as drive the output signals Zero and Overflow
    (OFL).
*/
module alu (InA, InB, Cin, Oper, invA, invB, sign, Out, signOut, Zero, Ofl, carryFlag);

    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 3;
       
    input  [OPERAND_WIDTH -1:0] InA ; // Input operand A
    input  [OPERAND_WIDTH -1:0] InB ; // Input operand B
    input                       Cin ; // Carry in
    input  [NUM_OPERATIONS-1:0] Oper; // Operation type
    input                       invA; // Signal to invert A
    input                       invB; // Signal to invert B
    input                       sign; // Signal for signed operation
    output [OPERAND_WIDTH -1:0] Out ; // Result of computation
    output wire signOut; //signal 1 if positive;
    output                      Ofl ; // Signal if overflow occured
    output                      Zero; // Signal if Out is 0
    output wire carryFlag; //flag for carry


    /* YOUR CODE HERE */

    //these two values will be the inverted or non inverted, will always use over InA,B
    wire  [OPERAND_WIDTH -1:0] InA_invA;
    wire  [OPERAND_WIDTH -1:0] InB_invB;


    //result for shifter
    wire  [OPERAND_WIDTH -1:0] barrel;

    //result for the xor or and
    wire  [OPERAND_WIDTH -1:0] logic_gates_r;
    wire  [OPERAND_WIDTH -1:0] addition;
    wire  [OPERAND_WIDTH -1:0] addition_logic;
    

    //assign the invert lgogic
    assign InA_invA = invA ? ~InA: InA;
    assign InB_invB = invB ? ~InB: InB;  
    
    //shift
    shifter #() shift (.In(InA_invA), .ShAmt(InB_invB[3:0]), .Oper(Oper[1:0]), .Out(barrel));

    //xor and or will send this to one module
    xor_or_and #() logic_gates(.A(InA_invA), .B(InB_invB), .Oper(Oper[1:0]), .Result(logic_gates_r));

    //addition part
    wire carry;
    wire signed_over;
    cla_16b adding(.sum(addition), .c_out(carry), .a(InA_invA), .b(InB_invB), .c_in(Cin));

    assign signed_over = (InA_invA[15] & InB_invB[15] & ~addition[15]) | (~InA_invA[15] & ~InB_invB[15] & addition[15]);

    //assign out to barrel if MSB of Opcode is low
    assign addition_logic = (~Oper[1] & ~Oper[0]) ? addition : logic_gates_r;
    assign Out = Oper[2] ? addition_logic : barrel;

    //assign Zero = &(~Out);

    assign Ofl  = sign ? signed_over : carry;

    //branch cnd
    //assign EQZ  = (ReadData1 == 0);                   // Equal
    //assign NEQZ = (ReadData1 != 0);                   // Not equal
    //assign GTZ  = ($signed(ReadData1) >= 0); // Greater than
    //assign LTZ  = ($signed(ReadData1) < 0); // Less than
    //cant have multiple in this
    assign Zero = &(~InA);
    assign signOut = ($signed(InA) >= 0);

    //todo need to not do this
    assign carryFlag = carry;





    

endmodule
