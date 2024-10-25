module tb_lessThan;

    // Inputs
    reg [15:0] InA;
    reg [15:0] InB;

    // Output
    wire Out;

    // Instantiate the Unit Under Test (UUT)
    lessThan uut (
        .InA(InA),
        .InB(InB),
        .Out(Out)
    );

    initial begin
        // Display header for simulation results
        $display("InA\t\tInB\t\tOut (InA < InB)");
        $monitor("%h\t%h\t%b", InA, InB, Out);

        // Test Case 1: InA < InB
        InA = 16'h0001; // 1
        InB = 16'h0002; // 2
        #10; // Wait for 10 time units

        // Test Case 2: InA > InB
        InA = 16'h0005; // 5
        InB = 16'h0003; // 3
        #10;

        // Test Case 3: InA == InB
        InA = 16'h000A; // 10
        InB = 16'h000A; // 10
        #10;

        // Test Case 4: Negative numbers (InA < InB)
        InA = 16'hFFFE; // -2 (in 2's complement)
        InB = 16'hFFFF; // -1 (in 2's complement)
        #10;

        // Test Case 5: Negative numbers (InA > InB)
        InA = 16'hFFFD; // -3 (in 2's complement)
        InB = 16'hFFFC; // -4 (in 2's complement)
        #10;

        // Test Case 6: Edge case with zeros
        InA = 16'h0000; // 0
        InB = 16'h0000; // 0
        #10;

        // Test Case 7: Large positive numbers
        InA = 16'h7FFF; // Maximum positive number
        InB = 16'h7FFE; // Slightly smaller positive number
        #10;

        // Test Case 8: Large negative numbers
        InA = 16'h8000; // Minimum negative number (-32768)
        InB = 16'h7FFF; // Maximum positive number (32767)
        #10;

        // End simulation
        $finish;
    end

endmodule
