module put_together_tb();

    // Declare signals
    logic clk, rst, err; //error will output, clk rst are inputs

    //outputs
    logic [15:0] DataOut;
    logic Done; 
    logic Stall;
    logic CacheHit;

    //inputs
    logic [15:0] Addr;
    logic [15:0] DataIn;
    logic Rd;
    logic Wr;
    logic createdump;


    mem_system IDUT(.DataOut(DataOut), .Done(Done), .Stall(Stall), .CacheHit(CacheHit), .err(err), .Addr(Addr), .DataIn(DataIn), .Rd(Rd), .Wr(Wr), .createdump(createdump), .clk(clk), .rst(rst));
    
    initial begin
    rst = 1'b1;
    clk = 1'b0;

    @(negedge clk);
    createdump = 1'b0;
    rst = 1'b0;
    Rd = 0;
    Wr = 1;
    Addr = 16'h015c;
    DataIn = 16'h0018;

    
    
    
    
    @(posedge Done); // Run for 25 clock cycles (or adjust as needed)
    Rd = 0;
    Wr = 1;
    Addr = 16'h015c;
    DataIn = 16'h0018;

    @(posedge Done);

    Rd = 1;
    Wr = 0;
    Addr = 16'h015c;
    DataIn = 16'h0018;

    @(posedge Done);
    #3;
    $stop(); // Fallback stop if "Done" isn't asserted in the expected time
    end

   

    always 
        #5 clk = ~clk;

endmodule