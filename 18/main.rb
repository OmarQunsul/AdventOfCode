file = "input2.txt"
@grid = File.read(file).split("\n").map{|line| line.split("") }

location = nil
@locations = {}

@grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    if ([cell] & %w[. #]).empty?
      if cell == "@"
        location = [y, x]
      elsif
        @locations[cell] = [y, x]
      end
    end
  end
end

@grid[location.first][location.last] = "." # No need for "@"

DIRECTIONS = [[1, 0], [-1, 0], [0, 1], [0, -1]]

def outside?(l)
  return true if l.first < 0 || l.last < 0
  return true if l.first >= @grid.length || l.last >= @grid.first.length
  return false
end

def add(l, d); [l[0] + d[0], l[1] + d[1]]; end

def neighbours(l)
  DIRECTIONS.map{ |d| [l[0] + d.first, l[1] + d.last]}.reject{ |l2| outside?(l2) }
end

def explore(steps, location, grid, locations, visited)
  return nil if outside?(location)
  value = grid[location.first][location.last]
  return nil if grid[location.first][location.last] == "#"
  return nil if visited[location]

  return nil if value.match?(/[A-Z]/)
  small = true if value.match?(/[a-z]/)

  if small
    big = value.upcase
    door_location = locations[big]
    if door_location
      grid[door_location.first][door_location.last] = "."
      grid[location.first][location.last] = "."
    end
    locations.delete(value)
    locations.delete(big)
    if locations.length == 0
      return steps
    end
    visited = { location => true }

    result = []
    DIRECTIONS.each do |d|
      new_location = add(location, d)
      result << explore(steps + 1, new_location, grid.map(&:clone), locations.clone, visited.dup)
    end
    result = result.compact
    return result.empty? ? nil : result.min

  elsif value == "."
    visited[location] = true
    result = []
    DIRECTIONS.each do |d|
      new_location = add(location, d)
      result << explore(steps + 1, new_location, grid.map(&:clone), locations.clone, visited.dup)
    end
    result = result.compact
    return result.empty? ? nil : result.min
  end
end

puts explore(0, location.dup, @grid.clone, @locations.clone, {})
