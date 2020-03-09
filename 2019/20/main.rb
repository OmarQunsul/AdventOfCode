@grid = File.read("input.txt").split("\n").map{|line| line.split("") }

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
        reverse = (x < d.first) || (y < d.last)
        outside = (y == 1 || y == (Y - 2) || x == 1 || x == (X - 2))
        key = "#{n}#{value}"
        key = key.reverse if reverse
        str = key + "-" + (outside ? "outside" : "inside")
        @locations[str] = d + [outside]
      end
    end
  end
end


level = 0
start = @locations["AA-outside"][0..1] + [0]

@distances = {start => 0}
current = [start]
distance = 0

TARGET = @locations["ZZ-outside"][0..1] + [0]

while current.length > 0
  distance += 1
  puts distance if distance % 100 == 0
  
  n = []

  current.each do |node|
    level = node.last
    raise "Wrong Level #{level}" if level < 0

    tunnel = @locations.select{|k, v| v[0..1] == node[0..1] }.first

    if tunnel
      tunnel_key = tunnel.first
      tunnel_node = tunnel.last
      outside = tunnel_node.last

      if outside && (level < 1)
      else
        opposite = outside ? tunnel_key.gsub("outside", "inside") : tunnel_key.gsub("inside", "outside")
        other_node = @locations[opposite]
        #raise "NOT FOUND #{tunnel_key} #{level}" if other_node.nil?
        if other_node
          target_level = outside ? level - 1 : level + 1
          n << (other_node + [target_level]) if target_level > -1
        end
      end
    end

    n += find(node.first, node[1], '.').select{|p| @distances[p].nil? }.map{|node| node += [level] }
  end

  current = n
  current = current.reject{|p| !@distances[p].nil? }
  current.each{|p| @distances[p] = distance }

  found = @distances[TARGET]
  raise found.inspect if found
end
