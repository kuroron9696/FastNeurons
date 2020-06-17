require_relative '../../lib/fast_neurons'

puts "Initializing network"

data = [[0,0],[0,1],[1,0],[1,1]]
t = [[0],[1],[1],[0]]

# Make a neural network.
nn = FastNeurons::NN.new([2,2,1], :Tanh)

# Set up the parameters to random values.
nn.randomize

# Load learned network.
#nn.load_network("network.json")

puts "Runnning..."

# learning
# An Autoencoder is shown below as a sample.
10000.times do
  data.each_with_index do |inputs,i|

    nn.input(inputs,t[i]) # Inputs input data and training data
    nn.run(1) # propagate and backpropagate

    puts t[i]
    puts nn.get_outputs
  end
end

puts "Understood!"
#nn.save_network("network.json") # save learned network
