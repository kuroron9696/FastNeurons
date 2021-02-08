`timescale 1ps/1ps

module neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0_00003a_00003acounter_00003aT1( clk, ack, rst, ack__mac ); 
   input clk;
   input ack;
   input rst;
   output reg ack__mac;
   reg [1:0] q;

   always @( negedge clk ) begin : _00003a526
      if (rst) begin : _00003a524
         q <= 32'd0;
         ack__mac <= 32'd0;
      end
      else if (ack) begin : _00003a525
         begin : _00003a523
            q = (q + 32'd1);
            if ((q == 32'd2)) begin : _00003a522
               q = 32'd0;
               ack__mac = 32'd1;
            end
         end
      end
   end
endmodule