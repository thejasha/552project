module fulladder4(A, B, Cin, S, Cout);

input [3:0] A, B;
input Cin;//Carry-in
output [3:0] S; //Sum
output Cout; //Carry-out

wire Cout0;
wire Cout1;
wire Cout2;

fulladder1 f1(.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(Cout0));
fulladder1 f2(.A(A[1]), .B(B[1]), .Cin(Cout0), .S(S[1]), .Cout(Cout1));
fulladder1 f3(.A(A[2]), .B(B[2]), .Cin(Cout1), .S(S[2]), .Cout(Cout2));
fulladder1 f4(.A(A[3]), .B(B[3]), .Cin(Cout2), .S(S[3]), .Cout(Cout));

endmodule