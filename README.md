# FastNeurons
A simple and fast neural network library for Ruby using NMatrix.
## Example
- learning xor
```ruby
nn = FastNeurons::NN.new([2,1], :Tanh)
inputs = [[0,0], [0,1], [1,0], [1,1]]
t = [[0], [1], [1], [0]]
nn.randomize
inputs.each_with_index do |input, i|
  nn.input(input,t[i])
  nn.run(1)
  puts nn.get_outputs
end
```

- restricted boltzmannn machine
```ruby
rbm = FastNeurons::RBM.new([6,5], :Bernoulli)
inputs = [[1,1,1,0,0,0]]
rbm.randomize
inputs.each do |input|
  rbm.input(input)
  rbm.run(1)
  puts rbm.get_outputs
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
