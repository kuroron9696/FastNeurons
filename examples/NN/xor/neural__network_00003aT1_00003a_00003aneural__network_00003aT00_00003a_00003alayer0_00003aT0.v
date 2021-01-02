`timescale 1ps/1ps

module neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0( clk, rst, req, _00003a59, ack__layer, _00003a57, _00003a58, _00003a99, _00003a100 ); 
   input clk;
   input rst;
   input req;
   input signed[7:0] _00003a59;
   output ack__layer;
   output reg _00003a57;
   output reg [0:0] _00003a58;
   inout signed[7:0] _00003a99;
   inout signed[7:0] _00003a100;
   wire req__mac;
   reg ack;
   reg ack__mac;
   reg ack__add;
   wire signed[7:0] _00003a136;
   reg _00003a134;
   reg [0:0] _00003a135;
   reg signed[7:0] _00003a159;
   reg signed[7:0] _00003a160;
   wire signed[7:0] _00003a151;
   reg _00003a149;
   reg [0:0] _00003a150;
   wire signed[7:0] _00003a200;
   wire _00003a201;
   reg _00003a198;
   reg [0:0] _00003a199;
   reg signed[7:0] _00003a228;
   reg signed[7:0] _00003a229;
   wire signed[7:0] _00003a215;
   wire _00003a216;
   reg _00003a213;
   reg [0:0] _00003a214;
   reg signed[7:0] value__z0;
   reg signed[7:0] value__z1;
   wire signed[7:0] value__a0;
   wire signed[7:0] value__a1;
   reg flag__z0;
   reg flag__z1;
   reg ack__a0;
   reg ack__a1;
   wire channel__w0_00003a127_00003a_00003atrig__r;
   reg signed[7:0] channel__w0_00003a127_00003a_00003adbus__r;
   wire [0:0] channel__w0_00003a127_00003a_00003aabus__r;
   reg signed[7:0] channel__w0_00003a127_00003a_00003amem  [0:1];
   wire channel__w1_00003a142_00003a_00003atrig__r;
   reg signed[7:0] channel__w1_00003a142_00003a_00003adbus__r;
   wire [0:0] channel__w1_00003a142_00003a_00003aabus__r;
   reg signed[7:0] channel__w1_00003a142_00003a_00003amem  [0:1];
   wire signed[7:0] channel__accum_00003a157_00003a_00003areg__0;
   wire signed[7:0] channel__accum_00003a157_00003a_00003areg__1;
   wire [0:0] channel__accum_00003a157_00003a_00003arinc_00003a169_00003a_00003aabus__r;
   wire [0:0] channel__accum_00003a157_00003a_00003awinc_00003a174_00003a_00003aabus__w;
   wire [0:0] channel__accum_00003a157_00003a_00003ardec_00003a179_00003a_00003aabus__r;
   wire [0:0] channel__accum_00003a157_00003a_00003awdec_00003a184_00003a_00003aabus__w;
   reg signed[7:0] mac__n1_00003a189_00003a_00003alv0;
   reg signed[7:0] mac__n1_00003a189_00003a_00003alv1;
   reg signed[7:0] mac__n1_00003a189_00003a_00003aav0;
   reg signed[7:0] mac__n1_00003a189_00003a_00003aav1;
   reg signed[7:0] mac__n1_00003a189_00003a_00003arv;
   reg mac__n1_00003a189_00003a_00003alvok0;
   reg mac__n1_00003a189_00003a_00003alvok1;
   reg mac__n1_00003a189_00003a_00003arvok;
   reg mac__n1_00003a189_00003a_00003awok0;
   reg mac__n1_00003a189_00003a_00003awok1;
   reg mac__n1_00003a189_00003a_00003arun;
   wire channel__b0_00003a196_00003a_00003atrig__r;
   reg signed[7:0] channel__b0_00003a196_00003a_00003adbus__r;
   wire [0:0] channel__b0_00003a196_00003a_00003aabus__r;
   reg signed[7:0] channel__b0_00003a196_00003a_00003amem  [0:0] = 32'd0;
   wire channel__b1_00003a211_00003a_00003atrig__r;
   reg signed[7:0] channel__b1_00003a211_00003a_00003adbus__r;
   wire [0:0] channel__b1_00003a211_00003a_00003aabus__r;
   reg signed[7:0] channel__b1_00003a211_00003a_00003amem  [0:0] = 32'd0;
   wire signed[7:0] channel__z_00003a226_00003a_00003areg__0;
   wire signed[7:0] channel__z_00003a226_00003a_00003areg__1;
   wire [0:0] channel__z_00003a226_00003a_00003arinc_00003a238_00003a_00003aabus__r;
   wire [0:0] channel__z_00003a226_00003a_00003awinc_00003a242_00003a_00003aabus__w;
   wire [0:0] channel__z_00003a226_00003a_00003ardec_00003a246_00003a_00003aabus__r;
   wire [0:0] channel__z_00003a226_00003a_00003awdec_00003a251_00003a_00003aabus__w;
   reg signed[7:0] add__n_00003a256_00003a_00003alv0;
   reg signed[7:0] add__n_00003a256_00003a_00003alv1;
   reg signed[7:0] add__n_00003a256_00003a_00003arv0;
   reg signed[7:0] add__n_00003a256_00003a_00003arv1;
   reg add__n_00003a256_00003a_00003alvok0;
   reg add__n_00003a256_00003a_00003alvok1;
   reg add__n_00003a256_00003a_00003arvok0;
   reg add__n_00003a256_00003a_00003arvok1;
   reg add__n_00003a256_00003a_00003arun;
   wire _00005e_000060212;
   wire _00005e_000060213;
   wire _00005e_000060214;
   wire _00005e_000060215;
   wire signed[7:0] _00005e_000060216;
   wire signed[7:0] _00005e_000060217;
   wire signed[7:0] _00005e_000060218;
   wire signed[7:0] _00005e_000060219;

   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0_00003a_00003acounter_00003aT1 counter(.clk(_00005e_000060212),.ack(_00005e_000060213),.rst(_00005e_000060214),.ack__mac(_00005e_000060215));
   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0_00003a_00003afunc0_00003aT1 func0(.z__value(_00005e_000060216),.a(_00005e_000060217));
   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0_00003a_00003afunc1_00003aT0 func1(.z__value(_00005e_000060218),.a(_00005e_000060219));
   assign req__mac = (req & ~ack__mac);

   assign _00005e_000060212 = clk;

   assign _00005e_000060213 = ack;

   assign _00005e_000060214 = rst;

   assign ack__mac = _00005e_000060215;

   assign _00003a201 = rst;

   assign _00003a216 = rst;

   assign _00005e_000060216 = value__z0;

   assign value__a0 = _00005e_000060217;

   assign _00005e_000060218 = value__z1;

   assign value__a1 = _00005e_000060219;

   assign ack__layer = (ack__a0 & ack__a1);

   assign _00003a136 = channel__w0_00003a127_00003a_00003adbus__r;

   assign _00003a134 = channel__w0_00003a127_00003a_00003atrig__r;

   assign _00003a135 = channel__w0_00003a127_00003a_00003aabus__r;

   assign _00003a151 = channel__w1_00003a142_00003a_00003adbus__r;

   assign _00003a149 = channel__w1_00003a142_00003a_00003atrig__r;

   assign _00003a150 = channel__w1_00003a142_00003a_00003aabus__r;

   assign _00003a159 = channel__accum_00003a157_00003a_00003areg__0;

   assign _00003a160 = channel__accum_00003a157_00003a_00003areg__1;

   assign _00003a200 = channel__b0_00003a196_00003a_00003adbus__r;

   assign _00003a198 = channel__b0_00003a196_00003a_00003atrig__r;

   assign _00003a199 = channel__b0_00003a196_00003a_00003aabus__r;

   assign _00003a215 = channel__b1_00003a211_00003a_00003adbus__r;

   assign _00003a213 = channel__b1_00003a211_00003a_00003atrig__r;

   assign _00003a214 = channel__b1_00003a211_00003a_00003aabus__r;

   assign _00003a228 = channel__z_00003a226_00003a_00003areg__0;

   assign _00003a229 = channel__z_00003a226_00003a_00003areg__1;

   always @( posedge clk ) begin

      if (rst) begin
         ack <= 32'd0;
         ack__mac <= 32'd0;
         ack__add <= 32'd0;
      end

   end

   always @( posedge clk ) begin

      if (ack__add) begin
         value__z0 <= _00003a228;
         flag__z0 <= 32'd1;
         value__z1 <= _00003a229;
         flag__z1 <= 32'd1;
      end
      else begin
         flag__z0 <= 32'd0;
         flag__z1 <= 32'd0;
      end

   end

   always @( posedge clk ) begin

      if (rst) begin
         ack__a0 <= 32'd0;
         ack__a1 <= 32'd0;
      end
      else if ((flag__z0 & flag__z1)) begin
         _00003a99 <= value__a0;
         ack__a0 <= 32'd1;
         _00003a100 <= value__a1;
         ack__a1 <= 32'd1;
      end

   end

   always @( negedge clk ) begin

      channel__w0_00003a127_00003a_00003adbus__r <= channel__w0_00003a127_00003a_00003amem[channel__w0_00003a127_00003a_00003aabus__r];

   end

   always @( negedge clk ) begin

      channel__w1_00003a142_00003a_00003adbus__r <= channel__w1_00003a142_00003a_00003amem[channel__w1_00003a142_00003a_00003aabus__r];

   end

   always @( posedge clk ) begin

      if ((rst == 32'd1)) begin
         _00003a150 <= -32'd1;
         _00003a149 <= 32'd0;
      end

      if ((rst == 32'd1)) begin
         _00003a135 <= -32'd1;
         _00003a134 <= 32'd0;
      end

      if ((rst == 32'd1)) begin
         _00003a58 <= -32'd1;
      end

      _00003a57 <= 32'd0;

      ack <= 32'd0;

      mac__n1_00003a189_00003a_00003arun <= 32'd0;

      if (~mac__n1_00003a189_00003a_00003arun) begin
         mac__n1_00003a189_00003a_00003arvok <= 32'd0;
         mac__n1_00003a189_00003a_00003alvok0 <= 32'd0;
         mac__n1_00003a189_00003a_00003awok0 <= 32'd0;
         mac__n1_00003a189_00003a_00003alvok1 <= 32'd0;
         mac__n1_00003a189_00003a_00003awok1 <= 32'd0;
      end

      if ((req__mac | mac__n1_00003a189_00003a_00003arun)) begin
         mac__n1_00003a189_00003a_00003arun <= 32'd1;
         if (~mac__n1_00003a189_00003a_00003arvok) begin
            if ((rst == 32'd0)) begin
               if ((_00003a57 == 32'd1)) begin
                  mac__n1_00003a189_00003a_00003arv <= _00003a59;
                  mac__n1_00003a189_00003a_00003arvok <= 32'd1;
               end
               else begin
                  _00003a58 <= ((_00003a58 + 32'd1) == 32'd2) == 1 ? (_00003a58 + 32'd1) : 32'd0;
                  _00003a57 <= 32'd1;
               end
            end
         end
         if (~mac__n1_00003a189_00003a_00003alvok0) begin
            if ((rst == 32'd0)) begin
               if ((_00003a134 == 32'd1)) begin
                  _00003a134 <= 32'd0;
                  mac__n1_00003a189_00003a_00003alv0 <= _00003a136;
                  mac__n1_00003a189_00003a_00003alvok0 <= 32'd1;
               end
               else begin
                  _00003a135 <= ((_00003a135 + 32'd1) == 32'd2) == 1 ? (_00003a135 + 32'd1) : 32'd0;
                  _00003a134 <= 32'd1;
               end
            end
         end
         if (((mac__n1_00003a189_00003a_00003alvok0 & mac__n1_00003a189_00003a_00003arvok) & ~mac__n1_00003a189_00003a_00003awok0)) begin
            ack <= 32'd1;
            mac__n1_00003a189_00003a_00003arun <= 32'd0;
            mac__n1_00003a189_00003a_00003aav0 <= (mac__n1_00003a189_00003a_00003aav0 + (($signed({{4{mac__n1_00003a189_00003a_00003alv0[7]}},mac__n1_00003a189_00003a_00003alv0}) * mac__n1_00003a189_00003a_00003arv) >> 32'd4));
            _00003a159 <= ((mac__n1_00003a189_00003a_00003aav0 + (($signed({{4{mac__n1_00003a189_00003a_00003alv0[7]}},mac__n1_00003a189_00003a_00003alv0}) * mac__n1_00003a189_00003a_00003arv) >> 32'd4)) + (($signed({{4{mac__n1_00003a189_00003a_00003alv0[7]}},mac__n1_00003a189_00003a_00003alv0}) * mac__n1_00003a189_00003a_00003arv) >> 32'd4));
            mac__n1_00003a189_00003a_00003awok0 <= 32'd1;
         end
         if ((mac__n1_00003a189_00003a_00003awok0 & mac__n1_00003a189_00003a_00003awok1)) begin
            mac__n1_00003a189_00003a_00003awok0 <= 32'd0;
            mac__n1_00003a189_00003a_00003awok1 <= 32'd0;
            mac__n1_00003a189_00003a_00003alvok0 <= 32'd0;
            mac__n1_00003a189_00003a_00003alvok1 <= 32'd0;
            mac__n1_00003a189_00003a_00003arvok <= 32'd0;
         end
         if (~mac__n1_00003a189_00003a_00003alvok1) begin
            if ((rst == 32'd0)) begin
               if ((_00003a149 == 32'd1)) begin
                  _00003a149 <= 32'd0;
                  mac__n1_00003a189_00003a_00003alv1 <= _00003a151;
                  mac__n1_00003a189_00003a_00003alvok1 <= 32'd1;
               end
               else begin
                  _00003a150 <= ((_00003a150 + 32'd1) == 32'd2) == 1 ? (_00003a150 + 32'd1) : 32'd0;
                  _00003a149 <= 32'd1;
               end
            end
         end
         if (((mac__n1_00003a189_00003a_00003alvok1 & mac__n1_00003a189_00003a_00003arvok) & ~mac__n1_00003a189_00003a_00003awok1)) begin
            ack <= 32'd1;
            mac__n1_00003a189_00003a_00003arun <= 32'd0;
            mac__n1_00003a189_00003a_00003aav1 <= (mac__n1_00003a189_00003a_00003aav1 + (($signed({{4{mac__n1_00003a189_00003a_00003alv1[7]}},mac__n1_00003a189_00003a_00003alv1}) * mac__n1_00003a189_00003a_00003arv) >> 32'd4));
            _00003a160 <= ((mac__n1_00003a189_00003a_00003aav1 + (($signed({{4{mac__n1_00003a189_00003a_00003alv1[7]}},mac__n1_00003a189_00003a_00003alv1}) * mac__n1_00003a189_00003a_00003arv) >> 32'd4)) + (($signed({{4{mac__n1_00003a189_00003a_00003alv1[7]}},mac__n1_00003a189_00003a_00003alv1}) * mac__n1_00003a189_00003a_00003arv) >> 32'd4));
            mac__n1_00003a189_00003a_00003awok1 <= 32'd1;
         end
         if ((mac__n1_00003a189_00003a_00003awok0 & mac__n1_00003a189_00003a_00003awok1)) begin
            mac__n1_00003a189_00003a_00003awok0 <= 32'd0;
            mac__n1_00003a189_00003a_00003awok1 <= 32'd0;
            mac__n1_00003a189_00003a_00003alvok0 <= 32'd0;
            mac__n1_00003a189_00003a_00003alvok1 <= 32'd0;
            mac__n1_00003a189_00003a_00003arvok <= 32'd0;
         end
      end
      else begin
         mac__n1_00003a189_00003a_00003aav0 <= 32'd0;
         mac__n1_00003a189_00003a_00003aav1 <= 32'd0;
      end

   end

   always @( negedge clk ) begin

      channel__b0_00003a196_00003a_00003adbus__r <= channel__b0_00003a196_00003a_00003amem[channel__b0_00003a196_00003a_00003aabus__r];

   end

   always @( negedge clk ) begin

      channel__b1_00003a211_00003a_00003adbus__r <= channel__b1_00003a211_00003a_00003amem[channel__b1_00003a211_00003a_00003aabus__r];

   end

   always @( posedge clk ) begin

      _00003a213 <= 32'd0;

      _00003a198 <= 32'd0;

      ack__add <= 32'd0;

      add__n_00003a256_00003a_00003arun <= 32'd0;

      if ((ack__mac | add__n_00003a256_00003a_00003arun)) begin
         add__n_00003a256_00003a_00003arun <= 32'd1;
         add__n_00003a256_00003a_00003alv0 <= _00003a159;
         add__n_00003a256_00003a_00003alvok0 <= 32'd1;
         if ((_00003a201 == 32'd0)) begin
            if ((_00003a198 == 32'd1)) begin
               add__n_00003a256_00003a_00003arv0 <= _00003a200;
               _00003a198 <= 32'd0;
               add__n_00003a256_00003a_00003arvok0 <= 32'd1;
            end
            else begin
               _00003a199 <= 32'd0;
               _00003a198 <= 32'd1;
            end
         end
         if ((add__n_00003a256_00003a_00003alvok0 & add__n_00003a256_00003a_00003arvok0)) begin
            add__n_00003a256_00003a_00003arun <= 32'd0;
            ack__add <= 32'd1;
            _00003a228 <= (add__n_00003a256_00003a_00003alv0 + add__n_00003a256_00003a_00003arv0);
         end
         add__n_00003a256_00003a_00003alv1 <= _00003a160;
         add__n_00003a256_00003a_00003alvok1 <= 32'd1;
         if ((_00003a216 == 32'd0)) begin
            if ((_00003a213 == 32'd1)) begin
               add__n_00003a256_00003a_00003arv1 <= _00003a215;
               _00003a213 <= 32'd0;
               add__n_00003a256_00003a_00003arvok1 <= 32'd1;
            end
            else begin
               _00003a214 <= 32'd0;
               _00003a213 <= 32'd1;
            end
         end
         if ((add__n_00003a256_00003a_00003alvok1 & add__n_00003a256_00003a_00003arvok1)) begin
            add__n_00003a256_00003a_00003arun <= 32'd0;
            ack__add <= 32'd1;
            _00003a229 <= (add__n_00003a256_00003a_00003alv1 + add__n_00003a256_00003a_00003arv1);
         end
      end
      else begin
         add__n_00003a256_00003a_00003alvok0 <= 32'd0;
         add__n_00003a256_00003a_00003arvok0 <= 32'd0;
         add__n_00003a256_00003a_00003alvok1 <= 32'd0;
         add__n_00003a256_00003a_00003arvok1 <= 32'd0;
      end

   end

   initial begin

      channel__w0_00003a127_00003a_00003amem[32'd0] = -32'd12;

      channel__w0_00003a127_00003a_00003amem[32'd1] = 32'd12;

      channel__w1_00003a142_00003a_00003amem[32'd0] = 32'd17;

      channel__w1_00003a142_00003a_00003amem[32'd1] = -32'd17;

   end

endmodule