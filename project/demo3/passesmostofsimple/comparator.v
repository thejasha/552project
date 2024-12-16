module comparator (inst, execute, memory, writeback, BSrc, Branch, BranchEx, NOPEx, NOPMem, NOPWB, WRMEM, WRWB, sendNOP, fetch_stall, mem_stall);
    //NOPEx/NOPMem/NOPWB are low when that is a nop inst
    input wire [15:0] inst;
    input wire[2:0]  execute, memory, writeback;
    input wire[1:0] BSrc;
    input wire Branch, BranchEx, NOPEx, NOPMem, NOPWB;
    input wire fetch_stall, mem_stall; //if the cache for fetch or mem stalls, we need to do nops.
    output wire sendNOP;//low when need nop

    wire regEqual;
    wire regEqual2;

    wire sendNOP_not_st;
    wire sendnopout;

    assign sendNOP = (inst[15:11] == 5'b00110) ? 1'b1 : (sendnopout & ~fetch_stall & ~mem_stall); //(inst[15:11] == 5'b00110)



    //swap sendNOP and sendnopout

    wire stinstthing;
    assign stinstthing = (inst[15:11] == 5'b10000)  | (inst[15:11] == 5'b10011); //| (inst[15:11] == 5'b11000) | (inst[15:11] == 5'b10010)
    wire oneops;


    assign sendNOP_not_st= ~((inst == 16'h0800) | regEqual);

    assign sendnopout = ~((inst == 16'h0800) | regEqual);
    
    wire [2:0] RegS, RegT;
    assign RegS = inst[10:8];
    assign RegT = inst[7:5];
    input wire WRMEM, WRWB;



    wire compEx;
    assign compEx = (BSrc==2'b00 | stinstthing) & ~(inst[15:11] == 5'b00111) ? (execute == RegS) | (execute == RegT) : (execute == RegS);

    wire compMem;
    assign compMem = (BSrc==2'b00 | stinstthing) & ~(inst[15:11] == 5'b00111)  ? (memory == RegS) | (memory == RegT) : (memory == RegS);

    wire compWB;
    assign compWB = (BSrc==2'b00 | stinstthing) & ~(inst[15:11] == 5'b00111)  ? (writeback == RegS) | (writeback == RegT) : (writeback == RegS);//questionable, might remove cause it would add extra stall

    assign regEqual = (compEx & NOPEx) | (compMem & NOPMem & WRMEM) | (compWB & NOPWB & WRWB);



    //st

    







endmodule
