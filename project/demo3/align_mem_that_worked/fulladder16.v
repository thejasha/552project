module fulladder16(A, B, S, Cout);

input [15:0] A, B;
output [15:0] S; //Sum
output Cout; //Carry-out

wire Cout0;
wire Cout1;
wire Cout2;

wire Cin = 0;

fulladder4 f1 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .Cout(Cout0));
fulladder4 f2 (.A(A[7:4]), .B(B[7:4]), .Cin(Cout0), .S(S[7:4]), .Cout(Cout1));
fulladder4 f3 (.A(A[11:8]), .B(B[11:8]), .Cin(Cout1), .S(S[11:8]), .Cout(Cout2));
fulladder4 f4 (.A(A[15:12]), .B(B[15:12]), .Cin(Cout2), .S(S[15:12]), .Cout(Cout));

endmodule