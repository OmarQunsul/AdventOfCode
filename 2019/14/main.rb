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


# PART2
t = 1000000000000
min = 899155 # PROBLEM
#min = 2210736
count = (t * 1.0 / min).floor
puts "TARGET #{count}"
t -= solve(count, "FUEL")
@leftovers["ORE"] = t

target = 10000
while target > 0
  @original_leftovers = @leftovers.clone
  @leftovers["ORE"] -= solve(target, "FUEL")
  if @leftovers["ORE"] >= 0
    @original_leftovers= @leftovers.clone
    count += target
  else
    target -= 1
    puts target
    @leftovers = @original_leftovers
  end
  break if @leftovers["ORE"] == 0
  puts target
end

#while @leftovers["ORE"] > 0
#  puts "---- " + @leftovers["ORE"].to_s if count % 100 == 0
#  @leftovers["ORE"] -= solve(1, "FUEL")
#  count += 1
#end

puts count



# PART 1
#answer = solve(1, "FUEL")
#puts answer

