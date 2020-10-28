`timescale 1ps/1ps

module neural__network_00003aT0_00003a_00003alayer1_00003aT0( clk, rst, req, _00003a66, _00003a67, ack__layer, _00003a68, _00003a32 ); 
   input clk;
   input rst;
   input req;
   input signed[7:0] _00003a66;
   input signed[7:0] _00003a67;
   output ack__layer;
   inout [0:0] _00003a68;
   inout signed[7:0] _00003a32;
   wire req__mac;
   reg ack;
   reg ack__mac;
   reg ack__add;
   wire signed[7:0] _00003a232;
   reg _00003a230;
   reg [0:0] _00003a231;
   reg signed[7:0] _00003a240;
   wire signed[7:0] _00003a272;
   wire _00003a273;
   reg _00003a270;
   reg [0:0] _00003a271;
   reg signed[7:0] _00003a285;
   reg signed[7:0] value__z0;
   wire signed[7:0] value__a0;
   reg flag__z0;
   reg ack__a0;
   wire channel__w0_00003a223_00003a_00003atrig__r;
   reg signed[7:0] channel__w0_00003a223_00003a_00003adbus__r;
   wire [0:0] channel__w0_00003a223_00003a_00003aabus__r;
   wire signed[7:0] channel__w0_00003a223_00003a_00003amem  :0[0:1];
   wire signed[7:0] channel__accum_00003a238_00003a_00003areg__0;
   wire [0:-1] channel__accum_00003a238_00003a_00003arinc_00003a247_00003a_00003aabus__r;
   wire [0:-1] channel__accum_00003a238_00003a_00003awinc_00003a251_00003a_00003aabus__w;
   wire [0:-1] channel__accum_00003a238_00003a_00003ardec_00003a255_00003a_00003aabus__r;
   wire [0:-1] channel__accum_00003a238_00003a_00003awdec_00003a259_00003a_00003aabus__w;
   reg signed[7:0] mac__n1_00003a263_00003a_00003alv0;
   reg signed[7:0] mac__n1_00003a263_00003a_00003aav0;
   reg signed[7:0] mac__n1_00003a263_00003a_00003arv;
   reg mac__n1_00003a263_00003a_00003alvok0;
   reg mac__n1_00003a263_00003a_00003arvok;
   reg mac__n1_00003a263_00003a_00003awok0;
   reg mac__n1_00003a263_00003a_00003arun;
   wire channel__b0_00003a268_00003a_00003atrig__r;
   reg signed[7:0] channel__b0_00003a268_00003a_00003adbus__r;
   wire [0:0] channel__b0_00003a268_00003a_00003aabus__r;
   reg signed[7:0] channel__b0_00003a268_00003a_00003amem  :0[0:0] = $signed(32'd3);
   wire signed[7:0] channel__z_00003a283_00003a_00003areg__0;
   wire [0:-1] channel__z_00003a283_00003a_00003arinc_00003a292_00003a_00003aabus__r;
   wire [0:-1] channel__z_00003a283_00003a_00003awinc_00003a295_00003a_00003aabus__w;
   wire [0:-1] channel__z_00003a283_00003a_00003ardec_00003a298_00003a_00003aabus__r;
   wire [0:-1] channel__z_00003a283_00003a_00003awdec_00003a302_00003a_00003aabus__w;
   reg signed[7:0] add__n_00003a306_00003a_00003alv0;
   reg signed[7:0] add__n_00003a306_00003a_00003arv0;
   reg add__n_00003a306_00003a_00003alvok0;
   reg add__n_00003a306_00003a_00003arvok0;
   reg add__n_00003a306_00003a_00003arun;
   wire _00005e_00006095;
   wire _00005e_00006096;
   wire _00005e_00006097;
   wire _00005e_00006098;
   wire signed[7:0] _00005e_00006099;
   wire signed[7:0] _00005e_000060100;

   neural__network_00003aT0_00003a_00003alayer1_00003aT0_00003a_00003acounter_00003aT00 counter(.clk(_00005e_00006095),.ack(_00005e_00006096),.rst(_00005e_00006097),.ack__mac(_00005e_00006098));
   neural__network_00003aT0_00003a_00003alayer1_00003aT0_00003a_00003afunc0_00003aT00 func0(.z__value(_00005e_00006099),.a(_00005e_000060100));
   assign req__mac = (req & ~ack__mac);

   assign _00005e_00006095 = clk;

   assign _00005e_00006096 = ack;

   assign _00005e_00006097 = rst;

   assign ack__mac = _00005e_00006098;

   assign _00003a273 = rst;

   assign _00005e_00006099 = value__z0;

   assign value__a0 = _00005e_000060100;

   assign ack__layer = ack__a0;

   assign _00003a232 = channel__w0_00003a223_00003a_00003adbus__r;

   assign _00003a230 = channel__w0_00003a223_00003a_00003atrig__r;

   assign _00003a231 = channel__w0_00003a223_00003a_00003aabus__r;

   assign _00003a240 = channel__accum_00003a238_00003a_00003areg__0;

   assign _00003a272 = channel__b0_00003a268_00003a_00003adbus__r;

   assign _00003a270 = channel__b0_00003a268_00003a_00003atrig__r;

   assign _00003a271 = channel__b0_00003a268_00003a_00003aabus__r;

   assign _00003a285 = channel__z_00003a283_00003a_00003areg__0;

   always @( posedge clk ) begin

      if (rst) begin
         ack <= 32'd0;
         ack__mac <= 32'd0;
         ack__add <= 32'd0;
      end

   end

   always @( posedge clk ) begin

      if (ack__add) begin
         value__z0 <= _00003a285;
         flag__z0 <= 32'd1;
      end
      else begin
         flag__z0 <= 32'd0;
      end

   end

   always @( posedge clk ) begin

      if (rst) begin
         ack__a0 <= 32'd0;
      end
      else if (flag__z0) begin
         _00003a32 <= value__a0;
         ack__a0 <= 32'd1;
      end

   end

   always @( negedge clk ) begin

      channel__w0_00003a223_00003a_00003adbus__r <= channel__w0_00003a223_00003a_00003amem[channel__w0_00003a223_00003a_00003aabus__r];

   end

   always @( posedge clk ) begin

      if ((rst == 32'd1)) begin
         _00003a231 <= -32'd1;
      end

      _00003a230 <= 32'd0;

      if ((rst == 32'd1)) begin
         _00003a68 <= 32'd0;
      end

      ack <= 32'd0;

      mac__n1_00003a263_00003a_00003arun <= 32'd0;

      if (~mac__n1_00003a263_00003a_00003arun) begin
         mac__n1_00003a263_00003a_00003arvok <= 32'd0;
         mac__n1_00003a263_00003a_00003alvok0 <= 32'd0;
         mac__n1_00003a263_00003a_00003awok0 <= 32'd0;
      end

      if ((req__mac | mac__n1_00003a263_00003a_00003arun)) begin
         mac__n1_00003a263_00003a_00003arun <= 32'd1;
         if (~mac__n1_00003a263_00003a_00003arvok) begin
            if ((rst == 32'd0)) begin
               case(_00003a68)
                  32'd0: mac__n1_00003a263_00003a_00003arv <= _00003a66;
                  32'd1: mac__n1_00003a263_00003a_00003arv <= _00003a67;
               endcase
               mac__n1_00003a263_00003a_00003arvok <= 32'd1;
               _00003a68 <= ((_00003a68 + 32'd1) == 32'd2) == 1 ? (_00003a68 + 32'd1) : 32'd0;
            end
         end
         if (~mac__n1_00003a263_00003a_00003alvok0) begin
            if ((rst == 32'd0)) begin
               if ((_00003a230 == 32'd1)) begin
                  mac__n1_00003a263_00003a_00003alv0 <= _00003a232;
                  mac__n1_00003a263_00003a_00003alvok0 <= 32'd1;
               end
               else begin
                  _00003a231 <= ((_00003a231 + 32'd1) == 32'd2) == 1 ? (_00003a231 + 32'd1) : 32'd0;
                  _00003a230 <= 32'd1;
               end
            end
         end
         if (((mac__n1_00003a263_00003a_00003alvok0 & mac__n1_00003a263_00003a_00003arvok) & ~mac__n1_00003a263_00003a_00003awok0)) begin
            ack <= 32'd1;
            mac__n1_00003a263_00003a_00003arun <= 32'd0;
            mac__n1_00003a263_00003a_00003aav0 <= (mac__n1_00003a263_00003a_00003aav0 + (($signed(mac__n1_00003a263_00003a_00003alv0) * mac__n1_00003a263_00003a_00003arv) >> 32'd4));
            _00003a240 <= ((mac__n1_00003a263_00003a_00003aav0 + (($signed(mac__n1_00003a263_00003a_00003alv0) * mac__n1_00003a263_00003a_00003arv) >> 32'd4)) + (($signed(mac__n1_00003a263_00003a_00003alv0) * mac__n1_00003a263_00003a_00003arv) >> 32'd4));
            mac__n1_00003a263_00003a_00003awok0 <= 32'd1;
         end
         if (mac__n1_00003a263_00003a_00003awok0) begin
            mac__n1_00003a263_00003a_00003awok0 <= 32'd0;
            mac__n1_00003a263_00003a_00003alvok0 <= 32'd0;
            mac__n1_00003a263_00003a_00003arvok <= 32'd0;
         end
      end
      else begin
         mac__n1_00003a263_00003a_00003aav0 <= 32'd0;
      end

   end

   always @( negedge clk ) begin

      channel__b0_00003a268_00003a_00003adbus__r <= channel__b0_00003a268_00003a_00003amem[channel__b0_00003a268_00003a_00003aabus__r];

   end

   always @( posedge clk ) begin

      _00003a270 <= 32'd0;

      ack__add <= 32'd0;

      add__n_00003a306_00003a_00003arun <= 32'd0;

      if ((ack__mac | add__n_00003a306_00003a_00003arun)) begin
         add__n_00003a306_00003a_00003arun <= 32'd1;
         add__n_00003a306_00003a_00003alv0 <= _00003a240;
         add__n_00003a306_00003a_00003alvok0 <= 32'd1;
         if ((_00003a273 == 32'd0)) begin
            if ((_00003a270 == 32'd1)) begin
               add__n_00003a306_00003a_00003arv0 <= _00003a272;
               _00003a270 <= 32'd0;
               add__n_00003a306_00003a_00003arvok0 <= 32'd1;
            end
            else begin
               _00003a271 <= 32'd0;
               _00003a270 <= 32'd1;
            end
         end
         if ((add__n_00003a306_00003a_00003alvok0 & add__n_00003a306_00003a_00003arvok0)) begin
            add__n_00003a306_00003a_00003arun <= 32'd0;
            ack__add <= 32'd1;
            _00003a285 <= (add__n_00003a306_00003a_00003alv0 + add__n_00003a306_00003a_00003arv0);
         end
      end
      else begin
         add__n_00003a306_00003a_00003alvok0 <= 32'd0;
         add__n_00003a306_00003a_00003arvok0 <= 32'd0;
      end

   end

   initial begin

      channel__w0_00003a223_00003a_00003amem[32'd0] = $signed(-32'd11);

      channel__w0_00003a223_00003a_00003amem[32'd1] = $signed(32'd14);

   end

endmodule