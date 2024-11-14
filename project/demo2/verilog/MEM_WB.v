module MEM_WB(RegSrc_in, RegSrc_out, MemRead_in, mem_data_out, alu_data_in, 
    pc_data_in, Binput_in, alu_data_out, pc_data_out, Binput_out, RegWrt_in, RegWrt_out, write_reg_in, write_reg_out, clk, rst);

/*
needed for wb
wb iDUU5(.RegSrc(RegSrc), .mem_data(memory_data), .alu_data(Alu_result), .Binput(Binput), 
.pc_data(pc_next_to_pc2), .data_to_write(data_write));
*/

input wire clk, rst;

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

    // address of the write reg(picks which one to write to )
    input wire [2:0] write_reg_in;
    output wire [2:0] write_reg_out;

    


//WILL Likely need to flop the write register all the way through

/*Flops*/

dff RegSrc [1:0] (.q(RegSrc_out), .d(RegSrc_in), .clk(clk), .rst(rst));
dff MemRead [15:0] (.q(mem_data_out), .d(MemRead_in), .clk(clk), .rst(rst));
dff alu_data [15:0] (.q(alu_data_out), .d(alu_data_in), .clk(clk), .rst(rst));
dff pc_data [15:0] (.q(pc_data_out), .d(pc_data_in), .clk(clk), .rst(rst));
dff Binput [15:0] (.q(Binput_out), .d(Binput_in), .clk(clk), .rst(rst));
dff RegWrt(.q(RegWrt_out), .d(RegWrt_in), .clk(clk), .rst(rst));
dff write_reg [2:0](.q(write_reg_out), .d(write_reg_in), .clk(clk), .rst(rst));


endmodule