lines = File.read("input.txt").split("\n")
@eq = Hash.new
@leftovers = Hash.new(0)

def parse_quantity(str)
  q = str.split(" ").first.to_i
  n = str.split(" ").last
  {name: n, quantity: q}
end

lines.each do |line|
  inputs, target = line.split("=>").map(&:strip)
  target = parse_quantity(target)
  inputs = inputs.split(",").map(&:strip).map{|n| parse_quantity(n) }
  @eq[target] = inputs
end

def solve(target, name)
  return target.ceil if name == "ORE"
  available = @leftovers[name]

  if available > target
    @leftovers[name] -= target
    return 0
  elsif available > 0
    target -= available
    @leftovers[name] = 0
  end

  inputs = @eq.select{|k| k[:name] == name}.values.first
  target_info = @eq.select{|k| k[:name] == name}.first.first

  factor = (target * 1.0 / target_info[:quantity]).ceil

  sum = inputs.map{|input| solve(input[:quantity] * factor, input[:name]) }.sum

  leftover = (factor * target_info[:quantity]) - target
  @leftovers[name] += leftover

  sum
end

answer = solve(1, "FUEL")
puts answer

