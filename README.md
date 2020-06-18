# FastNeurons
A simple and fast neural network library for Ruby using NMatrix.
## Example
- learning xor
```ruby
inputs = [[0,0], [0,1], [1,0], [1,1]]
t = [[0], [1], [1], [0]]

nn = FastNeurons::NN.new([2, 2, 1], [:Tanh, :Linear])
nn.randomize

100.times do
  data.each_with_index do |inputs,i|

    nn.input(inputs,t[i]) # Inputs input data and training data
    nn.run(1) # propagate and backpropagate

    puts "ans: #{t[i]}, expected: #{nn.get_outputs[0]}"
  end
end

# confirmation of learned network
data.each_with_index do |inputs,i|
  nn.input(inputs,t[i])
  nn.run(1)

  puts "input: #{inputs}, ans: #{t[i]}, expected: #{nn.get_outputs[0]}"
end
```

- restricted boltzmannn machine
```ruby
inputs = [[1,1,1,0,0,0]]
rbm = FastNeurons::RBM.new([6,5], :Bernoulli)

rbm.randomize

100.times do |i|
  inputs.each do |input|
    rbm.input(input)
    rbm.run(1)
    puts rbm.get_outputs
  end
end

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
