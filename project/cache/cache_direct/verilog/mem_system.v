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
                          .offset               (cache_addr[2:0]),
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
                     .addr              (mem_data_in),
                     .data_in           (mem_addr),
                     .wr                (mem_write),
                     .rd                (mem_read));
   
   // your code here

   //to cache
   wire cache_en;
   wire force_disable;
   wire [15:0] cache_data_in; 
   wire [15:0] cache_addr; //will make up the tag index and offset, offset[0] will determine error
   wire cache_comp;

   wire cache_rd;
   wire cache_wr;

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
   assign real_hit = dirty_out & ~hit_out;

   //to 4 bank
   wire [15:0] mem_data_in;
   wire [15:0] mem_addr;
   wire mem_write;
   wire mem_read;

   //from 4 bank
   wire [15:0] mem_data_out;
   wire mem_stall;
   wire [3:0] mem_busy;
   wire mem_err;

   //from controller
   wire controller_err;







   //main err, might not be assign
   assign err = mem_err | controller_err;

   
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
