module comparator (inst, execute, memory, writeback, BSrc, Branch, BranchEx, NOPEx, NOPMem, NOPWB, WRMEM, WRWB, sendNOP, MEMWRT);
    //NOPEx/NOPMem/NOPWB are low when that is a nop inst
    input wire [15:0] inst;
    input wire[2:0]  execute, memory, writeback;
    input wire[1:0] BSrc;
    input wire Branch, BranchEx, NOPEx, NOPMem, NOPWB;
    output wire sendNOP;//low when need nop

    wire regEqual;

    wire sendNOP_regular;

    assign sendNOP_regular = ~((inst == 16'h0800) | regEqual);

    assign sendNOP = MEMWRT ? (~((inst == 16'h0800) | regEqualtwo)) : (sendNOP_regular)

    wire [2:0] RegS, RegT, RegD;
    assign RegS = inst[10:8];
    assign RegT = inst[7:5];
    input wire WRMEM, WRWB;

    wire compEx;
    assign compEx = BSrc==2'b00 ? (execute == RegS) | (execute == RegT) : (execute == RegS);

    wire compMem;
    assign compMem = BSrc==2'b00 ? (memory == RegS) | (memory == RegT) : (memory == RegS);

    wire compWB;
    assign compWB = BSrc==2'b00 ? (writeback == RegS) | (writeback == RegT) : (writeback == RegS);//questionable, might remove cause it would add extra stall

    //when in nop already won't proc another nop
    assign regEqual = (compEx & NOPEx) | (compMem & NOPMem & WRMEM) | (compWB & NOPWB & WRWB);


    //for st instruction, mem write will be high and the rd is what we need to check
    //in this case RegT is Rd

    //if memwrt = 1
    wire compExtwo;
    assign compExtwo = execute == RegT

    wire compMemtwo;
    assign compMemtwo = memory == RegT

    wire compWBtwo;
    assign compWBtwo = (writeback == RegT)

    assign regEqualtwo = (compExtwo & NOPEx) | (compMemtwo & NOPMem) | (compWBtwo & NOPWB);





endmodule
