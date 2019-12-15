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
        break if inputs.length == 0
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

input = File.read("input.txt")
$instructions = input.split(",").map(&:to_i)
#m = Machine.new(input.split(",").map(&:to_i))
#m.set_inputs([2])
#m.run
#

class Explorer
  attr_accessor :location, :output, :visited, :inputs

  def initialize(location, visited = {}, i)
    @location = location.dup
    @visited = visited
    @inputs = i
  end

  def run
    @visited[@location] = true
    results = []
    north = [1, [@location[0] - 1, @location[1]]] # input, location
    south = [2, [@location[0] + 1, @location[1]]]
    west = [3, [@location[0], @location[1] - 1]]
    east = [4, [@location[0], @location[1] + 1]]
    [north, south, east, west].each do |d|
      results << explore(d.first, d.last) if !@visited[d.last]
    end
    results.compact.min || nil
  end

  def explore(input, d)
    m = Machine.new($instructions.dup)
    m.inputs = @inputs + [input]
    m.run

    if m.output == 0
      return nil

    elsif m.output == 1
      explorer = Explorer.new(d.dup, @visited.dup, @inputs + [input])
      return explorer.run

    elsif m.output == 2
      puts "Start exploring Oxygen..."
      @visited = {@location => 0}
      run_oxygen
    else
      raise "ERROR"
    end
  end

  def run_oxygen
    north = [1, [@location[0] - 1, @location[1]]] # input, location
    south = [2, [@location[0] + 1, @location[1]]]
    west = [3, [@location[0], @location[1] - 1]]
    east = [4, [@location[0], @location[1] + 1]]
    puts @location.inspect
    [north, south, east, west].each do |d|
      explore_oxygen(@location, d.first, d.last) if @visited[d.last].nil?
    end
  end

  def explore_oxygen(parent, input, current)
    m = Machine.new($instructions.dup)
    m.inputs = @inputs + [input]
    m.run

    if m.output == 0
      return nil

    elsif m.output == 1 || m.output == 2
      @visited[current] = @visited[parent] + 1
      puts @visited.length
      explorer = Explorer.new(current.dup, @visited.dup, @inputs + [input])
      return explorer.run_oxygen
    else
      raise "UNKNOWN OUTPUT"
    end
  end
end

explorer = Explorer.new([0, 0], {}, [])
explorer.run
