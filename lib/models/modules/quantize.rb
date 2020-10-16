# Quantize an array of parameters(weights, bias).
# @param [Array] array an array of parameters
# @param [Type] typ the data type of HDLRuby
# @param [Integer] decimal_width the width of decimal part
# @return [Array] an array of quantized values
def quantize(array, typ, decimal_width)
  return array.map{ |value| value.to_fix(decimal_width).to_expr.as(typ) }
end