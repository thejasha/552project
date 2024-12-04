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

   cache #(2 + memtype) c1(
      .tag_out     (c1_tag_out),
      .data_out    (c1_data_out),
      .hit         (c1_hit),
      .dirty       (c1_dirty),
      .valid       (c1_valid),
      .err         (err_c1),
      .enable      (enable_signal),
      .clk         (clk),
      .rst         (rst),
      .createdump  (createdump),
      .tag_in      (Addr[15:11]),
      .index       (Addr[10:3]),
      .offset      (offset_signal),
      .data_in     (cache_data_in),
      .comp        (comp_signal),
      .write       (c1_write_signal),
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
   assign cache_hit = c0_hit | c1_hit;

   // Determine which way to select. If a hit occurs, choose the hitting way.
   // If no hit, choose based on victim selection logic.
   assign selected_way = ((c0_valid & c0_hit) | (c1_valid & c1_hit)) ? (c1_valid & c1_hit) : victim_line_sel;

   // Choose dirty, valid, tag_out, data_out based on selected way
   assign chosen_dirty    = selected_way ? c1_dirty : c0_dirty;
   assign chosen_valid    = selected_way ? c1_valid : c0_valid;
   assign chosen_tag_out  = selected_way ? c1_tag_out : c0_tag_out;
   assign chosen_data_out = selected_way ? c1_data_out : c0_data_out;

   // Write signals: only one way can be written at a time
   assign c0_write_signal = selected_way ? 1'b0 : write_signal;
   assign c1_write_signal = selected_way ? write_signal : 1'b0;

   // Victimway register for pseudo-random replacement
   dff victimway_reg(
      .q    (victimway_out),
      .d    (victimway_in),
      .clk  (clk),
      .rst  (rst)
   );

   // Invert victimway_out on each done cycle
   assign victimway_in = Done ? ~victimway_out : victimway_out;

   // Victim selection logic:
   // If both ways valid, use victimway_out; if one invalid, choose that one.
   // If both invalid, choose way zero.
   assign victim_line_sel = (c0_valid & c1_valid) ? ~victimway_out : c0_valid;

   // Data input to cache
   // On allocation (comp=0 and write=1), data from mem; on compare, data from CPU
   assign cache_data_in = (write_signal & ~comp_signal) ? m_data_out : DataIn;

   assign DataOut = chosen_data_out;
   assign err = err_c0 | err_c1 | err_mem | err_fsm;

endmodule // mem_system

`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:



module cache_FSM(
   // Outputs
   Done, Stall, CacheHit, err,
   enable, offset, comp, write, valid_in,
   addr, wr, rd,
   // Inputs
   Rd, Wr, tag_in, index, offset_in, clk, rst,
   hit, dirty, valid, tag_out, stall
);
   input        Rd, Wr, clk, rst, hit, dirty, valid, stall;
   input  [4:0] tag_in;
   input  [7:0] index;
   input  [2:0] offset_in;
   input  [4:0] tag_out;

   output reg        Done;
   output reg        Stall;
   output reg        CacheHit;
   output reg        err;
   output reg        enable;
   output reg [2:0]  offset;
   output reg        comp;
   output reg        write;
   output reg        valid_in;
   output reg [15:0] addr;
   output reg        wr;
   output reg        rd;

   // State definitions (unchanged)
   localparam IDLE  = 4'b0000;
   localparam WB0   = 4'b0001;
   localparam WB1   = 4'b0010;
   localparam WB2   = 4'b0011;
   localparam WB3   = 4'b0100;
   localparam ALLO0 = 4'b0101;
   localparam ALLO1 = 4'b0110;
   localparam ALLO2 = 4'b0111;
   localparam ALLO3 = 4'b1000;
   localparam ALLO4 = 4'b1001;
   localparam ALLO5 = 4'b1010;
   localparam COMP  = 4'b1011;
   localparam DONE  = 4'b1100;

   reg [3:0] next_state;
   wire [3:0] curr_state;

   dff state_reg[3:0](
      .q    (curr_state),
      .d    (next_state),
      .clk  (clk),
      .rst  (rst)
   );

   always @(*) begin
      // Default outputs
      Done      = 1'b0;
      Stall     = 1'b1;
      CacheHit  = 1'b0;
      err       = 1'b0;
      enable    = 1'b1;
      offset    = 3'b000;
      comp      = 1'b0;
      write     = 1'b0;
      valid_in  = 1'b0;
      addr      = 16'h0000;
      wr        = 1'b0;
      rd        = 1'b0;
      next_state = curr_state;

      case (curr_state)
         IDLE: begin
            // If request comes in:
            //   If hit&valid: done immediately
            //   If miss&valid&dirty: writeback
            //   Else: allocate
            next_state = (Rd | Wr) ? ((hit & valid) ? IDLE : (~hit & valid & dirty) ? WB0 : ALLO0) : IDLE;
            comp = Rd | Wr;
            offset = offset_in;
            write = Wr;
            Done = (Rd | Wr) & (hit & valid);
            CacheHit = hit & valid;
            Stall = 1'b0;
         end

         WB0: begin
            next_state = stall ? WB0 : WB1;
            wr = 1'b1;
            addr = {tag_out, index, 3'b000};
            offset = 3'b000;
         end

         WB1: begin
            next_state = stall ? WB1 : WB2;
            wr = 1'b1;
            addr = {tag_out, index, 3'b010};
            offset = 3'b010;
         end

         WB2: begin
            next_state = stall ? WB2 : WB3;
            wr = 1'b1;
            addr = {tag_out, index, 3'b100};
            offset = 3'b100;
         end

         WB3: begin
            next_state = stall ? WB3 : ALLO0;
            wr = 1'b1;
            addr = {tag_out, index, 3'b110};
            offset = 3'b110;
         end

         ALLO0: begin
            next_state = stall ? ALLO0 : ALLO1;
            rd = 1'b1;
            addr = {(Rd | Wr) ? tag_in : tag_out, index, 3'b000};
         end

         ALLO1: begin
            next_state = stall ? ALLO1 : ALLO2;
            rd = 1'b1;
            addr = {(Rd | Wr) ? tag_in : tag_out, index, 3'b010};
         end

         ALLO2: begin
            next_state = stall ? ALLO2 : ALLO3;
            write = 1'b1;
            rd = 1'b1;
            addr = {(Rd | Wr) ? tag_in : tag_out, index, 3'b100};
            offset = 3'b000;
         end

         ALLO3: begin
            next_state = stall ? ALLO3 : ALLO4;
            write = 1'b1;
            rd = 1'b1;
            addr = {(Rd | Wr) ? tag_in : tag_out, index, 3'b110};
            offset = 3'b010;
         end

         ALLO4: begin
            next_state = ALLO5;
            write = 1'b1;
            offset = 3'b100;
         end

         ALLO5: begin
            next_state = COMP;
            write = 1'b1;
            valid_in = 1'b1;
            offset = 3'b110;
         end

         COMP: begin
            next_state = DONE;
            comp = 1'b1;
            write = Wr;
            offset = offset_in;
         end

         DONE: begin
            next_state = IDLE;
            Done = 1'b1;
            offset = offset_in;
         end

         default: begin
            err = 1'b1;
         end
      endcase
   end

endmodule

