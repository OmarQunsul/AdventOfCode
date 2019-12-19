file = "input4.txt"
@grid = File.read(file).split("\n").map{|line| line.split("") }

location = nil
@locations = {}

@grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    if ([cell] & %w[. #]).empty?
      if cell == "@"
        location = [y, x]
      else
        @locations[cell] = [y, x]
      end
    end
  end
end

@grid[location.first][location.last] = "." # No need for "@"

DIRECTIONS = [[1, 0], [-1, 0], [0, 1], [0, -1]]
SMALL = ('a'..'z').to_a

def outside?(l)
  return true if l.first < 0 || l.last < 0
  return true if l.first >= @grid.length || l.last >= @grid.first.length
  return false
end

def add(l, d); [l[0] + d[0], l[1] + d[1]]; end

def neighbours(l)
  DIRECTIONS.map{ |d| [l[0] + d.first, l[1] + d.last]}.reject{ |l2| outside?(l2) }
end

@cache = {}

def explore(steps, location, grid, locations, visited)
  cache_key = [location.dup, locations.keys.sort.dup]
  if cached_values = @cache[cache_key]
    return (cached_values.first - cached_values.last) + steps
  end

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
    end
    grid[location.first][location.last] = "."

    raise "NOT FOUND #{value} in #{locations.inspect}" if locations[value].nil?

    locations.delete(value)
    locations.delete(big)

    if (locations.keys & SMALL).empty?
      puts steps
      return steps
    end

    visited = { location => true }

    result = []
    DIRECTIONS.each do |d|
      new_location = add(location, d)
      result << explore(steps + 1, new_location, grid.map(&:clone), locations.dup, visited.dup)
    end

    result = result.compact.min
    @cache[cache_key] = [result, steps]
    return result

  elsif value == "."

    unvisited_neighbours = neighbours(location).reject{ |u| visited[u]}.select{|u| grid[u.first][u.last] != "#" }

    while unvisited_neighbours.length == 1 && grid[unvisited_neighbours.first.first][unvisited_neighbours.first.last] == "."
      steps += 1
      visited[location] = true
      location = unvisited_neighbours.first
      unvisited_neighbours = neighbours(location).reject{ |u| visited[u] }.select{ |u| grid[u.first][u.last] != "#" }
    end

    value = grid[location.first][location.last]

    visited[location] = true
    result = []
    DIRECTIONS.each do |d|
      new_location = add(location, d)
      result << explore(steps + 1, new_location, grid.map(&:clone), locations.dup, visited.dup)
    end

    result = result.compact.min
    @cache[[location, @locations.keys.dup]] = [result, steps]
    return result

  end
end

puts explore(0, location.dup, @grid.clone, @locations.clone, {})
