/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
// D-flipflop
`default_nettype none
module dff_inst (q, d, clk, rst);

    output wire [15:0]       q;
    input wire   [15:0]      d;
    input wire         clk;
    input wire         rst;

    reg        [15:0]    state;

    assign #(1) q = state;

    always @(posedge clk) begin
      state = rst? 16'h0800 : d;
    end
endmodule
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
