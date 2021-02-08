# 活性化関数のモジュール

require "std/fixpoint.rb"

include HDLRuby::High::Std

# 活性化関数のモジュール
system :activation_function do |func, typ, integer_width, decimal_width, address_width|
  # ジェネリックパラメータの整合性の確認
  func = func.to_proc
  typ = typ.to_type
  integer_width = integer_width.to_i
  decimal_width = decimal_width.to_i
  address_width = address_width.to_i

  # 活性化関数適用前の計算値
  typ.input :z_value

  # 活性化関数適用後の値
  typ.output :a

  # アドレスに対応する活性化関数の値
  typ.inner :base, :next_data
  
  # アドレスと入力データのアドレスに対応しない部分
  # アドレスは入力データの整数部に対応
  [address_width].inner :address
  typ.inner :remaining
  typ.inner :change

  # 入力データからアドレスとアドレスでない残りを取り出す
  address <= z_value[(z_value.width - 1)..(z_value.width - address_width)]
  remaining <= [[_b1b0] * address_width, z_value[(z_value.width - address_width - 1)..0]]

  # 活性化関数のLUT
  lut(func, typ, integer_width, decimal_width, address_width).(:my_lut).(address, base, next_data)

  # 線形補間
  interpolator(typ, integer_width, address_width).(:my_interpolator).(base, next_data, remaining, a)
end

# module of activation function's LUT
# 活性化関数のLUTを表現するモジュール
# 任意の活性化関数をprocで渡せる
system :lut do |func, typ, integer_width, decimal_width, address_width|
  func = func.to_proc
  typ = typ.to_type
  integer_width = integer_width.to_i
  decimal_width = decimal_width.to_i
  address_width = address_width.to_i

  lut_size = 2 ** address_width

  # address of LUT
  [address_width].input :address

  # value of LUT that corresponds to address
  typ.output :base, :next_data
  
  # points of tanh
  # tanhの点を格納するLUT
  typ[-lut_size].constant lut: initialize_lut(func, lut_size, typ, integer_width, decimal_width, address_width)

  base <= lut[address]

  # アドレスの全ビットが1の場合、次のデータは最後のデータと等しい
  hif(address == (lut_size - 1)) do
    if typ.signed?
      next_data <= lut[0]
    else
      next_data <= lut[address]
    end
  end
  helse do
    hif(address == [_b1b0, [_b1b1] * (address.width - 1)]) do          
      if typ.signed?
        next_data <= lut[address]
      else
        next_data <= lut[address + 1]
      end
    end
    helse { next_data <= lut[address + 1] }  
  end
end

# compute tanh
# LUTの点の間の値を計算するモジュール
system :interpolator do |typ, integer_width, address_width|
  typ = typ.to_type
  shift_bits = integer_width - address_width # シフトさせるビット数

  typ.input :base,       # 入力データのアドレスに対応する値 
            :next_data,  # 入力データの次のアドレスに対応する値
            :remaining   # 入力データのアドレスに対応しない部分(0埋め済み)
  
  # 線形補間した値
  typ.output :interpolated_value

  # 線形補間
  # y = y0 + ( (y1 - y0) / (x1 - x0) ) * (x - x0)
  # y => 線形補間した値
  # x => x0とx1の間の値
  # changeはアドレスの変化量
  # アドレスの変化量は2のべき乗の正の値しかとらないので、
  # 除算はビットシフトで置き換えられる

  # shift_bitsの正負によってビットシフトの方向を変える
  if shift_bits < 0
    interpolated_value <= base + ((next_data - base) << shift_bits.abs) * remaining
  else
    interpolated_value <= base + ((next_data - base) >> shift_bits) * remaining
  end
end

# Make an array consists of a point of any activation function.
# @param [Integer] lut_size the lut_size of LUT
# @return [Array] table an array consists of a point of tanh
def initialize_lut(func, lut_size, typ, integer_width, decimal_width, address_width)
  steps = 2.0 ** (integer_width - address_width)
  
  # データ型が符号付きかどうか判定
  if typ.signed?
    # 表現可能なアドレスの範囲
    starting_point = - (2 ** (integer_width - 1))
    ending_point = 2 ** (integer_width - 1) - 1
        
    range_array = Range.new(starting_point, ending_point).step(steps).to_a
    
    while range_array.size < lut_size
      range_array.append(range_array[-1] + steps)
    end

    # 活性化関数の適用
    table = range_array.map(&func).map{ |value| value.to_fix(decimal_width).to_expr.as(typ) }

    # 配列を分割して順番入れ替え
    sliced = table.each_slice(lut_size/2).to_a
    table = [sliced[1], sliced[0]].flatten
  else
    # 表現可能なアドレスの範囲 
    starting_point = 0
    ending_point = 2 ** (integer_width) - 1

    range_array = Range.new(starting_point, ending_point).step(steps).to_a

    while range_array.size < lut_size
      range_array.append(range_array[-1] + steps)
    end
    
    # 活性化関数の適用
    table = range_array.map(&func).map{ |value| value.to_fix(decimal_width).to_expr.as(typ) }
  end
  
  return table
end