require_relative 'idx_loader'
require 'zlib'

# MNISTの画像データを入力するクラス
class MNISTLoader
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

  # gzipped fileを読み込み
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
