module xor_or_and(A, B, Oper, Result);

parameter OPERAND_WIDTH = 16;    
parameter NUM_OPERATIONS = 2;

input [OPERAND_WIDTH -1:0] A, B;
input [NUM_OPERATIONS - 1: 0] Oper;
output [OPERAND_WIDTH -1:0] Result;

//this techinally isnt very efficient since we need to use the add alu might add to it.


assign Result = Oper[1] ? (Oper[0] ? (A ^ B) : (A | B)) : (Oper[0] ? (A & B) : 0);

endmodule