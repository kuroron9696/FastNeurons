`timescale 1ps/1ps

module neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer1_00003aT0( clk, rst, req, _00003a123, _00003a124, ack__layer, _00003a125, _00003a77 ); 
   input clk;
   input rst;
   input req;
   input signed[7:0] _00003a123;
   input signed[7:0] _00003a124;
   output ack__layer;
   output reg [0:0] _00003a125;
   output reg signed[7:0] _00003a77;
   wire req__mac;
   reg ack;
   wire ack__mac;
   reg ack__add;
   wire signed[7:0] _00003a311;
   reg _00003a309;
   reg [0:0] _00003a310;
   reg signed[7:0] _00003a320;
   wire signed[7:0] _00003a319;
   wire signed[7:0] _00003a356;
   wire _00003a357;
   reg _00003a354;
   reg [0:0] _00003a355;
   reg signed[7:0] _00003a370;
   reg signed[7:0] value__z0;
   wire signed[7:0] value__a0;
   reg flag__z0;
   reg ack__a0;
   wire signed[7:0] _00003a369;
   wire channel__w0_00003a302_00003a_00003atrig__r;
   reg signed[7:0] channel__w0_00003a302_00003a_00003adbus__r;
   wire [0:0] channel__w0_00003a302_00003a_00003aabus__r;
   reg signed[7:0] channel__w0_00003a302_00003a_00003amem  [0:1];
   wire signed[7:0] channel__accum_00003a317_00003a_00003areg__0;
   wire [0:0] channel__accum_00003a317_00003a_00003arinc_00003a331_00003a_00003aabus__r;
   wire [0:0] channel__accum_00003a317_00003a_00003awinc_00003a335_00003a_00003aabus__w;
   wire [0:0] channel__accum_00003a317_00003a_00003ardec_00003a339_00003a_00003aabus__r;
   wire [0:0] channel__accum_00003a317_00003a_00003awdec_00003a343_00003a_00003aabus__w;
   reg signed[7:0] mac__n1_00003a347_00003a_00003alv0;
   reg signed[7:0] mac__n1_00003a347_00003a_00003aav0;
   reg signed[7:0] mac__n1_00003a347_00003a_00003arv;
   reg mac__n1_00003a347_00003a_00003alvok0;
   reg mac__n1_00003a347_00003a_00003arvok;
   reg mac__n1_00003a347_00003a_00003awok0;
   reg mac__n1_00003a347_00003a_00003arun;
   wire channel__b0_00003a352_00003a_00003atrig__r;
   reg signed[7:0] channel__b0_00003a352_00003a_00003adbus__r;
   wire [0:0] channel__b0_00003a352_00003a_00003aabus__r;
   reg signed[7:0] channel__b0_00003a352_00003a_00003amem  [0:0];
   wire signed[7:0] channel__z_00003a367_00003a_00003areg__0;
   wire [0:0] channel__z_00003a367_00003a_00003arinc_00003a381_00003a_00003aabus__r;
   wire [0:0] channel__z_00003a367_00003a_00003awinc_00003a384_00003a_00003aabus__w;
   wire [0:0] channel__z_00003a367_00003a_00003ardec_00003a387_00003a_00003aabus__r;
   wire [0:0] channel__z_00003a367_00003a_00003awdec_00003a391_00003a_00003aabus__w;
   reg signed[7:0] add__n_00003a395_00003a_00003alv0;
   reg signed[7:0] add__n_00003a395_00003a_00003arv0;
   reg add__n_00003a395_00003a_00003alvok0;
   reg add__n_00003a395_00003a_00003arvok0;
   reg add__n_00003a395_00003a_00003arun;
   wire _00005e_000060204;
   wire _00005e_000060205;
   wire _00005e_000060206;
   wire _00005e_000060207;
   wire signed[7:0] _00005e_000060208;
   wire signed[7:0] _00005e_000060209;

   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer1_00003aT0_00003a_00003acounter_00003aT00 counter(.clk(_00005e_000060204),.ack(_00005e_000060205),.rst(_00005e_000060206),.ack__mac(_00005e_000060207));
   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer1_00003aT0_00003a_00003afunc0_00003aT00 func0(.z__value(_00005e_000060208),.a(_00005e_000060209));
   assign req__mac = (req & ~ack__mac);

   assign _00005e_000060204 = clk;

   assign _00005e_000060205 = ack;

   assign _00005e_000060206 = rst;

   assign ack__mac = _00005e_000060207;

   assign _00003a357 = rst;

   assign _00005e_000060208 = value__z0;

   assign value__a0 = _00005e_000060209;

   assign ack__layer = ack__a0;

   assign _00003a311 = channel__w0_00003a302_00003a_00003adbus__r;

   assign channel__w0_00003a302_00003a_00003atrig__r = _00003a309;

   assign channel__w0_00003a302_00003a_00003aabus__r = _00003a310;

   assign channel__accum_00003a317_00003a_00003areg__0 = _00003a320;

   assign _00003a319 = channel__accum_00003a317_00003a_00003areg__0;

   assign _00003a356 = channel__b0_00003a352_00003a_00003adbus__r;

   assign channel__b0_00003a352_00003a_00003atrig__r = _00003a354;

   assign channel__b0_00003a352_00003a_00003aabus__r = _00003a355;

   assign channel__z_00003a367_00003a_00003areg__0 = _00003a370;

   assign _00003a369 = channel__z_00003a367_00003a_00003areg__0;

   always @( posedge clk ) begin : _00003a583
      if (rst) begin : _00003a576
         ack <= 32'd0;
         ack__add <= 32'd0;
      end
   end   always @( posedge clk ) begin : _00003a584
      if (ack__add) begin : _00003a578
         begin : _00003a577
            value__z0 <= _00003a369;
            flag__z0 <= 32'd1;
         end
      end
      else begin : _00003a579
         flag__z0 <= 32'd0;
      end
   end   always @( posedge clk ) begin : _00003a585
      if (rst) begin : _00003a581
         ack__a0 <= 32'd0;
      end
      else if (flag__z0) begin : _00003a582
         begin : _00003a580
            _00003a77 <= value__a0;
            ack__a0 <= 32'd1;
         end
      end
   end   always @( negedge clk ) begin : _00003a539
      channel__w0_00003a302_00003a_00003adbus__r <= channel__w0_00003a302_00003a_00003amem[channel__w0_00003a302_00003a_00003aabus__r];
   end   always @( posedge clk ) begin : _00003a563
      begin : _00003a558
         if ((rst == 32'd1)) begin : _00003a540
            _00003a310 <= -32'd1;
            _00003a309 <= 32'd0;
         end
      end
      begin : _00003a559
         if ((rst == 32'd1)) begin : _00003a541
            _00003a125 <= 32'd0;
         end
      end
      ack <= 32'd0;
      mac__n1_00003a347_00003a_00003arun <= 32'd0;
      if (~mac__n1_00003a347_00003a_00003arun) begin : _00003a560
         mac__n1_00003a347_00003a_00003arvok <= 32'd0;
         mac__n1_00003a347_00003a_00003alvok0 <= 32'd0;
         mac__n1_00003a347_00003a_00003awok0 <= 32'd0;
      end
      if ((req__mac | mac__n1_00003a347_00003a_00003arun)) begin : _00003a561
         mac__n1_00003a347_00003a_00003arun <= 32'd1;
         if (~mac__n1_00003a347_00003a_00003arvok) begin : _00003a554
            begin : _00003a545
               if ((rst == 32'd0)) begin : _00003a544
case(_00003a125)
                     32'd0: begin : _00003a542
                        mac__n1_00003a347_00003a_00003arv <= _00003a123;
                     end                     32'd1: begin : _00003a543
                        mac__n1_00003a347_00003a_00003arv <= _00003a124;
                     end                  endcase

                  mac__n1_00003a347_00003a_00003arvok <= 32'd1;
                  _00003a125 <= (_00003a125 + 32'd1);
               end
            end
         end
         if (~mac__n1_00003a347_00003a_00003alvok0) begin : _00003a555
            begin : _00003a550
               if ((rst == 32'd0)) begin : _00003a549
                  if ((_00003a309 == 32'd1)) begin : _00003a547
                     begin : _00003a546
                        _00003a309 = 32'd0;
                        mac__n1_00003a347_00003a_00003alv0 = _00003a311;
                        mac__n1_00003a347_00003a_00003alvok0 = 32'd1;
                     end
                  end
                  else begin : _00003a548
                     _00003a310 <= (_00003a310 + 32'd1);
                     _00003a309 <= 32'd1;
                  end
               end
            end
         end
         if (((mac__n1_00003a347_00003a_00003alvok0 & mac__n1_00003a347_00003a_00003arvok) & ~mac__n1_00003a347_00003a_00003awok0)) begin : _00003a556
            ack <= 32'd1;
            mac__n1_00003a347_00003a_00003arun <= 32'd0;
            begin : _00003a553
               begin : _00003a551
               end
               mac__n1_00003a347_00003a_00003aav0 = (mac__n1_00003a347_00003a_00003aav0 + (($signed({{4{mac__n1_00003a347_00003a_00003alv0[7]}},mac__n1_00003a347_00003a_00003alv0}) * mac__n1_00003a347_00003a_00003arv) >> 32'd4));
               begin : _00003a552
                  _00003a320 <= mac__n1_00003a347_00003a_00003aav0;
                  mac__n1_00003a347_00003a_00003awok0 <= 32'd1;
               end
            end
         end
         if (mac__n1_00003a347_00003a_00003awok0) begin : _00003a557
            mac__n1_00003a347_00003a_00003awok0 <= 32'd0;
            mac__n1_00003a347_00003a_00003alvok0 <= 32'd0;
            mac__n1_00003a347_00003a_00003arvok <= 32'd0;
         end
      end
      else begin : _00003a562
         mac__n1_00003a347_00003a_00003aav0 <= 32'd0;
      end
   end   always @( negedge clk ) begin : _00003a564
      channel__b0_00003a352_00003a_00003adbus__r <= channel__b0_00003a352_00003a_00003amem[channel__b0_00003a352_00003a_00003aabus__r];
   end   always @( posedge clk ) begin : _00003a575
      begin : _00003a572
         _00003a354 <= 32'd0;
      end
      ack__add <= 32'd0;
      add__n_00003a395_00003a_00003arun <= 32'd0;
      if ((ack__mac | add__n_00003a395_00003a_00003arun)) begin : _00003a573
         add__n_00003a395_00003a_00003arun <= 32'd1;
         begin : _00003a569
            add__n_00003a395_00003a_00003alv0 <= _00003a319;
            add__n_00003a395_00003a_00003alvok0 <= 32'd1;
         end
         begin : _00003a570
            if ((_00003a357 == 32'd0)) begin : _00003a567
               if ((_00003a354 == 32'd1)) begin : _00003a565
                  add__n_00003a395_00003a_00003arv0 <= _00003a356;
                  _00003a354 <= 32'd0;
                  add__n_00003a395_00003a_00003arvok0 <= 32'd1;
               end
               else begin : _00003a566
                  _00003a355 <= 32'd0;
                  _00003a354 <= 32'd1;
               end
            end
         end
         if ((add__n_00003a395_00003a_00003alvok0 & add__n_00003a395_00003a_00003arvok0)) begin : _00003a571
            add__n_00003a395_00003a_00003arun <= 32'd0;
            ack__add <= 32'd1;
            begin : _00003a568
               _00003a370 <= (add__n_00003a395_00003a_00003alv0 + add__n_00003a395_00003a_00003arv0);
            end
         end
      end
      else begin : _00003a574
         add__n_00003a395_00003a_00003alvok0 <= 32'd0;
         add__n_00003a395_00003a_00003arvok0 <= 32'd0;
      end
   end   initial begin
      channel__w0_00003a302_00003a_00003amem[32'd0] = 32'd20;
      channel__w0_00003a302_00003a_00003amem[32'd1] = -32'd29;
      channel__b0_00003a352_00003a_00003amem[32'd0] = 32'd0;
   end
endmodule