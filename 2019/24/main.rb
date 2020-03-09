grid = File.read("input.txt").split("\n").map{|line| line.strip.split("") }

WIDTH = grid.first.length
HEIGHT = grid.length

def neighbours(grids, level, y, x)
  points = neighbours_yx(level, y, x)
  points.map do |point|
    get_point(grids, point.first, point[1], point[2])
  end
end

CENTER = [2, 2]

def neighbours_yx(level, y, x)
  raise "ERROR" if y == 2 && x == 2
  points = [[y - 1, x],[y + 1, x], [y, x - 1], [y, x + 1]]
  result = []
  points.each do |point|
    if point[0] < 0
      result << [level - 1, 1, 2]
    elsif point[0] == 5
      result << [level - 1, 3, 2]
    elsif point[1] < 0
      result << [level - 1, 2, 1]
    elsif point[1] == 5
      result << [level - 1, 2, 3]
    elsif point == CENTER
      if x == 1
        result += (0..4).map{|i| [level + 1, i, 0] }
      elsif x == 3
        result += (0..4).map{|i| [level + 1, i, 4] }
      elsif y == 1
        result += (0..4).map{|i| [level + 1, 0, i] }
      elsif y == 3
        result += (0..4).map{|i| [level + 1, 4, i] }
      else
        raise "WTF"
      end
    else
      result << [level] + point
    end
  end

  result
end

def get_point(grids, level, y, x)
  (grids[level] || new_grid)[y][x]
end

def set_point(grids, level, y, x, value)
  grids[level] = new_grid if grids[level].nil?
  grids[level][y][x] = value
end

def process(grids1, grids2)
  min = grids1.keys.min
  max = grids1.keys.max
  grids1[min - 1] = new_grid
  grids1[max + 1] = new_grid
  grids2[min - 1] = new_grid
  grids2[max + 1] = new_grid

  grids1.each do |level, grid|
    (0...HEIGHT).each do |y|
      (0...WIDTH).each do |x|
        next if x == 2 && y == 2
        value = grid[y][x]
        n = neighbours(grids1, level, y, x)
        if value == "#"
          output = n.count("#") == 1 ? "#" : "."
        elsif value == "."
          output = [1, 2].include?(n.count("#")) ? "#" : "."
        else
          raise "ERROR"
        end
        set_point(grids2, level, y, x, output)
      end
    end
  end
end

#def bio(grid)
#  array = grid.flatten
#  i = 0
#  sum = 0
#  while i < array.length
#    sum += 2 ** (i) if array[i] == "#"
#    i += 1
#  end
#  sum
#end

def new_grid
  5.times.map{ ['.'] * 5 }
end

def clone_grids(grids)
  result = {}
  grids.each do |k, v|
    result[k] = v.map(&:clone)
  end
  result
end

grids1 = { 0 => grid }
grids2 = clone_grids(grids1)

200.times do |i|
  puts i
  process(grids1, grids2) if i % 2 == 0
  process(grids2, grids1) if i % 2 == 1
  @output = (i % 2 == 0) ? grids2 : grids1
end

count = 0
@output.each do |k, v|
  count += v.flatten.count("#")
end

puts count
