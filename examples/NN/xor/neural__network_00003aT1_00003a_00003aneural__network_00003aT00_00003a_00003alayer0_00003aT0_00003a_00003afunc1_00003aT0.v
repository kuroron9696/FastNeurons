`timescale 1ps/1ps

module neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0_00003a_00003afunc1_00003aT0( z__value, a ); 
   input signed[7:0] z__value;
   output signed[7:0] a;
   wire signed[7:0] base;
   wire signed[7:0] next__data;
   wire [3:0] address;
   wire signed[7:0] remaining;
   wire signed[7:0] change;
   wire [3:0] _00005e_000060542;
   wire signed[7:0] _00005e_000060543;
   wire signed[7:0] _00005e_000060544;
   wire signed[7:0] _00005e_000060545;
   wire signed[7:0] _00005e_000060546;
   wire signed[7:0] _00005e_000060547;
   wire signed[7:0] _00005e_000060548;
   wire signed[7:0] _00005e_000060549;

   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0_00003a_00003afunc1_00003aT0_00003a_00003amy__lut_00003aT00 my__lut(.address(_00005e_000060542),.base(_00005e_000060543),.next__data(_00005e_000060544));
   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0_00003a_00003afunc1_00003aT0_00003a_00003amy__interpolator_00003aT00 my__interpolator(.base(_00005e_000060545),.next__data(_00005e_000060546),.change(_00005e_000060547),.remaining(_00005e_000060548),.interpolated__value(_00005e_000060549));
   assign address = z__value[7:4];

   assign remaining = {{1'b0,1'b0,1'b0,1'b0},z__value[3:0]};

   assign change = {{1'b0,1'b0,1'b0},1'b1,{1'b0,1'b0,1'b0,1'b0}};

   assign _00005e_000060542 = address;

   assign base = _00005e_000060543;

   assign next__data = _00005e_000060544;

   assign _00005e_000060545 = base;

   assign _00005e_000060546 = next__data;

   assign _00005e_000060547 = change;

   assign _00005e_000060548 = remaining;

   assign a = _00005e_000060549;

endmodule