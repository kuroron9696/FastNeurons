require_relative '../../lib/fast_neurons'
require_relative '../../lib/mnist_loader'
require 'gnuplot'

puts "Loading images"

# Load MNIST.
mnist = MNISTLoader.new("../../assets/t10k-images-idx3-ubyte.gz", "../../assets/t10k-labels-idx1-ubyte.gz")
images = mnist.load_images

puts "Initializing network"
loss = []

# Initialize a neural network.
nn = FastNeurons::NN.new([784, 15, 784], [:Sigmoid, :Sigmoid], :SquaredError)

# Set learning rate.
nn.set_learning_rate(0.1)

# Set mini-batch size.
#nn.set_batch_size(1)

# Set up the parameters to random values.
nn.randomize(:GlorotNormal, :Zeros)

# Load learned network.
#nn.load_network("network.json")

# Normalize pixel values.
imgs = images.map { |image| mnist.normalize(image).flatten }

puts "Runnning..."

# learning
# An Autoencoder is shown below as a sample.
1.times do
  imgs.each.with_index do |inputs,index|

    nn.input(inputs,inputs) # Input training data and teaching data.
    nn.run(1) # Compute feed forward propagation and backpropagation.

    mnist.print_ascii(inputs) # Output training data.
    mnist.print_ascii(nn.get_outputs) # Output the output of neural network.
    #nn.compute_loss
    #loss << nn.get_loss
    #nn.initialize_loss
  end
end

puts "Understood!"
nn.save_network("network.json") # save learned network
gets

# confirmation of network
10.times do
  nn.input_to(1,15.times.map{rand()})
  nn.propagate_from(1)
  mnist.print_ascii(nn.get_outputs)
end

num = Array.new(loss.size){ |i| i }

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|    
    plot.terminal "png"
    plot.output "learning_curve_mnist.png"
    plot.xlabel "Steps"
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
