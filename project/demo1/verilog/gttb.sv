module tb_greaterThan;

  // Inputs
  reg [15:0] InA;
  reg [15:0] InB;

  // Output
  wire Out;

  // Instantiate the Unit Under Test (UUT)
  greaterThan uut (
    .InA(InA), 
    .InB(InB), 
    .Out(Out)
  );

  initial begin
    // Test 1: InA > InB
    InA = 16'b0000000000001010; // 10
    InB = 16'b0000000000000101; // 5
    #10;
    $display("Test 1 - InA: %d, InB: %d, Output: %b", InA, InB, Out); 

    // Test 2: InA < InB
    InA = 16'b0000000000000101; // 5
    InB = 16'b0000000000001010; // 10
    #10;
    $display("Test 2 - InA: %d, InB: %d, Output: %b", InA, InB, Out); 

    // Test 3: InA == InB
    InA = 16'b0000000000001010; // 10
    InB = 16'b0000000000001010; // 10
    #10;
    $display("Test 3 - InA: %d, InB: %d, Output: %b", InA, InB, Out); 

    // Test 4: InA > InB with negative values
    InA = 16'b1111111111111100; // -4 (2's complement)
    InB = 16'b1111111111111111; // -1 (2's complement)
    #10;
    $display("Test 4 - InA: %d, InB: %d, Output: %b", InA, InB, Out); 

    // Test 5: InA < InB with negative values
    InA = 16'b1111111111111111; // -1 (2's complement)
    InB = 16'b1111111111111100; // -4 (2's complement)
    #10;
    $display("Test 5 - InA: %d, InB: %d, Output: %b", InA, InB, Out); 

    $stop;
  end
endmodule
