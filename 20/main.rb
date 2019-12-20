@grid = File.read("input2.txt").split("\n").map{|line| line.split("") }

X = @grid.first.length
Y = @grid.length
C = ('A'..'Z').to_a

@locations = Hash.new(nil)

def neighbours(x, y)
  array = [[x + 1, y], [x - 1, y], [x, y - 1], [x, y + 1]]
  array.reject{ |arr| arr.first < 0 || arr.first >= X || arr.last < 0 || arr.last >= Y }
end

def n_values(x, y)
  n = neighbours(x, y)
  n.map{|v| @grid[v.last][v.first] }
end

def find(x, y, v)
  n = neighbours(x, y)
  n.select{|p| @grid[p.last][p.first] == v }
end

(0...Y).each do |y|
  (0...X).each do |x|
    value = @grid[y][x] || " "
    if value.match(/[A-Z]/)
      n = (n_values(x, y) & C).first
      d = find(x, y, '.').first
      if d
        strings = ["#{value}#{n}", "#{n}#{value}"]
        strings.each{|str| @locations[str] ||= []; @locations[str] << d }
      end
    end
  end
end

start = @locations["AA"].first

@distances = {start => 0}
current = [start]
distance = 0

while current.length > 0
  distance += 1

  n = []
  current.each do |node|
    # TODO: Here we check the neighours from the locations
    @locations.each do |k, v| 
      if v.include?(node)
        n += v.reject{|u| u == node }
      end
    end
    n += find(node.first, node.last, '.').select{|p| @distances[p].nil? }
  end

  current = n
  current = current.reject{|p| !@distances[p].nil? }
  current.each{|p| @distances[p] = distance }
end

puts @distances[@locations["ZZ"].first]
