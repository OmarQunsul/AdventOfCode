input = File.read("input.txt").strip.split("").map(&:to_i)

layers_count = input.length / (25 * 6)
layer_length = input.length / layers_count

#raise [row_length, rows_number].inspect

rows = []
(0...layers_count).each do |i|
  rows << input[0...layer_length]
  input = input[layer_length..-1]
end

pixels = []
(0...(25 * 6)).each do |i|
  (0...layers_count).each do |j|
    next if rows[j][i] == 2
    pixels << rows[j][i]
    break
  end
end

6.times do
  puts pixels[0...25].join("").gsub("0", " ").gsub("1", "*")
  pixels = pixels[25..-1]
end


#min_zeros = nil
#
#(0...layers_count).each do |i|
#  zeros = rows[i].select{|n| n == 0}.length
#  if min_zeros.nil? || zeros < min_zeros
#    min_zeros = zeros
#    ones = rows[i].select{|n| n == 1}.length
#    twos = rows[i].select{|n| n == 2}.length
#    puts [ones, twos].inspect
#    puts rows[i].length
#    puts i
#    @answer = ones * twos
#  end
#end
#
#puts @answer


