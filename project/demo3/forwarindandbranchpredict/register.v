module register(clk, rst, writeData, read, writeEn);

    parameter bitlength = 16;

    //inputs
    input        clk, rst, writeEn;
    input [bitlength - 1:0] writeData;

    //outputs
    output [bitlength - 1:0] read;


    dff flop[bitlength - 1:0](.q(read), .d(writeEn ? writeData : read), .clk(clk), .rst(rst));

endmodule