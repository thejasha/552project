/*
    CS/ECE 552 FALL'22
    Homework #2, Problem 1
    
    a 4-bit CLA module
*/
module cla_4b(sum, c_out, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;

    // YOUR CODE HERE

    wire [3:0] gen;
    wire [3:0] prop;
    wire [2:0] carry;
    wire [3:0] fa_sum;

    //we will assign the carry based on generates and propergates, this will be for sum mainly
    fullAdder_1b fa1(.s(fa_sum[0]), .c_out(), .a(a[0]), .b(b[0]), .c_in(c_in));
    fullAdder_1b fa2(.s(fa_sum[1]), .c_out(), .a(a[1]), .b(b[1]), .c_in(carry[0]));
    fullAdder_1b fa3(.s(fa_sum[2]), .c_out(), .a(a[2]), .b(b[2]), .c_in(carry[1]));
    fullAdder_1b fa4(.s(fa_sum[3]), .c_out(), .a(a[3]), .b(b[3]), .c_in(carry[2]));

    //Generate and propagate bits
    assign gen = a & b;
    assign prop = a ^ b;

    //carry bits assignment
    assign carry[0] = gen[0] | (prop[0] & c_in); 
    assign carry[1] = gen[1] | (prop[1] & carry[0]); 
    assign carry[2] = gen[2] | (prop[2] & carry[1]); 

    //final carry will be the last gen prop statement
    assign c_out = gen[3] | (prop[3] & carry[2]); 

    //final sum
    assign sum = fa_sum;
   

endmodule
