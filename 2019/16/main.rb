BASE = [0, 1, 0, -1]

@cache_patterns = {}

def generate_pattern(index)
  result = []

  count = (index + 1)

  BASE.each do |el|
    result += [el] * count
  end

  @cache_patterns[index] = result
  result
end

def phase(input)
  output = []
  input.each_with_index do |val, ind|
    pattern = generate_pattern(ind)
    sum = 0
    input.each_with_index do |val2, ind2|
      p = pattern[(ind2 + 1) % pattern.length]
      sum += (val2 * p)
    end
    output << sum.abs % 10
  end
  output
end

def phase_fast(input)
  output = []
  output
end

# Part 1
# input = File.read("input.txt").split("").map(&:to_i)
# output = input.clone
# 100.times { output = phase(output) }
# puts output[0..7].join("")

raw_input = File.read("input.txt")
raw_input = "03036732577212944063491565474664"
signal = raw_input.split("").map(&:to_i) * 10000
offset = raw_input[0..6].to_i

output = signal.clone
100.times { |i| puts i; output = phase(output) }
