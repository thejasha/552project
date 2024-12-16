module rotate_right_tb;

// Parameters
parameter OPERAND_WIDTH = 16;
parameter SHAMT_WIDTH   =  4;

// Inputs
reg [OPERAND_WIDTH -1:0] In;
reg [SHAMT_WIDTH   -1:0] ShAmt;

// Outputs
wire [OPERAND_WIDTH -1:0] result;

// Instantiate the Unit Under Test (UUT)
rotate_right #(OPERAND_WIDTH, SHAMT_WIDTH) uut (
    .In(In),
    .ShAmt(ShAmt),
    .result(result)
);

// Test cases
initial begin
    $display("Starting rotate_right test...");

    // Test case 1: Rotate by 0
    In = 16'b1011001110001111;
    ShAmt = 4'b0000;
    #10;
    $display("Test Case 1: In = %b, ShAmt = %d, result = %b", In, ShAmt, result);

    // Test case 2: Rotate by 1
    In = 16'b1011001110001111;
    ShAmt = 4'b0001;
    #10;
    $display("Test Case 2: In = %b, ShAmt = %d, result = %b", In, ShAmt, result);

    // Test case 3: Rotate by 2
    In = 16'b1011001110001111;
    ShAmt = 4'b0010;
    #10;
    $display("Test Case 3: In = %b, ShAmt = %d, result = %b", In, ShAmt, result);

    // Test case 4: Rotate by 4
    In = 16'b1011001110001111;
    ShAmt = 4'b0100;
    #10;
    $display("Test Case 4: In = %b, ShAmt = %d, result = %b", In, ShAmt, result);

    // Test case 5: Rotate by 8
    In = 16'b1011001110001111;
    ShAmt = 4'b1000;
    #10;
    $display("Test Case 5: In = %b, ShAmt = %d, result = %b", In, ShAmt, result);

    // Test case 6: Rotate by 15 (maximum shift)
    In = 16'b1011001110001111;
    ShAmt = 4'b1111;
    #10;
    $display("Test Case 6: In = %b, ShAmt = %d, result = %b", In, ShAmt, result);

    $display("All test cases finished.");
end

endmodule
