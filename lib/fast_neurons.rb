require 'nmatrix'
require 'json'

##
#      Simple and fast library for building neural networks.
########################################################################

module FastNeurons

    Sigmoid = proc { |x| 1 / (1 + Math::E**(-x)) }
    ##
    # Describes a standard fully connected NN based on backpropagation.
    class NN
        # Creates a NN from columns giving each the size
        # of a column of neurons (input and output comprised).
        # If a block is given as argument, it will be used as
        # default transfer fuction (default: sigmoid)
        def initialize(*columns,&transfer)
            # 学習率
            @training_rate = 0.1
            # Ensure columns is a proper array.
            # 各層のニューロンの数を配列にする
            @columns = columns.flatten
            # The columns containing processing neurons (i.e., excluding the
            # inputs).
            @neuron_columns = @columns[1..-1]

            # Set the default transfer function
            @transfer = block_given? ? Sigmoid : transfer

            # Creates the geometry of the bias matrices
            @biases_geometry = @neuron_columns.map { |col| [col,1] }


            # Create the geometry of the weight matrices
            @weights_geometry = @neuron_columns.zip(@columns[0..-2])


            # Create the geometry of the linear results (z)
            # NOTE: shoud be the same as the biases.
            # 活性化関数を適用する前の計算値を格納
            @z = @biases_geometry.clone

            # Create the geomet ry of the neurons statuses.
            # NOTE: includes the input values of the NN, hence uses @columns
            # NOTE: a[0] ARE the input values
            # a[0]にニューラルネットワークへの入力値を格納
            # a[1]以降に活性化関数を適用した後の計算値を格納
            @a = @columns.map{ |col| NMatrix.new([1,col],0.0).transpose }

            @g_dash = @biases_geometry.clone #シグモイドの微分値を格納

            @delta_t = @biases_geometry.map { |g| NMatrix.new(g,0.0).transpose } #g_dashと同じ形のデルタを作成
            @delta = @biases_geometry.clone #計算値を格納
            @loss_derivate_weights = @weights_geometry.map{ |g| NMatrix.new(g,0.0) } #重みの導関数を格納
            @loss_derivate_biases = @biases_geometry.map{ |g| NMatrix.new(g,0.0) } #バイアスの導関数を格納

            @ones_vector = @columns.map{ |i| NVector.ones(i) }  #シグモイドの微分値計算用の列ベクトルを生成 ※全要素が1の列ベクトル
            @idn_geometry = @weights_geometry.clone # @idn生成用の配列
            @idn = @idn_geometry.map{ |g| NMatrix.eye([g[0],g[0]]) } # 正方行列の生成
        end


        # Set up the NN to random values.
        def randomize

            # Create random fast matrices for the biases.
            # NMatrixの配列を作成 バイアス
            @biases = @biases_geometry.map { |geo| NMatrix.random(geo,:dtype => :float64)}
            @biases.size.times do |i|
              @biases[i] -= 0.5
            end
            puts "@biases: #{@biases}"
            # Create random fast matrices for the weights.
            # NMatrixの配列を作成 重み
            @weights = @weights_geometry.map do |geo|
                NMatrix.random(geo,:dtype => :float64)
            end
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

        # NNへの入力を取得
        # 引数: *vaules→入力 t→教師信号
        def input(*values,t)
            # The inputs are stored into a[0] as a NMatrix vector.
            # a[0]にはニューラルネットワークへの入力値をNMatrixの行列として格納
            @a[0] = N[values.flatten,:dtype => :float64].transpose
            @T = N[t.flatten,:dtype => :float64].transpose
        end

        # 隠れ層への入力を行うメソッド
        # 主な用途は学習後のネットワークの確認
        def hidden_input(row,*values)
            @a[row] = N[values.flatten,:dtype => :float64].transpose
        end

        # z = inputs * weights + biases
        # z = 入力値×重み+バイアス
        # zは長さの違う配列を複数持つ配列
        # zは活性化関数適用前の状態
        # 活性化関数への入力値を計算するメソッド
        # 引数:row 現在の層のインデックス →　現在が何層目かを表す。
        def z_compute(row)
            @z[row] = NMatrix::BLAS.gemm(@weights[row],@a[row],@biases[row])
        end

        # Apply activating function to z
        # 活性化関数への入力値 z に活性化関数を適用するメソッド
        # rowの次の層への入力値@a[row+1]
        def a_compute(row)
            @z[row].each_with_index do |data,i|
              @a[row+1][i] = Sigmoid.call(data) # Sigmoidの計算
            end
        end

        # 入力層から順方向に計算するメソッド
        # 最初に入力されたニューラルネットワークの層の回数計算する
        def propagate
            # 変数：入力、状態　定数：重み、バイアス
            @neuron_columns.size.times do |i|
              z_compute(i)
              a_compute(i)
            end
        end

        # 隠れ層から出力層への計算のみを行うメソッド
        # 主な用途は学習後のネットワークの確認
        # 引数 : 計算を開始したい層のインデックス (1 から @neuron_columns.size-1 まで)
        def hidden_propagate(row)
          (row).upto(@neuron_columns.size-1) do |i|
            z_compute(i)
            a_compute(i)
          end
        end

        # backpropagation用メソッド
        # 変数：重み、バイアス　定数、入力、状態
        # 活性関数(ここではシグモイド関数)の微分は簡単なので足し算と掛け算で実装できる
        # 重みとバイアスを調整する
        def backpropagate
            sigmoid_derivate(@neuron_columns.size-1)
            @delta[@neuron_columns.size-1] = @g_dash[@neuron_columns.size-1]*(@a[@neuron_columns.size] - @T)
            NMatrix::BLAS.gemm(@delta[@neuron_columns.size-1],@a[@neuron_columns.size-1].transpose,@loss_derivate_weights[@neuron_columns.size-1],1.0,0.0)
            @loss_derivate_biases[@neuron_columns.size-1] = @delta[@neuron_columns.size-1]
            update_weights(@neuron_columns.size-1)
            update_biases(@neuron_columns.size-1)
            (@neuron_columns.size-2).downto(0) do |i|
              sigmoid_derivate(i)
              delta(i)
              loss_derivate_weights(i)
              loss_derivate_biases(i)
              update_weights(i)
              update_biases(i)
            end
        end

        # Sigmoidを微分するメソッド
        # 最初のデルタは別に計算する必要がある。
        # シグモイドの微分は f'(x) = ( 1 - f(x) )*f(x)
        def sigmoid_derivate(row)
          @g_dash[row] = (@ones_vector[row+1] - @a[row+1])  * @a[row+1]
        end

        # デルタを計算するメソッド
        def delta(row)
          @delta[row] = NMatrix::BLAS.gemm(@weights[row+1],@delta[row+1],nil,1.0,0.0,:transpose)*@g_dash[row]
        end

        # 重みの導関数を導出するメソッド
        def loss_derivate_weights(row)
          @loss_derivate_weights[row] = NMatrix::BLAS.gemm(@delta[row],@a[row].transpose)
        end

        # バイアスの導関数を導出するメソッド
        def loss_derivate_biases(row)
          @loss_derivate_biases[row] = @delta[row]
        end

        # 重みを更新するメソッド
        def update_weights(row)
          @weights[row] = NMatrix::BLAS.gemm(@idn[row],@loss_derivate_weights[row],@weights[row],-(@training_rate),1.0)
        end

        # バイアスを更新するメソッド
        def update_biases(row)
          @biases[row] = NMatrix::BLAS.gemm(@idn[row],@loss_derivate_biases[row],@biases[row],-(@training_rate),1.0)
        end

        # 重みとバイアスを出力
        def backpropagate_outputs(row)
          puts "weights=#{@weights[row]}"
          puts "biases=#{@biases[row]}"
        end

        # 入力値と状態を出力
        def propagate_outputs(row)
          puts "a=#{@a[row]}"
          puts "z=#{@z[row]}"
        end

        def outputs
          @a[@neuron_columns.size]
        end

        def run(time)
          time.times do |trial|
            propagate # 順方向計算
            backpropagate # 誤差逆伝搬の計算
          end
        end

        # 学習したネットワークを保存するメソッド
        def save_network(filename)
          hash = {"columns" => @columns,"biases" => @biases,"weights" => @weights}
          File.open(filename,"w+") do |f|
            f.puts(JSON.pretty_generate(hash))
          end
        end

        # 学習したネットワークを読み出すメソッド
        def load_network(filename)
          File.open(filename,"r+") do |f|
            hash = JSON.load(f)
            @columns = hash["columns"]
            initialize(@columns)

            biases_matrix = hash["biases"].to_a
            @biases = []
            @neuron_columns.size.times do |i|
              @biases.push(N[biases_matrix[i].split(',').map!{ |item| item.delete("/[\-]/").gsub(" ","").to_f}].transpose)
            end
            puts "#{@biases}"

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
