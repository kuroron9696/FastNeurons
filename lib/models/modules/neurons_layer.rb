# ニューロンの計算モジュール
# 任意の重みとバイアスを適用できる。
# 重みとバイアスはジェネリックパラメータとして配列で渡す。

require "std/memory.rb"
require "std/linear.rb"
require "std/fixpoint.rb"
require_relative "activation_function.rb"
require_relative "mac_counter.rb"
require_relative "quantize.rb"

include HDLRuby::High::Std

system :neurons_layer do |func, typ, integer_width, decimal_width, address_width, input_size, output_size, reader_input, a, weights, bias|
  func = func.to_proc
  typ = typ.to_type
  integer_width = integer_width.to_i
  decimal_width = decimal_width.to_i
  address_width = address_width.to_i
  input_size = input_size.to_i
  output_size = output_size.to_i

  input :clk, :rst, :req
  output :ack_layer

  inner :req_mac
  inner :ack, :ack_mac, :ack_add

  req_mac <= req & ~ack_mac

  par(clk.posedge) do
    hif(rst) do
      ack <= 0
      ack_mac <= 0
      ack_add <= 0
    end    
  end
  #---------------------------------------------------------------------------
  # 入力と重みの積和計算
  # 重みのメモリ  
  channel_w = output_size.times.map{ |i| mem_rom(typ, input_size, clk, rst, quantize(weights[i], typ, decimal_width), rinc: :rst, winc: :rst).(:"channel_w#{i}") }

  # 重みのRead用ポートの作成
  reader_w = output_size.times.map{ |i| channel_w[i].branch(:rinc) }
  
  reader_weights = output_size.times.map{ |i| reader_w[i] }

  # 積和計算の結果の格納用
  mem_file(typ, output_size, clk, rst, anum: :rst).(:channel_accum)

  accum = channel_accum.branch(:anum)
  
  result_mac = output_size.times.map{ |i| accum.wrap(i) }
  
  # 積和演算のモジュール
  # 入力のニューロンの数だけackを出力する
  mac_n1(typ, clk, req_mac, ack, reader_weights, reader_input, result_mac)

  # mac_n1のackのカウンタ
  mac_counter(input_size).(:counter).(clk, ack, rst, ack_mac)
  #---------------------------------------------------------------------------
  # バイアスの計算
  bias = quantize(bias, typ, decimal_width)
  channel_b = output_size.times.map{ |i| mem_rom(typ, 1, clk, rst, bias[i], rinc: :rst, winc: :rst).(:"channel_b#{i}") }

  mem_file(typ, output_size, clk, rst, rinc: :rst, winc: :rst, anum: :rst).(:channel_z)

  reader_bias = output_size.times.map{ |i| channel_b[i].branch(:raddr).wrap(0) }
  accessor_z = channel_z.branch(:anum)
  
  z = output_size.times.map{ |i| accessor_z.wrap(i) }

  add_n(typ, clk, ack_mac, ack_add, result_mac, reader_bias, z)
  #---------------------------------------------------------------------------
  # 活性化関数の適用
  value_z = output_size.times.map{ |i| typ.inner :"value_z#{i}"}
  value_a = output_size.times.map{ |i| typ.inner :"value_a#{i}"}     

  flag_z = output_size.times.map{ |i| inner :"flag_z#{i}"}
  ack_a = output_size.times.map{ |i| inner :"ack_a#{i}"}

  output_size.times do |i|
    activation_function(func, typ, integer_width, decimal_width, address_width).(:"func#{i}").(value_z[i], value_a[i])
  end

  # z(線形変換後の値)のメモリからの読み出し
  par(clk.posedge) do
    hif(ack_add) do
      output_size.times do |i|
        z[i].read(value_z[i]) { flag_z[i] <= 1 }
      end
    end
    helse do
      output_size.times do |i|
        flag_z[i] <= 0
      end
    end
  end

  # a(活性化関数適用後の値)のメモリへの書き出し
  par(clk.posedge) do
    hif(rst) do
      output_size.times do |i|
        ack_a[i] <= 0
      end
    end
    helsif(flag_z.inject(:&)) do
      output_size.times do |i|
        a[i].write(value_a[i]) { ack_a[i] <= 1 }
      end
    end
  end

  ack_layer <= ack_a.inject(:&)
end