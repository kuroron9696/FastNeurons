`timescale 1ps/1ps

module neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0( clk, rst, req, _00003a59, ack__layer, _00003a57, _00003a58, _00003a106, _00003a107 ); 
   input clk;
   input rst;
   input req;
   input signed[7:0] _00003a59;
   output ack__layer;
   output reg _00003a57;
   output reg [0:0] _00003a58;
   output reg signed[7:0] _00003a106;
   output reg signed[7:0] _00003a107;
   wire req__mac;
   reg ack;
   wire ack__mac;
   reg ack__add;
   wire signed[7:0] _00003a149;
   reg _00003a147;
   reg [0:0] _00003a148;
   reg signed[7:0] _00003a174;
   reg signed[7:0] _00003a175;
   wire signed[7:0] _00003a164;
   reg _00003a162;
   reg [0:0] _00003a163;
   wire signed[7:0] _00003a172;
   wire signed[7:0] _00003a173;
   wire signed[7:0] _00003a221;
   wire _00003a222;
   reg _00003a219;
   reg [0:0] _00003a220;
   reg signed[7:0] _00003a251;
   reg signed[7:0] _00003a252;
   wire signed[7:0] _00003a236;
   wire _00003a237;
   reg _00003a234;
   reg [0:0] _00003a235;
   reg signed[7:0] value__z0;
   reg signed[7:0] value__z1;
   wire signed[7:0] value__a0;
   wire signed[7:0] value__a1;
   reg flag__z0;
   reg flag__z1;
   reg ack__a0;
   reg ack__a1;
   wire signed[7:0] _00003a249;
   wire signed[7:0] _00003a250;
   wire channel__w0_00003a140_00003a_00003atrig__r;
   reg signed[7:0] channel__w0_00003a140_00003a_00003adbus__r;
   wire [0:0] channel__w0_00003a140_00003a_00003aabus__r;
   reg signed[7:0] channel__w0_00003a140_00003a_00003amem  [0:1];
   wire channel__w1_00003a155_00003a_00003atrig__r;
   reg signed[7:0] channel__w1_00003a155_00003a_00003adbus__r;
   wire [0:0] channel__w1_00003a155_00003a_00003aabus__r;
   reg signed[7:0] channel__w1_00003a155_00003a_00003amem  [0:1];
   wire signed[7:0] channel__accum_00003a170_00003a_00003areg__0;
   wire signed[7:0] channel__accum_00003a170_00003a_00003areg__1;
   wire [0:0] channel__accum_00003a170_00003a_00003arinc_00003a190_00003a_00003aabus__r;
   wire [0:0] channel__accum_00003a170_00003a_00003awinc_00003a195_00003a_00003aabus__w;
   wire [0:0] channel__accum_00003a170_00003a_00003ardec_00003a200_00003a_00003aabus__r;
   wire [0:0] channel__accum_00003a170_00003a_00003awdec_00003a205_00003a_00003aabus__w;
   reg signed[7:0] mac__n1_00003a210_00003a_00003alv0;
   reg signed[7:0] mac__n1_00003a210_00003a_00003alv1;
   reg signed[7:0] mac__n1_00003a210_00003a_00003aav0;
   reg signed[7:0] mac__n1_00003a210_00003a_00003aav1;
   reg signed[7:0] mac__n1_00003a210_00003a_00003arv;
   reg mac__n1_00003a210_00003a_00003alvok0;
   reg mac__n1_00003a210_00003a_00003alvok1;
   reg mac__n1_00003a210_00003a_00003arvok;
   reg mac__n1_00003a210_00003a_00003awok0;
   reg mac__n1_00003a210_00003a_00003awok1;
   reg mac__n1_00003a210_00003a_00003arun;
   wire channel__b0_00003a217_00003a_00003atrig__r;
   reg signed[7:0] channel__b0_00003a217_00003a_00003adbus__r;
   wire [0:0] channel__b0_00003a217_00003a_00003aabus__r;
   reg signed[7:0] channel__b0_00003a217_00003a_00003amem  [0:0];
   wire channel__b1_00003a232_00003a_00003atrig__r;
   reg signed[7:0] channel__b1_00003a232_00003a_00003adbus__r;
   wire [0:0] channel__b1_00003a232_00003a_00003aabus__r;
   reg signed[7:0] channel__b1_00003a232_00003a_00003amem  [0:0];
   wire signed[7:0] channel__z_00003a247_00003a_00003areg__0;
   wire signed[7:0] channel__z_00003a247_00003a_00003areg__1;
   wire [0:0] channel__z_00003a247_00003a_00003arinc_00003a267_00003a_00003aabus__r;
   wire [0:0] channel__z_00003a247_00003a_00003awinc_00003a271_00003a_00003aabus__w;
   wire [0:0] channel__z_00003a247_00003a_00003ardec_00003a275_00003a_00003aabus__r;
   wire [0:0] channel__z_00003a247_00003a_00003awdec_00003a280_00003a_00003aabus__w;
   reg signed[7:0] add__n_00003a285_00003a_00003alv0;
   reg signed[7:0] add__n_00003a285_00003a_00003alv1;
   reg signed[7:0] add__n_00003a285_00003a_00003arv0;
   reg signed[7:0] add__n_00003a285_00003a_00003arv1;
   reg add__n_00003a285_00003a_00003alvok0;
   reg add__n_00003a285_00003a_00003alvok1;
   reg add__n_00003a285_00003a_00003arvok0;
   reg add__n_00003a285_00003a_00003arvok1;
   reg add__n_00003a285_00003a_00003arun;
   wire _00005e_000060204;
   wire _00005e_000060205;
   wire _00005e_000060206;
   wire _00005e_000060207;
   wire signed[7:0] _00005e_000060208;
   wire signed[7:0] _00005e_000060209;
   wire signed[7:0] _00005e_000060210;
   wire signed[7:0] _00005e_000060211;

   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0_00003a_00003acounter_00003aT1 counter(.clk(_00005e_000060204),.ack(_00005e_000060205),.rst(_00005e_000060206),.ack__mac(_00005e_000060207));
   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0_00003a_00003afunc0_00003aT1 func0(.z__value(_00005e_000060208),.a(_00005e_000060209));
   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0_00003a_00003afunc1_00003aT0 func1(.z__value(_00005e_000060210),.a(_00005e_000060211));
   assign req__mac = (req & ~ack__mac);

   assign _00005e_000060204 = clk;

   assign _00005e_000060205 = ack;

   assign _00005e_000060206 = rst;

   assign ack__mac = _00005e_000060207;

   assign _00003a222 = rst;

   assign _00003a237 = rst;

   assign _00005e_000060208 = value__z0;

   assign value__a0 = _00005e_000060209;

   assign _00005e_000060210 = value__z1;

   assign value__a1 = _00005e_000060211;

   assign ack__layer = (ack__a0 & ack__a1);

   assign _00003a149 = channel__w0_00003a140_00003a_00003adbus__r;

   assign channel__w0_00003a140_00003a_00003atrig__r = _00003a147;

   assign channel__w0_00003a140_00003a_00003aabus__r = _00003a148;

   assign _00003a164 = channel__w1_00003a155_00003a_00003adbus__r;

   assign channel__w1_00003a155_00003a_00003atrig__r = _00003a162;

   assign channel__w1_00003a155_00003a_00003aabus__r = _00003a163;

   assign channel__accum_00003a170_00003a_00003areg__0 = _00003a174;

   assign channel__accum_00003a170_00003a_00003areg__1 = _00003a175;

   assign _00003a172 = channel__accum_00003a170_00003a_00003areg__0;

   assign _00003a173 = channel__accum_00003a170_00003a_00003areg__1;

   assign _00003a221 = channel__b0_00003a217_00003a_00003adbus__r;

   assign channel__b0_00003a217_00003a_00003atrig__r = _00003a219;

   assign channel__b0_00003a217_00003a_00003aabus__r = _00003a220;

   assign _00003a236 = channel__b1_00003a232_00003a_00003adbus__r;

   assign channel__b1_00003a232_00003a_00003atrig__r = _00003a234;

   assign channel__b1_00003a232_00003a_00003aabus__r = _00003a235;

   assign channel__z_00003a247_00003a_00003areg__0 = _00003a251;

   assign channel__z_00003a247_00003a_00003areg__1 = _00003a252;

   assign _00003a249 = channel__z_00003a247_00003a_00003areg__0;

   assign _00003a250 = channel__z_00003a247_00003a_00003areg__1;

   always @( posedge clk ) begin : _00003a519
      if (rst) begin : _00003a510
         ack <= 32'd0;
         ack__add <= 32'd0;
      end
   end   always @( posedge clk ) begin : _00003a520
      if (ack__add) begin : _00003a513
         begin : _00003a511
            value__z0 <= _00003a249;
            flag__z0 <= 32'd1;
         end
         begin : _00003a512
            value__z1 <= _00003a250;
            flag__z1 <= 32'd1;
         end
      end
      else begin : _00003a514
         flag__z0 <= 32'd0;
         flag__z1 <= 32'd0;
      end
   end   always @( posedge clk ) begin : _00003a521
      if (rst) begin : _00003a517
         ack__a0 <= 32'd0;
         ack__a1 <= 32'd0;
      end
      else if ((flag__z0 & flag__z1)) begin : _00003a518
         begin : _00003a515
            _00003a106 <= value__a0;
            ack__a0 <= 32'd1;
         end
         begin : _00003a516
            _00003a107 <= value__a1;
            ack__a1 <= 32'd1;
         end
      end
   end   always @( negedge clk ) begin : _00003a449
      channel__w0_00003a140_00003a_00003adbus__r <= channel__w0_00003a140_00003a_00003amem[channel__w0_00003a140_00003a_00003aabus__r];
   end   always @( negedge clk ) begin : _00003a450
      channel__w1_00003a155_00003a_00003adbus__r <= channel__w1_00003a155_00003a_00003amem[channel__w1_00003a155_00003a_00003aabus__r];
   end   always @( posedge clk ) begin : _00003a488
      begin : _00003a482
         if ((rst == 32'd1)) begin : _00003a451
            _00003a163 <= -32'd1;
            _00003a162 <= 32'd0;
         end
      end
      begin : _00003a483
         if ((rst == 32'd1)) begin : _00003a452
            _00003a148 <= -32'd1;
            _00003a147 <= 32'd0;
         end
      end
      begin : _00003a484
         if ((rst == 32'd1)) begin : _00003a453
            _00003a58 <= -32'd1;
         end
         _00003a57 <= 32'd0;
      end
      ack <= 32'd0;
      mac__n1_00003a210_00003a_00003arun <= 32'd0;
      if (~mac__n1_00003a210_00003a_00003arun) begin : _00003a485
         mac__n1_00003a210_00003a_00003arvok <= 32'd0;
         mac__n1_00003a210_00003a_00003alvok0 <= 32'd0;
         mac__n1_00003a210_00003a_00003awok0 <= 32'd0;
         mac__n1_00003a210_00003a_00003alvok1 <= 32'd0;
         mac__n1_00003a210_00003a_00003awok1 <= 32'd0;
      end
      if ((req__mac | mac__n1_00003a210_00003a_00003arun)) begin : _00003a486
         mac__n1_00003a210_00003a_00003arun <= 32'd1;
         if (~mac__n1_00003a210_00003a_00003arvok) begin : _00003a475
            begin : _00003a458
               if ((rst == 32'd0)) begin : _00003a457
                  if ((_00003a57 == 32'd1)) begin : _00003a455
                     begin : _00003a454
                        mac__n1_00003a210_00003a_00003arv = _00003a59;
                        mac__n1_00003a210_00003a_00003arvok = 32'd1;
                     end
                  end
                  else begin : _00003a456
                     _00003a58 <= (_00003a58 + 32'd1);
                     _00003a57 <= 32'd1;
                  end
               end
            end
         end
         if (~mac__n1_00003a210_00003a_00003alvok0) begin : _00003a476
            begin : _00003a463
               if ((rst == 32'd0)) begin : _00003a462
                  if ((_00003a147 == 32'd1)) begin : _00003a460
                     begin : _00003a459
                        _00003a147 = 32'd0;
                        mac__n1_00003a210_00003a_00003alv0 = _00003a149;
                        mac__n1_00003a210_00003a_00003alvok0 = 32'd1;
                     end
                  end
                  else begin : _00003a461
                     _00003a148 <= (_00003a148 + 32'd1);
                     _00003a147 <= 32'd1;
                  end
               end
            end
         end
         if (((mac__n1_00003a210_00003a_00003alvok0 & mac__n1_00003a210_00003a_00003arvok) & ~mac__n1_00003a210_00003a_00003awok0)) begin : _00003a477
            ack <= 32'd1;
            mac__n1_00003a210_00003a_00003arun <= 32'd0;
            begin : _00003a466
               begin : _00003a464
               end
               mac__n1_00003a210_00003a_00003aav0 = (mac__n1_00003a210_00003a_00003aav0 + (($signed({{4{mac__n1_00003a210_00003a_00003alv0[7]}},mac__n1_00003a210_00003a_00003alv0}) * mac__n1_00003a210_00003a_00003arv) >> 32'd4));
               begin : _00003a465
                  _00003a174 <= mac__n1_00003a210_00003a_00003aav0;
                  mac__n1_00003a210_00003a_00003awok0 <= 32'd1;
               end
            end
         end
         if ((mac__n1_00003a210_00003a_00003awok0 & mac__n1_00003a210_00003a_00003awok1)) begin : _00003a478
            mac__n1_00003a210_00003a_00003awok0 <= 32'd0;
            mac__n1_00003a210_00003a_00003awok1 <= 32'd0;
            mac__n1_00003a210_00003a_00003alvok0 <= 32'd0;
            mac__n1_00003a210_00003a_00003alvok1 <= 32'd0;
            mac__n1_00003a210_00003a_00003arvok <= 32'd0;
         end
         if (~mac__n1_00003a210_00003a_00003alvok1) begin : _00003a479
            begin : _00003a471
               if ((rst == 32'd0)) begin : _00003a470
                  if ((_00003a162 == 32'd1)) begin : _00003a468
                     begin : _00003a467
                        _00003a162 = 32'd0;
                        mac__n1_00003a210_00003a_00003alv1 = _00003a164;
                        mac__n1_00003a210_00003a_00003alvok1 = 32'd1;
                     end
                  end
                  else begin : _00003a469
                     _00003a163 <= (_00003a163 + 32'd1);
                     _00003a162 <= 32'd1;
                  end
               end
            end
         end
         if (((mac__n1_00003a210_00003a_00003alvok1 & mac__n1_00003a210_00003a_00003arvok) & ~mac__n1_00003a210_00003a_00003awok1)) begin : _00003a480
            ack <= 32'd1;
            mac__n1_00003a210_00003a_00003arun <= 32'd0;
            begin : _00003a474
               begin : _00003a472
               end
               mac__n1_00003a210_00003a_00003aav1 = (mac__n1_00003a210_00003a_00003aav1 + (($signed({{4{mac__n1_00003a210_00003a_00003alv1[7]}},mac__n1_00003a210_00003a_00003alv1}) * mac__n1_00003a210_00003a_00003arv) >> 32'd4));
               begin : _00003a473
                  _00003a175 <= mac__n1_00003a210_00003a_00003aav1;
                  mac__n1_00003a210_00003a_00003awok1 <= 32'd1;
               end
            end
         end
         if ((mac__n1_00003a210_00003a_00003awok0 & mac__n1_00003a210_00003a_00003awok1)) begin : _00003a481
            mac__n1_00003a210_00003a_00003awok0 <= 32'd0;
            mac__n1_00003a210_00003a_00003awok1 <= 32'd0;
            mac__n1_00003a210_00003a_00003alvok0 <= 32'd0;
            mac__n1_00003a210_00003a_00003alvok1 <= 32'd0;
            mac__n1_00003a210_00003a_00003arvok <= 32'd0;
         end
      end
      else begin : _00003a487
         mac__n1_00003a210_00003a_00003aav0 <= 32'd0;
         mac__n1_00003a210_00003a_00003aav1 <= 32'd0;
      end
   end   always @( negedge clk ) begin : _00003a489
      channel__b0_00003a217_00003a_00003adbus__r <= channel__b0_00003a217_00003a_00003amem[channel__b0_00003a217_00003a_00003aabus__r];
   end   always @( negedge clk ) begin : _00003a490
      channel__b1_00003a232_00003a_00003adbus__r <= channel__b1_00003a232_00003a_00003amem[channel__b1_00003a232_00003a_00003aabus__r];
   end   always @( posedge clk ) begin : _00003a509
      begin : _00003a505
         _00003a234 <= 32'd0;
      end
      begin : _00003a506
         _00003a219 <= 32'd0;
      end
      ack__add <= 32'd0;
      add__n_00003a285_00003a_00003arun <= 32'd0;
      if ((ack__mac | add__n_00003a285_00003a_00003arun)) begin : _00003a507
         add__n_00003a285_00003a_00003arun <= 32'd1;
         begin : _00003a499
            add__n_00003a285_00003a_00003alv0 <= _00003a172;
            add__n_00003a285_00003a_00003alvok0 <= 32'd1;
         end
         begin : _00003a500
            if ((_00003a222 == 32'd0)) begin : _00003a493
               if ((_00003a219 == 32'd1)) begin : _00003a491
                  add__n_00003a285_00003a_00003arv0 <= _00003a221;
                  _00003a219 <= 32'd0;
                  add__n_00003a285_00003a_00003arvok0 <= 32'd1;
               end
               else begin : _00003a492
                  _00003a220 <= 32'd0;
                  _00003a219 <= 32'd1;
               end
            end
         end
         if ((add__n_00003a285_00003a_00003alvok0 & add__n_00003a285_00003a_00003arvok0)) begin : _00003a501
            add__n_00003a285_00003a_00003arun <= 32'd0;
            ack__add <= 32'd1;
            begin : _00003a494
               _00003a251 <= (add__n_00003a285_00003a_00003alv0 + add__n_00003a285_00003a_00003arv0);
            end
         end
         begin : _00003a502
            add__n_00003a285_00003a_00003alv1 <= _00003a173;
            add__n_00003a285_00003a_00003alvok1 <= 32'd1;
         end
         begin : _00003a503
            if ((_00003a237 == 32'd0)) begin : _00003a497
               if ((_00003a234 == 32'd1)) begin : _00003a495
                  add__n_00003a285_00003a_00003arv1 <= _00003a236;
                  _00003a234 <= 32'd0;
                  add__n_00003a285_00003a_00003arvok1 <= 32'd1;
               end
               else begin : _00003a496
                  _00003a235 <= 32'd0;
                  _00003a234 <= 32'd1;
               end
            end
         end
         if ((add__n_00003a285_00003a_00003alvok1 & add__n_00003a285_00003a_00003arvok1)) begin : _00003a504
            add__n_00003a285_00003a_00003arun <= 32'd0;
            ack__add <= 32'd1;
            begin : _00003a498
               _00003a252 <= (add__n_00003a285_00003a_00003alv1 + add__n_00003a285_00003a_00003arv1);
            end
         end
      end
      else begin : _00003a508
         add__n_00003a285_00003a_00003alvok0 <= 32'd0;
         add__n_00003a285_00003a_00003arvok0 <= 32'd0;
         add__n_00003a285_00003a_00003alvok1 <= 32'd0;
         add__n_00003a285_00003a_00003arvok1 <= 32'd0;
      end
   end   initial begin
      channel__w0_00003a140_00003a_00003amem[32'd0] = 32'd12;
      channel__w0_00003a140_00003a_00003amem[32'd1] = 32'd12;
      channel__w1_00003a155_00003a_00003amem[32'd0] = 32'd17;
      channel__w1_00003a155_00003a_00003amem[32'd1] = 32'd17;
      channel__b0_00003a217_00003a_00003amem[32'd0] = 32'd0;
      channel__b1_00003a232_00003a_00003amem[32'd0] = -32'd17;
   end
endmodule