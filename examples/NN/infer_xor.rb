require_relative '../../lib/fast_neurons'
require "gnuplot"

puts "Initializing network"

data = [[0,0],[1,0],[0,1],[1,1]]
t = [[0],[1],[1],[0]]

# Make a neural network.
nn = FastNeurons::NN.new([2, 2, 1], [:ReLU, :Linear], :MeanSquare)

puts "Loading network..."
# Load learned network.
nn.load_network("xor2.json")

# confirmation of learned network
data.each_with_index do |inputs,i|
  nn.input(inputs, t[i])
  nn.propagate

  puts "input: #{inputs}, ans: #{t[i]}, expected: #{nn.get_outputs}"
end