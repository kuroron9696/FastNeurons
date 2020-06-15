require 'nmatrix'
require 'json'

SCALE = 1.0507009873554804934193349852946
ALPHA = 1.6732632423543772848170429916717

# Simple and fast library for building neural networks.
# @since 1.1.0
# @author Ryota Sakai,Yusuke Tomimoto
module FastNeurons
  # Describes a standard fully connected NN based on backpropagation.
  class NN
    # Creates a NN from columns giving each the size
    # of a column of neurons (input and output comprised).
    # If a block is given as argument, it will be used as
    # default transfer fuction (default: sigmoid)
    # constructor
    # @param [Array] columns the array showing the shape of a neural network
    # @param [Symbol or Array] activation_function the name of the activation function you want to use
    # ':Linear', ':Sigmoid', ':Tanh', ':ReLU', ':LeakyReLU', ':ELU', ':SELU', ':Softplus', ':Swish', or ':Mish'
    # @example initialization of the neural network
    #   nn = FastNeurons::NN.new([784,15,784])
    #   nn = FastNeurons::NN.new([784,15,784], :Sigmoid)
    #   nn = FastNeurons::NN.new([784,15,784], [:Sigmoid, :Tanh])
    def initialize(columns, activation_function = nil)
      # training rate
      @training_rate = 0.1

      # Ensure columns is a proper array.
      @columns = columns.flatten

      # The columns containing processing neurons (i.e., excluding the inputs).
      @neuron_columns = @columns[1..-1]

      # Make the array of keys of activation functions' hash.
      @keys = Array.new(@neuron_columns.size)

      # Judge the arguments of activation functions.
      if activation_function.kind_of?(Symbol)
        # Set the activation function passed as a symbol in the argument to all layers.
        @keys.map!{ |key| key = activation_function }
      elsif activation_function.kind_of?(Array)
        # Set the activation function passed as an array of symbol in the argument to correspond to layer.
        if activation_function.size == @keys.size
          @keys = activation_function
        else
          raise(ArgumentError, "The size of the activation functions' array does not match the number of hidden and output layers.\n")
        end
      else
        # Set Sigmoid as default activation function.
        @keys.map!{ |key| key = :Sigmoid }
      end

      # Make the hash of activation_functions.
      @activation_functions = { Linear: Linear, Sigmoid: Sigmoid, Tanh: Tanh,
                                ReLU: ReLU, LeakyReLU: LeakyReLU, ELU: ELU, SELU: SELU,
                                Softplus: Softplus, Swish: Swish, Mish: Mish }

      # Set the proc object of antiderivative of a specified activation function.
      @antiderivatives = @keys.map{ |key| @activation_functions[key][:antiderivative] }.to_a

      # Set the proc object of derivative of a specified activation function.
      @derivatives = @keys.map{ |key| @activation_functions[key][:derivative] }.to_a

      # Creates the geometry of the bias matrices
      @biases_geometry = @neuron_columns.map{ |col| [col,1] }

      # Create the geometry of the weight matrices
      @weights_geometry = @neuron_columns.zip(@columns[0..-2])

      # Create the geometry of the linear results (z)
      # NOTE: shoud be the same as the biases.
      @z = @biases_geometry.clone

      # Create the geometry of the neurons statuses.
      # NOTE: includes the input values of the NN, hence uses @columns
      # NOTE: a[0] ARE the input values
      @a = @columns.map{ |col| NMatrix.new([1,col],0.0).transpose }

      # the array stored derivatives of neurons statuses
      @g_dash = @biases_geometry.clone

      # need for backpropagation
      @delta = @biases_geometry.clone

      # the arrays of derivatives.
      @loss_derivative_weights = @weights_geometry.map{ |g| NMatrix.new(g,0.0) }
      @loss_derivative_biases = @biases_geometry.map{ |g| NMatrix.new(g,0.0) }

      # Create the geometry of identity matrix.
      @idn_geometry = @weights_geometry.clone

      # Create identity matrix.
      @idn = @idn_geometry.map{ |g| NMatrix.eye([g[0],g[0]]) }
    end


    # Set up the NN to random values.
    def randomize
      # Create random fast matrices for the biases.
      @biases = @biases_geometry.map { |geo| NMatrix.random(geo, :dtype => :float64)}

      # Convert a range of biases from 0 ~ 1 to -0.5 ~ 0.5.
      @biases.size.times do |i|
        @biases[i] -= 0.5
      end
      puts "@biases: #{@biases}"

      # Create random fast matrices for the weights.
      @weights = @weights_geometry.map do |geo|
        NMatrix.random(geo, :dtype => :float64)
      end

      # Convert a range of weights from 0 ~ 1 to -0.5 ~ 0.5.
      @weights.size.times do |i|
        @weights[i] -= 0.5
      end
      puts "@weights: #{@weights}"
    end

    # Get the biases as an array.
    def biases
      @biases.map { |mat| mat.to_a }
    end

    # Get the weights as an array.
    def weights
      @weights.map { |mat| mat.to_a }
    end

    # Get the inputs of the neural network.
    # @param [Array] values inputs of the neural network.
    # @param [Array] t training data
    def input(*values,t)
      # The inputs are stored into a[0] as a NMatrix vector.
      @a[0] = N[values.flatten, :dtype => :float64].transpose

      # The training data is stored into T as a NMatrix vector.
      @T = N[t.flatten, :dtype => :float64].transpose
    end

    # Input to the hidden layer.
    # The main use is for post-learning confirmation.
    # @param [Int] row the number of the hidden layer you want to input
    # @param [Array] values inputs of the hidden layer
    def input_hidden(row,*values)
      @a[row] = N[values.flatten, :dtype => :float64].transpose
    end

    # Compute multiply accumulate of inputs, weights and biases.
    # z = inputs * weights + biases
    # @param [Int] row the number of layer currently computing
    def compute_z(row)
      # Compute the values before the activation function is applied.
      @z[row] = NMatrix::BLAS.gemm(@weights[row],@a[row],@biases[row])
    end

    # Compute neurons statuses.
    # Apply activation function to z.
    # @param [Int] row the number of layer currently computing
    def compute_a(row)
      @a[row+1] = @antiderivatives[row].call(@z[row])
    end

    # Compute Feed Forward Neural Network.
    def propagate
      # Compute as many times as layers of the neural network.
      @neuron_columns.size.times do |i|
        compute_z(i)
        compute_a(i)
      end
    end

    # Compute from the hidden layer to the output layer.
    # The main use is for post-learning confirmation.
    # @param [Int] row the number of layer you want to begin computing
    # row's range -> 1 ~ @neuron_columns.size - 1
    def propagate_from_hidden(row)
      (row).upto(@neuron_columns.size-1) do |i|
        compute_z(i)
        compute_a(i)
      end
    end

    # Compute backpropagation.
    def backpropagate
      differentiate_a(@neuron_columns.size-1)
      @delta[@neuron_columns.size-1] = @g_dash[@neuron_columns.size-1]*(@a[@neuron_columns.size] - @T)
      NMatrix::BLAS.gemm(@delta[@neuron_columns.size-1],@a[@neuron_columns.size-1].transpose,@loss_derivative_weights[@neuron_columns.size-1],1.0,0.0)
      @loss_derivative_biases[@neuron_columns.size-1] = @delta[@neuron_columns.size-1]
      update_weights(@neuron_columns.size-1)
      update_biases(@neuron_columns.size-1)

      (@neuron_columns.size-2).downto(0) do |i|
        differentiate_a(i)
        compute_delta(i)
        differentiate_weights(i)
        differentiate_biases(i)
        update_weights(i)
        update_biases(i)
      end
    end

    # Differentiate neurons statuses.
    # @param [Int] row the number of layer currently computing
    def differentiate_a(row)
      # Judge the symbol of activation function.
      if [:Linear, :Sigmoid, :Tanh].include?(@keys[row])
        arr = @a[row+1]
      else
        arr = @z[row]
      end

      # Defferentiate array correspond to activation function.
      @g_dash[row] = @derivatives[row].call(arr)
    end

    # Compute delta.
    # @param [Int] row the number of layer currently computing
    def compute_delta(row)
      @delta[row] = NMatrix::BLAS.gemm(@weights[row+1],@delta[row+1],nil,1.0,0.0,:transpose)*@g_dash[row]
    end

    # Compute derivative of weights.
    # @param [Int] row the number of layer currently computing
    def differentiate_weights(row)
      @loss_derivative_weights[row] = NMatrix::BLAS.gemm(@delta[row],@a[row].transpose)
    end

    # Compute derivative of biases.
    # @param [Int] row the number of layer currently computing
    def differentiate_biases(row)
      @loss_derivative_biases[row] = @delta[row]
    end

    # Update weights.
    # @param [Int] row the number of layer currently computing
    def update_weights(row)
      @weights[row] = NMatrix::BLAS.gemm(@idn[row],@loss_derivative_weights[row],@weights[row],-(@training_rate),1.0)
    end

    # Update biases.
    # @param [Int] row the number of layer currently computing
    def update_biases(row)
      @biases[row] = NMatrix::BLAS.gemm(@idn[row],@loss_derivative_biases[row],@biases[row],-(@training_rate),1.0)
    end

    # Get outputs of neural network.
    # @return [Array] @a[@neuron_columns.size] output of neural network
    def get_outputs
      return @a[@neuron_columns.size]
    end

    # Set training rate.
    # @param [Float] rate training rate
    def set_training_rate(rate = 0.1)
      @training_rate = rate
    end

    # Compute feed forward propagation and backpropagation.
    # @param [Int] epoch the number of learning of input data
    def run(epoch)
      epoch.times do |i|
        propagate
        backpropagate
      end
    end

    # Save learned network to JSON file.
    # @param [String] path file path
    def save_network(path)
      # Make hash of parameters.
      hash = { "columns" => @columns, "activation_function" => @keys, "biases" => @biases, "weights" => @weights }

      # Save file.
      File.open(path,"w+") do |f|
        f.puts(JSON.pretty_generate(hash))
      end
    end

    # Load learned network from JSON file.
    # @param [String] path file path
    # @param [Array or Symbol] activation_function the name of the activation function you want to use as a symbol or an array
    def load_network(path, activation_function = nil)
      # Open file.
      File.open(path,"r+") do |f|

        # Load hash from JSON file.
        hash = JSON.load(f)

        # Set columns from hash.
        @columns = hash["columns"]

        # Set activation function.
        # If activation function has not been set, it will be loaded from JSON file.
        activation_function = activation_function.nil? ? hash["activation_function"].map{ |elem| elem.to_sym } : activation_function

        # Initialize neural network.
        initialize(@columns, activation_function)

        # Load biases.
        biases_matrix = hash["biases"].to_a
        @biases = []
        @neuron_columns.size.times do |i|
          @biases.push(N[biases_matrix[i].split(',').map!{ |item| item.delete("/[\-]/").gsub(" ","").to_f}].transpose)
        end
        puts "#{@biases}"

        # Load weights.
        weights_matrix = hash["weights"].to_a
        @weights = []
        @neuron_columns.size.times do |i|
          weights_array = weights_matrix[i].split(',').map!{ |item| item.delete("/[\-]/").gsub(" ","").to_f}.to_a
          @weights.push(NMatrix.new(@weights_geometry[i],weights_array))
        end
        puts "#{@weights}"
      end
    end
  end


  # Apply linear function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to linear function
  def self.linear(z)
    return z
  end

  # Apply sigmoid function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to sigmoid function
  def self.sigmoid(z)
    exp_z = z.exp
    return exp_z / (exp_z + 1.0)
  end

  # Apply tanh function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to tanh function
  def self.tanh(z)
    pos_exp = z.exp
    neg_exp = (-z).exp
    return (pos_exp - neg_exp) / (pos_exp + neg_exp)
  end

  # Apply relu function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to relu function
  def self.relu(z)
    return (z + z.abs) / 2.0
  end

  # Apply leaky relu function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to leaky relu function
  def self.leakyrelu(z)
    return N[z.map{ |x| x > 0.0 ? x : 0.01 * x }.to_a.flatten].transpose
  end

  # Apply elu function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to elu function
  def self.elu(z)
    return N[z.map{ |x| x > 0.0 ? x : (Math.exp(x) - 1) }.to_a.flatten].transpose
  end

  # Apply selu function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to selu function
  def self.selu(z)
    return N[z.map{ |x| x > 0.0 ? x * SCALE : ALPHA * (Math.exp(x) - 1) * SCALE }.to_a.flatten].transpose
  end

  # Apply softplus function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to softplus function
  def self.softplus(z)
    return (z.exp + 1.0).log
  end

  # Apply swish function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to swish function
  def self.swish(z)
    return z * sigmoid(z)
  end

  # Apply mish function to z.
  # @param [NMatrix] z a vector of NMatrix containing the multiply accumulation of inputs, weights and biases
  # @return [NMatrix] a vector of NMatrix that each elements are applied to mish function
  def self.mish(z)
    return z * tanh(softplus(z))
  end

  # Differentiate linear function.
  # @param [NMatrix] a a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  def self.differentiate_linear(a)
    return NMatrix.ones_like(a)
  end

  # Differentiate sigmoid function.
  # @param [NMatrix] a a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  def self.differentiate_sigmoid(a)
    return (-a + 1.0) * a
  end

  # Differentiate tanh function.
  # @param [NMatrix] a a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  def self.differentiate_tanh(a)
    return -(a ** 2) + 1.0
  end

  # Differentiate relu function.
  # @param [NMatrix] a a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  def self.differentiate_relu(z)
    return N[z.map{ |x| x > 0.0 ? 1.0 : 0.0 }.to_a.flatten].transpose
  end

  # Differentiate leaky relu function.
  # @param [NMatrix] a a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  def self.differentiate_leakyrelu(z)
    return N[z.map{ |x| x > 0.0 ? 1.0 : 0.01 }.to_a.flatten].transpose
  end

  # Differentiate elu function.
  # @param [NMatrix] a a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  def self.differentiate_elu(z)
    return N[z.map{ |x| x > 0.0 ? 1.0 : Math.exp(x) }.to_a.flatten].transpose
  end

  # Differentiate selu function.
  # @param [NMatrix] a a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  def self.differentiate_selu(z)
    return N[z.map{ |x| x > 0.0 ? SCALE : ALPHA * Math.exp(x) * SCALE }.to_a.flatten].transpose
  end

  # The derivative of softplus is the same as sigmoid function.

  # Differentiate swish function.
  # @param [NMatrix] a a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  def self.differentiate_swish(z)
    a = swish(z)
    return a + (-a + 1) * sigmoid(z)
  end

  # Differentiate mish function.
  # @param [NMatrix] a a vector of NMatrix containing neuron statuses
  # @return [NMatrix] a vector of NMatrix that each elements are differentiated
  def self.differentiate_mish(z)
    omega = (z + 1) * 4 + (z * 2).exp * 4 + (z * 3).exp + (z * 4 + 6) * z.exp
    delta = z.exp * 2 + (z * 2).exp + 2
    return (z.exp * omega) / (delta ** 2)
  end

  # activation functions
  Linear = { antiderivative: method(:linear), derivative: method(:differentiate_linear) }
  Sigmoid = { antiderivative: method(:sigmoid), derivative: method(:differentiate_sigmoid) }
  Tanh = { antiderivative: method(:tanh), derivative: method(:differentiate_tanh) }
  ReLU = { antiderivative: method(:relu), derivative: method(:differentiate_relu) }
  LeakyReLU = { antiderivative: method(:leakyrelu), derivative: method(:differentiate_leakyrelu) }
  ELU = { antiderivative: method(:elu), derivative: method(:differentiate_elu) }
  SELU = { antiderivative: method(:selu), derivative: method(:differentiate_selu) }
  Softplus = { antiderivative: method(:softplus), derivative: method(:sigmoid) }
  Swish = { antiderivative: method(:swish), derivative: method(:differentiate_swish) }
  Mish = { antiderivative: method(:mish), derivative: method(:differentiate_mish) }
end
