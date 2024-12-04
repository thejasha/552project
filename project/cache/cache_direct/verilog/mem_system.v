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

   wire valid_to_cache;

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



   //fsm states
   parameter IDLE = 3'b000;
   parameter TAG_CHECK = 3'b001;
   parameter LOAD_HIT = 3'b010;
   parameter STORE_HIT = 3'b011;
   parameter ACCESS_READ = 3'b100;
   parameter ACCESS_WRITE = 3'b101;



   //FSM regs
   reg [2:0] next_state;
   wire [2:0] current_state;

   dff state_ff1(.q(current_state[0]), .d(next_state[0]), .clk(clk), .rst(rst));
   dff state_ff2(.q(current_state[1]), .d(next_state[1]), .clk(clk), .rst(rst));
   dff state_ff3(.q(current_state[2]), .d(next_state[2]), .clk(clk), .rst(rst));

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
      //Done=0;
      Stall=0;
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

      case (current_state)
         default: begin
            next_state = (Rd | Wr) ? TAG_CHECK : IDLE;
         end

         TAG_CHECK: begin
            cache_comp = 1;
            cache_rd = Rd;
            cache_wr = Wr;
            cache_addr = Addr;
            cache_data_in = DataIn;
            next_state = real_hit ? (Rd ? LOAD_HIT : STORE_HIT) : (victimize ? ACCESS_READ : ACCESS_WRITE);

         end

         LOAD_HIT: begin
            DataOut = cache_data_out;
            //Done = 1;
            CacheHit=1;
            next_state = IDLE;

         end

         STORE_HIT: begin
            //Done = 1;
            CacheHit=1;
            next_state = IDLE;
         end

         ACCESS_READ: begin
            cache_rd = 1;
            cache_addr = Addr;
            mem_write = 1;//writing dirty to mem
            mem_addr = {actual_tag, cache_addr[10:0]}; //takes in address from cc input
            mem_data_in = cache_data_out;
            next_state = ACCESS_WRITE;
         end

         ACCESS_WRITE: begin
            mem_read = 1;
            mem_addr = Addr;

            cache_wr = 1;
            cache_data_in = mem_data_out;
            cache_addr = Addr;
            next_state = mem_stall ? ACCESS_WRITE : IDLE;
         end
      endcase
   end



   
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
