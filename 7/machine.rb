class Machine
  attr_accessor :output, :inputs, :stopped

  def initialize(instructions)
    @instructions = instructions
    @pc = 0
  end

  def set_inputs(inputs)
    @inputs = inputs
  end

  def get_value(v, mode = 0)
    mode ||= 0
    return @instructions[v] if mode == 0
    return v if mode == 1
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
        if modes.pop == 0
          @instructions[@instructions[@pc + 3]] = value
        else
          @instructions[@pc + 3] = value
        end
        @pc += 4
      elsif instruction == 2
        value = get_value(@instructions[@pc + 1], modes.pop) * get_value(@instructions[@pc + 2], modes.pop)
        if modes.pop == 0
          @instructions[@instructions[@pc + 3]] = value
        else
          @instructions[@pc + 3] = value
        end
        @pc += 4
      elsif instruction == 3
        @instructions[@instructions[@pc + 1]] = inputs.shift
        @pc += 2
      elsif instruction == 4
        if modes.pop == 0
          @output = @instructions[@instructions[@pc + 1]]
        else
          @output = @instructions[@pc + 1]
        end
        @pc += 2
        break
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
        if modes.pop == 0
          @instructions[@instructions[@pc + 3]] = condition ? 1 : 0
        else
          @instructions[@pc + 3] = condition ? 1 : 0
        end
        @pc += 4
      elsif instruction == 8
        condition = get_value(@instructions[@pc + 1], modes.pop) == get_value(@instructions[@pc + 2], modes.pop)
        if modes.pop == 0
          @instructions[@instructions[@pc + 3]] = condition ? 1 : 0
        else
          @instructions[@pc + 3] = condition ? 1 : 0
        end
        @pc += 4
      else
        raise "Invalid Instruction #{instruction}"
      end
    end
  end
end

input = File.read("input.txt")

max = 0

(5..9).to_a.permutation(5).each do |permutation|
  machines = {}
  (0..4).each{|i| machines[i] = Machine.new(input.split(",").map(&:to_i)) }

  last_output = 0
  first_loop = true
  while !machines[0].stopped
    (0..4).each do |i|
      m = machines[i]
      m.set_inputs(first_loop ? [permutation[i], last_output] : [last_output])
      m.run
      last_output = m.output
    end
    first_loop = false
  end

  max = machines[4].output if machines[4].output > max
end

puts max
