class Machine
  attr_accessor :output, :inputs, :stopped, :relative, :pc

  def initialize(instructions)
    @instructions = instructions
    @instructions += [0] * 10000
    @pc = 0
    @relative = 0
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

@input = File.read("input.txt")

@cache = {}

def square_value(x, y)
  return @cache[[x, y]] if @cache[[x, y]] != nil
  m = Machine.new(@input.split(",").map(&:to_i))
  m.set_inputs([x, y])
  m.run
  @cache[[x, y]] = m.output
  return m.output
end

def square_at(x, y)
  [[x, y], [x + 99, y + 99], [x + 99, y], [x, y + 99]].each do |point|
    value = square_value(point.first, point.last)
    return false if value == 0
  end
  return true
end

y = 1100
@last_start = 1

while true
  y += 1
  puts "Y #{y} X #{@last_start}"
  x = @last_start

  # Move across the Row
  while square_value(x, y) == 0
    x += 1
  end
  @last_start = x

  # Check after 100
  if square_value(x + 100, y) == 0
    next
  end

  while square_value(x, y) == 1
    if square_at(x, y)
      raise "FOUND #{x} #{y}"
    end
    x += 1
  end

end
