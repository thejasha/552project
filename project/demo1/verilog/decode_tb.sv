module decode_tb();

    // Declare signals

    logic [15:0] instruction, read_data_1, read_data_2, i_1, i_2, word_align_jump, to_shift, data_write;

    // Instantiate the DUT (Device Under Test)
    decode iDUT (.instruction(instruction), .read_data_1(read_data_1), .read_data_2(read_data_2), .i_1(i_1), .i_2(i_2), .word_align_jump(word_align_jump),  .to_shift(to_shift), .data_write(data_write));


    initial begin
        
    instruction = 16'h2001;
    data_write = 0;
    #5;
    instruction = 16'b0101100000010000;
    #5;
    end

endmodule