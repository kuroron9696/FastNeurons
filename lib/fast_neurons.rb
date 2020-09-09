require 'nmatrix'
require 'json'
require 'random_bell'

SCALE = 1.0507009873554804934193349852946
ALPHA = 1.6732632423543772848170429916717

# FastNeurons is a simple and fast library using NMatrix for building neural networks.<br>
# Currently, it supports fully connected neural network and restricted boltzmann machine.<br>
# More models will be added gradually.<br>
# @version 1.3.0
# @since 1.0.0
# @author Ryota Sakai,Yusuke Tomimoto
module FastNeurons
  # Describes a standard fully connected NN based on backpropagation.
  # @example learning of xor
  #  data = [[0,0],[0,1],[1,0],[1,1]]
  #  t = [[0],[1],[1],[0]]
  #  nn = FastNeurons::NN.new([2, 2, 1], [:Tanh, :Linear])
  #  nn.randomize
  #  data.each_with_index do |inputs, i|
  #    nn.input(inputs, t[i])
  #    nn.run(1)
  #  end
  # @since 1.0.0
  class NN
    # constructor <br>
    # Creates a NN from columns giving each the size of a column of neurons (input and output comprised). <br>
    # You can use the following activation functions.<br>
    # ':Linear', ':Sigmoid', ':Tanh', ':ReLU', ':LeakyReLU', ':ELU', ':SELU', ':Softplus', ':Swish', or ':Mish' <br>
    # @param [Array] columns the array showing the shape of a neural network
    # @param [Symbol or Array] activation_function the name of the activation function you want to use
    # @example initialization of the neural network
    #   nn = FastNeurons::NN.new([784,15,784])
    #   nn = FastNeurons::NN.new([784,15,784], :Sigmoid)
    #   nn = FastNeurons::NN.new([784,15,784], [:Sigmoid, :Tanh])
    # @since 1.0.0
    def initialize(columns, activation_function = nil)
      # training rate
      @training_rate = 0.1

      # batch size
      @batch_size = 1

      # counter
      @count = 0

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
                                ReLU: ReLU, LeakyReLU: LeakyReLU, ELU: Elu, SELU: SElu,
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

      initialize_loss_derivatives

      # Create the geometry of identity matrix.
      @idn_geometry = @weights_geometry.clone

      # Create identity matrix.
      @idn = @idn_geometry.map{ |g| NMatrix.eye([g[0],g[0]]) }

      # Set the coefficients of derivatives.
      @coefficients = NMatrix.ones_like(@a[@neuron_columns.size])
    end

    # Initialize loss derivatives.
    # The main use is for mini-batch learning.
    # @since 1.2.0
    def initialize_loss_derivatives
      # the arrays of derivatives.
      @loss_derivative_weights = @weights_geometry.map{ |geo| NMatrix.new(geo, 0.0) }
      @loss_derivative_biases = @biases_geometry.map{ |geo| NMatrix.new(geo, 0.0) }
    end

    # Set up the NN to random values.
    # @since 1.0.0
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
    # @since 1.0.0
    def biases
      @biases.map { |mat| mat.to_a }
    end

    # Get the weights as an array.
    # @since 1.0.0
    def weights
      @weights.map { |mat| mat.to_a }
    end

    # Get the inputs of the neural network.
    # @param [Array] values inputs of the neural network
    # @param [Array] teaching_data teaching data of the neural network
    # @since 1.0.0
    def input(values, teaching_data = nil)
      # The inputs are stored into a[0] as a NMatrix vector.
      @a[0] = N[values.flatten, :dtype => :float64].transpose

      # The teaching data is stored into T as a NMatrix vector.
      set_teaching_data(teaching_data)
    end

    # Input to the hidden layer.
    # The main use is for post-learning confirmation.
    # @param [Integer] row the number of the hidden layer you want to input
    # @param [Array] values inputs of the hidden layer
    # @since 1.0.0
    def input_hidden(row,*values)
      @a[row] = N[values.flatten, :dtype => :float64].transpose
    end

    # Compute multiply accumulate of inputs, weights and biases.
    # z = inputs * weights + biases
    # @param [Integer] row the number of layer currently computing
    # @since 1.0.0
    def compute_z(row)
      # Compute the values before the activation function is applied.
      @z[row] = NMatrix::BLAS.gemm(@weights[row],@a[row],@biases[row])
    end

    # Compute neurons statuses.
    # Apply activation function to z.
    # @param [Integer] row the number of layer currently computing
    # @since 1.0.0
    def compute_a(row)
      @a[row+1] = @antiderivatives[row].call(@z[row])
    end

    # Compute Feed Forward Neural Network.
    # @since 1.0.0
    def propagate
      # Compute as many times as layers of the neural network.
      @neuron_columns.size.times do |i|
        compute_z(i)
        compute_a(i)
      end

      @count += 1
    end

    # Compute from the hidden layer to the output layer.
    # The main use is for post-learning confirmation.
    # @param [Integer] row the number of layer you want to begin computing
    # row's range -> 1 ~ @neuron_columns.size - 1
    # @since 1.0.0
    def propagate_from_hidden(row)
      (row).upto(@neuron_columns.size-1) do |i|
        compute_z(i)
        compute_a(i)
      end
    end

    # Compute backpropagation.
    # @since 1.0.0
    def backpropagate
      differentiate_a(@neuron_columns.size-1)
      @delta[@neuron_columns.size-1] = @g_dash[@neuron_columns.size-1] * (@a[@neuron_columns.size] - @T) * @coefficients
      @loss_derivative_weights[@neuron_columns.size-1] += NMatrix::BLAS.gemm(@delta[@neuron_columns.size-1], @a[@neuron_columns.size-1].transpose, @loss_derivative_weights[@neuron_columns.size-1], 1.0, 0.0)
      @loss_derivative_biases[@neuron_columns.size-1] += @delta[@neuron_columns.size-1]

      (@neuron_columns.size-2).downto(0) do |i|
        differentiate_a(i)
        compute_delta(i)
        differentiate_weights(i)
        differentiate_biases(i)
      end

      if @count == @batch_size
        @count = 0
        update_parameters
        initialize_loss_derivatives
      end
    end

    # Differentiate neurons statuses.
    # @param [Integer] row the number of layer currently computing
    # @since 1.1.0
    def differentiate_a(row)
      # Judge the symbol of activation function.
      arr = [:Linear, :Sigmoid, :Tanh].include?(@keys[row]) ? @a[row+1] : @z[row]

      # Defferentiate array correspond to activation function.
      @g_dash[row] = @derivatives[row].call(arr)
    end

    # Compute delta.
    # @param [Integer] row the number of layer currently computing
    # @since 1.0.0
    def compute_delta(row)
      @delta[row] = NMatrix::BLAS.gemm(@weights[row+1],@delta[row+1], nil, 1.0, 0.0, :transpose) * @g_dash[row]
    end

    # Compute derivative of weights.
    # @param [Integer] row the number of layer currently computing
    # @since 1.2.0
    def differentiate_weights(row)
      @loss_derivative_weights[row] += NMatrix::BLAS.gemm(@delta[row], @a[row].transpose)
    end

    # Compute derivative of biases.
    # @param [Integer] row the number of layer currently computing
    # @since 1.2.0
    def differentiate_biases(row)
      @loss_derivative_biases[row] += @delta[row]
    end

    # Update weights.
    # @param [Integer] row the number of layer currently computing
    # @since 1.0.0
    def update_weights(row)
      @loss_derivative_weights[row] = @loss_derivative_weights[row] / @batch_size.to_f
      @weights[row] = NMatrix::BLAS.gemm(@idn[row], @loss_derivative_weights[row], @weights[row], -(@training_rate), 1.0)
    end

    # Update biases.
    # @param [Integer] row the number of layer currently computing
    # @since 1.0.0
    def update_biases(row)
      @loss_derivative_biases[row] = @loss_derivative_biases[row] / @batch_size.to_f
      @biases[row] = NMatrix::BLAS.gemm(@idn[row],@loss_derivative_biases[row],@biases[row],-(@training_rate),1.0)
    end

    # Update biases and weights.
    # @since 1.2.0
    def update_parameters
      (@neuron_columns.size-1).downto(0) do |i|
        update_weights(i)
        update_biases(i)
      end
    end

    # Get outputs of the layer of neural network.
    # @param [Integer] row the row number you want to get outputs
    # @return [Array] @a[row] the output of layer specified by row
    # @since 1.0.0
    def get_outputs(row = @neuron_columns.size)
      return @a[row]
    end

    # Set a training rate.
    # @param [Float] rate training rate
    # @since 1.1.0
    def set_training_rate(rate = 0.1)
      @training_rate = rate
    end

    # Set the teaching data.
    # @param [Array] teaching_data teaching data of neural network
    # @since 1.3.0
    def set_teaching_data(teaching_data = nil)
      @T = teaching_data.nil? ? NMatrix.zeros_like(@a[@neuron_columns.size]) : N[teaching_data.flatten, :dtype => :float64].transpose
    end

    # Set coefficients of derivatives.
    # @param [Array or Float] coefficients coefficients of derivatives.
    # @since 1.3.0
    def set_coefficients(coefficients)
      if coefficients.kind_of?(Array)
        @coefficients = N[coefficients.flatten, :dtype => :float64].transpose
      elsif
        @coefficients = NMatrix.new([1, @a[@neuron_columns.size].size], coefficients).transpose        
      end      
    end

    # Set batch size of mini-batch learning.
    # @param [Integer] size batch size
    # @since 1.2.0
    def set_batch_size(size = 1)
      @batch_size = size
    end

    # Compute feed forward propagation and backpropagation.
    # @param [Integer] times_of_learning the number of learning times of input data
    # @since 1.0.0
    def run(times_of_learning = 1)
      times_of_learning.times do |i|
        propagate
        backpropagate
      end
    end

    # Save learned network to JSON file.
    # @param [String] path file path
    # @since 1.0.0
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
    # @since 1.0.0
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

  # Describes a restricted boltzmann machine.
  # @example learning
  #  data = [[1,1,1,0,0,0]]
  #  rbm = FastNeurons::NN.new([6, 5], :Bernoulli)
  #  rbm.randomize
  #  data.each do |inputs|
  #    rbm.input(inputs)
  #    rbm.run(1)
  #  end
  # @since 1.2.0
  class RBM
    # Creates a RBM from columns giving each the size of a column of units.<br>
    # You can use two different types of RBM. (Bernoulli-Bernoulli RBM or Gaussian-Bernoulli RBM)<br>
    # The type of RBM is specified by a symbol.<br>
    #':Bernoulli' or ':Gaussian' default -> :Bernoulli<br>
    # If you set :Bernoulli, you can use Bernoulli-Bernoulli RBM.<br>
    # If you set :Gaussian, you can use Gaussian-Bernoulli RBM.<br>
    # @param [Array] columns the array showing the shape of a restricted boltzmann machine
    # @param [Symbol] type the visible units' type you want to use
    # @example initialization of the restricted boltzmann machine
    #   rbm = RBMR::RBM.new([5,4])
    #   rbm = RBMR::RBM.new([5,4],:Gaussian)
    # @since 1.2.0
    def initialize(columns,type = :Bernoulli)
      # training_rate
      @training_rate = 0.1

      # Set the type of visible units.
      @type = type

      # batch size
      @batch_size = 1

      # counter
      @count = 0

      # Ensure columns is a proper array.
      @columns = columns.flatten

      # Creates the geometry of the bias matrices.
      # The hidden layer and the visible layer are stored in that order.
      # @biases[0] -> hidden layer's biases
      # @biases[1] -> visible layer's biases
      @biases_geometry = @columns.reverse.map { |col| [1,col] }

      # Create the geometry of the weight matrix
      @weights_geometry = @columns[0..1]

      # Create units matrices
      # The visible layer and the hidden layer are stored in that order.
      # @units[0] -> visible layer's units
      # @units[1] -> hidden layer's units
      @units = @columns.map{ |col| NMatrix.new([1,col],0.0) }

      # Create the matrices of conditional probability that the unit will be 1.
      # P(hidden|visible)→P(visible|hidden)の順で格納
      # @probability[0] -> P(hidden|visible)
      # @probability[1] -> P(visible|hidden)
      @probability = @columns.reverse.map{ |col| NMatrix.new([1,col],0.0) }

      # Initialize derivative of biases and weights.
      initialize_derivatives

      # need for compute cross entropy
      @cross_entropy = NMatrix.new([1,@units[0].size],0.0)

      # Make a Gaussian distribution that has μ = 0, σ = 0.01.
      @bell = RandomBell.new(mu: 0, sigma: 0.01, range: -Float::INFINITY..Float::INFINITY)

      # computation method of sampling visible units
      @sampling_methods = { Bernoulli: method(:sample_from_bernoulli), Gaussian: method(:sample_from_gaussian) }
      @sampling_method = @sampling_methods[@type]

      # Set Sigmoid function.
      @sigmoid = Sigmoid[:antiderivative]
    end

    # Initialize derivatives.
    # The main use is for mini-batch learning.
    # @since 1.2.0
    def initialize_derivatives
      # Initialize derivative matrix of biases.
      @derivative_biases = @columns.map{ |col| NMatrix.new([1,col], 0.0) }

      # Initialize derivative matrix of weights.
      @derivative_weights = NMatrix.new(@weights_geometry, 0.0)
    end

    # Set up the RBM to random values.
    # @since 1.2.0
    def randomize
      # Create fast matrices for the biases.
      @biases = @biases_geometry.map { |geo| NMatrix.new(geo,0.0)}
      puts "@biases: #{@biases}"

      # Create random fast matrices for the weights.
      # The weights are initialized to follow the Gaussian distribution.
      weights_array = []
      @weights_geometry[0].times do |i|
        @weights_geometry[0].times do |j|
          weights_array.push(@bell.rand)
        end
      end

      # Store weights into @weights.
      @weights = []
      @weights.push(NMatrix.new(@weights_geometry,weights_array))
      puts "@weights: #{@weights}"
    end

    # Get the inputs of the restricted boltzmann machine.
    # @param [Array] values inputs of the restricted boltzmann machine.
    # @since 1.2.0
    def input(values)
      @units[0] = N[values.flatten,:dtype => :float64]
      @inputs = @units[0].dup

      # If Gaussian-Bernoulli RBM is used, it standardize input data.
      @type == :Gaussian ? standardize : nil
    end

    # Input to the hidden layer.
    # The main use is for post-learning confirmation.
    # @param [Array] values inputs of the hidden layer
    # @since 1.2.0
    def input_hidden_layer(values)
      @units[1] = N[values.flatten,:dtype => :float64]
      sample_visible_units
    end

    # Standardize input data.
    # @since 1.2.0
    def standardize
      @mean = @units[0].mean(1)[0]
      @standard_deviation = @units[0].std(1)[0]
      @units[0] = (@units[0] - @mean) / @standard_deviation
      @inputs = @units[0].dup
    end

    # Unstandardize visible units and inputs.
    # @since 1.2.0
    def unstandardize
      @units[0] = @units[0] * @standard_deviation + @mean
      @inputs = @inputs * @standard_deviation + @mean
    end

    # Learn RBM.
    # @param [Integer] number_of_steps the number of Contrastive Divergence steps
    # @since 1.2.0
    def run(number_of_steps)
      sample(number_of_steps)
      compute_derivatives

      @count += 1
      if @count == @batch_size
        @count = 0
        update_parameters
        initialize_derivatives
      end
    end

    # Sample visible units and hidden units.
    # @param [Integer] number_of_steps the number of Contrastive Divergence steps
    # @since 1.2.0
    def sample(number_of_steps)
      sample_hidden_units

      # Store the conditional probability of hidden layer of first step.
      # Need for computing derivatives.
      @probability_hidden = @probability[0].dup

      sample_visible_units

      # Sample the times of number_of_steps.
      number_of_steps.times do |i|
        sample_hidden_units
        sample_visible_units
      end
    end

    # Compute P(hidden|visible) and sample hidden units.
    # @since 1.2.0
    def sample_hidden_units
      # Compute conditional probability of hidden layer.
      pre_sigmoid = NMatrix::BLAS.gemm(@units[0],@weights[0],@biases[0])
      @probability[0] = @sigmoid.call(pre_sigmoid)

      # Sample hidden units from conditional probability.
      @probability[0].each_with_index do |prob,i|
        @units[1][i] = prob >= rand ? 1.0 : 0.0
      end
    end

    # Compute P(visible|hidden) and sample visible units.
    # @since 1.2.0
    def sample_visible_units
      @sampling_method.call
    end

    # Sample visible units from Bernoulli units.
    # @since 1.2.0
    def sample_from_bernoulli
      # Compute conditional probability of visible layer.
      product_of_units_and_weights = NMatrix::BLAS.gemm(@weights[0],@units[1].transpose)
      pre_sigmoid = product_of_units_and_weights.transpose + @biases[1]
      @probability[1] = @sigmoid.call(pre_sigmoid)

      # Sample visible units from conditional probability.
      @probability[1].each_with_index do |prob,i|
        @units[0][i] = prob >= rand ? 1.0 : 0.0
      end
    end

    # Sample visible units from Gaussian units.
    # @since 1.2.0
    def sample_from_gaussian
      # Compute product of hidden units and weights.
      product_of_units_and_weights = NMatrix::BLAS.gemm(@weights[0],@units[1].transpose)

      # Compute mean of Gaussian distribution.
      mean_of_gaussian_distribution = product_of_units_and_weights.transpose + @biases[1]

      # Sample visible units from Gaussian distribution.
      mean_of_gaussian_distribution.each_with_index do |mean,i|
        @units[0][i] = RandomBell.new(mu: mean, sigma: 1, range: -Float::INFINITY..Float::INFINITY).rand
      end

      # Compute Gaussian distribution.
      difference_of_units_and_mean = @units[0] - mean_of_gaussian_distribution
      @probability[1] = (-(difference_of_units_and_mean ** 2) / 2.0).exp / Math.sqrt(2.0 * Math::PI)
    end

    # Compute derivatives biases and weights.
    # @since 1.2.0
    def compute_derivatives
      # Judge RBM type.
      unit = @type == :Bernoulli ? @units[0] : @probability[1]

      # Compute derivative of weights.
      @derivative_weights += NMatrix::BLAS.gemm(@inputs, @probability_hidden, nil, 1.0, 0.0, :transpose) - NMatrix::BLAS.gemm(unit, @probability[0], nil, 1.0, 0.0, :transpose)

      # Compute derivative of biases.
      @derivative_biases[0] += (@inputs - unit)
      @derivative_biases[1] += (@probability_hidden - @probability[0])
    end

    # Update biases and weights.
    # @since 1.2.0
    def update_parameters
      update_biases
      update_weights
    end

    # Update biases.
    # @since 1.2.0
    def update_biases
      @biases[0] += @derivative_biases[1] / @batch_size.to_f * @training_rate
      @biases[1] += @derivative_biases[0] / @batch_size.to_f * @training_rate
    end

    # Update weights.
    # @since 1.2.0
    def update_weights
      @weights[0] += @derivative_weights / @batch_size.to_f * @training_rate
    end

    # Reconstruct input data.
    # The main use is for post-learning confirmation.
    # @param [Array] values the data you want to reconstruct
    # @since 1.2.0
    def reconstruct(values)
      input(values)
      sample_hidden_units
      sample_visible_units
    end

    # Compute cross entropy.
    # @since 1.2.0
    def compute_cross_entropy
      log_probability = @probability[1].log
      log_probability_dash = (-@probability[1] + 1).log
      inputs_dash = (-@inputs + 1)
      @cross_entropy += ((@inputs * log_probability) + (inputs_dash * log_probability_dash))
    end

    # Compute mean cross entropy.
    # @param [Integer] number_of_data the number of training data.
    # @since 1.2.0
    def compute_mean_cross_entropy(number_of_data)
      mean_cross_entropy = -@cross_entropy.to_a.sum / number_of_data.to_f
      @cross_entropy = NMatrix.new([1,@units[0].size],0.0)
      return mean_cross_entropy
    end

    # Get outputs of neural network.
    # @return [Array] output of restricted boltzmann machine(= visible units)
    # @since 1.2.0
    def get_outputs
      @type == :Gaussian ? unstandardize : nil
      return @units[0]
    end

    # Get conditional probability of visible layer.
    # @return [Array] conditional probability of visible layer.
    # @since 1.2.0
    def get_visible_probability
      return @probability[1]
    end

    # Set training rate.
    # @param [Float] rate training rate
    # @since 1.2.0
    def set_training_rate(rate = 0.1)
      @training_rate = rate
    end

    # Set batch size of mini-batch learning.
    # @param [Integer] size batch size
    # default -> 1
    # @since 1.2.0
    def set_batch_size(size = 1)
      @batch_size = size
    end

    # Save learned network to JSON file.
    # @param [String] path file path
    # @since 1.2.0
    def save_network(path)
      # Make hash of parameters.
      hash = { "type" => @type, "columns" => @columns, "biases" => @biases, "weights" => @weights }

      # Save file.
      File.open(path,"w+") do |f|
        f.puts(JSON.pretty_generate(hash))
      end
    end

    # Load learned network from JSON file.
    # @param [String] path file path
    # @since 1.2.0
    def load_network(path)
      # Open file.
      File.open(path,"r+") do |f|
        # Load hash from JSON file.
        hash = JSON.load(f)

        # Set columns from hash.
        @columns = hash["columns"]

        # Set visible units' type.
        @type = hash["type"].to_sym

        # Initialize the restricted boltzmann machine.
        initialize(@columns,@type)

        # Load biases.
        biases_matrix = hash["biases"].to_a
        @biases = []
        @columns.size.times do |i|
          @biases.push(N[biases_matrix[i].split(',').map!{ |item| item.delete("/[\-]/").gsub(" ","").to_f}])
        end
        puts "#{@biases}"

        # Load weights.
        weights_matrix = hash["weights"].to_a
        @weights = []
        weights_array = weights_matrix[0].split(',').map!{ |item| item.delete("/[\-]/").gsub(" ","").to_f}.to_a
        @weights.push(NMatrix.new(@weights_geometry,weights_array))
        puts "#{@weights}"
      end
    end
  end

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
end
