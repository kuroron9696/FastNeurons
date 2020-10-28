`timescale 1ps/1ps

module neural__network_00003aT0_00003a_00003alayer0_00003aT0_00003a_00003afunc1_00003aT0( z__value, a ); 
   input signed[7:0] z__value;
   output signed[7:0] a;
   wire signed[7:0] base;
   wire signed[7:0] next__data;
   wire [3:0] address;
   wire signed[7:0] remaining;
   wire [3:0] _00005e_000060423;
   wire signed[7:0] _00005e_000060424;
   wire signed[7:0] _00005e_000060425;
   wire signed[7:0] _00005e_000060426;
   wire signed[7:0] _00005e_000060427;
   wire signed[7:0] _00005e_000060428;
   wire signed[7:0] _00005e_000060429;

   neural__network_00003aT0_00003a_00003alayer0_00003aT0_00003a_00003afunc1_00003aT0_00003a_00003amy__lut_00003aT00 my__lut(.address(_00005e_000060423),.base(_00005e_000060424),.next__data(_00005e_000060425));
   neural__network_00003aT0_00003a_00003alayer0_00003aT0_00003a_00003afunc1_00003aT0_00003a_00003amy__interpolator_00003aT00 my__interpolator(.remaining(_00005e_000060426),.base(_00005e_000060427),.next__data(_00005e_000060428),.interpolated__value(_00005e_000060429));
   assign address = z__value[7:4];

   assign remaining = {{1'b0,1'b0,1'b0,1'b0},z__value[3:0]};

   assign _00005e_000060423 = address;

   assign base = _00005e_000060424;

   assign next__data = _00005e_000060425;

   assign _00005e_000060426 = remaining;

   assign _00005e_000060427 = base;

   assign _00005e_000060428 = next__data;

   assign a = _00005e_000060429;

endmodule