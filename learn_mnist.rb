require_relative './lib/fast_neurons'
require_relative './lib/mnist_loader'

puts "Loading images"

# MNISTの読み込み
mnist = MNISTLoader.new("assets/t10k-images-idx3-ubyte.gz", "assets/t10k-labels-idx1-ubyte.gz")
images = mnist.load_images

puts "Initializing network"

nn = FastNeurons::NN.new([784,15,784]) # ネットワークの作成

#nn.randomize # ネットワークの初期化

nn.load_network("network.json") # 学習したネットワークの読み込み

# pixel値を0 ～ 1の連続値に正規化
imgs = images.map { |image| mnist.byte_to_float(image).flatten }

puts "Runnning..."

# 学習
# サンプルとしてオートエンコーダを構築
1.times do
  imgs.each.with_index do |inputs,index|

    nn.input(inputs,inputs) # 入力データと教師データの入力
    nn.run(1) # 実行

    mnist.ascii_print(inputs) # 教師データを出力
    mnist.ascii_print(nn.outputs) # 学習したデータを出力
  end
end
puts "Understood!"
nn.save_network("network.json") # 学習したネットワークを保存
gets

# 学習後の確認
10.times do
  nn.hidden_input(1,15.times.map{rand()})
  nn.hidden_propagate(1)
  mnist.ascii_print(nn.outputs)
end
