`timescale 1ps/1ps

module neural__network_00003aT1_00003a_00003aneural__network_00003aT00( clk, rst, req, fill, _00003a10, ack__fill, ack__network, _00003a8, _00003a9, _00003a32, _00003a33, _00003a34 ); 
   input clk;
   input rst;
   input req;
   input fill;
   input signed[7:0] _00003a10;
   output ack__fill;
   output reg ack__network;
   output reg _00003a8;
   output reg [0:0] _00003a9;
   output reg _00003a32;
   output reg [0:0] _00003a33;
   output reg signed[7:0] _00003a34;
   wire ack__0;
   wire ack__1;
   wire fill__inputs;
   reg signed[7:0] value__inputs;
   reg [1:0] address__inputs;
   reg flag__inputs;
   reg ack__inputs;
   reg _00003a61;
   reg [0:0] _00003a62;
   reg signed[7:0] _00003a63;
   wire fill__outputs;
   reg signed[7:0] value__outputs;
   reg [0:0] address__outputs;
   reg flag__outputs;
   wire signed[7:0] _00003a89;
   reg [0:0] _00003a90;
   wire channel__inputs_00003a45_00003a_00003atrig__r;
   wire channel__inputs_00003a45_00003a_00003atrig__w;
   reg signed[7:0] channel__inputs_00003a45_00003a_00003adbus__r;
   wire signed[7:0] channel__inputs_00003a45_00003a_00003adbus__w;
   wire [0:0] channel__inputs_00003a45_00003a_00003aabus__r;
   wire [0:0] channel__inputs_00003a45_00003a_00003aabus__w;
   reg signed[7:0] channel__inputs_00003a45_00003a_00003amem  [0:1];
   wire signed[7:0] channel__outputs_00003a74_00003a_00003areg__0;
   wire [0:0] channel__outputs_00003a74_00003a_00003arinc_00003a88_00003a_00003aabus__r;
   wire [0:0] channel__outputs_00003a74_00003a_00003awinc_00003a91_00003a_00003aabus__w;
   wire [0:0] channel__outputs_00003a74_00003a_00003ardec_00003a94_00003a_00003aabus__r;
   wire [0:0] channel__outputs_00003a74_00003a_00003awdec_00003a98_00003a_00003aabus__w;
   wire signed[7:0] channel__a0_00003a102_00003a_00003areg__0;
   wire signed[7:0] channel__a0_00003a102_00003a_00003areg__1;
   wire [0:0] channel__a0_00003a102_00003a_00003arinc_00003a122_00003a_00003aabus__r;
   wire [0:0] channel__a0_00003a102_00003a_00003awinc_00003a126_00003a_00003aabus__w;
   wire [0:0] channel__a0_00003a102_00003a_00003ardec_00003a130_00003a_00003aabus__r;
   wire [0:0] channel__a0_00003a102_00003a_00003awdec_00003a135_00003a_00003aabus__w;
   wire _00005e_00006045;
   wire _00005e_00006046;
   wire _00005e_00006047;
   wire _00005e_00006048;
   wire _00005e_00006049;
   wire _00005e_00006050;
   wire _00005e_00006051;
   wire _00005e_00006052;
   wire signed[7:0] _00005e_00006053;
   wire _00005e_00006054;
   wire [0:0] _00005e_00006055;
   wire signed[7:0] _00005e_00006056;
   wire signed[7:0] _00005e_00006057;
   wire signed[7:0] _00005e_00006058;
   wire signed[7:0] _00005e_00006059;
   wire signed[7:0] _00005e_00006060;
   wire [0:0] _00005e_00006061;

   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer0_00003aT0 layer0(.clk(_00005e_00006045),.rst(_00005e_00006046),.req(_00005e_00006047),._00003a59(_00005e_00006053),.ack__layer(_00005e_00006048),._00003a57(_00005e_00006054),._00003a58(_00005e_00006055),._00003a106(_00005e_00006057),._00003a107(_00005e_00006058));
   neural__network_00003aT1_00003a_00003aneural__network_00003aT00_00003a_00003alayer1_00003aT0 layer1(.clk(_00005e_00006049),.rst(_00005e_00006050),.req(_00005e_00006051),._00003a123(_00005e_00006059),._00003a124(_00005e_00006060),.ack__layer(_00005e_00006052),._00003a125(_00005e_00006061),._00003a77(_00005e_00006056));
   assign _00005e_00006045 = clk;

   assign _00005e_00006046 = rst;

   assign _00005e_00006047 = req;

   assign ack__0 = _00005e_00006048;

   assign _00005e_00006049 = clk;

   assign _00005e_00006050 = rst;

   assign _00005e_00006051 = ack__0;

   assign ack__1 = _00005e_00006052;

   assign ack__fill = ack__inputs;

   assign fill__inputs = ((fill & ~ack__inputs) & ~flag__inputs);

   assign fill__outputs = ((ack__1 & ~ack__network) & ~flag__outputs);

   assign channel__inputs_00003a45_00003a_00003atrig__w = _00003a61;

   assign channel__inputs_00003a45_00003a_00003aabus__w = _00003a62;

   assign channel__inputs_00003a45_00003a_00003adbus__w = _00003a63;

   assign _00005e_00006053 = channel__inputs_00003a45_00003a_00003adbus__r;

   assign channel__inputs_00003a45_00003a_00003atrig__r = _00005e_00006054;

   assign channel__inputs_00003a45_00003a_00003aabus__r = _00005e_00006055;

   assign _00003a89 = channel__outputs_00003a74_00003a_00003areg__0;

   assign channel__outputs_00003a74_00003a_00003areg__0 = _00005e_00006056;

   assign channel__outputs_00003a74_00003a_00003arinc_00003a88_00003a_00003aabus__r = _00003a90;

   assign channel__a0_00003a102_00003a_00003areg__0 = _00005e_00006057;

   assign channel__a0_00003a102_00003a_00003areg__1 = _00005e_00006058;

   assign _00005e_00006059 = channel__a0_00003a102_00003a_00003areg__0;

   assign _00005e_00006060 = channel__a0_00003a102_00003a_00003areg__1;

   assign channel__a0_00003a102_00003a_00003arinc_00003a122_00003a_00003aabus__r = _00005e_00006061;

   always @( posedge clk ) begin : _00003a447
      begin : _00003a426
         if ((rst == 32'd1)) begin : _00003a415
            _00003a62 <= -32'd1;
         end
         _00003a61 <= 32'd0;
      end
      begin : _00003a427
         if ((rst == 32'd1)) begin : _00003a416
            _00003a9 <= -32'd1;
            _00003a8 <= 32'd0;
         end
      end
      if (rst) begin : _00003a428
         address__inputs <= 32'd0;
         flag__inputs <= 32'd0;
         ack__inputs <= 32'd0;
      end
      else if (fill__inputs) begin : _00003a429
         begin : _00003a421
            if ((rst == 32'd0)) begin : _00003a420
               if ((_00003a8 == 32'd1)) begin : _00003a418
                  begin : _00003a417
                     _00003a8 = 32'd0;
                     value__inputs = _00003a10;
                     flag__inputs = 32'd1;
                  end
               end
               else begin : _00003a419
                  _00003a9 <= (_00003a9 + 32'd1);
                  _00003a8 <= 32'd1;
               end
            end
         end
      end
      else if (flag__inputs) begin : _00003a430
         begin : _00003a424
            address__inputs = (address__inputs + 32'd1);
            flag__inputs = 32'd0;
            if ((address__inputs == 32'd2)) begin : _00003a422
               ack__inputs = 32'd1;
            end
         end
         begin : _00003a425
            if ((rst == 32'd0)) begin : _00003a423
               _00003a62 <= (_00003a62 + 32'd1);
               _00003a61 <= 32'd1;
               _00003a63 <= value__inputs;
            end
         end
      end
      else begin : _00003a431
         flag__inputs <= 32'd0;
      end
   end   always @( posedge clk ) begin : _00003a448
      begin : _00003a441
         if ((rst == 32'd1)) begin : _00003a432
            _00003a33 <= -32'd1;
         end
         _00003a32 <= 32'd0;
      end
      begin : _00003a442
         if ((rst == 32'd1)) begin : _00003a433
            _00003a90 <= 32'd0;
         end
      end
      if (rst) begin : _00003a443
         address__outputs <= 32'd0;
         flag__outputs <= 32'd0;
         ack__network <= 32'd0;
      end
      else if (fill__outputs) begin : _00003a444
         begin : _00003a436
            if ((rst == 32'd0)) begin : _00003a435
case(_00003a90)
                  32'd0: begin : _00003a434
                     value__outputs <= _00003a89;
                  end               endcase

               flag__outputs <= 32'd1;
               _00003a90 <= ((_00003a90 + 32'd1) == 32'd1) == 1 ? (_00003a90 + 32'd1) : 32'd0;
            end
         end
      end
      else if (flag__outputs) begin : _00003a445
         begin : _00003a439
            address__outputs = (address__outputs + 32'd1);
            flag__outputs = 32'd0;
            if ((address__outputs == 32'd1)) begin : _00003a437
               ack__network = 32'd1;
            end
         end
         begin : _00003a440
            if ((rst == 32'd0)) begin : _00003a438
               _00003a33 <= ((_00003a33 + 32'd1) == 32'd1) == 1 ? (_00003a33 + 32'd1) : 32'd0;
               _00003a32 <= 32'd1;
               _00003a34 <= value__outputs;
            end
         end
      end
      else begin : _00003a446
         flag__outputs <= 32'd0;
      end
   end   always @( negedge clk ) begin : _00003a414
      channel__inputs_00003a45_00003a_00003adbus__r <= channel__inputs_00003a45_00003a_00003amem[channel__inputs_00003a45_00003a_00003aabus__r];
      if (channel__inputs_00003a45_00003a_00003atrig__w) begin : _00003a413
         channel__inputs_00003a45_00003a_00003amem[channel__inputs_00003a45_00003a_00003aabus__w] <= channel__inputs_00003a45_00003a_00003adbus__w;
      end
   end
endmodule