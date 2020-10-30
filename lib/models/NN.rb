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
    # ':Linear', ':Sigmoid', ':Tanh', ':ReLU', ':LeakyReLU', ':ELU', ':SELU', ':Softplus', ':Swish', ':Mish', or ':Softmax' <br>
    # And, you can use the following loss functions.<br>
    # ':MeanSquare', ':CrossEntropy' <br>
    # @param [Array] columns the array showing the shape of a neural network
    # @param [Symbol or Array] activation_function the symbol of the activation function you want to use
    # @param [Symbol] loss_function the symbol of the loss function you want to use
    # @example initialization of the neural network
    #   nn = FastNeurons::NN.new([784,15,784])
    #   nn = FastNeurons::NN.new([784,15,784], :Sigmoid)
    #   nn = FastNeurons::NN.new([784,15,784], [:Sigmoid, :Tanh])
    #   nn = FastNeurons::NN.new([784,15,784], [:Sigmoid, :Tanh], :CrossEntropy)
    # @since 1.0.0
    def initialize(columns, activation_function = nil, loss_function = :MeanSquare)
      # training rate
      @learning_rate = 0.01

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
          raise(ArgumentError, "The size of the activation functions' array needs to match the number of hidden and output layers.\n")
        end
      else
        # Set Sigmoid as default activation function.
        # If activation function isn't passed, set Sigmoid function to all layer.
        @keys.map!{ |key| key = :Sigmoid }
      end

      # Make the hash of activation functions.
      @activation_functions = { Linear: Linear, Sigmoid: Sigmoid, Tanh: Tanh,
                                ReLU: ReLU, LeakyReLU: LeakyReLU, ELU: Elu, SELU: SElu,
                                Softplus: Softplus, Swish: Swish, Mish: Mish,
                                Softmax: Softmax }

      # Set the proc object of antiderivative of a specified activation function.
      @antiderivatives = @keys.map{ |key| @activation_functions[key][:antiderivative] }.to_a

      # Set the proc object of derivative of a specified activation function.
      @derivatives = @keys.map{ |key| @activation_functions[key][:derivative] }.to_a

      # Make the hash of loss functions.
      @loss_functions = { MeanSquare: MeanSquare, SquaredError: SquaredError, CrossEntropy: CrossEntropy }

      # Set the proc object of antiderivative of a specified loss function.
      @loss_antiderivative = @loss_functions[loss_function][:antiderivative]

      # Set the proc object of derivative of a specified loss function.
      @loss_derivative = @loss_functions[loss_function][:derivative]

      # Creates the geometry of the bias matrices
      @biases_geometry = @neuron_columns.map{ |col| [col,1] }

      # Create the geometry of the weight matrices
      @weights_geometry = @neuron_columns.zip(@columns[0..-2])

      # These are need for storing and restoring parameters.
      @stored_weights = @weights_geometry.map{ |geo| NMatrix.new(geo, 0.0) }
      @stored_biases = @biases_geometry.map{ |geo| NMatrix.new(geo, 0.0) }

      # Create the geometry of the linear results (z)
      # NOTE: shoud be the same as the biases.
      @z = @biases_geometry.clone

      # Create the geometry of the neurons statuses.
      # NOTE: includes the input values of the NN, hence uses @columns
      # NOTE: a[0] ARE the input values
      @a = @columns.map{ |col| NMatrix.new([1,col],0.0).transpose }

      # the array stored derivatives of neurons statuses
      @derivative_activation_function = @biases_geometry.clone

      # need for backpropagation
      @delta = @biases_geometry.clone

      initialize_loss_derivatives

      # Create the geometry of identity matrix.
      @idm_geometry = @weights_geometry.clone

      # Create identity matrix.
      @idm = @idm_geometry.map{ |g| NMatrix.eye([g[0],g[0]]) }            

      # Set the coefficients of derivatives.
      @coefficients = NMatrix.ones_like(@a[@neuron_columns.size])

      # Indicates whether updating parameters are enabled or not.
      @updating_is_enabled = true

      # loss of neural network
      @loss = 0

      # normal distribution
      @normal = RandomBell.new(mu: 0, sigma: 1, range: -Float::INFINITY..Float::INFINITY)
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
    # @param [Symbol] weights_method the method of initializing weights
    # @param [Symbol] biases_method the method of initializing biases
    # @example randomize in specified methods
    #   nn.randomize
    #   nn.randomize(:Normal, :Zeros)
    #   nn.randomize([:Uniform, :Ones], [:Zeros, :Zeros])
    # @since 1.0.0
    def randomize(weights_method = nil, biases_method = nil)
      weights_methods, biases_methods = set_initializing_methods(weights_method, biases_method)

      # Initialize weights in the specified method.
      @weights = []
      weights_methods.each_with_index do |method, i|
        fan_in = @weights_geometry[i][1] # a number of input units of layer
        fan_out = @weights_geometry[i][0] # a number of output units of layer

        case method
        when :Uniform
          # Initialize weights with a uniform random number of a range from -1.0 to 1.0.
          # Create random fast matrices for the weights.
          weights_array = NMatrix.random(@weights_geometry[i], :dtype => :float64)
  
          # Convert a range of weights from 0 ~ 1 to -1.0 ~ 1.0.
          weights_array -= 0.5
          weights_array *= 2.0

          @weights.push(weights_array)
        when :Normal
          # Initialize weights with a random number from a Gaussian distribution that has μ = 0, σ = 1.0.
          weights_array = (fan_in * fan_out).times.map{ |size| @normal.rand }
          @weights.push(NMatrix.new(@weights_geometry[i], weights_array, :dtype => :float64))
        when :Zeros
          # Initialize weights with zeros.
          @weights.push(NMatrix.new(@weights_geometry[i], 0.0))
        when :Ones
          # Initialize weights with ones.
          @weights.push(NMatrix.new(@weights_geometry[i], 1.0))
        when :GlorotUniform
          # Initialize weights with a random number from a Glorot's uniform distribution.
          limit = Math.sqrt(6.0 / (fan_in + fan_out))
          weights_array = (fan_in * fan_out).times.map{ |size| rand(-limit..limit) }
          @weights.push(NMatrix.new(@weights_geometry[i], weights_array, :dtype => :float64))
        when :GlorotNormal
          # Initialize weights with a random number from a Glorot's normal distribution.
          glorot_normal = RandomBell.new(mu: 0, sigma: Math.sqrt(2.0 / (fan_in + fan_out)), range: -Float::INFINITY..Float::INFINITY)
          weights_array = (fan_in * fan_out).times.map{ |size| glorot_normal.rand }
          @weights.push(NMatrix.new(@weights_geometry[i], weights_array, :dtype => :float64))
        when :HeUniform
          # Initialize weights with a random number from a He's uniform distribution.
          limit = Math.sqrt(6.0 / fan_in)
          weights_array = (fan_in * fan_out).times.map{ |size| rand(-limit..limit) }
          @weights.push(NMatrix.new(@weights_geometry[i], weights_array, :dtype => :float64))
        when :HeNormal
          # Initialize weights with a random number from a He's normal distribution.
          he_normal = RandomBell.new(mu: 0, sigma: Math.sqrt(2.0 / fan_in), range: -Float::INFINITY..Float::INFINITY)
          weights_array = (fan_in * fan_out).times.map{ |size| he_normal.rand }
          @weights.push(NMatrix.new(@weights_geometry[i], weights_array, :dtype => :float64))
        when :LeCunUniform
          # Initialize weights with a random number from a LeCun's uniform distribution.
          limit = Math.sqrt(3.0 / fan_in)
          weights_array = (fan_in * fan_out).times.map{ |size| rand(-limit..limit) }
          @weights.push(NMatrix.new(@weights_geometry[i], weights_array, :dtype => :float64))
        when :LeCunNormal
          # Initialize weights with a random number from a LeCun's normal distribution.
          lecun_normal = RandomBell.new(mu: 0, sigma: Math.sqrt(1.0 / fan_in), range: -Float::INFINITY..Float::INFINITY)
          weights_array = (fan_in * fan_out).times.map{ |size| lecun_normal.rand }
          @weights.push(NMatrix.new(@weights_geometry[i], weights_array, :dtype => :float64))
        end
      end
      
      # Initialize biasess in the specified method.
      @biases = []
      biases_methods.each_with_index do |method, i|
        fan_in = @biases_geometry[i][1] # a number of input units of layer
        fan_out = @biases_geometry[i][0] # a number of output units of layer

        case method
        when :Uniform 
          # Initialize biases with a uniform random number of a range from -1.0 to 1.0.
          # Create random fast matrices for the biases.
          biases_array = NMatrix.random(@biases_geometry[i], :dtype => :float64)
  
          # Convert a range of biases from 0 ~ 1 to -1.0 ~ 1.0.
          biases_array -= 0.5
          biases_array *= 2.0

          @biases.push(biases_array)
        when :Normal
          # Initialize biases with a random number from a Gaussian distribution that has μ = 0, σ = 1.0.
          @biases.push(N[@biases_geometry[i][0].times.map{ @normal.rand }, :dtype => :float64].transpose)
        when :Zeros
          # Initialize biases with zeros.
          @biases.push(NMatrix.new(@biases_geometry[i], 0.0))
        when :Ones
          # Initialize biases with ones.          
          @biases.push(NMatrix.new(@biases_geometry[i], 1.0))
        when :GlorotUniform
          # Initialize weights with a random number from a Glorot's uniform distribution.
          limit = Math.sqrt(6.0 / (fan_in + fan_out))
          biases_array = (fan_in * fan_out).times.map{ |size| rand(-limit..limit) }
          @biases.push(NMatrix.new(@biases_geometry[i], biases_array, :dtype => :float64))
        when :GlorotNormal
          # Initialize weights with a random number from a Glorot's normal distribution.
          glorot_normal = RandomBell.new(mu: 0, sigma: Math.sqrt(2.0 / (fan_in + fan_out)), range: -Float::INFINITY..Float::INFINITY)
          biases_array = (fan_in * fan_out).times.map{ |size| glorot_normal.rand }
          @biases.push(NMatrix.new(@biases_geometry[i], biases_array, :dtype => :float64))
        when :HeUniform
          # Initialize weights with a random number from a He's uniform distribution.
          limit = Math.sqrt(6.0 / fan_in)
          biases_array = (fan_in * fan_out).times.map{ |size| rand(-limit..limit) }
          @biases.push(NMatrix.new(@biases_geometry[i], biases_array, :dtype => :float64))
        when :HeNormal
          # Initialize weights with a random number from a He's normal distribution.
          he_normal = RandomBell.new(mu: 0, sigma: Math.sqrt(2.0 / fan_in), range: -Float::INFINITY..Float::INFINITY)
          biases_array = (fan_in * fan_out).times.map{ |size| he_normal.rand }
          @biases.push(NMatrix.new(@biases_geometry[i], biases_array, :dtype => :float64))
        when :LeCunUniform
          # Initialize weights with a random number from a LeCun's uniform distribution.
          limit = Math.sqrt(3.0 / fan_in)
          biases_array = (fan_in * fan_out).times.map{ |size| rand(-limit..limit) }
          @biases.push(NMatrix.new(@biases_geometry[i], biases_array, :dtype => :float64))
        when :LeCunNormal
          # Initialize weights with a random number from a LeCun's normal distribution.
          lecun_normal = RandomBell.new(mu: 0, sigma: Math.sqrt(1.0 / fan_in), range: -Float::INFINITY..Float::INFINITY)
          biases_array = (fan_in * fan_out).times.map{ |size| lecun_normal.rand }
          @biases.push(NMatrix.new(@biases_geometry[i], biases_array, :dtype => :float64))
        end
      end
      
      # Output the weights and biases.
      puts "@weights: #{@weights}"
      puts "@biases: #{@biases}"
    end

    # Set the initializing methods to each weights and biases.
    # @param [Symbol or Array] weights_method the symbol or the array of initializing method of weights
    # @param [Symbol or Array] biases_method the symbol or the array of initializing method of biases
    # @return [Array] the array of intializing methods for weights and biases
    # @since 1.7.0
    def set_initializing_methods(weights_method, biases_method)
      weights_methods = Array.new(@neuron_columns.size)
      biases_methods = Array.new(@neuron_columns.size)

      # Judge the arguments of initializing methods.
      if weights_method.kind_of?(Symbol)
        # Set the initializing method passed as a symbol in the argument to weights.
        weights_methods.map!{ |method| method = weights_method }
      elsif weights_method.kind_of?(Array)
        # Set the initializing method passed as an array of symbol in the argument to weights.
        if weights_method.size == weights_methods.size
          weights_methods = weights_method
        else
          raise(ArgumentError, "The size of the initializing methods' array of weights needs to match the number of hidden and output layers.\n")
        end
      else
        # Set Uniform as default method.
        # If initializing method isn't passed, set Uniform to all weights.
        weights_methods.map!{ |method| method = :Uniform }
      end

      # Judge the arguments of initializing methods.
      if biases_method.kind_of?(Symbol)
        # Set the initializing method passed as a symbol in the argument to biases.
        biases_methods.map!{ |method| method = biases_method }
      elsif biases_method.kind_of?(Array)
        # Set the initializing method passed as an array of symbol in the argument to biases.
        if biases_method.size == biases_methods.size
          biases_methods = biases_method
        else
          raise(ArgumentError, "The size of the initializing methods' array of biasess needs to match the number of hidden and output layers.\n")
        end
      else
        # Set Sigmoid as default activation function.
        # If initializing method isn't passed, set Uniform to all weights.
        biases_methods.map!{ |method| method = :Uniform }
      end

      return weights_methods, biases_methods
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

    # Input to the any layer.
    # The main use is for post-learning confirmation.
    # @param [Integer] row the number of the hidden layer you want to input
    # @param [Array] values outputs of row-th layer's neurons
    # @since 1.0.0
    def input_to(row, *values)
      @a[row] = N[values.flatten, :dtype => :float64].transpose
    end

    # Compute multiply accumulate of inputs, weights and biases.
    # z = weights * inputs + biases
    # @param [Integer] row the number of layer currently computing
    # @since 1.0.0
    def compute_z(row)      
      # BLAS.gemm performs the following calculations.
      #   C = (alpha * A * B) + (beta * C)
      # In this case, the calculation results are stored in Matrix C.
      # For this reason, need to duplicate the @biases[row] value in @z[row] in advance.

      # Duplicate @biases[row] value to @z[row].
      @z[row] = NMatrix::BLAS.gemm(@idm[row], @biases[row])
      
      # Compute the values before the activation function is applied.  
      @z[row] = NMatrix::BLAS.gemm(@weights[row], @a[row], @z[row], 1.0, 1.0)                              
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

    # Compute from the any layer to the output layer.
    # The main use is for post-learning confirmation.
    # @param [Integer] row the number of layer you want to begin computing
    # row's range -> 1 ~ @neuron_columns.size - 1
    # @since 1.0.0
    def propagate_from(row)
      (row).upto(@neuron_columns.size-1) do |i|
        compute_z(i)
        compute_a(i)
      end
    end

    # Compute backpropagation and update parameters.
    # @since 1.0.0
    def backpropagate
      # If Softmax function is used on output layer with cross entropy function as loss function, do the following process.
      if @keys[-1] == :Softmax
        @delta[@neuron_columns.size-1] = @derivatives[-1].call(@T, @a[-1])
      else
        # the process in all cases except Softmax with cross entropy
        differentiate_activation_function(@neuron_columns.size-1)
        @delta[@neuron_columns.size-1] = @loss_derivative.call(@T, @a[-1]) * @derivative_activation_function[@neuron_columns.size-1] * @coefficients
      end

      # Compute loss derivatives. 
      compute_weights_derivatives(@neuron_columns.size-1)
      compute_biases_derivatives(@neuron_columns.size-1)

      (@neuron_columns.size-2).downto(0) do |i|
        differentiate_activation_function(i)
        compute_delta(i)
        compute_weights_derivatives(i)
        compute_biases_derivatives(i)
      end

      # If updating parameters is enable, updates biases and weights.
      if @updating_is_enabled
        if @count == @batch_size
          @count = 0
          update_parameters
        end
      end
    end

    # Compute backpropagation from any layer.
    # @param [Integer] row the number of layer you want to begin computing
    # row's range -> @neuron_columns.size ~ 0
    # @since 1.9.0
    def backpropagate_from(row)
      if (row-1) == @neuron_columns.size-1
        # If Softmax function is used on output layer with cross entropy function as loss function, do the following process.
        if @keys[-1] == :Softmax
          @delta[@neuron_columns.size-1] = @derivatives[-1].call(@T, @a[-1])
        else
          # the process in all cases except Softmax with cross entropy
          differentiate_activation_function(@neuron_columns.size-1)
          @delta[@neuron_columns.size-1] = @loss_derivative.call(@T, @a[-1]) * @derivative_activation_function[@neuron_columns.size-1] * @coefficients
        end
  
        # Compute loss derivatives. 
        compute_weights_derivatives(@neuron_columns.size-1)
        compute_biases_derivatives(@neuron_columns.size-1)
  
        (@neuron_columns.size-2).downto(0) do |i|
          differentiate_activation_function(i)
          compute_delta(i)
          compute_weights_derivatives(i)
          compute_biases_derivatives(i)
        end
      elsif (row-1) < (@neuron_columns.size-1)
        (row-1).downto(0) do |i|
          differentiate_activation_function(i)
          compute_delta(i)
          compute_weights_derivatives(i)
          compute_biases_derivatives(i)
        end
      end
    end

    # Compute backpropagation from output layer until any layer.
    # @param [Integer] row the number of layer you want to compute backpropagation
    # row's range -> @neuron_columns.size - 1 ～ 0
    # @since 1.9.0
    def backpropagate_until(row)
      if row < @neuron_columns.size
        # If Softmax function is used on output layer with cross entropy function as loss function, do the following process.
        if @keys[-1] == :Softmax
          @delta[@neuron_columns.size-1] = @derivatives[-1].call(@T, @a[-1])
        else
          # the process in all cases except Softmax with cross entropy
          differentiate_activation_function(@neuron_columns.size-1)
          @delta[@neuron_columns.size-1] = @loss_derivative.call(@T, @a[-1]) * @derivative_activation_function[@neuron_columns.size-1] * @coefficients
        end

        # Compute loss derivatives. 
        compute_weights_derivatives(@neuron_columns.size-1)
        compute_biases_derivatives(@neuron_columns.size-1)

        (@neuron_columns.size-2).downto(row) do |i|
          differentiate_activation_function(i)
          compute_delta(i)
          compute_weights_derivatives(i)
          compute_biases_derivatives(i)
        end
      end
    end

    # Differentiate neurons statuses.
    # @param [Integer] row the number of layer currently computing
    # @since 1.1.0
    def differentiate_activation_function(row)
      # Judge the symbol of activation function.
      array = [:Linear, :Sigmoid, :Tanh].include?(@keys[row]) ? @a[row+1] : @z[row] 

      # Defferentiate array correspond to activation function.
      @derivative_activation_function[row] = @derivatives[row].call(array)
    end

    # Compute delta.
    # @param [Integer] row the number of layer currently computing
    # @since 1.0.0
    def compute_delta(row)
      @delta[row] = NMatrix::BLAS.gemm(@weights[row+1], @delta[row+1], nil, 1.0, 0.0, :transpose) * @derivative_activation_function[row]      
    end

    # Compute derivatives of weights.
    # @param [Integer] row the number of layer currently computing
    # @since 1.2.0
    def compute_weights_derivatives(row)                  
      @loss_derivative_weights[row] += NMatrix::BLAS.gemm(@delta[row], @a[row].transpose)      
    end

    # Compute derivatives of biases.
    # @param [Integer] row the number of layer currently computing
    # @since 1.2.0
    def compute_biases_derivatives(row)
      @loss_derivative_biases[row] += @delta[row]
    end

    # Enable updating biases and weights.
    # @since 1.5.0
    def enable_update
      @updating_is_enabled = true
    end

    # Disable updating biases and weights.
    # @since 1.5.0
    def disable_update
      @updating_is_enabled = false
    end

    # Update weights.
    # @param [Integer] row the number of layer currently computing
    # @since 1.0.0
    def update_weights(row)
      @loss_derivative_weights[row] = @loss_derivative_weights[row] / @batch_size.to_f
      @weights[row] = NMatrix::BLAS.gemm(@idm[row], @loss_derivative_weights[row], @weights[row], -(@learning_rate), 1.0)
    end

    # Update biases.
    # @param [Integer] row the number of layer currently computing
    # @since 1.0.0
    def update_biases(row)
      @loss_derivative_biases[row] = @loss_derivative_biases[row] / @batch_size.to_f      
      @biases[row] = NMatrix::BLAS.gemm(@idm[row], @loss_derivative_biases[row], @biases[row], -(@learning_rate), 1.0)            
    end

    # Update biases and weights.
    # @since 1.2.0
    def update_parameters
      (@neuron_columns.size-1).downto(0) do |i|
        update_weights(i)
        update_biases(i)
      end
      initialize_loss_derivatives
    end

    # Update biases and weights from any layer.
    # @param [Integer] row the number of layer you want to begin updating
    # row's range -> @neuron_columns.size ~ 0
    # @since 1.9.0
    def update_parameters_from(row)
      (row-1).downto(0) do |i|
        update_weights(i)
        update_biases(i)
      end
    end
    
    # Compute backpropagation from output layer until any layer.
    # @param [Integer] row the number of layer you want to begin updating
    # row's range -> @neuron_columns.size - 1 ～ 0
    # @since 1.9.0
    def update_parameters_until(row)
      (@neuron_columns.size-1).downto(row) do |i|
        update_weights(i)
        update_biases(i)
      end
    end

    # Store parameters(biases and weights).
    # @param [Integer] row the number of layer you want to store parameters
    # @since 1.9.0
    def store_parameters(row)
      @stored_weights[row] = @weights[row].clone
      @stored_biases[row] = @biases[row].clone
    end

    # Restore parameters(biases and weights).
    # @param [Integer] row the number of layer you want to restore parameters
    # @since 1.9.0
    def restore_parameters(row)
      @weights[row] = @stored_weights[row]
      @biases[row] = @stored_biases[row]
    end

    # Compute loss by loss function.
    # @since 1.5.0
    def compute_loss
      @loss += @loss_antiderivative.call(@T, @a[-1])      
    end
    
    # Initialize and output loss by loss function.
    # @since 1.8.0
    def initialize_loss
      puts "loss : #{@loss}"
      @loss = 0.0
    end
    
    # Get loss value.
    # @since 1.9.0
    def get_loss
      return @loss
    end

    # Get outputs of the layer of neural network.
    # @param [Integer] row the row number you want to get outputs
    # @return [Array] @a[row] the output of layer specified by row
    # @since 1.0.0
    def get_outputs(row = @neuron_columns.size)
      return @a[row]
    end

    # Get derivative values.
    # @return [Hash] the hash of derivative values.
    # @since 1.5.0
    def get_derivative_values
      return { activation_function: @derivative_activation_function, delta: @delta, weights: @loss_derivative_weights, biases: @loss_derivative_biases } 
    end

    # Set derivative values.
    # @param [Hash] derivative_values the hash of derivative values
    # @since 1.6.0
    def set_derivative_values(derivative_values)
      @derivative_activation_function = derivative_values[:activation_function]
      @delta = derivative_values[:delta]
      @loss_derivative_weights = derivative_values[:weights]
      @loss_derivative_biases = derivative_values[:biases]
    end

    # Set a learning rate.
    # @param [Float] rate learning rate
    # @since 1.1.0
    def set_learning_rate(rate = 0.01)
      @learning_rate = rate
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
      # Make a hash of parameters.
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
          @weights.push(NMatrix.new(@weights_geometry[i], weights_array))
        end
        puts "#{@weights}"
      end
    end
  end
end