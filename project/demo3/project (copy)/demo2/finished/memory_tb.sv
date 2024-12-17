`timescale 1ns / 1ps  // Define the time scale

module tb_memory;

    // Declare testbench variables
    reg branch;
    reg jmpdsp;
    reg [15:0] alu;
    reg [15:0] SgnExt;
    reg [15:0] readData2;
    reg [15:0] pc2;
    reg ALUJmp;
    reg MemWrt;
    reg clk;
    reg rst;
    reg enable;

    wire [15:0] newPC;
    wire [15:0] MemRead;

    // Instantiate the memory module
    memory dut (
        .branch(branch),
        .jmpdsp(jmpdsp),
        .alu(alu),
        .SgnExt(SgnExt),
        .readData2(readData2),
        .pc2(pc2),
        .ALUJmp(ALUJmp),
        .MemWrt(MemWrt),
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .newPC(newPC),
        .MemRead(MemRead)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    

    // Test stimulus
    initial begin
        rst = 1; // Assert reset
        

        branch = 1;
        jmpdsp = 0;
        alu = 16'h0000;
        SgnExt = 16'h0000;
        readData2 = 16'h0000;
        pc2 = 16'h0000;
        ALUJmp = 0;
        enable = 0;
        MemWrt = 0;
        #10 rst = 0; // De-assert reset after 10 time units
        #10;
        // Wait for reset
        wait (!rst);

        // Test case 1: Branch taken
        #10;
        branch = 1;
        jmpdsp = 0;
        alu = 16'h0000; // Example value
        SgnExt = 16'h0001; // Example value
        pc2 = 16'h0003; // Example PC value
        ALUJmp = 0;
        enable = 1;
        #10;
        MemWrt = 1;
        alu = 16'h0000;
        readData2 = 16'h0001;

        #10; // Wait for a clock cycle
        MemWrt = 0;
        alu = 16'h0000;
        readData2 = 16'h0001;
        #10;
        alu = 16'h0001;
        readData2 = 16'h0011;
        MemWrt = 1;

        #10; 
        alu = 16'h0011;
        readData2 = 16'h0101;
        #10;
        MemWrt = 0;
        alu = 16'h0011;
        readData2 = 16'h0101;
        #10; 
        // Test case 2: Jump taken
        #10;
        branch = 0;
        jmpdsp = 1;
        alu = 16'h0000; // Jump address
        SgnExt = 16'h0004;
        pc2 = 16'h0005; // Reset PC
        ALUJmp = 1; // Trigger ALU Jump
        readData2 = 16'h0201;
        #10; // Wait for a clock cycle

        // Test case 3: Memory write operation
        #10;
        branch = 0;
        jmpdsp = 0;
        alu = 16'h0055; // Memory address
        SgnExt = 16'h0030;
        readData2 = 16'h1234; // Data to write
        pc2 = 16'h0030;
        ALUJmp = 0;
        MemWrt = 1; // Enable write

        #10;
        branch = 0;
        jmpdsp = 0;
        alu = 16'h0055; // Memory address
        SgnExt = 16'h0030;
        readData2 = 16'h1234; // Data to write
        pc2 = 16'h0030;
        ALUJmp = 0;
        MemWrt = 1; // Enable write

        #10; // Wait for a clock cycle

        // Test case 4: Check MemRead output
        #10;
        MemWrt = 0; // Disable write
        alu = 16'h030; // Address to read
        readData2 = 16'h0040; // Not used during read

        #10; // Wait for a clock cycle

        // End of test
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | newPC: %h | MemRead: %h | branch: %b | jmpdsp: %b | ALUJmp: %b | MemWrt: %b", 
                 $time, newPC, MemRead, branch, jmpdsp, ALUJmp, MemWrt);
    end

endmodule
