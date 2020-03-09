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


opp = {"west" => "east", "east" => "west", "north" => "south", "south" => "north"}

plan = ["north", "take astronaut ice cream", "south", "west", "take mouse", "north", "take ornament", "west", "north", "take easter egg"]
plan += ["north", "west", "north", "take wreath", "south", "east", "south"]
plan += ["east", "take hypercube", "north", "east", "take prime number"]
#plan += ["west", "south", "west", "south", "west", "take mug", "west", "north"] #, "inv"]
plan += ["west", "south", "west", "south", "west", "west", "north", "inv"]

while true

  m = Machine.new(@program.dup)
  m.set_inputs([])
  m.run
  #puts m.outputs.map(&:chr).join("")
  commands = plan.dup

  location = []
  while commands.any?
    #command = $stdin.readline
    command = commands.shift + "\n"
    if command.start_with?("take ") && (rand < 0.5)
      command = commands.shift + "\n"
    end
    if location.last == opp[command.strip]
      location.pop
    else
      location << command.strip if opp[command.strip]
    end
    m.set_inputs(command.each_byte.to_a)
    m.run
    output = m.outputs.map(&:chr).join("")
    #puts output
    raise output if output.match(/\d{2,}/)
    #puts output
    #puts "============="
    #puts location.inspect
    #puts "============="
  end

  puts output

end
