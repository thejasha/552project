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

   output wire [15:0] DataOut;
   output wire        Done;
   output wire        Stall;
   output wire        CacheHit;
   output wire        err;

   parameter memtype = 0;

   // BEGIN INSERTED CODE (Do not change anything below this line)

   // Internal wires for both ways of the associative cache
   wire [4:0] c0_tag_out, c1_tag_out, chosen_tag_out;
   wire [15:0] c0_data_out, c1_data_out, chosen_data_out;
   wire c0_hit, c1_hit, cache_hit;
   wire c0_dirty, c1_dirty, chosen_dirty;
   wire c0_valid, c1_valid, chosen_valid;
   wire enable_signal;
   wire comp_signal;
   wire write_signal, c0_write_signal, c1_write_signal;
   wire valid_in_signal;
   wire [2:0] offset_signal;
   wire [15:0] m_data_out;
   wire [15:0] mem_addr;
   wire mem_wr, mem_rd;
   wire stall_mem;
   wire [15:0] cache_data_in;

   wire err_c0, err_c1, err_mem, err_fsm;
   wire victimway_in, victimway_out;
   wire victim_line_sel;
   wire selected_way;

   // Instantiate the two caches
   cache #(0 + memtype) c0(
      .tag_out     (c0_tag_out),
      .data_out    (c0_data_out),
      .hit         (c0_hit),
      .dirty       (c0_dirty),
      .valid       (c0_valid),
      .err         (err_c0),
      .enable      (enable_signal),
      .clk         (clk),
      .rst         (rst),
      .createdump  (createdump),
      .tag_in      (Addr[15:11]),
      .index       (Addr[10:3]),
      .offset      (offset_signal),
      .data_in     (cache_data_in),
      .comp        (comp_signal),
      .write       (c0_write_signal),
      .valid_in    (valid_in_signal)
   );

   // Four-bank memory instantiation
   four_bank_mem main_mem(
      .data_out    (m_data_out),
      .stall       (stall_mem),
      .busy        (),
      .err         (err_mem),
      .clk         (clk),
      .rst         (rst),
      .createdump  (createdump),
      .addr        (mem_addr),
      .data_in     (chosen_data_out),
      .wr          (mem_wr),
      .rd          (mem_rd)
   );

   // FSM controller instantiation
   cache_FSM cache_controller(
      .Done       (Done),
      .Stall      (Stall),
      .CacheHit   (CacheHit),
      .err        (err_fsm),
      .enable     (enable_signal),
      .offset     (offset_signal),
      .comp       (comp_signal),
      .write      (write_signal),
      .valid_in   (valid_in_signal),
      .addr       (mem_addr),
      .wr         (mem_wr),
      .rd         (mem_rd),
      .Rd         (Rd),
      .Wr         (Wr),
      .tag_in     (Addr[15:11]),
      .index      (Addr[10:3]),
      .offset_in  (Addr[2:0]),
      .clk        (clk),
      .rst        (rst),
      .hit        (cache_hit),
      .dirty      (chosen_dirty),
      .valid      (chosen_valid),
      .tag_out    (chosen_tag_out),
      .stall      (stall_mem)
   );

   // Determine if there's a hit in any of the ways
   assign cache_hit = c0_hit;

   // Determine which way to select. If a hit occurs, choose the hitting way.
   // If no hit, choose based on victim selection logic.

   // Choose dirty, valid, tag_out, data_out based on selected way
   assign chosen_dirty    = c0_dirty;
   assign chosen_valid    = c0_valid;
   assign chosen_tag_out  = c0_tag_out;
   assign chosen_data_out = c0_data_out;

   // Write signals: only one way can be written at a time
   assign c0_write_signal = write_signal;
   

   // Invert victimway_out on each done cycle
   //assign victimway_in = Done ? ~victimway_out : victimway_out;

   // Victim selection logic:
   // If both ways valid, use victimway_out; if one invalid, choose that one.
   // If both invalid, choose way zero.
   //assign victim_line_sel = (c0_valid) ? ~victimway_out : c0_valid;

   // Data input to cache
   // On allocation (comp=0 and write=1), data from mem; on compare, data from CPU
   assign cache_data_in = (write_signal & ~comp_signal) ? m_data_out : DataIn;

   assign DataOut = chosen_data_out;
   assign err = err_c0 | err_mem | err_fsm;

endmodule // mem_system

`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:





