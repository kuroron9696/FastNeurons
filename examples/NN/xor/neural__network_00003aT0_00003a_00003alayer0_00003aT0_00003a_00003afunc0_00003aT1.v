`timescale 1ps/1ps

module neural__network_00003aT0_00003a_00003alayer0_00003aT0_00003a_00003afunc0_00003aT1( z__value, a ); 
   input signed[7:0] z__value;
   output signed[7:0] a;
   wire signed[7:0] base;
   wire signed[7:0] next__data;
   wire [3:0] address;
   wire signed[7:0] remaining;
   wire [3:0] _00005e_000060415;
   wire signed[7:0] _00005e_000060416;
   wire signed[7:0] _00005e_000060417;
   wire signed[7:0] _00005e_000060418;
   wire signed[7:0] _00005e_000060419;
   wire signed[7:0] _00005e_000060420;
   wire signed[7:0] _00005e_000060421;

   neural__network_00003aT0_00003a_00003alayer0_00003aT0_00003a_00003afunc0_00003aT1_00003a_00003amy__lut_00003aT2 my__lut(.address(_00005e_000060415),.base(_00005e_000060416),.next__data(_00005e_000060417));
   neural__network_00003aT0_00003a_00003alayer0_00003aT0_00003a_00003afunc0_00003aT1_00003a_00003amy__interpolator_00003aT2 my__interpolator(.remaining(_00005e_000060418),.base(_00005e_000060419),.next__data(_00005e_000060420),.interpolated__value(_00005e_000060421));
   assign address = z__value[7:4];

   assign remaining = {{1'b0,1'b0,1'b0,1'b0},z__value[3:0]};

   assign _00005e_000060415 = address;

   assign base = _00005e_000060416;

   assign next__data = _00005e_000060417;

   assign _00005e_000060418 = remaining;

   assign _00005e_000060419 = base;

   assign _00005e_000060420 = next__data;

   assign a = _00005e_000060421;

endmodule