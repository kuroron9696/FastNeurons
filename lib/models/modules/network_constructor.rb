# 与えられた構造に基づいてニューラルネットワークを生成するモジュール

require "std/memory.rb"
require "std/fixpoint.rb"
require_relative "neurons_layer.rb"
require_relative "quantize.rb"

include HDLRuby::High::Std

system :network_constructor do |columns, functions, types, integer_width, decimal_width, address_width, inputs, outputs, weights, biases|  
  columns = columns.to_a
  integer_width = integer_width.to_i
  decimal_width = decimal_width.to_i
  address_width = address_width.to_i

  # 重みを持つ層の形
  neuron_columns = columns[1..-1]
  
  # 活性化関数の配列の作成
  unless functions.instance_of?(Array) then
    functions = Array.new(neuron_columns.size, functions)
  end
  
  # データ型の配列の作成
  if types.instance_of?(HDLRuby::High::TypeDef) then
    types = Array.new(columns.size, types)
  end

  functions.map{ |func| func.to_proc }
  types.map{ |typ| typ.to_type }
  #------------------入出力の宣言-------------------
  input :clk, :rst, :req, :fill
  output :ack_fill, :ack_network

  # ackのジェネリック宣言
  # 隠れ層と出力層の数だけ宣言
  ack = neuron_columns.size.times.map{ |i| inner :"ack_#{i}"}  

  #---------------チャンネルの宣言-------------------
  # ニューラルネットワークへの入力を格納するメモリ
  mem_dual(types[0], columns[0], clk, rst, rinc: :rst, winc: :rst).(:channel_inputs)

  # ニューラルネットワークからの出力を格納するメモリ
  mem_file(types[-1], columns[-1] , clk, rst, rinc: :rst, winc: :rst, anum: :rst).(:channel_outputs)

  # ニューロンの出力値を格納するメモリ
  channel_a = (neuron_columns.size - 1).times.map{ |i| mem_file(types[i+1], neuron_columns[i] , clk, rst, rinc: :rst, winc: :rst, anum: :rst).(:"channel_a#{i}") }  

  #---------------ブランチの宣言-------------------
  # 入力値のRead用ポート作成
  reader_inputs = channel_inputs.branch(:rinc)

  # 入力値のWrite用ポート作成
  writer_inputs = channel_inputs.branch(:winc)

  # 出力値のR/W用ポート
  accessor_outputs = channel_outputs.branch(:anum)

  # 出力値のRead用ポート
  reader_outputs = channel_outputs.branch(:rinc)

  # 隠れ層の出力値のRead用ポート作成
  reader_a = (neuron_columns.size - 1).times.map{ |i| channel_a[i].branch(:rinc) }

  # ニューラルネットワークの出力値のR/W用ポート作成
  accessor_a = (neuron_columns.size - 1).times.map{ |i| channel_a[i].branch(:anum) }
  accessor_a << accessor_outputs

  # アクセスの固定化
  a = neuron_columns.size.times.map{ |i| neuron_columns[i].times.map{ |j| accessor_a[i].wrap(j) } }
  #---------------neurons_layerのインスタンス生成-------------------  
  neuron_columns.size.times do |i|
    if i == 0 then
      neurons_layer(functions[i], types[i+1], integer_width, decimal_width, address_width, columns[i], columns[i+1], reader_inputs, a[i], weights[i], biases[i]).(:"layer#{i}").(clk, rst, req, ack[i])
    else
      neurons_layer(functions[i], types[i+1], integer_width, decimal_width, address_width, columns[i], columns[i+1], reader_a[i-1], a[i], weights[i], biases[i]).(:"layer#{i}").(clk, rst, ack[i-1], ack[i])
    end
  end
  
  #---------------入力値の書き込み-------------------
  inner :fill_inputs # 入力値への書き込み命令
  types[0].inner :value_inputs # メモリから読み出した値
  [columns[0].width].inner :address_inputs # アドレス
  inner :flag_inputs # 読み出し完了のflag
  inner :ack_inputs # 書き込み完了のack  
  
  ack_fill <= ack_inputs
  fill_inputs <= fill & ~ack_inputs & ~flag_inputs

  par(clk.posedge) do
    hif(rst) do      
      address_inputs <= 0
      flag_inputs <= 0            
      ack_inputs <= 0
    end
    helsif(fill_inputs) do      
      inputs.read(value_inputs) { flag_inputs <= 1 }                
    end
    helsif(flag_inputs) do                
      writer_inputs.write(value_inputs) do
        seq do
          address_inputs <= address_inputs + 1
          flag_inputs <= 0
          
          hif(address_inputs == columns[0]) do
            ack_inputs <= 1
          end
        end
      end          
    end  
    helse do
      flag_inputs <= 0
    end
  end

  #---------------出力値の書き込み-------------------
  inner :fill_outputs
  types[-1].inner :value_outputs # メモリから読み出した値
  [columns[-1].width].inner :address_outputs # アドレス
  inner :flag_outputs # 読み出し完了のflag

  fill_outputs <= ack[-1] & ~ack_network & ~flag_outputs

  par(clk.posedge) do
    hif(rst) do
      address_outputs <= 0      
      flag_outputs <= 0
      ack_network <= 0
    end
    helsif(fill_outputs) do
      reader_outputs.read(value_outputs) { flag_outputs <= 1 }
    end
    helsif(flag_outputs) do
      outputs.write(value_outputs) do
        seq do
          address_outputs <= address_outputs + 1
          flag_outputs <= 0

          hif(address_outputs == columns[-1]) do
            ack_network <= 1
          end
        end
      end
    end
    helse do
      flag_outputs <= 0
    end
  end      
end