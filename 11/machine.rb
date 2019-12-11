class Machine
  attr_accessor :output, :inputs, :stopped, :relative, :pc

  def initialize(instructions)
    @instructions = instructions
    @instructions += [0] * 1000
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
    @output = nil
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

class Robot
  attr_accessor :current

  def initialize
    input = File.read("input.txt")
    @current = [0, 0]
    @grid = Hash.new(0)
    @grid[[0,0]] = 1 # PART 2 ONLY
    @direction = [-1, 0]
    @machine = Machine.new(input.split(",").map(&:to_i))
  end

  def run
    @machine.set_inputs [@grid[current] || 0]
    @machine.run
    paint = @machine.output
    @machine.run
    steer = @machine.output
    while !@machine.stopped
      if steer == 0
        left
      elsif steer == 1
        3.times { left }
      else
        raise "ERROR"
      end
      @grid[current.clone] = paint
      @current[0] += @direction[0]
      @current[1] += @direction[1]
      @machine.set_inputs [@grid[@current.clone] || 0]
      @machine.run
      paint = @machine.output
      @machine.run
      steer = @machine.output
    end
    (0..7).each do |row|
      (0..100).each do |col|
        if @grid[[row, col]] == 0
          printf " "
        else
          printf '.'
        end
      end
      puts "\n"
    end
  end

  def left
    if @direction == [-1, 0]
      @direction = [0, -1]
    elsif @direction == [0, -1]
      @direction = [1, 0]
    elsif @direction == [1, 0]
      @direction = [0, 1]
    elsif @direction == [0, 1]
      @direction = [-1, 0]
    else
      raise "Wrong Direction #{@direction}"
    end
  end
end

robot = Robot.new
robot.run
