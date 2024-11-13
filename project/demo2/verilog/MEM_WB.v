module MEM_WB(RegSrc_in, RegSrc_out, MemRead_in, mem_data_out, alu_data_in, 
    pc_data_in, Binput_in, alu_data_out, pc_data_out, Binput_out, RegWrt_in, RegWrt_out);

/*
needed for wb
wb iDUU5(.RegSrc(RegSrc), .mem_data(memory_data), .alu_data(Alu_result), .Binput(Binput), 
.pc_data(pc_next_to_pc2), .data_to_write(data_write));
*/

/*FROM MEM TO WB*/

    //Data read from mem
    input wire [15:0] MemRead_in;
    output wire [15:0] mem_data_out;


/*FROM EX_MEM flop TO WB*/
   
    //RegSrc singal
    input wire [1:0] RegSrc_in;
    output wire [1:0] RegSrc_out;

    //Rest of the data
    input wire [15:0] alu_data_in, pc_data_in, Binput_in;
    output wire [15:0] alu_data_out, pc_data_out, Binput_out;


/*STFF not used in WB*/

    //need the signal for regwrt, to fetch
    input wire RegWrt_in;
    output wire RegWrt_out;

    //input wire [15:0] newPC; //output that goes back to pc we dont need this, goes straight to fetch after mem


//WILL Likely need to flop the write register all the way through

dff [15:0] ();


endmodule