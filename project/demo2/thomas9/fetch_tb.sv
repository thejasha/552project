module fetch_tb ();

    // Declare signals
    logic [15:0] pc_in;
    logic [15:0] pc_out;
    logic clk, rst;
    logic [15:0] something;

    // Instantiate the DUT (Device Under Test)
    fetch iDUT (
        .PC_in(pc_in),       // Input PC value
        .PC_next(pc_out),    // Output next PC value
        .instruction(something), // Fetched instruction
        .clk(clk),
        .rst(rst)
    );

    // Clock generation: Toggle clock every 5 time units
    always 
        #5 clk = ~clk;

    // Testbench initialization
    initial begin
        // Initialize signals
        clk = 0;
        pc_in = 16'h0000;  // Start at address 0x0040
        rst = 1;           // Start with reset asserted

        // Wait for one negative edge of clock to deassert reset
        @(negedge clk);
        rst = 0;           // Deassert reset

        // Run the simulation for a certain amount of time
        #10000 $finish;      // End the simulation after 100 time units
    end

    // // Increment PC on every negative clock edge
    // always @(negedge clk) begin
    //     if (!rst)
    //         pc_in <= pc_in + 2; // Increment by 2 (16-bit instruction size)
    // end

endmodule