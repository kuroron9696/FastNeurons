`timescale 1ps/1ps

module neural__network_00003aT0_00003a_00003alayer0_00003aT0( clk, rst, req, _00003a15, ack__layer, _00003a13, _00003a14, _00003a55, _00003a56 ); 
   input clk;
   input rst;
   input req;
   input signed[7:0] _00003a15;
   output ack__layer;
   output reg _00003a13;
   output reg [0:0] _00003a14;
   inout signed[7:0] _00003a55;
   inout signed[7:0] _00003a56;
   wire req__mac;
   reg ack;
   reg ack__mac;
   reg ack__add;
   wire signed[7:0] _00003a92;
   reg _00003a90;
   reg [0:0] _00003a91;
   reg signed[7:0] _00003a115;
   reg signed[7:0] _00003a116;
   wire signed[7:0] _00003a107;
   reg _00003a105;
   reg [0:0] _00003a106;
   wire signed[7:0] _00003a156;
   wire _00003a157;
   reg _00003a154;
   reg [0:0] _00003a155;
   reg signed[7:0] _00003a184;
   reg signed[7:0] _00003a185;
   wire signed[7:0] _00003a171;
   wire _00003a172;
   reg _00003a169;
   reg [0:0] _00003a170;
   reg signed[7:0] value__z0;
   reg signed[7:0] value__z1;
   wire signed[7:0] value__a0;
   wire signed[7:0] value__a1;
   reg flag__z0;
   reg flag__z1;
   reg ack__a0;
   reg ack__a1;
   wire channel__w0_00003a83_00003a_00003atrig__r;
   reg signed[7:0] channel__w0_00003a83_00003a_00003adbus__r;
   wire [0:0] channel__w0_00003a83_00003a_00003aabus__r;
   wire signed[7:0] channel__w0_00003a83_00003a_00003amem  :0[0:1];
   wire channel__w1_00003a98_00003a_00003atrig__r;
   reg signed[7:0] channel__w1_00003a98_00003a_00003adbus__r;
   wire [0:0] channel__w1_00003a98_00003a_00003aabus__r;
   wire signed[7:0] channel__w1_00003a98_00003a_00003amem  :0[0:1];
   wire signed[7:0] channel__accum_00003a113_00003a_00003areg__0;
   wire signed[7:0] channel__accum_00003a113_00003a_00003areg__1;
   wire [0:0] channel__accum_00003a113_00003a_00003arinc_00003a125_00003a_00003aabus__r;
   wire [0:0] channel__accum_00003a113_00003a_00003awinc_00003a130_00003a_00003aabus__w;
   wire [0:0] channel__accum_00003a113_00003a_00003ardec_00003a135_00003a_00003aabus__r;
   wire [0:0] channel__accum_00003a113_00003a_00003awdec_00003a140_00003a_00003aabus__w;
   reg signed[7:0] mac__n1_00003a145_00003a_00003alv0;
   reg signed[7:0] mac__n1_00003a145_00003a_00003alv1;
   reg signed[7:0] mac__n1_00003a145_00003a_00003aav0;
   reg signed[7:0] mac__n1_00003a145_00003a_00003aav1;
   reg signed[7:0] mac__n1_00003a145_00003a_00003arv;
   reg mac__n1_00003a145_00003a_00003alvok0;
   reg mac__n1_00003a145_00003a_00003alvok1;
   reg mac__n1_00003a145_00003a_00003arvok;
   reg mac__n1_00003a145_00003a_00003awok0;
   reg mac__n1_00003a145_00003a_00003awok1;
   reg mac__n1_00003a145_00003a_00003arun;
   wire channel__b0_00003a152_00003a_00003atrig__r;
   reg signed[7:0] channel__b0_00003a152_00003a_00003adbus__r;
   wire [0:0] channel__b0_00003a152_00003a_00003aabus__r;
   reg signed[7:0] channel__b0_00003a152_00003a_00003amem  :0[0:0] = $signed(-32'd3);
   wire channel__b1_00003a167_00003a_00003atrig__r;
   reg signed[7:0] channel__b1_00003a167_00003a_00003adbus__r;
   wire [0:0] channel__b1_00003a167_00003a_00003aabus__r;
   reg signed[7:0] channel__b1_00003a167_00003a_00003amem  :0[0:0] = $signed(32'd3);
   wire signed[7:0] channel__z_00003a182_00003a_00003areg__0;
   wire signed[7:0] channel__z_00003a182_00003a_00003areg__1;
   wire [0:0] channel__z_00003a182_00003a_00003arinc_00003a194_00003a_00003aabus__r;
   wire [0:0] channel__z_00003a182_00003a_00003awinc_00003a198_00003a_00003aabus__w;
   wire [0:0] channel__z_00003a182_00003a_00003ardec_00003a202_00003a_00003aabus__r;
   wire [0:0] channel__z_00003a182_00003a_00003awdec_00003a207_00003a_00003aabus__w;
   reg signed[7:0] add__n_00003a212_00003a_00003alv0;
   reg signed[7:0] add__n_00003a212_00003a_00003alv1;
   reg signed[7:0] add__n_00003a212_00003a_00003arv0;
   reg signed[7:0] add__n_00003a212_00003a_00003arv1;
   reg add__n_00003a212_00003a_00003alvok0;
   reg add__n_00003a212_00003a_00003alvok1;
   reg add__n_00003a212_00003a_00003arvok0;
   reg add__n_00003a212_00003a_00003arvok1;
   reg add__n_00003a212_00003a_00003arun;
   wire _00005e_00006095;
   wire _00005e_00006096;
   wire _00005e_00006097;
   wire _00005e_00006098;
   wire signed[7:0] _00005e_00006099;
   wire signed[7:0] _00005e_000060100;
   wire signed[7:0] _00005e_000060101;
   wire signed[7:0] _00005e_000060102;

   neural__network_00003aT0_00003a_00003alayer0_00003aT0_00003a_00003acounter_00003aT1 counter(.clk(_00005e_00006095),.ack(_00005e_00006096),.rst(_00005e_00006097),.ack__mac(_00005e_00006098));
   neural__network_00003aT0_00003a_00003alayer0_00003aT0_00003a_00003afunc0_00003aT1 func0(.z__value(_00005e_00006099),.a(_00005e_000060100));
   neural__network_00003aT0_00003a_00003alayer0_00003aT0_00003a_00003afunc1_00003aT0 func1(.z__value(_00005e_000060101),.a(_00005e_000060102));
   assign req__mac = (req & ~ack__mac);

   assign _00005e_00006095 = clk;

   assign _00005e_00006096 = ack;

   assign _00005e_00006097 = rst;

   assign ack__mac = _00005e_00006098;

   assign _00003a157 = rst;

   assign _00003a172 = rst;

   assign _00005e_00006099 = value__z0;

   assign value__a0 = _00005e_000060100;

   assign _00005e_000060101 = value__z1;

   assign value__a1 = _00005e_000060102;

   assign ack__layer = (ack__a0 & ack__a1);

   assign _00003a92 = channel__w0_00003a83_00003a_00003adbus__r;

   assign _00003a90 = channel__w0_00003a83_00003a_00003atrig__r;

   assign _00003a91 = channel__w0_00003a83_00003a_00003aabus__r;

   assign _00003a107 = channel__w1_00003a98_00003a_00003adbus__r;

   assign _00003a105 = channel__w1_00003a98_00003a_00003atrig__r;

   assign _00003a106 = channel__w1_00003a98_00003a_00003aabus__r;

   assign _00003a115 = channel__accum_00003a113_00003a_00003areg__0;

   assign _00003a116 = channel__accum_00003a113_00003a_00003areg__1;

   assign _00003a156 = channel__b0_00003a152_00003a_00003adbus__r;

   assign _00003a154 = channel__b0_00003a152_00003a_00003atrig__r;

   assign _00003a155 = channel__b0_00003a152_00003a_00003aabus__r;

   assign _00003a171 = channel__b1_00003a167_00003a_00003adbus__r;

   assign _00003a169 = channel__b1_00003a167_00003a_00003atrig__r;

   assign _00003a170 = channel__b1_00003a167_00003a_00003aabus__r;

   assign _00003a184 = channel__z_00003a182_00003a_00003areg__0;

   assign _00003a185 = channel__z_00003a182_00003a_00003areg__1;

   always @( posedge clk ) begin

      if (rst) begin
         ack <= 32'd0;
         ack__mac <= 32'd0;
         ack__add <= 32'd0;
      end

   end

   always @( posedge clk ) begin

      if (ack__add) begin
         value__z0 <= _00003a184;
         flag__z0 <= 32'd1;
         value__z1 <= _00003a185;
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
         _00003a55 <= value__a0;
         ack__a0 <= 32'd1;
         _00003a56 <= value__a1;
         ack__a1 <= 32'd1;
      end

   end

   always @( negedge clk ) begin

      channel__w0_00003a83_00003a_00003adbus__r <= channel__w0_00003a83_00003a_00003amem[channel__w0_00003a83_00003a_00003aabus__r];

   end

   always @( negedge clk ) begin

      channel__w1_00003a98_00003a_00003adbus__r <= channel__w1_00003a98_00003a_00003amem[channel__w1_00003a98_00003a_00003aabus__r];

   end

   always @( posedge clk ) begin

      if ((rst == 32'd1)) begin
         _00003a106 <= -32'd1;
      end

      _00003a105 <= 32'd0;

      if ((rst == 32'd1)) begin
         _00003a91 <= -32'd1;
      end

      _00003a90 <= 32'd0;

      if ((rst == 32'd1)) begin
         _00003a14 <= -32'd1;
      end

      _00003a13 <= 32'd0;

      ack <= 32'd0;

      mac__n1_00003a145_00003a_00003arun <= 32'd0;

      if (~mac__n1_00003a145_00003a_00003arun) begin
         mac__n1_00003a145_00003a_00003arvok <= 32'd0;
         mac__n1_00003a145_00003a_00003alvok0 <= 32'd0;
         mac__n1_00003a145_00003a_00003awok0 <= 32'd0;
         mac__n1_00003a145_00003a_00003alvok1 <= 32'd0;
         mac__n1_00003a145_00003a_00003awok1 <= 32'd0;
      end

      if ((req__mac | mac__n1_00003a145_00003a_00003arun)) begin
         mac__n1_00003a145_00003a_00003arun <= 32'd1;
         if (~mac__n1_00003a145_00003a_00003arvok) begin
            if ((rst == 32'd0)) begin
               if ((_00003a13 == 32'd1)) begin
                  mac__n1_00003a145_00003a_00003arv <= _00003a15;
                  mac__n1_00003a145_00003a_00003arvok <= 32'd1;
               end
               else begin
                  _00003a14 <= ((_00003a14 + 32'd1) == 32'd2) == 1 ? (_00003a14 + 32'd1) : 32'd0;
                  _00003a13 <= 32'd1;
               end
            end
         end
         if (~mac__n1_00003a145_00003a_00003alvok0) begin
            if ((rst == 32'd0)) begin
               if ((_00003a90 == 32'd1)) begin
                  mac__n1_00003a145_00003a_00003alv0 <= _00003a92;
                  mac__n1_00003a145_00003a_00003alvok0 <= 32'd1;
               end
               else begin
                  _00003a91 <= ((_00003a91 + 32'd1) == 32'd2) == 1 ? (_00003a91 + 32'd1) : 32'd0;
                  _00003a90 <= 32'd1;
               end
            end
         end
         if (((mac__n1_00003a145_00003a_00003alvok0 & mac__n1_00003a145_00003a_00003arvok) & ~mac__n1_00003a145_00003a_00003awok0)) begin
            ack <= 32'd1;
            mac__n1_00003a145_00003a_00003arun <= 32'd0;
            mac__n1_00003a145_00003a_00003aav0 <= (mac__n1_00003a145_00003a_00003aav0 + (($signed(mac__n1_00003a145_00003a_00003alv0) * mac__n1_00003a145_00003a_00003arv) >> 32'd4));
            _00003a115 <= ((mac__n1_00003a145_00003a_00003aav0 + (($signed(mac__n1_00003a145_00003a_00003alv0) * mac__n1_00003a145_00003a_00003arv) >> 32'd4)) + (($signed(mac__n1_00003a145_00003a_00003alv0) * mac__n1_00003a145_00003a_00003arv) >> 32'd4));
            mac__n1_00003a145_00003a_00003awok0 <= 32'd1;
         end
         if ((mac__n1_00003a145_00003a_00003awok0 & mac__n1_00003a145_00003a_00003awok1)) begin
            mac__n1_00003a145_00003a_00003awok0 <= 32'd0;
            mac__n1_00003a145_00003a_00003awok1 <= 32'd0;
            mac__n1_00003a145_00003a_00003alvok0 <= 32'd0;
            mac__n1_00003a145_00003a_00003alvok1 <= 32'd0;
            mac__n1_00003a145_00003a_00003arvok <= 32'd0;
         end
         if (~mac__n1_00003a145_00003a_00003alvok1) begin
            if ((rst == 32'd0)) begin
               if ((_00003a105 == 32'd1)) begin
                  mac__n1_00003a145_00003a_00003alv1 <= _00003a107;
                  mac__n1_00003a145_00003a_00003alvok1 <= 32'd1;
               end
               else begin
                  _00003a106 <= ((_00003a106 + 32'd1) == 32'd2) == 1 ? (_00003a106 + 32'd1) : 32'd0;
                  _00003a105 <= 32'd1;
               end
            end
         end
         if (((mac__n1_00003a145_00003a_00003alvok1 & mac__n1_00003a145_00003a_00003arvok) & ~mac__n1_00003a145_00003a_00003awok1)) begin
            ack <= 32'd1;
            mac__n1_00003a145_00003a_00003arun <= 32'd0;
            mac__n1_00003a145_00003a_00003aav1 <= (mac__n1_00003a145_00003a_00003aav1 + (($signed(mac__n1_00003a145_00003a_00003alv1) * mac__n1_00003a145_00003a_00003arv) >> 32'd4));
            _00003a116 <= ((mac__n1_00003a145_00003a_00003aav1 + (($signed(mac__n1_00003a145_00003a_00003alv1) * mac__n1_00003a145_00003a_00003arv) >> 32'd4)) + (($signed(mac__n1_00003a145_00003a_00003alv1) * mac__n1_00003a145_00003a_00003arv) >> 32'd4));
            mac__n1_00003a145_00003a_00003awok1 <= 32'd1;
         end
         if ((mac__n1_00003a145_00003a_00003awok0 & mac__n1_00003a145_00003a_00003awok1)) begin
            mac__n1_00003a145_00003a_00003awok0 <= 32'd0;
            mac__n1_00003a145_00003a_00003awok1 <= 32'd0;
            mac__n1_00003a145_00003a_00003alvok0 <= 32'd0;
            mac__n1_00003a145_00003a_00003alvok1 <= 32'd0;
            mac__n1_00003a145_00003a_00003arvok <= 32'd0;
         end
      end
      else begin
         mac__n1_00003a145_00003a_00003aav0 <= 32'd0;
         mac__n1_00003a145_00003a_00003aav1 <= 32'd0;
      end

   end

   always @( negedge clk ) begin

      channel__b0_00003a152_00003a_00003adbus__r <= channel__b0_00003a152_00003a_00003amem[channel__b0_00003a152_00003a_00003aabus__r];

   end

   always @( negedge clk ) begin

      channel__b1_00003a167_00003a_00003adbus__r <= channel__b1_00003a167_00003a_00003amem[channel__b1_00003a167_00003a_00003aabus__r];

   end

   always @( posedge clk ) begin

      _00003a169 <= 32'd0;

      _00003a154 <= 32'd0;

      ack__add <= 32'd0;

      add__n_00003a212_00003a_00003arun <= 32'd0;

      if ((ack__mac | add__n_00003a212_00003a_00003arun)) begin
         add__n_00003a212_00003a_00003arun <= 32'd1;
         add__n_00003a212_00003a_00003alv0 <= _00003a115;
         add__n_00003a212_00003a_00003alvok0 <= 32'd1;
         if ((_00003a157 == 32'd0)) begin
            if ((_00003a154 == 32'd1)) begin
               add__n_00003a212_00003a_00003arv0 <= _00003a156;
               _00003a154 <= 32'd0;
               add__n_00003a212_00003a_00003arvok0 <= 32'd1;
            end
            else begin
               _00003a155 <= 32'd0;
               _00003a154 <= 32'd1;
            end
         end
         if ((add__n_00003a212_00003a_00003alvok0 & add__n_00003a212_00003a_00003arvok0)) begin
            add__n_00003a212_00003a_00003arun <= 32'd0;
            ack__add <= 32'd1;
            _00003a184 <= (add__n_00003a212_00003a_00003alv0 + add__n_00003a212_00003a_00003arv0);
         end
         add__n_00003a212_00003a_00003alv1 <= _00003a116;
         add__n_00003a212_00003a_00003alvok1 <= 32'd1;
         if ((_00003a172 == 32'd0)) begin
            if ((_00003a169 == 32'd1)) begin
               add__n_00003a212_00003a_00003arv1 <= _00003a171;
               _00003a169 <= 32'd0;
               add__n_00003a212_00003a_00003arvok1 <= 32'd1;
            end
            else begin
               _00003a170 <= 32'd0;
               _00003a169 <= 32'd1;
            end
         end
         if ((add__n_00003a212_00003a_00003alvok1 & add__n_00003a212_00003a_00003arvok1)) begin
            add__n_00003a212_00003a_00003arun <= 32'd0;
            ack__add <= 32'd1;
            _00003a185 <= (add__n_00003a212_00003a_00003alv1 + add__n_00003a212_00003a_00003arv1);
         end
      end
      else begin
         add__n_00003a212_00003a_00003alvok0 <= 32'd0;
         add__n_00003a212_00003a_00003arvok0 <= 32'd0;
         add__n_00003a212_00003a_00003alvok1 <= 32'd0;
         add__n_00003a212_00003a_00003arvok1 <= 32'd0;
      end

   end

   initial begin

      channel__w0_00003a83_00003a_00003amem[32'd0] = $signed(32'd3);

      channel__w0_00003a83_00003a_00003amem[32'd1] = $signed(32'd1);

      channel__w1_00003a98_00003a_00003amem[32'd0] = $signed(32'd14);

      channel__w1_00003a98_00003a_00003amem[32'd1] = $signed(32'd0);

   end

endmodule