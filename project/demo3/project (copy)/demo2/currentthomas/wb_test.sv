module wb_tb();

    // Declare signals
    logic [15:0] mem_data, alu_data, other_data, pc_data, data_to_write;
    logic [1:0] RegSrc;
  

    // Instantiate the DUT (Device Under Test)
    wb iDUT (.RegSrc(RegSrc), .mem_data(mem_data), .alu_data(alu_data), .other_data(other_data), .pc_data(pc_data), .data_to_write(data_to_write));

    // Testbench initialization
    initial begin
    mem_data = 1;
    alu_data = 2;
    other_data = 3;
    pc_data = 4;
    RegSrc = 0;

    #5;
    RegSrc = 1;

    #5;
    RegSrc = 2;

    #5;
    RegSrc = 3;

    end

endmodule