module comparator (inst, execute, memory, writeback, BSrc, Branch, BranchEx, NOPEx, NOPMem, NOPWB, sendNOP);
    //NOPEx/NOPMem/NOPWB are low when that is a nop inst
    input wire [15:0] inst;
    input wire[2:0]  execute, memory, writeback;
    input wire[1:0] BSrc;
    input wire Branch, BranchEx, NOPEx, NOPMem, NOPWB;
    output wire sendNOP;//low when need nop

    wire regEqual;
    assign sendNOP = ~((inst == 16'h0800) | regEqual);
    wire [2:0] RegS, RegT;
    assign RegS = inst[10:8];
    assign RegT = inst[7:5];



    wire compEx;
    assign compEx = BSrc==2'b00 ? (execute == RegS) | (execute == RegT) : (execute == RegS);

    wire compMem;
    assign compMem = BSrc==2'b00 ? (memory == RegS) | (memory == RegT) : (memory == RegS);

    wire compWB;
    assign compWB = BSrc==2'b00 ? (writeback == RegS) | (writeback == RegT) : (writeback == RegS);//questionable, might remove cause it would add extra stall

    assign regEqual = (compEx & NOPEx) | (compMem & NOPMem) | (compWB & NOPWB) | Branch | BranchEx;










endmodule
