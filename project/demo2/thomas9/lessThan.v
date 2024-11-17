module lessThan (
    input wire [15:0] InA,
    input wire [15:0] InB,
    output wire Out
);

    wire difference;

    // Reverse the conditions to check for "less than" instead of "greater than"
    assign difference = ((InA[15] == 1) & (InB[15] == 0)) ? 1 : ((InA[15] == 0) & (InB[15] == 1)) ? 0 :
                        ((InA[14] == 1) & (InB[14] == 0)) ? 0 : ((InA[14] == 0) & (InB[14] == 1)) ? 1 :
                        ((InA[13] == 1) & (InB[13] == 0)) ? 0 : ((InA[13] == 0) & (InB[13] == 1)) ? 1 :
                        ((InA[12] == 1) & (InB[12] == 0)) ? 0 : ((InA[12] == 0) & (InB[12] == 1)) ? 1 :
                        ((InA[11] == 1) & (InB[11] == 0)) ? 0 : ((InA[11] == 0) & (InB[11] == 1)) ? 1 :
                        ((InA[10] == 1) & (InB[10] == 0)) ? 0 : ((InA[10] == 0) & (InB[10] == 1)) ? 1 :
                        ((InA[9] == 1) & (InB[9] == 0)) ? 0 : ((InA[9] == 0) & (InB[9] == 1)) ? 1 :
                        ((InA[8] == 1) & (InB[8] == 0)) ? 0 : ((InA[8] == 0) & (InB[8] == 1)) ? 1 :
                        ((InA[7] == 1) & (InB[7] == 0)) ? 0 : ((InA[7] == 0) & (InB[7] == 1)) ? 1 :
                        ((InA[6] == 1) & (InB[6] == 0)) ? 0 : ((InA[6] == 0) & (InB[6] == 1)) ? 1 :
                        ((InA[5] == 1) & (InB[5] == 0)) ? 0 : ((InA[5] == 0) & (InB[5] == 1)) ? 1 :
                        ((InA[4] == 1) & (InB[4] == 0)) ? 0 : ((InA[4] == 0) & (InB[4] == 1)) ? 1 :
                        ((InA[3] == 1) & (InB[3] == 0)) ? 0 : ((InA[3] == 0) & (InB[3] == 1)) ? 1 :
                        ((InA[2] == 1) & (InB[2] == 0)) ? 0 : ((InA[2] == 0) & (InB[2] == 1)) ? 1 :
                        ((InA[1] == 1) & (InB[1] == 0)) ? 0 : ((InA[1] == 0) & (InB[1] == 1)) ? 1 :
                        ((InA[0] == 1) & (InB[0] == 0)) ? 0 : ((InA[0] == 0) & (InB[0] == 1)) ? 1 : 0;

    assign Out = !(InA == InB) & difference;

endmodule
