require 'HDLRuby'
require 'fileutils'
require 'HDLRuby'
require 'HDLRuby/hruby_check.rb'
require 'HDLRuby/hruby_low2high'
require 'HDLRuby/hruby_low2c'
require 'HDLRuby/hruby_low2vhd'
require 'HDLRuby/hruby_low_fix_types'
require 'HDLRuby/hruby_low_without_outread'
require 'HDLRuby/hruby_low_with_bool'
require 'HDLRuby/hruby_low_bool2select'
require 'HDLRuby/hruby_low_without_select'
require 'HDLRuby/hruby_low_without_namespace'
require 'HDLRuby/hruby_low_without_bit2vector'
require 'HDLRuby/hruby_low_with_port'
require 'HDLRuby/hruby_low_with_var'
require 'HDLRuby/hruby_low_without_concat'
require 'HDLRuby/hruby_low_without_connection'
require 'HDLRuby/hruby_low_cleanup'
require 'HDLRuby/hruby_verilog.rb'
require 'HDLRuby/backend/hruby_allocator'
require 'HDLRuby/backend/hruby_c_allocator'

configure_high
require_relative 'modules/network_constructor.rb'

# A proc object for instantiating module written by HDLRuby.
$network_constructor_caller = proc{ |*args, &blk| network_constructor(*args, &blk) }

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
    def initialize(columns, activation_function = nil, loss_function = :MeanSquare)
      # training rate
      @learning_rate = 0.1

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
      @loss_functions = { MeanSquare: MeanSquare, CrossEntropy: CrossEntropy }

      # Set the proc object of antiderivative of a specified loss function.
      @loss_antiderivative = @loss_functions[loss_function][:antiderivative]

      # Set the proc object of derivative of a specified loss function.
      @loss_derivative = @loss_functions[loss_function][:derivative]

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
      @idm_geometry = @weights_geometry.clone

      # Create identity matrix.
      @idm = @idm_geometry.map{ |g| NMatrix.eye([g[0],g[0]]) }

      # Set the coefficients of derivatives.
      @coefficients = NMatrix.ones_like(@a[@neuron_columns.size])

      # Indicates whether updating parameters are enabled or not.
      @updating_is_enabled = true

      # loss of neural network
      @loss = 0
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
      @z[row] = NMatrix::BLAS.gemm(@weights[row], @a[row], @biases[row].clone, 1.0, 1.0)      
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
      @delta[@neuron_columns.size-1] = @loss_derivative.call(@T, @a[-1]) * @g_dash[@neuron_columns.size-1] * @coefficients
      @loss_derivative_weights[@neuron_columns.size-1] += NMatrix::BLAS.gemm(@delta[@neuron_columns.size-1], @a[@neuron_columns.size-1].transpose)
      @loss_derivative_biases[@neuron_columns.size-1] += @delta[@neuron_columns.size-1]

      (@neuron_columns.size-2).downto(0) do |i|
        differentiate_a(i)
        compute_delta(i)
        differentiate_weights(i)
        differentiate_biases(i)
      end

      # If updating parameters is enable, updates biases and weights.
      if @updating_is_enabled
        if @count == @batch_size
          @count = 0
          update_parameters
          initialize_loss_derivatives
        end
      else
        if @count == @batch_size
          (@neuron_columns.size - 1).downto(0) do |row|
            puts "@g_dash[#{row}] : #{@g_dash[row]}"
            puts "@delta[#{row}] : #{@delta[row]}"
            puts "@loss_derivative_weights[#{row}] : #{@loss_derivative_weights[row]}"
            puts "@loss_derivative_biases[#{row}] : #{@loss_derivative_biases[row]}"
          end
        end
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
      @delta[row] = NMatrix::BLAS.gemm(@weights[row+1], @delta[row+1], nil, 1.0, 0.0, :transpose) * @g_dash[row]      
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
      @weights[row] = NMatrix::BLAS.gemm(@idm[row], @loss_derivative_weights[row], @weights[row].clone, @learning_rate, 1.0)
    end

    # Update biases.
    # @param [Integer] row the number of layer currently computing
    # @since 1.0.0
    def update_biases(row)
      @loss_derivative_biases[row] = @loss_derivative_biases[row] / @batch_size.to_f
      @biases[row] = NMatrix::BLAS.gemm(@idm[row], @loss_derivative_biases[row], @biases[row].clone, @learning_rate, 1.0)
    end

    # Update biases and weights.
    # @since 1.2.0
    def update_parameters
      (@neuron_columns.size-1).downto(0) do |i|
        update_weights(i)
        update_biases(i)
      end
    end

    # Compute loss by loss function.
    # @since 1.5.0
    def compute_loss
      @loss = @loss_antiderivative.call(@T, @a[-1])
      puts "loss : #{@loss}"
    end    

    # Get outputs of the layer of neural network.
    # @param [Integer] row the row number you want to get outputs
    # @return [Array] @a[row] the output of layer specified by row
    # @since 1.0.0
    def get_outputs(row = @neuron_columns.size)
      return @a[row]
    end

    # Set a learning rate.
    # @param [Float] rate learning rate
    # @since 1.1.0
    def set_learning_rate(rate = 0.1)
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
          @weights.push(NMatrix.new(@weights_geometry[i], weights_array))
        end
        puts "#{@weights}"
      end
    end

    # Instantiate neural network module written by HDLRuby.
    # @param [Array or proc] functions an activation function of each layer
    # @param [Integer] integer_width the width of integer part of fixed point
    # @param [Integer] decimal_width the width of decimal part of fixed point
    # @param [Integer] address_width the width of address for Look up table of activation functions
    # @param [Array] inputs inputs of neural network(for simulation)
    # @param [Array] weights an array of all weights of neural network
    # @param [Array] biases an array of all biases of neural network
    # @since 1.4.0
    def instantiate(functions, integer_width, decimal_width, address_width, inputs, weights = nil, biases = nil)
      @functions = functions
      @integer_width = integer_width
      @decimal_width = decimal_width
      @address_width = address_width

      @types = signed[@integer_width, @decimal_width]

      @inputs = inputs
      @module_weights = weights.nil? ? @weights.map.with_index{ |w, i| w.to_a.flatten.each_slice(@weights_geometry[i][1]).to_a } : weights
      @module_biases = biases.nil? ? @biases.map{ |b| b.to_a.flatten } : biases


      @instance =  $network_constructor_caller.(@columns, @functions, @types, @integer_width, @decimal_width, @address_width, @inputs, @module_weights, @module_biases).(:neural_network)
    end

    # Generate the Verilog files of neural network module.
    # @poram [String] folder_name output folder's name
    # @since 1.4.0
    def to_verilog(folder_name)
      # Generate the low level representation.
      top_system = @instance.to_low.systemT

      top_system.each_systemT_deep do |systemT|
        systemT.to_upper_space!
        systemT.to_global_systemTs!
        systemT.initial_concat_to_timed!
        systemT.with_port!
      end

      output = folder_name
      basename = output + "/neural_network"

      # Create a directory if necessary.
      unless File.directory?(output)
        FileUtils.mkdir_p(output)
      end

      # Prepare the initial name for the main file.
      name = basename + ".v"
      # Multiple files generation mode.
      top_system.each_systemT_deep do |systemT|
        # Generate the name if necessary.
        unless name
          name = output + "/" + HDLRuby::Verilog.name_to_verilog(systemT.name) + ".v"
        end
        
        # Open the file for current systemT
        outfile = File.open(name,"w")
    
        # Generate the Verilog code in to.    
        outfile << systemT.to_verilog

        # Close the file.
        outfile.close

        # Clears the name.
        name = nil
      end
    end
  end
end