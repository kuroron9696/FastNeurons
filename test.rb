require 'nmatrix'
require_relative 'fast_neurons'
#nn = FastNeurons::NN.new([2,3,3,2]) # ネットワークの作成
#nn.randomize
a = N[[2,2]]
b = a.map{|geo| NMatrix.new([1,geo],1.0)}
File.open("sample.txt", "w+") do |f|

end

File.open("network.txt","r+") do |f|
  columns = f.gets.chomp!.split(',').map!{ |item| item.delete("/[\-]/").gsub(" ","").to_i}
  neuron_columns = f.gets.chomp!.split(',').map!{ |item| item.delete("/[\-]/").gsub(" ","").to_i}

  biases = []
  neuron_columns.size.times do |i|
    biases.append(N[f.gets.chomp!.split(',').map!{ |item| item.delete("/[\-]/").gsub(" ","").to_f}].transpose)
  end
  puts "#{biases}"

  weights = []
  neuron_columns.size.times do |i|
    temp = f.gets.chomp!.split(',').map!{ |item| item.delete("/[\-]/").gsub(" ","").to_f}.each_slice(columns[i]).to_a
    weights.append(N[temp])
  end
  puts "#{weights}"
end
