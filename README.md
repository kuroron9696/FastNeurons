# FastNeurons
A simple and fast neural network library for Ruby using NMatrix.

## Warning
- This library is in the middle of implementation.Over time, more features will be added.
- This library needs to install gems 'NMatrix', 'RandomBell', 'HDLRuby'.

## Example
- learning xor

```ruby
# input data
data = [[0,0],[0,1],[1,0],[1,1]]

# teaching data
t = [[0],[1],[1],[0]]

# Initialize a neural network.
nn = FastNeurons::NN.new([2, 2, 1], [:ReLU, :Linear], :MeanSquare)

# Set up the parameters to random values.
nn.randomize(:HeNormal, :Zeros)

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
end

# confirmation of learned network
data.each_with_index do |inputs,i|
  nn.input(inputs, t[i])
  nn.propagate

  puts "input: #{inputs}, ans: #{t[i]}, expected: #{nn.get_outputs}"
end

nn.save_network("xor.json") # save learned network
```

- restricted boltzmannn machine
```ruby
# training data
data = [[1,1,1,0,0,0]]

# Initialize a restricted boltzmann machine.
rbm = FastNeurons::RBM.new([6,5], :Bernoulli)

# Set up the parameters to random values.
rbm.randomize

# learning
100.times do
  data.each do |inputs|
    rbm.input(inputs) # Input training data.
    rbm.run(1) # Sampling and parameters updating.
    puts rbm.get_outputs # Get the outputs of RBM(= visible units)
  end
end

rbm.reconstruct(data[0]) # Reconstruct input data.
puts "input: #{data[0]}"
puts "output: #{rbm.get_outputs}"
puts "P(v|h): #{rbm.get_visible_probability}"
```
## Feature(currently)
- Create a standard fully connected neural network.
- Create a restricted boltzmann machine.(Bernoulli-Bernoulli RBM, Gaussian-Bernoulli RBM)
- Save&Load learned network to JSON file
- Apply different activation functions to each layer.
- Generate a Verilog description of the neural network from the trained network.(Operation is not guaranteed as it has not been tested on FPGA.)

### Learning
- Supervised learning

### Activation Functions
|  operability confirmed |
| :----: |
|  Sigmoid, Linear, Tanh, ReLU, Leaky ReLU, ELU, SELU, Softplus, Swish, Mish, Softmax  |
