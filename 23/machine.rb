class Machine
  attr_accessor :output, :inputs, :stopped, :relative, :pc, :outputs

  def initialize(instructions)
    @instructions = instructions
    @instructions += [0] * 100000
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

input = File.read("input.txt")

machines = (0..49).map do |i|
  m = Machine.new(input.split(",").map(&:to_i))
  m.set_inputs([i])
  m.run
  m
end

queues = Hash.new(nil)
while true
  (0..49).each do |i|
    m = machines[i]
    queue = queues[i] || [-1]
    m.set_inputs(queue)
    m.run
    while m.outputs.any?
      address = m.outputs.shift
      packet = [m.outputs.shift, m.outputs.shift]
      if address == 255
        @nat = packet
      else
        queues[address] ||= []
        queues[address] += packet
      end
    end
  end
  idle = ! (queues.values.select{|v| (v || []).any? }.length > 0)
  # Here printing the values
  if idle && @nat
    queues[0] ||= []
    queues[0] += @nat
    puts @nat.inspect
  end
end
