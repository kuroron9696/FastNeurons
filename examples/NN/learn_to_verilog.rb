require_relative '../../lib/fast_neurons'
require_relative '../../lib/models/NN/NN4H'

puts "Initializing network"

tanh = proc{ |i| Math.tanh(i) }
relu = proc{ |i| (i + i.abs) / 2.0 }
linear = proc{ |i| i }

data = [[0,0],[0,1],[1,0],[1,1]]
t = [[0],[1],[1],[0]]

# Make a neural network.
nn = FastNeurons::NN.new([2, 2, 1], [:ReLU, :Linear])

# Set up the parameters to random values.
nn.randomize

# Load learned network.
#nn.load_network("xor.json")

puts "Runnning..."
# learning
1000.times do
  data.each_with_index do |inputs,i|

    nn.input(inputs) # Inputs input data and teaching data.
    nn.set_teaching_data(t[i]) # Set teaching data of neural network.

    # Setting of teaching data can also be as below.
    # nn.input(inputs, t[i])

    nn.run(1) # propagate and backpropagate

    puts "input: #{inputs}, ans: #{t[i]}, expected: #{nn.get_outputs}"
  end
end

puts "Understood!"

# confirmation of learned network
data.each_with_index do |inputs,i|
  nn.input(inputs,t[i])
  nn.propagate

  puts "input: #{inputs}, ans: #{t[i]}, expected: #{nn.get_outputs}"
end

#nn.save_network("xor.json") # save learned network

# Instantiate neural network module written by HDLRuby.
nn.instantiate([relu, linear], 4, 4, 4, [1, 1])

# Generate the Verilog description.
nn.to_verilog("xor")