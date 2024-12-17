module comparator (inst, execute, memory, writeback, BSrc, Branch, BranchEx, NOPEx, NOPMem, NOPWB, WRMEM, WRWB, sendNOP, RegWrt_out_ID_EX, RegSrc_out_ID_EX, EXFWD1, EXFWD2, MEMFWD1, MEMFWD2);
    //NOPEx/NOPMem/NOPWB are low when that is a nop inst
    input wire [15:0] inst;
    input wire[2:0]  execute, memory, writeback;
    input wire[1:0] BSrc;
    input wire Branch, BranchEx, NOPEx, NOPMem, NOPWB;
    output wire sendNOP;//low when need nop

    wire regEqual;
    wire regEqual2;

    wire sendNOP_not_st;
    wire sendnopout;



    //forward
    input wire[1:0] RegSrc_out_ID_EX;

    input wire RegWrt_out_ID_EX;
    wire memread;
    assign memread = RegSrc_out_ID_EX == 2'b01;

    output wire EXFWD1, EXFWD2, MEMFWD1, MEMFWD2;


    wire [4:0] code;
    assign code = inst[15:11];//opcode in decode
    
	
	wire line1_fwdable, line2_fwdable;
	








    assign sendNOP = (inst[15:11] == 5'b00110) ? 1'b1 : sendnopout; //(inst[15:11] == 5'b00110)



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

    assign regEqual = (compEx & NOPEx & ~(EXFWD1 | EXFWD2)) | (compMem & NOPMem & WRMEM & ~(MEMFWD1 | MEMFWD2)) | (compWB & NOPWB & WRWB);



    //st







    //forwarding

	assign line1_fwdable = ~(code == 5'b00000 |		// HALT
							 code == 5'b00001 |		// NOP
							 code[4:2] == 3'b011 |		// branches
							 code == 5'b11000 |		// LBI
							 code == 5'b00100 |		// J
							 code == 5'b00110 |		// JAL
							 code == 5'b00010 |		// siic
							 code == 5'b00011);		// RTI
							 
	assign line2_fwdable = code == 5'b10000 |			// ST
						   code == 5'b10011 |			// STU
						   code == 5'b11011 |			// ADD, SUB, XOR, ANDN
						   code == 5'b11010 |			// ROL, SLL, ROR, SRL
						   code[4:2] == 3'b111;		// SEQ, SLT, SLE, SCO
	
	assign EXFWD1 = RegWrt_out_ID_EX & line1_fwdable & (execute == RegS) & ~memread;
	assign EXFWD2 = RegWrt_out_ID_EX & line2_fwdable & (execute == RegT) & ~memread;
	
	assign MEMFWD1 = WRMEM & line1_fwdable & (memory == RegS);
	assign MEMFWD2 = WRMEM & line2_fwdable & (memory == RegT);
	
    







endmodule
