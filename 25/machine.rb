class Machine
  attr_accessor :output, :inputs, :stopped, :relative, :pc, :outputs, :instructions

  def initialize(instructions)
    @instructions = instructions
    @instructions += [0] * 1000
    @pc = 0
    @relative = 0
    @outputs = []
  end

  def set_inputs(inputs)
    @inputs = inputs
  end

  def clone
    m = Machine.new(@instructions.dup)
    m.pc = @pc
    m
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
        break if inputs.empty?
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

DOORS = %w[north west east south]
@program = File.read("input.txt").split(",").map(&:to_i)

def explore(inputs, inv)
  return if inputs.length > 50
  m = Machine.new(@program)
  m.set_inputs([])
  m.run
  inputs.each do |input|
    m.outputs = []
    m.set_inputs(input.each_byte.to_a + [10])
    m.run
  end
  output = m.outputs.map(&:chr).join("")
  return nil if m.stopped
  location = output.split("\n").reject(&:empty?).first
  description = output.split("\n").reject(&:empty?)[1]
  puts description
  lines = output.split("\n")
  options = lines.select{|line| line.start_with?("- ") }.map{|line| line[2..-1] }

  doors = options & DOORS
  doors = doors.shuffle
  options = (options - doors)
  options += inv
  options = options.shuffle

  doors.each do |door|
    (0..options.length).each do |i|
      possibilities = options.combination(i)
      possibilities.each do |possibility_array|
        puts possibility_array
        new_inputs = inputs.dup
        new_inv = inv.dup
        (possibility_array).each do |option|
          if inv.include?(option)
            new_inputs << "drop #{option}"
            new_inv = new_inv.reject{|i| i == option }
          else
            new_inputs << "take #{option}"
            new_inv << option
          end
        end
        new_inputs << door
        explore(new_inputs, new_inv)
      end
    end
  end
end

input = []

explore(input, [])

puts @seen.inspect
puts @seen.length

