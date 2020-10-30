require_relative '../../lib/fast_neurons'
require "gnuplot"

puts "Initializing network"

data = [[0,0],[0,1],[1,0],[1,1]]
t = [[0],[1],[1],[0]]
loss = []

# Make a neural network.
nn = FastNeurons::NN.new([2, 2, 1], [:Tanh, :Linear], :MeanSquare)

# Set up the parameters to random values.
nn.randomize(:GlorotNormal, :Zeros)

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
    nn.compute_loss # Compute and output the loss value.

    puts "input: #{inputs}, ans: #{t[i]}, expected: #{nn.get_outputs}"
  end
  loss << nn.get_loss
  nn.initialize_loss
end

puts "Understood!"

# confirmation of learned network
data.each_with_index do |inputs,i|
  nn.input(inputs, t[i])
  nn.propagate

  puts "input: #{inputs}, ans: #{t[i]}, expected: #{nn.get_outputs}"
end

num = Array.new(1000){ |i| i }

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|    
    plot.terminal "png"
    plot.output "learning_curve_xor.png"
    plot.xlabel "Epochs"
    plot.ylabel "Loss"
    plot.yrange "[0:#{loss.max}]"
    plot.xrange "[0:#{loss.size}]"

    plot.data << Gnuplot::DataSet.new( [num, loss] ) do |ds|
      ds.with = "lines"
      ds.linecolor = "black"
      ds.linewidth = 3
      ds.notitle
    end
  end
end

nn.save_network("xor.json") # save learned network