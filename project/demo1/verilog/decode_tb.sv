module decode_tb();

    // Declare signals

    logic [15:0] instruction, read_data_1, read_data_2, write_data, i_1, i_2, word_align_jump;

    // Instantiate the DUT (Device Under Test)
    decode iDUT (.instruction(instruction), .read_data_1(read_data_1), .read_data_2(read_data_2), .write_data(write_data), .i_1(i_1), .i_2(i_2), .word_align_jump(word_align_jump));


    initial begin
        
    instruction = 16'h1629;
    #5;
     instruction = 16'h1699;
    #5;
    
    end

endmodule