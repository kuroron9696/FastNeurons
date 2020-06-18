require_relative '../../lib/fast_neurons'
require_relative '../../lib/mnist_loader'

puts "Loading images"

# Load MNIST.
mnist = MNISTLoader.new("../../assets/t10k-images-idx3-ubyte.gz", "../../assets/t10k-labels-idx1-ubyte.gz")
images = mnist.load_images

puts "Initializing network"

# Make a restricted boltzmann machine.
rbm = FastNeurons::RBM.new([784,5], :Bernoulli)

# Set up the parameters to random values.
rbm.randomize

# Load learned restricted boltzmann machine from JSON file.
#rbm.load_network("network.json")

images = images.map { |image| mnist.normalize(image).flatten }
imgs = images.map { |image| mnist.binarize(image).flatten }

puts "Runnning..."

c = 0
1.times do
  imgs.each_with_index do |inputs,index|

    if c > 50
      c = 0
      break
    end

    rbm.input(inputs) # Inputs input data.

    rbm.run(1)
    mnist.print_ascii(inputs)
    c += 1
  end
end

puts "\nUnderstood!\n\n"
gets

c = 0
imgs.each_with_index do |inputs,index|

  if c > 50
    break
  end

  mnist.print_ascii(inputs)
  rbm.reconstruct(inputs)
  mnist.print_ascii(rbm.get_outputs)

  c += 1
end

# Save learned network.
#rbm.save_network("network.json")
