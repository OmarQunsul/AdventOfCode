lines = File.read("input2.txt").split("\n")

input = (0..9).to_a

def process(input, line)
  if line.start_with?("deal into new stack")
    output = input.reverse
  elsif line.start_with?("cut")
    n = line.split(" ").last.to_i
    if n > 0
      output = input[(-1 * (input.length - n))..-1] + input[0...n]
    else
      output = input[n..-1] + input[0...(input.length + n)]
    end
  elsif line.start_with?("deal with increment")

  else
    raise "ERROR #{line}"
  end
  output
end

lines.each do |line|
  input = process(input, line)
end
