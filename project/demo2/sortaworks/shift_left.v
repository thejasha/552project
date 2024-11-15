module shift_left(In, ShAmt, result);
parameter OPERAND_WIDTH = 16;
parameter SHAMT_WIDTH   =  4;

input [OPERAND_WIDTH -1:0] In;
input [SHAMT_WIDTH   -1:0] ShAmt;
output [OPERAND_WIDTH -1:0] result;

wire [OPERAND_WIDTH -1:0] temp1;
wire [OPERAND_WIDTH -1:0] temp2;
wire [OPERAND_WIDTH -1:0] temp3;

//will shift all bits left and make the first bit a 0

//one shift
assign temp1 = ShAmt[0] ? {In[OPERAND_WIDTH -2:0], 1'b0} : In;

//two shift
assign temp2 = ShAmt[1] ? {temp1[OPERAND_WIDTH-3:0], 2'b0}: temp1;

//four shift
assign temp3  = ShAmt[2] ? {temp2[OPERAND_WIDTH-5:0], 4'b0} : temp2;

//8shift
assign result = ShAmt[3] ? {temp3[OPERAND_WIDTH-9:0], 8'b0} : temp3;

endmodule