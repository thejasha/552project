/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

`default_nettype none
module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input wire [15:0] Addr;
   input wire [15:0] DataIn;
   input wire        Rd;
   input wire        Wr;
   input wire        createdump;
   input wire        clk;
   input wire        rst;
   
   output reg [15:0] DataOut;
   output reg        Done;
   output reg        Stall;
   output reg        CacheHit;
   output reg        err;

     //to cache
   wire cache_en;
   reg force_disable;
   reg [15:0] cache_data_in; 
   reg [15:0] cache_addr; //will make up the tag index and offset, offset[0] will determine error
   reg cache_comp;

   reg cache_rd;
   reg cache_wr;

   wire enable_or;
   wire enable_force;

   reg valid_to_cache;

   //combo logic for the block
   assign enable_or = cache_rd | cache_wr;
   assign enable_force = enable_or & ~force_disable;
   assign cache_en = enable_force;

   //from cache
   wire valid_out;
   wire hit_out;
   wire dirty_out;

   wire real_hit;
   wire victimize;
   wire [4:0] actual_tag;
   wire [15:0] cache_data_out;
   wire cache_err;

   //combo logic for the block
   assign real_hit = valid_out & hit_out;
   assign victimize = dirty_out & ~hit_out;

   //to 4 bank
   reg [15:0] mem_data_in;
   reg [15:0] mem_addr;
   reg mem_write;
   reg mem_read;

   //from 4 bank
   wire [15:0] mem_data_out;
   wire mem_stall;
   wire [3:0] mem_busy;
   wire mem_err;

   //from controller
   wire controller_err;

   reg [15:0] temp;



   //fsm states
   parameter IDLE = 4'b0000;
   parameter TAG_CHECK = 4'b0010;
   parameter LOAD_HIT = 4'b0011;
   parameter STORE_HIT = 4'b0100;
   parameter ACCESS_READ_1 = 4'b0101;
   parameter ACCESS_WRITE_1 = 4'b0110;
   parameter ACCESS_WRITE_2 = 4'b0111;
   parameter ACCESS_WRITE_3 = 4'b1000;
   parameter ACCESS_WRITE_4 = 4'b1001;
   parameter WRITE_WAIT1 = 4'b1010;
   parameter WRITE_WAIT2 = 4'b1011;
   parameter STORE_MISS_WRITE = 4'b1100;
   parameter ACCESS_READ_2 = 4'b1101;
   parameter ACCESS_READ_3 = 4'b1110;
   parameter ACCESS_READ_4 = 4'b1111;


   //FSM regs
   reg [3:0] next_state;
   wire [3:0] current_state;

   dff state_ff1(.q(current_state[0]), .d(next_state[0]), .clk(clk), .rst(rst));
   dff state_ff2(.q(current_state[1]), .d(next_state[1]), .clk(clk), .rst(rst));
   dff state_ff3(.q(current_state[2]), .d(next_state[2]), .clk(clk), .rst(rst));
   dff state_ff4(.q(current_state[3]), .d(next_state[3]), .clk(clk), .rst(rst));

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (actual_tag),
                          .data_out             (cache_data_out),
                          .hit                  (hit_out),
                          .dirty                (dirty_out),
                          .valid                (valid_out),
                          .err                  (cache_err),
                          // Inputs
                          .enable               (enable_force),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (cache_addr[15:11]),
                          .index                (cache_addr[10:3]),
                          .offset               ({cache_addr[2:1],1'b0}),
                          .data_in              (cache_data_in),
                          .comp                 (cache_comp),
                          .write                (cache_wr),
                          .valid_in             (valid_to_cache));

   four_bank_mem mem(// Outputs
                     .data_out          (mem_data_out),
                     .stall             (mem_stall),
                     .busy              (mem_busy),
                     .err               (mem_err), 
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (mem_data_in),
                     .wr                (mem_write),
                     .rd                (mem_read));
   
   // your code here

   always @(*) begin

      //default
      Done=0;
      Stall=1;
      DataOut=0;
      next_state = current_state;
      force_disable=0;
      cache_comp = 0;
      cache_rd = 0;
      cache_wr = 0;
      cache_addr = 0;
      cache_data_in = 0;
      mem_data_in=0;
      mem_addr=0;
      mem_write=0;
      mem_read=0;
      CacheHit=0;
      valid_to_cache = 0;

      err = cache_err | controller_err | mem_err;

      case (current_state)
         IDLE: begin
            Stall = 0;
            next_state = (Rd | Wr) ? TAG_CHECK : IDLE;
         end

         TAG_CHECK: begin
            cache_comp = 1;
            cache_rd = Rd;
            cache_wr = Wr;
            cache_addr = Addr;
            cache_data_in = DataIn;
            valid_to_cache = 1'b1;
            temp = cache_data_out;
            next_state = real_hit ? (Rd ? LOAD_HIT : STORE_HIT) : (victimize ? ACCESS_READ_1 : ACCESS_WRITE_1);

         end

         LOAD_HIT: begin //load hit and store hit add an extra cycle since cache happens instantly
            DataOut = temp;
            Done = 1;
            CacheHit = 1;
            next_state = IDLE;

         end

         STORE_HIT: begin
            Done = 1;
            CacheHit = 1;
            next_state = IDLE;
         end

         //access read write to mem 4 words loop

         ACCESS_READ_1: begin
            cache_rd = 1;
            cache_addr = {Addr[15:3], 2'b00, Addr[0]};
            mem_write = 1;//writing dirty to mem
            mem_addr = {actual_tag, cache_addr[10:3], 2'b00, cache_addr[0]}; //takes in address from cc input
            mem_data_in = cache_data_out;
            next_state = ACCESS_READ_2;
         end

          ACCESS_READ_2: begin
            cache_rd = 1;
            cache_addr = {Addr[15:3], 2'b01, Addr[0]};
            mem_write = 1;//writing dirty to mem
            mem_addr = {actual_tag, cache_addr[10:3], 2'b01, cache_addr[0]}; //takes in address from cc input
            mem_data_in = cache_data_out;
            next_state = mem_stall ? ACCESS_READ_2: ACCESS_READ_3;
         end

          ACCESS_READ_3: begin
            cache_rd = 1;
            cache_addr = {Addr[15:3], 2'b10, Addr[0]};
            mem_write = 1;//writing dirty to mem
            mem_addr = {actual_tag, cache_addr[10:3], 2'b10, cache_addr[0]}; //takes in address from cc input
            mem_data_in = cache_data_out;
            next_state = mem_stall ? ACCESS_READ_3 : ACCESS_READ_4;
         end

          ACCESS_READ_4: begin
            cache_rd = 1;
            cache_addr = {Addr[15:3], 2'b11, Addr[0]};
            mem_write = 1;//writing dirty to mem
            mem_addr = {actual_tag, cache_addr[10:3], 2'b11, cache_addr[0]}; //takes in address from cc input
            mem_data_in = cache_data_out;
            next_state = mem_stall ? ACCESS_READ_4 : ACCESS_WRITE_1;
         end

         //access write, write 4 words to cache loop, SHOULD ADD STALL IN EVERY ONE

         ACCESS_WRITE_1: begin
            mem_read = 1;
            mem_addr = {Addr[15:3], 2'b00, Addr[0]};
            next_state = ACCESS_WRITE_2;
         end

         ACCESS_WRITE_2: begin
            mem_read = 1;
            mem_addr = {Addr[15:3], 2'b01, Addr[0]};
            next_state = ACCESS_WRITE_3;
         end

         ACCESS_WRITE_3: begin
            mem_read = 1;
            mem_addr = {Addr[15:3], 2'b10, Addr[0]};

            cache_wr = 1;
            cache_data_in = mem_data_out;
            cache_addr = {Addr[15:3], 2'b00, Addr[0]};
            valid_to_cache = 1'b1;
            next_state = ACCESS_WRITE_4;
         end

         ACCESS_WRITE_4: begin
            mem_read = 1;
            mem_addr = {Addr[15:3], 2'b11, Addr[0]};

            cache_wr = 1;
            cache_data_in = mem_data_out;
            cache_addr = {Addr[15:3], 2'b01, Addr[0]};
            valid_to_cache = 1'b1;
            next_state = WRITE_WAIT1;
         end

         WRITE_WAIT1: begin 
            cache_wr = 1;
            cache_data_in = mem_data_out;
            cache_addr = {Addr[15:3], 2'b10, Addr[0]};
            valid_to_cache = 1'b1;
            next_state = WRITE_WAIT2;
         end

         WRITE_WAIT2: begin 
            cache_wr = 1;
            cache_data_in = mem_data_out;
            cache_addr = {Addr[15:3], 2'b11, Addr[0]};
            valid_to_cache = 1'b1;
            Done = Rd; //if we r doing load we are done, if it was a write, need to write back
            next_state = Wr ? STORE_MISS_WRITE : IDLE;
         end

         STORE_MISS_WRITE: begin 
            cache_wr = 1;
            cache_comp = 1;
            cache_data_in = DataIn;
            cache_addr = Addr;
            valid_to_cache = 1'b1;
            next_state = IDLE;
            Done = 1;
         end

         default: begin 
            next_state = IDLE;
         end

      endcase
   end


   assign controller_err = Rd & Wr;


   
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
