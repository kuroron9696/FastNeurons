# A module of counter for times of mac_n1's ack.

system :mac_counter do |layer_size|
  input :clk, :ack, :rst
  output :ack_mac

  [(layer_size + 1).width].inner :q

  par(clk.negedge) do
    hif(rst) do
      q <= 0
      ack_mac <= 0
    end
    helsif(ack) do
      seq do
        q <= q + 1
        hif(q == layer_size) do
          q <= 0
          ack_mac <= 1
        end
      end
    end
  end
end