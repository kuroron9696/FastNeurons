# シミュレーション用モジュール
require "std/memory.rb"
require "std/fixpoint.rb"
require_relative "network_constructor.rb"
require_relative "quantize.rb"


system :network_simulator do |columns, functions, types, integer_width, decimal_width, address_width, inputs, weights, biases|
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
  #---------------内部信号の宣言---------------------
  input :clk,   # clock 
        :rst,   # reset
        :req,   # request
        :fill   # 入力値のメモリへの書き込み

  output :ack_fill, # 書き込みのack
         :ack_network # ニューラルネットワークのack

  inputs = quantize(inputs, types[0], decimal_width)
  # NOTE: 入力のメモリに関して
  # network_constructorにはbranchを渡すので、mem_romからmem_dualやmem_fileに変更できる。
  # ただし、branchはrincのみ。つまり、rincのbranchを持つメモリなら何でもOK。
  mem_rom(types[0], columns[0], clk, rst, inputs, rinc: :rst, winc: :rst).(:rom_inputs) # 入力値を格納するrom

  mem_dual(types[-1], columns[-1], clk, rst, rinc: :rst, winc: :rst).(:ram_outputs) # 出力値を格納するram

  reader_inputs = rom_inputs.branch(:rinc) # 入力値の読み出し用branch
  writer_outputs = ram_outputs.branch(:winc) # 出力値の書き込み用branch

  network_constructor(columns, functions, types, integer_width, decimal_width, address_width, reader_inputs, writer_outputs, weights, biases).(:neural_network).(clk, rst, req, fill, ack_fill, ack_network)
end