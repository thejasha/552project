/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1
    
    a 1-bit full adder
*/
module fullAdder_1b(s, c_out, a, b, c_in);
    output s;
    output c_out;
	input  a, b;
    input  c_in;

    // YOUR CODE HERE
    wire xor_AB, xor_ABCin, NAND_AB, not_NAND_AB, NAND_Cin_xor_AB, not_NAND_Cin_xor_AB, NOR_2NAND, not_NOR_2NAND;

    xor2 xor1(.in1(a), .in2(b), .out(xor_AB));
    xor2 xor2(.in1(xor_AB), .in2(c_in), .out(xor_ABCin));

    assign s = xor_ABCin;

    nand2 nand1(.in1(a), .in2(b), .out(NAND_AB));
    not1 not1(.in1(NAND_AB), .out(not_NAND_AB));


    nand2 nand2(.in1(Cin), .in2(xor_AB), .out(NAND_Cin_xor_AB));
    not1 not2(.in1(NAND_Cin_xor_AB), .out(not_NAND_Cin_xor_AB));

    nor2 nor1(.in1(not_NAND_AB), .in2(not_NAND_Cin_xor_AB), .out(NOR_2NAND));
    not1 not3(.in1(NOR_2NAND), .out(not_NOR_2NAND));

    assign c_out = not_NOR_2NAND;

endmodule
