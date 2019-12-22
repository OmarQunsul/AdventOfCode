file = "input.txt"
@grid = File.read(file).split("\n").map{|line| line.split("") }

alocations = nil
@locations = {}

@grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    if ([cell] & %w[. #]).empty?
      if cell == "@"
        alocations << [y, x]
      else
        @locations[cell] = [y, x]
      end
    end
  end
end

alocations.each do |location|
  @grid[location.first][location.last] = "." # No need for "@"
end

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

def explore(location, steps, grid, locations)
  cache_key = [location, locations.keys.sort].inspect
  return @cache[cache_key] + steps if @cache[cache_key]
  original_steps = steps

  visited = {location => steps}
  current = [location]

  characters = {}

  while current.length > 0
    nodes = []
    current.each do |node|
      ns = neighbours(node).reject{|n| visited[n] != nil }.reject{|n| current.include?(n) }
      ns = ns.select{|n| grid[n.first][n.last] == "."}
      nodes += ns
      visited[node] = steps

      ns = neighbours(node).reject{|n| visited[n] != nil }.reject{|n| current.include?(n) }
      ns = ns.select{|n| grid[n.first][n.last].match(/[a-z]/) }
      ns.each{|n| characters[grid[n.first][n.last]] ||= steps + 1 }
    end
    current = nodes.uniq
    steps += 1
  end

  #return steps if characters.empty?

  results = []
  characters.each do |k, v|
    location = locations[k]
    small = k
    big = small.upcase
    location_big = locations[big]

    locations_dup = locations.dup
    grid_dup = grid.map(&:clone)
    locations_dup.delete(small)
    locations_dup.delete(big)
    return v if (locations_dup.keys & SMALL).empty?

    grid_dup[location.first][location.last] = '.'
    grid_dup[location_big.first][location_big.last] = '.' if location_big
    results << explore(location.dup, v, grid_dup, locations_dup)
  end

  answer = results.compact.min
  @cache[cache_key] = answer - original_steps
  return answer
end

puts explore(alocations.dup, 0, @grid.dup, @locations.dup)

