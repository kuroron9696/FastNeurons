require 'HDLRuby'
require 'fileutils'
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
require_relative '../modules/network_simulator.rb'

# A proc object for instantiating module written by HDLRuby.
$network_simulator_caller = proc{ |*args, &blk| network_simulator(*args, &blk) }

module FastNeurons
  class NN
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
  
  
      @instance =  $network_simulator_caller.(@columns, @functions, @types, @integer_width, @decimal_width, @address_width, @inputs, @module_weights, @module_biases).(:neural_network)
    end
  
    # Generate the Verilog files of neural network module.
    # @param [String] folder_name output folder's name
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