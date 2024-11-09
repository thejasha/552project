`timescale 1ns / 1ps

module tb_memory2c;
    // Testbench signals
    reg [15:0] data_in;
    reg [15:0] addr;
    reg enable;
    reg wr;
    reg createdump;
    reg clk;
    reg rst;
    wire [15:0] data_out;

    // Instantiate the memory2c module
    memory2c dut (
        .data_out(data_out),
        .data_in(data_in),
        .addr(addr),
        .enable(enable),
        .wr(wr),
        .createdump(createdump),
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        rst = 0; // Deassert reset
        #10;
        // Initialize signals
        rst = 1;
        enable = 0;
        wr = 0;
        createdump = 0;
        addr = 16'h0000;
        data_in = 16'h0000;

        // Reset the memory
        #10;
        rst = 0; // Deassert reset
        #10;

        // Write data to memory
        enable = 1;
        wr = 0;

        addr = 16'h0000; // Address 0
        data_in = 16'hABCD; // Data to write
        #10;
        addr = 16'h0002; // Address 2
        data_in = 16'h1234; // Data to write
        #10;
        addr = 16'h0001; // Address 2
        data_in = 16'h1234; // Data to write
        #10;
        addr = 16'h0003; // Address 2
        data_in = 16'h1234; // Data to write
        #10;
        addr = 16'h0004; // Address 2
        data_in = 16'h1234; // Data to write
        #10;
        addr = 16'h0005; // Address 2
        data_in = 16'h1234; // Data to write
        #10;
        enable = 1;
        wr = 1;

        addr = 16'h0000; // Address 0
        data_in = 16'hABCD; // Data to write
        // Read data from memory
        wr = 0; // Disable write
        addr = 16'h0000; // Read from address 0
        #10;
        $display("Read data at address %h: %h", addr, data_out);

        addr = 16'h0002; // Read from address 2
        #10;
        $display("Read data at address %h: %h", addr, data_out);

        // Test createdump functionality
        createdump = 1; // Enable dump
        #10;
        createdump = 0; // Disable dump after one clock cycle

        // Write more data
        addr = 16'h0004; // Address 4
        data_in = 16'hFFFF; // Data to write
        wr = 1;
        #10;

        // Read from a different address
        wr = 0; // Disable write
        addr = 16'h0004; // Read from address 4
        #10;
        $display("Read data at address %h: %h", addr, data_out);

        // Reset memory
        rst = 1;
        #10;
        rst = 0; // Deassert reset

        // Finish simulation
        $finish;
    end

endmodule
