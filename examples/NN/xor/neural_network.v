`timescale 1ps/1ps

module neural__network_00003aT1( clk, rst, req, fill, ack__fill, ack__network ); 
   input clk;
   input rst;
   input req;
   input fill;
   output ack__fill;
   output ack__network;
   wire rom__inputs_00003a1_00003a_00003atrig__r;
   reg signed[7:0] rom__inputs_00003a1_00003a_00003adbus__r;
   wire [0:0] rom__inputs_00003a1_00003a_00003aabus__r;
   wire signed[7:0] rom__inputs_00003a1_00003a_00003amem  :0[0:1];
   wire ram__outputs_00003a16_00003a_00003atrig__r;
   wire ram__outputs_00003a16_00003a_00003atrig__w;
   reg signed[7:0] ram__outputs_00003a16_00003a_00003adbus__r;
   wire signed[7:0] ram__outputs_00003a16_00003a_00003adbus__w;
   wire [0:0] ram__outputs_00003a16_00003a_00003aabus__r;
   wire [0:0] ram__outputs_00003a16_00003a_00003aabus__w;
   wire signed[7:0] ram__outputs_00003a16_00003a_00003amem  :0[0:0];
   wire _00005e_0000600;
   wire _00005e_0000601;
   wire _00005e_0000602;
   wire _00005e_0000603;
   wire _00005e_0000604;
   wire _00005e_0000605;
   wire signed[7:0] _00005e_0000606;
   wire _00005e_0000607;
   wire [0:0] _00005e_0000608;
   wire _00005e_0000609;
   wire [0:0] _00005e_00006010;
   wire signed[7:0] _00005e_00006011;

   neural__network_00003aT1_00003a_00003aneural__network_00003aT00 neural__network(.clk(_00005e_0000600),.rst(_00005e_0000601),.req(_00005e_0000602),.fill(_00005e_0000603),._00003a10(_00005e_0000606),.ack__fill(_00005e_0000604),.ack__network(_00005e_0000605),._00003a8(_00005e_0000607),._00003a9(_00005e_0000608),._00003a32(_00005e_0000609),._00003a33(_00005e_00006010),._00003a34(_00005e_00006011));
   assign _00005e_0000600 = clk;

   assign _00005e_0000601 = rst;

   assign _00005e_0000602 = req;

   assign _00005e_0000603 = fill;

   assign ack__fill = _00005e_0000604;

   assign ack__network = _00005e_0000605;

   assign _00005e_0000606 = rom__inputs_00003a1_00003a_00003adbus__r;

   assign _00005e_0000607 = rom__inputs_00003a1_00003a_00003atrig__r;

   assign _00005e_0000608 = rom__inputs_00003a1_00003a_00003aabus__r;

   assign _00005e_0000609 = ram__outputs_00003a16_00003a_00003atrig__w;

   assign _00005e_00006010 = ram__outputs_00003a16_00003a_00003aabus__w;

   assign _00005e_00006011 = ram__outputs_00003a16_00003a_00003adbus__w;

   always @( negedge clk ) begin

      rom__inputs_00003a1_00003a_00003adbus__r <= rom__inputs_00003a1_00003a_00003amem[rom__inputs_00003a1_00003a_00003aabus__r];

   end

   always @( negedge clk ) begin

      ram__outputs_00003a16_00003a_00003adbus__r <= ram__outputs_00003a16_00003a_00003amem[ram__outputs_00003a16_00003a_00003aabus__r];

      if (ram__outputs_00003a16_00003a_00003atrig__w) begin
         ram__outputs_00003a16_00003a_00003amem[ram__outputs_00003a16_00003a_00003aabus__w] <= ram__outputs_00003a16_00003a_00003adbus__w;
      end

   end

   initial begin

      rom__inputs_00003a1_00003a_00003amem[32'd0] = $signed(32'd16);

      rom__inputs_00003a1_00003a_00003amem[32'd1] = $signed(32'd16);

   end

endmodule