class IdxLoader
  IMAGE_FILE = 3
  LABEL_FILE = 1
  DWORD_SIZE = 4
  HEADER_UNPACK_STRING = 'S>CC'
  IMAGE_FILE_SIZE_UNPACK_STRING = 'L>L>L>'
  LABEL_FILE_SIZE_UNPACK_STRING = 'L>'

  def self.load(input_stream)
    header = input_stream.read(DWORD_SIZE)
    _zero_bytes, _data_type, dimensions_count = header.unpack(HEADER_UNPACK_STRING)

    case dimensions_count
    when IMAGE_FILE
      size_data = input_stream.read(IMAGE_FILE * DWORD_SIZE)
      images_count, row_length, column_length = size_data.unpack(IMAGE_FILE_SIZE_UNPACK_STRING)
      unpack_images(images_count, row_length, column_length, input_stream)
    when LABEL_FILE
      size_data = input_stream.read(LABEL_FILE * DWORD_SIZE)
      labels_count, = size_data.unpack(LABEL_FILE_SIZE_UNPACK_STRING)
      unpack_labels(labels_count, input_stream)
    end
  end

  def self.unpack_images(images_count, row_length, column_length, input_stream)
    images_count.times.map do 
      input_stream.read(row_length * column_length).chars.map do |byte|
        byte.unpack('C').first
      end
    end
  end

  def self.unpack_labels(labels_count, input_stream)
    input_stream.read(labels_count).chars.map do |byte|
      byte.unpack('C').first
    end
  end
end
