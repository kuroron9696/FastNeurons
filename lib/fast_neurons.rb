require 'nmatrix'
require 'json'
require 'random_bell'
require_relative 'models/NN.rb'
require_relative 'models/RBM.rb'

SCALE = 1.0507009873554804934193349852946
ALPHA = 1.6732632423543772848170429916717

# FastNeurons is a simple and fast library using NMatrix for building neural networks.<br>
# Currently, it supports fully connected neural network and restricted boltzmann machine.<br>
# More models will be added gradually.<br>
# @version 1.9.0
# @since 1.0.0
# @author Ryota Sakai, Yusuke Tomimoto
module FastNeurons
  # Apply linear function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to linear function
  # @since 1.1.0
  def self.linear(z)
    return z
  end

  # Apply sigmoid function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to sigmoid function
  # @since 1.1.0
  def self.sigmoid(z)
    return ((-z).exp + 1) ** (-1)
  end

  # Apply tanh function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to tanh function
  # @since 1.1.0
  def self.tanh(z)
    pos_exp = z.exp
    neg_exp = (-z).exp
    return (pos_exp - neg_exp) / (pos_exp + neg_exp)
  end

  # Apply relu function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to relu function
  # @since 1.1.0
  def self.relu(z)
    return (z + z.abs) / 2.0
  end

  # Apply leaky relu function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to leaky relu function
  # @since 1.1.0
  def self.leakyrelu(z)
    return N[z.map{ |x| x > 0.0 ? x : 0.01 * x }.to_a.flatten].transpose
  end

  # Apply elu function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to elu function
  # @since 1.1.0
  def self.elu(z)
    return N[z.map{ |x| x > 0.0 ? x : (Math.exp(x) - 1) }.to_a.flatten].transpose
  end

  # Apply selu function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to selu function
  # @since 1.1.0
  def self.selu(z)
    return N[z.map{ |x| x > 0.0 ? x * SCALE : ALPHA * (Math.exp(x) - 1) * SCALE }.to_a.flatten].transpose
  end

  # Apply softplus function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to softplus function
  # @since 1.1.0
  def self.softplus(z)
    return (z.exp + 1.0).log
  end

  # Apply swish function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to swish function
  # @since 1.1.0
  def self.swish(z)
    return z * sigmoid(z)
  end

  # Apply mish function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to mish function
  # @since 1.1.0
  def self.mish(z)
    return z * tanh(softplus(z))
  end

  # Apply softmax function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to softmax function
  # @since 1.5.0
  def self.softmax(z)
    exp_z = (z - z.max[0]).exp
    return exp_z / exp_z.sum[0]
  end

  # Differentiate linear function.
  # @param [NMatrix] a a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  # @since 1.1.0
  def self.differentiate_linear(a)
    return NMatrix.ones_like(a)
  end

  # Differentiate sigmoid function.
  # @param [NMatrix] a a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  # @since 1.1.0
  def self.differentiate_sigmoid(a)
    return (-a + 1.0) * a
  end

  # Differentiate tanh function.
  # @param [NMatrix] a a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  # @since 1.1.0
  def self.differentiate_tanh(a)
    return -(a ** 2) + 1.0
  end

  # Differentiate relu function.
  # @param [NMatrix] z a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  # @since 1.1.0
  def self.differentiate_relu(z)
    return N[z.map{ |x| x > 0.0 ? 1.0 : 0.0 }.to_a.flatten].transpose
  end

  # Differentiate leaky relu function.
  # @param [NMatrix] z a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  # @since 1.1.0
  def self.differentiate_leakyrelu(z)
    return N[z.map{ |x| x > 0.0 ? 1.0 : 0.01 }.to_a.flatten].transpose
  end

  # Differentiate elu function.
  # @param [NMatrix] z a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  # @since 1.1.0
  def self.differentiate_elu(z)
    return N[z.map{ |x| x > 0.0 ? 1.0 : Math.exp(x) }.to_a.flatten].transpose
  end

  # Differentiate selu function.
  # @param [NMatrix] z a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  # @since 1.1.0
  def self.differentiate_selu(z)
    return N[z.map{ |x| x > 0.0 ? SCALE : ALPHA * Math.exp(x) * SCALE }.to_a.flatten].transpose
  end

  # The derivative of softplus is the same as sigmoid function.

  # Differentiate swish function.
  # @param [NMatrix] z a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  # @since 1.1.0
  def self.differentiate_swish(z)
    a = swish(z)
    return a + (-a + 1) * sigmoid(z)
  end

  # Differentiate mish function.
  # @param [NMatrix] z a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  # @since 1.1.0
  def self.differentiate_mish(z)
    omega = (z + 1) * 4 + (z * 2).exp * 4 + (z * 3).exp + (z * 4 + 6) * z.exp
    delta = z.exp * 2 + (z * 2).exp + 2
    return (z.exp * omega) / (delta ** 2)
  end

  # Differentiate softmax function.
  # @param [NMatrix] t a vector of NMatrix containing teaching data
  # @param [NMatrix] a a vector of NMatrix containing outputs of neural network
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  # @since 1.5.0
  def self.differentiate_softmax(t, a)
    return (a - t)
  end

  # activation functions
  Linear = { antiderivative: method(:linear), derivative: method(:differentiate_linear) }
  Sigmoid = { antiderivative: method(:sigmoid), derivative: method(:differentiate_sigmoid) }
  Tanh = { antiderivative: method(:tanh), derivative: method(:differentiate_tanh) }
  ReLU = { antiderivative: method(:relu), derivative: method(:differentiate_relu) }
  LeakyReLU = { antiderivative: method(:leakyrelu), derivative: method(:differentiate_leakyrelu) }
  Elu = { antiderivative: method(:elu), derivative: method(:differentiate_elu) }
  SElu = { antiderivative: method(:selu), derivative: method(:differentiate_selu) }
  Softplus = { antiderivative: method(:softplus), derivative: method(:sigmoid) }
  Swish = { antiderivative: method(:swish), derivative: method(:differentiate_swish) }
  Mish = { antiderivative: method(:mish), derivative: method(:differentiate_mish) }
  Softmax = { antiderivative: method(:softmax), derivative: method(:differentiate_softmax) }

  # Compute the mean squared error.
  # @param [NMatrix] t a vector of NMatrix containing teaching data
  # @param [NMatrix] a a vector of NMatrix containing outputs of neural network
  # @return [Float] loss value
  # @since 1.5.0
  def self.mean_square(t, a)
    return ((t - a) ** 2).sum[0] / a.size
  end

  # Compute the squared error.
  # @param [NMatrix] t a vector of NMatrix containing teaching data
  # @param [NMatrix] a a vector of NMatrix containing outputs of neural network
  # @return [Float] loss value
  # @since 1.9.0
  def self.squared_error(t, a)
    return ((t - a) ** 2).sum[0] / 2.0
  end

  # Compute the cross entropy error.
  # @param [NMatrix] t a vector of NMatrix containing teaching data
  # @param [NMatrix] a a vector of NMatrix containing outputs of neural network
  # @return [Float] loss value
  # @since 1.5.0
  def self.cross_entropy(t, a)
    delta = 1e-7
    return -(t * (a + delta).log).sum[0]
  end

  # Differentiate the mean squared error function.
  # @param [NMatrix] t a vector of NMatrix containing teaching data
  # @param [NMatrix] a a vector of NMatrix containing outputs of neural network
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  # @since 1.5.0
  def self.differentiate_mean_square(t, a)
    return -(t - a) * (2.0 / a.size)
  end

  # Differentiate the squared error function.
  # @param [NMatrix] t a vector of NMatrix containing teaching data
  # @param [NMatrix] a a vector of NMatrix containing outputs of neural network
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  # @since 1.5.0
  def self.differentiate_squared_error(t, a)
    return -(t - a)
  end

  # Differentiate the cross entropy error function.
  # @param [NMatrix] t a vector of NMatrix containing teaching data
  # @param [NMatrix] a a vector of NMatrix containing outputs of neural network
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  # @since 1.5.0
  def self.differentiate_cross_entropy(t, a)
    return -(t / a)
  end

  # loss functions
  MeanSquare = { antiderivative: method(:mean_square), derivative: method(:differentiate_mean_square) }
  SquaredError = { antiderivative: method(:squared_error), derivative: method(:differentiate_squared_error) }
  CrossEntropy = { antiderivative: method(:cross_entropy), derivative: method(:differentiate_cross_entropy) }
end
