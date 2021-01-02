`timescale 1ps/1ps

module neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0_00003a_00003afunc1_00003aT0_00003a_00003amy__interpolator_00003aT00( base, next__data, change, remaining, interpolated__value ); 
   input signed[7:0] base;
   input signed[7:0] next__data;
   input signed[7:0] change;
   input signed[7:0] remaining;
   output signed[7:0] interpolated__value;

   assign interpolated__value = (base + (($signed({{4{(next__data - base)[7]}},(next__data - base)}) * remaining) >> 32'd4));

endmodule