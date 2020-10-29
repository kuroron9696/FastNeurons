`timescale 1ps/1ps

module neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer1_00003aT0_00003a_00003afunc0_00003aT00( z__value, a ); 
   input signed[7:0] z__value;
   output signed[7:0] a;
   wire signed[7:0] base;
   wire signed[7:0] next__data;
   wire [3:0] address;
   wire signed[7:0] remaining;
   wire signed[7:0] change;
   wire [3:0] _00005e_000060540;
   wire signed[7:0] _00005e_000060541;
   wire signed[7:0] _00005e_000060542;
   wire signed[7:0] _00005e_000060543;
   wire signed[7:0] _00005e_000060544;
   wire signed[7:0] _00005e_000060545;
   wire signed[7:0] _00005e_000060546;
   wire signed[7:0] _00005e_000060547;

   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer1_00003aT0_00003a_00003afunc0_00003aT00_00003a_00003amy__lut_00003aT10 my__lut(.address(_00005e_000060540),.base(_00005e_000060541),.next__data(_00005e_000060542));
   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer1_00003aT0_00003a_00003afunc0_00003aT00_00003a_00003amy__interpolator_00003aT10 my__interpolator(.base(_00005e_000060543),.next__data(_00005e_000060544),.change(_00005e_000060545),.remaining(_00005e_000060546),.interpolated__value(_00005e_000060547));
   assign address = z__value[7:4];

   assign remaining = {{1'b0,1'b0,1'b0,1'b0},z__value[3:0]};

   assign change = {{1'b0,1'b0,1'b0},1'b1,{1'b0,1'b0,1'b0,1'b0}};

   assign _00005e_000060540 = address;

   assign base = _00005e_000060541;

   assign next__data = _00005e_000060542;

   assign _00005e_000060543 = base;

   assign _00005e_000060544 = next__data;

   assign _00005e_000060545 = change;

   assign _00005e_000060546 = remaining;

   assign a = _00005e_000060547;

endmodule