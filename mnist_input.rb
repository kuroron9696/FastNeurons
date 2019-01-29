require_relative 'idx_loader'
require_relative 'fast_neurons'
require 'zlib'

# Mnistの画像データを入力するクラス
class Mnist_input
  # 画像のパスを取得
  def initialize(image_path, label_path)
    @image_path = image_path
    @label_path = label_path
  end

  # 画像読み込み
  def load_images
    @images = load_gzipped_idx_file(@image_path)
  end

  # ラベル読み込み
  def load_labels
    @labels = load_gzipped_idx_file(@label_path)
  end

  # gzippedfileを読み込み
  def load_gzipped_idx_file(path)
    file = File.open(path,"rb")
    stream = Zlib::GzipReader.new(file)
    IdxLoader.load(stream)
  end

  # ピクセルのbyte値をfloatに変換
  def byte_to_float(inputs)
    return inputs.map{|pixel|
      pixel/256.0
    }
  end

end

puts "Loading images"
mnist = Mnist_input.new("assets/t10k-images-idx3-ubyte.gz", "assets/t10k-labels-idx1-ubyte.gz")
images = mnist.load_images

puts "Initializing network"
nn = FastNeurons::NN.new([784,15,784]) # ネットワークの作成
nn.randomize # ネットワークの初期化

imgs = images.map { |image| mnist.byte_to_float(image).flatten }
data = imgs.zip(imgs)

puts "Runnning..."
1000.times do
  data.each do |img,expected_img|
    # expected_img = mnist.byte_to_float(img).flatten
    #puts "#{expected_img}"
    nn.input(img,expected_img) # 入力データと教師データの入力
    nn.run(100) # 実行
  end
end
