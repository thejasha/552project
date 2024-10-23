/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 2
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, 
    shift right arithmetic, or shift right logical based
    on the 'Oper' value that is passed in.  It uses these
    shifts to shift the value any number of bits.
 */
module shifter (In, ShAmt, Oper, Out);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input  [OPERAND_WIDTH -1:0] In   ; // Input operand
    input  [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    input  [NUM_OPERATIONS-1:0] Oper ; // Operation type
    output [OPERAND_WIDTH -1:0] Out  ; // Result of shift/rotate

   /* YOUR CODE HERE */
    wire [OPERAND_WIDTH -1:0] shift_left_r;
    wire [OPERAND_WIDTH -1:0] rotate_left_r;
    wire [OPERAND_WIDTH -1:0] shift_right_l_r;
    wire [OPERAND_WIDTH -1:0] shift_right_a_r;

   shift_left #() sleft(.In(In), .ShAmt(ShAmt), .result(shift_left_r));
   rotate_left #() rleft(.In(In), .ShAmt(ShAmt), .result(rotate_left_r));
   shift_right_logic #() srl(.In(In), .ShAmt(ShAmt), .result(shift_right_l_r));
   shift_right_arthimetic #() sra(.In(In), .ShAmt(ShAmt), .result(shift_right_a_r));

   assign Out = Oper[1] ? (Oper[0] ? shift_right_l_r : shift_right_a_r) : (Oper[0] ? shift_left_r : rotate_left_r);


endmodule
