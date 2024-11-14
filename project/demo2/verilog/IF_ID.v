module IF_ID(PC_next_in, PC_next_in_out, instruction_in, instruction_out, clk, rst);

// Stuff to put in different flop or remove 
    //output wire [15:0] data_write //THIS IS THE DATA FROM WB, NEED TO MOVE, wont even be in a flop
    //REG WRITE WILL COME FROM WB

input wire clk, rst;

// Stuff from fetch
input wire [15:0] PC_next_in; //word algined PC counter, this will be flopped all the way to mem
input wire [15:0] instruction_in; //the instruction that we are going to be using

//Stuff to Decode
output wire [15:0] PC_next_in_out;
output wire [15:0] instruction_out; //only input into the decode from fetch is going to be the instruction


//FLOPS
dff pc [15:0] (.q(PC_next_in_out), .d(PC_next_in), .clk(clk), .rst(rst));
dff instruc [15:0] (.q(instruction_out), .d(instruction_in), .clk(clk), .rst(rst));


endmodule