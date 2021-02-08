`timescale 1ps/1ps

module neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer1_00003aT0_00003a_00003afunc0_00003aT00_00003a_00003amy__lut_00003aT10( address, base, next__data ); 
   input [3:0] address;
   output signed[7:0] base;
   output reg signed[7:0] next__data;
   reg signed[7:0] lut  [0:15];

   assign base = lut[address];

   always @( * ) begin : _00003a595
      if ((address == 32'd15)) begin : _00003a593
         next__data <= lut[32'd0];
      end
      else begin : _00003a594
         if ((address == {1'b0,{1'b1,1'b1,1'b1}})) begin : _00003a591
            next__data <= lut[address];
         end
         else begin : _00003a592
            next__data <= lut[(address + 32'd1)];
         end
      end
   end   initial begin
      lut[32'd0] = 32'd0;
      lut[32'd1] = 32'd16;
      lut[32'd2] = 32'd32;
      lut[32'd3] = 32'd48;
      lut[32'd4] = 32'd64;
      lut[32'd5] = 32'd80;
      lut[32'd6] = 32'd96;
      lut[32'd7] = 32'd112;
      lut[32'd8] = -32'd128;
      lut[32'd9] = -32'd112;
      lut[32'd10] = -32'd96;
      lut[32'd11] = -32'd80;
      lut[32'd12] = -32'd64;
      lut[32'd13] = -32'd48;
      lut[32'd14] = -32'd32;
      lut[32'd15] = -32'd16;
   end
endmodule