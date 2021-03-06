class Machine
  attr_accessor :output, :inputs, :stopped, :relative, :pc, :outputs, :instructions, :screen, :score

  def initialize(instructions)
    @instructions = instructions
    @instructions += [0] * 10000
    @pc = 0
    @relative = 0
    @outputs = []

    @screen = Hash.new(0)

    @special_locations = {}
    @score = 0
  end

  def set_inputs(inputs)
    @inputs = inputs
  end

  def m(i)
    if i == 0
      " "
    elsif i == 1
      "#"
    elsif i == 2
      "@"
    elsif i == 3
      "H"
    elsif i == 4
      "O"
    else
      raise "ERROR"
    end
  end

  def render_screen
    #3.times{ puts "\n" }
    #(0..40).each do |y|
    #  (0..40).each do |x|
    #    putc m(@screen[[x, y]])
    #  end
    #  puts "\n"
    #end
    #puts "--------------"
    puts @score
  end

  def get_input
    if @special_locations[3] < @special_locations[4]
      1
    elsif @special_locations[3] > @special_locations[4]
      -1
    else
      0
    end
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
        #puts "READING INPUT"
        #input = $stdin.readline
        #inputs = [input.to_i]
        inputs = [get_input]
        mode = modes.pop
        if mode == 0
          @instructions[@instructions[@pc + 1]] = inputs.shift
        elsif mode == 1
          @instructions[@pc + 1] = inputs.shift
        elsif mode == 2
          @instructions[@instructions[@pc + 1] + @relative] = inputs.shift
        end
        @pc += 2
        render_screen
        #sleep 0.1
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
        if @outputs.length == 3
          if @outputs[0] == -1
            @score = @outputs[2]
          else
            @screen[[@outputs[0], @outputs[1]]] = @outputs[2]
            if @outputs[2] == 3
              @special_locations[3] = @outputs[0]
            elsif @outputs[2] == 4
              @special_locations[4] = @outputs[0]
            end
          end
          @outputs = []
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

input = File.read("input.txt")
m = Machine.new(input.split(",").map(&:to_i))
m.instructions[0] = 2
m.run

puts "Final Score: #{m.score}"


