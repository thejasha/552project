module rotate_right(In, ShAmt, result);
parameter OPERAND_WIDTH = 16;
parameter SHAMT_WIDTH   =  4;

input  [OPERAND_WIDTH -1:0] In;
input  [SHAMT_WIDTH   -1:0] ShAmt;
output [OPERAND_WIDTH -1:0] result;

//will rotate every bit to the right, and the first bit of initial becomes the very last bit of result

wire [OPERAND_WIDTH -1:0] temp1;
wire [OPERAND_WIDTH -1:0] temp2;
wire [OPERAND_WIDTH -1:0] temp3;

// One shift
assign temp1 = ShAmt[0] ? {In[0], In[OPERAND_WIDTH -1:1]} : In;

// Two shifts
assign temp2 = ShAmt[1] ? {temp1[1:0], temp1[OPERAND_WIDTH -1:2]} : temp1;

// Four shifts
assign temp3 = ShAmt[2] ? {temp2[3:0], temp2[OPERAND_WIDTH -1:4]} : temp2;

// Eight shifts
assign result = ShAmt[3] ? {temp3[7:0], temp3[OPERAND_WIDTH -1:8]} : temp3;

endmodule
