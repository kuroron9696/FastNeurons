require 'nmatrix'
require_relative 'fast_neurons'
#nn = FastNeurons::NN.new([2,3,3,2]) # ネットワークの作成
#nn.randomize
File.open("sample.txt", "w+") do |f|

end

File.open("network.txt","r+") do |f|
  columns = f.gets.chomp!.split(',').map!{ |item| item.delete("/[\-]/").gsub(" ","").to_i}
  neuron_columns = f.gets.chomp!.split(',').map!{ |item| item.delete("/[\-]/").gsub(" ","").to_i}

  biases = []
  neuron_columns.size.times do |i|
    biases.push(N[f.gets.chomp!.split(',').map!{ |item| item.delete("/[\-]/").gsub(" ","").to_f}].transpose)
  end
  puts "#{biases}"

  weights = []
  weights_geometry = neuron_columns.zip(columns[0..-2])
  neuron_columns.size.times do |i|
    sliced = f.gets.chomp!.split(',').map!{ |item| item.delete("/[\-]/").gsub(" ","").to_f}.to_a
    weights.push(NMatrix.new(weights_geometry[i],sliced,dtype: :float64))
  end
  puts "#{weights}"
end
