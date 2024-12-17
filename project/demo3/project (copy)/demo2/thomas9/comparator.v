module comparator (inst, execute, memory, writeback, BSrc, Branch, BranchEx, NOPEx, NOPMem, NOPWB, WRMEM, WRWB, sendNOP, MEMWRT);
    //NOPEx/NOPMem/NOPWB are low when that is a nop inst
    input wire [15:0] inst;
    input wire[2:0]  execute, memory, writeback;
    input wire[1:0] BSrc;
    input wire Branch, BranchEx, NOPEx, NOPMem, NOPWB;
    output wire sendNOP;//low when need nop

    wire regEqual;
    wire regEqual2;
    input wire MEMWRT;

    wire sendNOP_not_st;

    assign sendNOP_not_st= ~((inst == 16'h0800) | regEqual);

    assign sendNOP = ~((inst == 16'h0800) | regEqual);
    wire [2:0] RegS, RegT;
    assign RegS = inst[10:8];
    assign RegT = inst[7:5];
    input wire WRMEM, WRWB;



    wire compEx;
    assign compEx = BSrc==2'b00 ? (execute == RegS) | (execute == RegT) : (execute == RegS);

    wire compMem;
    assign compMem = BSrc==2'b00 ? (memory == RegS) | (memory == RegT) : (memory == RegS);

    wire compWB;
    assign compWB = BSrc==2'b00 ? (writeback == RegS) | (writeback == RegT) : (writeback == RegS);//questionable, might remove cause it would add extra stall

    assign regEqual = (compEx & NOPEx) | (compMem & NOPMem & WRMEM) | (compWB & NOPWB & WRWB);



    //st

    







endmodule
