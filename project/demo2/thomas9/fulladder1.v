module fulladder1(A, B, Cin, S, Cout);

input A, B, 
    Cin; //Carry-in
output S, //(Sum)
    Cout; //Carry-out

//Can only use NOT, NAND, NOR, and XOR gates
//For the sum we can just use xor gates cause if odd amount of 1s then there will be a 1 for sum
//need to use an or combined with and gates for Cout. If A and B are one we have a carry or if we hav
//A or B be a one (can use a xor for this) and it with Cin to see if we have a carry.

/*Gate solution*/
wire xor_AB, xor_ABCin, NAND_AB, not_NAND_AB, NAND_Cin_xor_AB, not_NAND_Cin_xor_AB, NOR_2NAND, not_NOR_2NAND;

xor2 xor1(.in1(A), .in2(B), .out(xor_AB));
xor2 xor2(.in1(xor_AB), .in2(Cin), .out(xor_ABCin));

assign S = xor_ABCin;

nand2 nand1(.in1(A), .in2(B), .out(NAND_AB));
not1 not1(.in1(NAND_AB), .out(not_NAND_AB));


nand2 nand2(.in1(Cin), .in2(xor_AB), .out(NAND_Cin_xor_AB));
not1 not2(.in1(NAND_Cin_xor_AB), .out(not_NAND_Cin_xor_AB));

nor2 nor1(.in1(not_NAND_AB), .in2(not_NAND_Cin_xor_AB), .out(NOR_2NAND));
not1 not3(.in1(NOR_2NAND), .out(not_NOR_2NAND));

assign Cout = not_NOR_2NAND;



/*Piazza says dont do it this way have to use gates*/
// assign xor_AB = A ^ B;

// assign NAND_AB = ~(A & B); //creating the nand gate for a and b
// assign NAND_Cin_xor_AB  = ~(Cin & xor_AB); //creating the second nand gate
// //could have made and AND variable and did ~(~(Cin & xor_AB))

// assign NOR_2NAND = ~(~NAND_AB | ~NAND_Cin_xor_AB); //creating the nor gate, and we are now notting the nand gates to
//                                                     //create and gate
// assign S = xor_AB ^ Cin;
// assign Cout = ~NOR_2NAND; //not the nor gate to make an or gate

endmodule