require_relative './lib/fast_neurons'
require_relative './lib/mnist_loader'

puts "Loading images"

# Load MNIST.
mnist = MNISTLoader.new("assets/t10k-images-idx3-ubyte.gz", "assets/t10k-labels-idx1-ubyte.gz")
images = mnist.load_images

puts "Initializing network"

# Make Neural Network.
nn = FastNeurons::NN.new([784,15,784],:Sigmoid)

# Set up the parameters to random values.
#nn.randomize

# Load learned network.
nn.load_network("network.json")

# Normalize pixel values.
imgs = images.map { |image| mnist.normalize(image).flatten }

puts "Runnning..."

# learning
# An Autoencoder is shown below as a sample.
1.times do
  imgs.each.with_index do |inputs,index|

    nn.input(inputs,inputs) # Inputs input data and training data
    nn.run(1) # propagate and backpropagate

    mnist.print_ascii(inputs) # Outputs training data
    mnist.print_ascii(nn.get_outputs) # Outputs output of neural network
  end
end

puts "Understood!"
nn.save_network("network.json") # save learned network
gets

# confirmation of network
10.times do
  nn.input_hidden(1,15.times.map{rand()})
  nn.propagate_from_hidden(1)
  mnist.print_ascii(nn.get_outputs)
end
