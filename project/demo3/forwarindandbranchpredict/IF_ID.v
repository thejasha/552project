module IF_ID(PC_next_in, PC_next_in_out, instruction_in, instruction_out, PC_NO_PLUS_TWO_IN, 
PC_NO_PLUS_TWO_OUT, HALT_IN, HALT_OUT, STALL_IN, STALL_OUT, clk, rst, branch_out);

// Stuff to put in different flop or remove 
    //output wire [15:0] data_write //THIS IS THE DATA FROM WB, NEED TO MOVE, wont even be in a flop
    //REG WRITE WILL COME FROM WB

input wire clk, rst;
input wire branch_out;
// Stuff from fetch
input wire [15:0] PC_next_in; //word algined PC counter, this will be flopped all the way to mem
input wire [15:0] instruction_in; //the instruction that we are going to be using
input wire [15:0] PC_NO_PLUS_TWO_IN;
// Stuff to fetch
output wire [15:0] PC_NO_PLUS_TWO_OUT;
//Stuff to Decode
output wire [15:0] PC_next_in_out;
output wire [15:0] instruction_out; //only input into the decode from fetch is going to be the instruction

input wire HALT_IN;
output wire HALT_OUT;

input wire STALL_IN;
output wire STALL_OUT;

//FLOPS
dff pc [15:0] (.q(PC_next_in_out), .d(branch_out ? 16'b0 : PC_next_in), .clk(clk), .rst(rst));
dff_inst instruc [15:0] (.q(instruction_out), .d(branch_out ? 16'h0800 : instruction_in), .clk(clk), .rst(rst));
dff PCNOTWO [15:0] (.q(PC_NO_PLUS_TWO_OUT), .d(branch_out ? 16'b0 : PC_NO_PLUS_TWO_IN), .clk(clk), .rst(rst));
dff HALT [15:0] (.q(HALT_OUT), .d(branch_out ? 16'b0 : HALT_IN), .clk(clk), .rst(rst));
dff STALL [15:0] (.q(STALL_OUT), .d(branch_out ? 16'b0 : STALL_IN), .clk(clk), .rst(rst));


endmodule
