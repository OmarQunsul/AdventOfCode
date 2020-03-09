lines = File.read("input.txt").split("\n")

input = (0...10007).to_a

def process(input, line)
  original_length = input.length
  if line.start_with?("deal into new stack")
    output = []
    while input.any?
      output.unshift(input.shift)
    end
  elsif line.start_with?("cut")
    n = line.split(" ").last.to_i
    raise "BIG" if n > input.length
    if n > 0
      output = input[n..-1] + input[0...n]
    elsif n < 0
      output = input[n..-1] + input[0...n]
    elsif n == 0
      raise "0"
    end
  elsif line.start_with?("deal with increment")
    n = line.split(" ").last.to_i
    i = 0
    output = Array.new(input.length)
    while input.any?
      raise "occupied" if output[i] != nil
      output[i] = input.shift
      i = (i + n) % original_length
    end
  else
    raise "ERROR #{line}"
  end
  raise "NULL" if output.select{|l| l.nil?}.any?
  raise "NOT SAME LENGTH #{line} #{output.length} #{input.length}" if output.length != original_length
  raise "NOT UNIQUE" if output.uniq.length < original_length
  output
end

lines.each do |line|
  output = process(input, line)
  input = output
  puts input.inspect
end

raise input.index_of?(2009)

