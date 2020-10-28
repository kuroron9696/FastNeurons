module FastNeurons
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
    #   rbm = FastNeurons::RBM.new([5,4])
    #   rbm = FastNeurons::RBM.new([5,4],:Gaussian)
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
      pre_sigmoid = NMatrix::BLAS.gemm(@units[0], @weights[0]) + @biases[0]      
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
      product_of_units_and_weights = NMatrix::BLAS.gemm(@weights[0], @units[1].transpose)
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
      product_of_units_and_weights = NMatrix::BLAS.gemm(@weights[0], @units[1].transpose)

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
end