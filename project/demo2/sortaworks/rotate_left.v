module rotate_left(In, ShAmt, result);
parameter OPERAND_WIDTH = 16;
parameter SHAMT_WIDTH   =  4;

input [OPERAND_WIDTH -1:0] In;
input [SHAMT_WIDTH   -1:0] ShAmt;
output [OPERAND_WIDTH -1:0] result;

//will rotate every bit to the left, and the last bit of initial become the very first bit of result

wire [OPERAND_WIDTH -1:0] temp1;
wire [OPERAND_WIDTH -1:0] temp2;
wire [OPERAND_WIDTH -1:0] temp3;

//will need to do 15 muxes since our max amount of shifts is 15, ShAMT = 0000 is no shift, 1111 is 15
//only need 4 conditional though since if we have our last bit as 1, we can just do 8 shifts in that conditional

//one shift
assign temp1 = ShAmt[0] ? {In[OPERAND_WIDTH -2:0], In[OPERAND_WIDTH -1]} : In;

//two shift
assign temp2 = ShAmt[1] ? {temp1[OPERAND_WIDTH-3:0], temp1[OPERAND_WIDTH -1: OPERAND_WIDTH -2]}: temp1;

//four shift
assign temp3  = ShAmt[2] ? {temp2[OPERAND_WIDTH-5:0], temp2[OPERAND_WIDTH -1: OPERAND_WIDTH -4]} : temp2;

//8shift
assign result = ShAmt[3] ? {temp3[OPERAND_WIDTH-9:0], temp3[OPERAND_WIDTH -1: OPERAND_WIDTH -8]} : temp3;


endmodule