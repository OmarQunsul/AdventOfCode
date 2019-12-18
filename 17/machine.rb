class Machine
  attr_accessor :output, :inputs, :stopped, :relative, :pc, :outputs, :instructions

  def initialize(instructions)
    @instructions = instructions
    @instructions += [0] * 10000
    @pc = 0
    @relative = 0
    @outputs = []
  end

  def set_inputs(inputs)
    @inputs = inputs
  end

  def get_value(v, mode = 0)
    mode ||= 0
    return @instructions[v] if mode == 0
    return v if mode == 1
    return @instructions[v + @relative] if mode == 2
  end

  def run
    while true
      instruction = @instructions[@pc] % 100
      m = @instructions[@pc] / 100
      modes = []
      while m > 0
        modes.unshift(m % 10)
        m /= 10
      end
      modes.unshift(0)
      modes.unshift(0)
      modes.unshift(0)
      modes.unshift(0)

      if instruction == 99
        @stopped = true
        break
      elsif instruction == 1
        value = get_value(@instructions[@pc + 1], modes.pop) + get_value(@instructions[@pc + 2], modes.pop)
        mode = modes.pop
        if mode == 0
          @instructions[@instructions[@pc + 3]] = value
        elsif mode == 1
          @instructions[@pc + 3] = value
        elsif mode == 2
          @instructions[@instructions[@pc + 3] + @relative] = value
        end
        @pc += 4
      elsif instruction == 2
        value = get_value(@instructions[@pc + 1], modes.pop) * get_value(@instructions[@pc + 2], modes.pop)
        mode = modes.pop
        if mode == 0
          @instructions[@instructions[@pc + 3]] = value
        elsif mode == 1
          @instructions[@pc + 3] = value
        elsif mode == 2
          @instructions[@instructions[@pc + 3] + @relative] = value
        end
        @pc += 4
      elsif instruction == 3
        #raise "NO INPUTS" if inputs.empty?
        mode = modes.pop
        if mode == 0
          @instructions[@instructions[@pc + 1]] = inputs.shift
        elsif mode == 1
          @instructions[@pc + 1] = inputs.shift
        elsif mode == 2
          @instructions[@instructions[@pc + 1] + @relative] = inputs.shift
        end
        @pc += 2
      elsif instruction == 4
        mode = modes.pop
        if mode == 0
          @output = @instructions[@instructions[@pc + 1]]
        elsif mode == 1
          @output = @instructions[@pc + 1]
        elsif mode == 2
          @output = @instructions[@instructions[@pc + 1] + @relative]
        end
        @outputs << @output
        @pc += 2
      elsif instruction == 5
        if get_value(@instructions[@pc + 1], modes.pop) != 0
          @pc = get_value(@instructions[@pc + 2], modes.pop)
        else
          @pc += 3
        end
      elsif instruction == 6
        if get_value(@instructions[@pc + 1], modes.pop) == 0
          @pc = get_value(@instructions[@pc + 2], modes.pop)
        else
          @pc += 3
        end
      elsif instruction == 7
        condition = get_value(@instructions[@pc + 1], modes.pop) < get_value(@instructions[@pc + 2], modes.pop)
        mode = modes.pop
        if mode == 0
          @instructions[@instructions[@pc + 3]] = condition ? 1 : 0
        elsif mode == 1
          @instructions[@pc + 3] = condition ? 1 : 0
        elsif mode == 2
          @instructions[@instructions[@pc + 3] + @relative] = condition ? 1 : 0
        end
        @pc += 4
      elsif instruction == 8
        condition = get_value(@instructions[@pc + 1], modes.pop) == get_value(@instructions[@pc + 2], modes.pop)
        mode = modes.pop
        if mode == 0
          @instructions[@instructions[@pc + 3]] = condition ? 1 : 0
        elsif mode == 1
          @instructions[@pc + 3] = condition ? 1 : 0
        elsif mode == 2
          @instructions[@instructions[@pc + 3] + @relative] = condition ? 1 : 0
        end
        @pc += 4
      elsif instruction == 9
        @relative += get_value(@instructions[@pc + 1], modes.pop)
        @pc += 2
      else
        raise "Invalid Instruction #{instruction}"
      end
    end
  end
end

input = File.read("input.txt")
m = Machine.new(input.split(",").map(&:to_i))
m.set_inputs([])
m.run

# Part 1
view = [[]]
m.outputs.each do |output|
  if output == 10
    view << []
  elsif
    view.last << output.chr
  end
end

view = view.reject{|l| l.empty? }

width = view.first.length
height = view.length

sum = 0
view.each_with_index do |line, y|
  line.each_with_index do |val, x|
    if val == "#" && x > 0 && x < (width - 1) && y > 0 && y < (height - 1)
      if [view[y - 1][x], view[y + 1][x], view[y][x - 1], view[y][x + 1]].uniq == ["#"]
        #view[y][x] = "O"
        sum += x * y
      end
    end
  end
end

#
#view.each do |line|
#  puts line.join("")
#end

#puts sum

# Part 2
input = File.read("input.txt")
m = Machine.new(input.split(",").map(&:to_i))
m.instructions[0] = 2

inputs = []
inputs += "A,B,A,C,A,B,C,A,B,C".each_byte.to_a + [10]
inputs += "R,12,R,4,R,10,R,12".each_byte.to_a + [10]
inputs += "R,6,L,8,R,10".each_byte.to_a + [10]
inputs += "L,8,R,4,R,4,R,6".each_byte.to_a + [10]
inputs += "n".each_byte.to_a + [10]

puts inputs.inspect

m.set_inputs(inputs)
m.run

# For Debugging
#view = [[]]
#m.outputs.each do |output|
#  if output == 10
#    view << []
#  elsif
#    view.last << output.chr
#  end
#end
#
#view.each do |line|
#  puts line.join("")
#end

puts m.outputs.last
