require_relative '../../lib/fast_neurons'

# Make a restricted boltzmann machine.
rbm = FastNeurons::RBM.new([6,5], :Bernoulli)

# Set up the parameters to random values.
rbm.randomize

# Set mini-batch size.
rbm.set_batch_size(1)

# Load learned restricted boltzmann machine.
#rbm.load_network("network.json")

# input data
data = [[1,1,1,0,0,0]]

# learning
100.times do |i|
  data.each do |input|
    rbm.input(input) # Inputs input data.

    rbm.run(1) # learn
    rbm.compute_cross_entropy
  end

  cost  = rbm.compute_mean_cross_entropy(data.size)
  puts "epoch: #{i}, cost: #{cost}"
end

puts "\nUnderstood!"

rbm.reconstruct(data[0])
puts "input: #{data[0]}"
puts "output: #{rbm.get_outputs}"
puts "P(v|h): #{rbm.get_visible_probability}"

# Save learned network.
rbm.save_network("network.json")
