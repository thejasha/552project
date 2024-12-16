/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1
    
    a 16-bit CLA module
*/
module cla_16b(sum, c_out, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;

    // YOUR CODE HERE

    wire [15:0] gen;
    wire [3:0] four_gen;
    wire [15:0] prop;
    wire [3:0] four_prop;
    wire [2:0] carry;
    wire [15:0] fa_sum;

    //we will assign the carry based on generates and propergates, this will be for sum mainly
    cla_4b cla1(.sum(fa_sum[3:0]), .c_out(), .a(a[3:0]), .b(b[3:0]), .c_in(c_in));
    cla_4b cla2(.sum(fa_sum[7:4]), .c_out(), .a(a[7:4]), .b(b[7:4]), .c_in(carry[0]));
    cla_4b cla3(.sum(fa_sum[11:8]), .c_out(), .a(a[11:8]), .b(b[11:8]), .c_in(carry[1]));
    cla_4b cla4(.sum(fa_sum[15:12]), .c_out(), .a(a[15:12]), .b(b[15:12]), .c_in(carry[2]));

    //Generate will occur when generate appears in the last bit, or if there are generate following a propergate
    //ex G000 or PG00 or PPG0 or PPPG
    assign gen[0] = a[0] & b[0];
    assign gen[1] = a[1] & b[1];
    assign gen[2] = a[2] & b[2];
    assign gen[3] = a[3] & b[3];
    assign four_gen[0] = gen[3] | (prop[3] & gen[2]) | (prop[3] & prop[2] & gen[1]) | (prop[3] & prop[2] & prop[1] & gen[0]);

    assign gen[4] = a[4] & b[4];
    assign gen[5] = a[5] & b[5];
    assign gen[6] = a[6] & b[6];
    assign gen[7] = a[7] & b[7];
    assign four_gen[1] = gen[7] | (prop[7] & gen[6]) | (prop[7] & prop[6] & gen[5]) | (prop[7] & prop[6] & prop[5] & gen[4]);


    assign gen[8] = a[8] & b[8];
    assign gen[9] = a[9] & b[9];
    assign gen[10] = a[10] & b[10];
    assign gen[11] = a[11]& b[11];
    assign four_gen[2] = gen[11] | (prop[11] & gen[10]) | (prop[11] & prop[10] & gen[9]) | (prop[11] & prop[10] & prop[9] & gen[8]);


    assign gen[12] = a[12]& b[12];
    assign gen[13] = a[13]& b[13];
    assign gen[14] = a[14]& b[14];
    assign gen[15] = a[15]& b[15];
    assign four_gen[3] = gen[15] | (prop[15] & gen[14]) | (prop[15] & prop[14] & gen[13]) | (prop[15] & prop[14] & prop[13] & gen[12]);



    //prop will occur only when all blocks are propergate
    assign prop[0] = a[0] ^ b[0];
    assign prop[1] = a[1] ^ b[1];
    assign prop[2] = a[2] ^ b[2];
    assign prop[3] = a[3] ^ b[3];
    assign four_prop[0] = prop[3] & prop[2] & prop[1] & prop[0];

    assign prop[4] = a[4] ^ b[4];
    assign prop[5] = a[5] ^ b[5];
    assign prop[6] = a[6] ^ b[6];
    assign prop[7] = a[7] ^ b[7];
    assign four_prop[1] = prop[7] & prop[6] & prop[5] & prop[4];

    assign prop[8] = a[8] ^ b[8];
    assign prop[9] = a[9] ^ b[9];
    assign prop[10] = a[10] ^ b[10];
    assign prop[11] = a[11] ^ b[11];
    assign four_prop[2] = prop[11] & prop[10] & prop[9] & prop[8];

    assign prop[12] = a[12] ^ b[12];
    assign prop[13] = a[13] ^ b[13];
    assign prop[14] = a[14] ^ b[14];
    assign prop[15] = a[15] ^ b[15];
    assign four_prop[3] = prop[15] & prop[14] & prop[13] & prop[12];
    

    //carry bits assignment
    assign carry[0] = four_gen[0] | (four_prop[0] & c_in); 
    assign carry[1] = four_gen[1] | (four_prop[1] & carry[0]); 
    assign carry[2] = four_gen[2] | (four_prop[2] & carry[1]); 

    //final carry will be the last gen prop statement
    assign c_out = four_gen[3] | (four_prop[3] & carry[2]); 

    //final sum
    assign sum = fa_sum;

    //W WE PASSED

endmodule
