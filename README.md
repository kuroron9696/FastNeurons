# FastNeurons
A simple and fast neural network library for Ruby using NMatrix.
## Example
- learning xor
```ruby
# learning data
data = [[0,0], [0,1], [1,0], [1,1]]

# teaching data
t = [[0], [1], [1], [0]]

# Initialize a neural network.
nn = FastNeurons::NN.new([2, 2, 1], [:Tanh, :Linear])

# Set up the parameters to random values.
nn.randomize

# learning
100.times do
  data.each_with_index do |inputs,i|

    nn.input(inputs,t[i]) # Input training data and teaching data.
    nn.run(1) # Compute feed forward propagation and backpropagation.

    puts "ans: #{t[i]}, expected: #{nn.get_outputs}"
  end
end

# confirmation of learned network
data.each_with_index do |inputs,i|
  nn.input(inputs,t[i])
  nn.run(1)

  puts "input: #{inputs}, ans: #{t[i]}, expected: #{nn.get_outputs}"
end
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

### Learning
- Supervised learning

### Activation Functions
|  operability confirmed |  operability unconfirmed  |
| :----: | :----: |
|  Sigmoid, Linear  |  Tanh, ReLU, Leaky ReLU, ELU, SELU, Softplus, Swish, Mish  |

## Warning
- This library is in the middle of implementation.Over time, more features will be added.
- This library needs to install gems "NMatrix" and "RandomBell".
