require 'matrix'
require 'benchmark'
require 'nmatrix'

class Bmark
  def initialize
    @big0 = [] #ランダムな数字を格納する配列の生成
    @big1 = [] #ランダムな数字を格納する配列の生成
  end

  def creatematrix(row0,column0,row1,column1)
    column0.times { |i| @big0 << [].fill(0,row0) { Random.rand } }
    #column0回だけ配列big0にrow0個のランダムな数字を要素として追加する
    column1.times { |i| @big1 << [].fill(0,row1) { Random.rand } }
    #column1回だけ配列big1にrow1個のランダムな数字を要素として追加する

    @mat0 = Matrix[*@big0]
    #columns0×row0のMatrixクラスの行列を生成する(要素の数字はランダム)
    @mat1 = Matrix[*@big1]
    #columns1×row1のMatrixクラスのRubyの行列を生成する(要素の数字はランダム)

    @nmat0 = NMatrix.new([row0,column0],Random.rand)
    #columns0×row0のNMatrixクラスの行列を生成する(要素の数字はランダム)
    @nmat1 = NMatrix.new([row1,column1],Random.rand)
    #columns0×row0のNMatrixクラスの行列を生成する(要素の数字はランダム)
  end

  def bmark
    Benchmark.bm 10 do |x|
      x.report "NMatrix" do
        1000.times { @nmat0.dot(@nmat1) }
        #NMatrixクラスの行列通しでドット積(内積)の計算を1000回行う
      end

      x.report "Matrix" do
        1000.times { @mat1*@mat0 }
        #Matrixクラスの行列通しでドット積(内積)の計算を1000回行う
      end
    end
  end
end

bench = Bmark.new #Bmarkクラスのオブジェクト生成
bench.creatematrix(2000,2000,2000,1) #行列、ベクトルの大きさを設定する
bench.bmark #計算速度の測定を行う
