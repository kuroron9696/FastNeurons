require_relative 'idx_loader'
require 'zlib'

# Loader of MNIST.
class MNISTLoader
  # constructor
  # @param [String] image_path path of images.
  # @param [String] label_path path of labels.
  def initialize(image_path, label_path)
    @image_path = image_path
    @label_path = label_path
  end

  # Load images.
  def load_images
    @images = load_gzipped_idx_file(@image_path)
  end

  # Load labels.
  def load_labels
    @labels = load_gzipped_idx_file(@label_path)
  end

  # Load gzipped file.
  # @param [String] path file path
  def load_gzipped_idx_file(path)
    file = File.open(path,"rb")
    stream = Zlib::GzipReader.new(file)
    IdxLoader.load(stream)
  end

  # Normalize pixel values to a continuous values from 0 ~ 255 to 0 ~ 1.
  # @param [Array] inputs array of pixel values.
  # @return [Array] array of normalized pixel values
  def normalize(inputs)
    return inputs.map{|pixel|
      pixel/256.0
    }
  end

  # Binarize pixel values to a continuous values from 0 ~ 255 to 0,1.
  # @param [Array] inputs array of pixel values.
  # @return [Array] array of binarized pixel values
  def binarize(inputs)
    return inputs.map{|pixel|
      pixel > 0.5 ? 1.0 : 0.0
    }
  end

  # Print ascii of MNIST.
  # @param [Array] inputs array of pixel values
  def print_ascii(inputs)
    inputs = inputs.map {|pixel| pixel*255}
    outputs = inputs.each_slice(28).map do |row|
      row.map do |darkness|
        darkness < 64 ?  " " : ( darkness < 128 ? "・" : "X" )
      end.join
    end.join("\n")
    puts outputs
  end
end
