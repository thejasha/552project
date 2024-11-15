module shift_right_arthimetic(In, ShAmt, result);
parameter OPERAND_WIDTH = 16;
parameter SHAMT_WIDTH   =  4;

input [OPERAND_WIDTH -1:0] In;
input [SHAMT_WIDTH   -1:0] ShAmt;
output [OPERAND_WIDTH -1:0] result;

wire [OPERAND_WIDTH -1:0] temp1;
wire [OPERAND_WIDTH -1:0] temp2;
wire [OPERAND_WIDTH -1:0] temp3;

//shift all bits right and have the before shifted MSB bit be extended 

//one shift
assign temp1 = ShAmt[0] ? {In[OPERAND_WIDTH -1], In[OPERAND_WIDTH -1 :1]} : In;

//two shift
assign temp2 = ShAmt[1] ? {{2{temp1[OPERAND_WIDTH -1]}}, temp1[OPERAND_WIDTH -1 :2]}: temp1;

//four shift
assign temp3  = ShAmt[2] ? {{4{temp2[OPERAND_WIDTH  -1]}}, temp2[OPERAND_WIDTH -1 :4]} : temp2;

//8shift
assign result = ShAmt[3] ? {{8{temp3[OPERAND_WIDTH -1]}}, temp3[OPERAND_WIDTH -1 :8]} : temp3;

endmodule