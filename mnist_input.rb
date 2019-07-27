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

  # mnistのデータをasciiで出力
  def ascii_print(inputs)
    inputs = inputs.map {|pixel| pixel*255}
    output = inputs.each_slice(28).map do |row|
      row.map do |darkness|
        darkness < 64 ?  " " : ( darkness < 128 ? "・" : "X" )
      end.join
    end.join("\n")
    puts output
  end

end

puts "Loading images"
mnist = Mnist_input.new("assets/t10k-images-idx3-ubyte.gz", "assets/t10k-labels-idx1-ubyte.gz")
images = mnist.load_images

puts "Initializing network"
nn = FastNeurons::NN.new([784,15,784]) # ネットワークの作成
#nn.randomize # ネットワークの初期化
nn.network_load("network.txt") # ネットワークの読み込み
imgs = images.map { |image| mnist.byte_to_float(image).flatten }

puts "Runnning..."
count = 0
10.times do
  imgs.each.with_index do |inputs,index|
    # expected_img = mnist.byte_to_float(img).flatten
    #puts "#{expected_img}"
    count += 1
    break if count >= 10000
    nn.input(inputs,inputs) # 入力データと教師データの入力
    nn.run(1) # 実行

    mnist.ascii_print(inputs) # 教師データを出力
    mnist.ascii_print(nn.outputs) # 学習したデータを出力
  end
end

puts "Understood!"
nn.network_save("network.txt")
gets

count = 0
1.times do
  imgs.each_with_index do |inputs,index|
    count += 1
    break if count >= 10
    #nn.input(inputs,inputs)
    #nn.propagate
    nn.hidden_input(1,15.times.map{rand()})
    nn.hidden_propagate(1)

    #mnist.ascii_print(inputs)
    mnist.ascii_print(nn.outputs)
  end
end
