a = ["line1", "line2", "line3"]
File.open("sample.txt", "r+") do |f|
  a.each { |s| f.puts(s) }
end
