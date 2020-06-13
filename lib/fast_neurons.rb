require 'nmatrix'
require 'json'

# Simple and fast library for building neural networks.
# @since 1.1.0
# @author Ryota Sakai,Yusuke Tomimoto
module FastNeurons
    # Describes a standard fully connected NN based on backpropagation.
    class NN

        # activation functions
        Sigmoid = { antiderivative: proc{ |z| z.exp / (z.exp + 1) }, derivative: proc{ |a| (-a + 1) * a } }
        Tanh = { antiderivative: proc{ |z| (z.exp - (-z).exp)/(z.exp + (-z).exp) }, derivative: proc{ |a| -(a * a) + 1 } }
        ReLU = { antiderivative: proc{ |z| N[z.map{ |x| [0.0,x].max }.to_a.flatten].transpose }, derivative: proc{ |a| N[a.map{ |x| x > 0.0 ? 1.0 : 0.0 }.to_a.flatten].transpose } }

        # Creates a NN from columns giving each the size
        # of a column of neurons (input and output comprised).
        # If a block is given as argument, it will be used as
        # default transfer fuction (default: sigmoid)
        # constructor
        # @param [Array] columns the array showing the shape of a neural network
        # @param [Symbol] activation_function the name of the activation function you want to use
        # ':Sigmoid' or ':Tanh'
        # @example initialization of the neural network
        #   nn = FastNeurons::NN.new([784,15,784])
        def initialize(columns, activation_function = :Sigmoid)

            # training rate
            @training_rate = 0.1

            # Ensure columns is a proper array.
            @columns = columns.flatten

            # The columns containing processing neurons (i.e., excluding the
            # inputs).
            @neuron_columns = @columns[1..-1]

            # Set a key of activation functions' hash.
            @key = activation_function

            # Make a hash of activation_functions.
            @activation_functions = { Sigmoid: Sigmoid, Tanh: Tanh, ReLU: ReLU }

            # Creates the geometry of the bias matrices
            @biases_geometry = @neuron_columns.map { |col| [col,1] }


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
            @loss_derivate_weights = @weights_geometry.map{ |g| NMatrix.new(g,0.0) }
            @loss_derivate_biases = @biases_geometry.map{ |g| NMatrix.new(g,0.0) }

            # the vector that all elements is 1.(need for differentiate neurons statuses)
            @ones_vector = @columns.map{ |i| NVector.ones(i) }

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
            # Compute the values before the activation function
            # is applied.
            @z[row] = NMatrix::BLAS.gemm(@weights[row],@a[row],@biases[row])
        end

        # Compute neurons statuses.
        # Apply activation function to z.
        # @param [Int] row the number of layer currently computing
        def compute_a(row)
          @a[row+1] = @activation_functions[@key][:antiderivative].call(@z[row])
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
            NMatrix::BLAS.gemm(@delta[@neuron_columns.size-1],@a[@neuron_columns.size-1].transpose,@loss_derivate_weights[@neuron_columns.size-1],1.0,0.0)
            @loss_derivate_biases[@neuron_columns.size-1] = @delta[@neuron_columns.size-1]
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
          @g_dash[row] = @activation_functions[@key][:derivative].call(@a[row+1])
        end

        # Compute delta.
        # @param [Int] row the number of layer currently computing
        def compute_delta(row)
          @delta[row] = NMatrix::BLAS.gemm(@weights[row+1],@delta[row+1],nil,1.0,0.0,:transpose)*@g_dash[row]
        end

        # Compute derivative of weights.
        # @param [Int] row the number of layer currently computing
        def differentiate_weights(row)
          @loss_derivate_weights[row] = NMatrix::BLAS.gemm(@delta[row],@a[row].transpose)
        end

        # Compute derivative of biases.
        # @param [Int] row the number of layer currently computing
        def differentiate_biases(row)
          @loss_derivate_biases[row] = @delta[row]
        end

        # Update weights.
        # @param [Int] row the number of layer currently computing
        def update_weights(row)
          @weights[row] = NMatrix::BLAS.gemm(@idn[row],@loss_derivate_weights[row],@weights[row],-(@training_rate),1.0)
        end

        # Update biases.
        # @param [Int] row the number of layer currently computing
        def update_biases(row)
          @biases[row] = NMatrix::BLAS.gemm(@idn[row],@loss_derivate_biases[row],@biases[row],-(@training_rate),1.0)
        end

        # Get outputs of neural network.
        def get_outputs
          return @a[@neuron_columns.size]
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
          hash = { "activation_function" => @key, "columns" => @columns, "biases" => @biases, "weights" => @weights }

          # Save file.
          File.open(path,"w+") do |f|
            f.puts(JSON.pretty_generate(hash))
          end
        end

        # Load learned network from JSON file.
        # @param [String] path file path
        def load_network(path, activation_function = nil)
          # Open file.
          File.open(path,"r+") do |f|

            # Load hash from JSON file.
            hash = JSON.load(f)

            # Set activation function.
            # If activation function has not been set, it will be loaded from JSON file.
            activation_function = activation_function.nil? ? hash["activation_function"].to_sym : activation_function

            # Set columns from hash.
            @columns = hash["columns"]

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
end
