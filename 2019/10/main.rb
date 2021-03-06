grid = File.read("input2.txt").split("\n").map{|line| line.split("") }
@grid = grid

locations = []
(0...grid.length).each do |i|
  (0...grid[0].length).each do |j|
    locations << [i, j] if grid[i][j] == "#"
  end
end

def middle(p1, p2, point)
  a = point.first >= p1.first
  a &&= point.last >= p1.last
  a &&= point.first <= p2.first
  a &&= point.last <= p2.last

  b = point.first <= p1.first
  b &&= point.last >= p1.last
  b &&= point.first >= p2.first
  b &&= point.last <= p2.last

  a || b

  #if a || b
  #  puts "#{point} is in middle of #{p1} & #{p2}"
  #else
  #  puts "#{point} IS NOT in middle of #{p1} & #{p2}"
  #end

  return a || b
end

def can_see(locations, point1, point2)
  return false if point1 == point2

  slope = (point1.first * 1.0 - point2.first) / (point1.last * 1.0 - point2.last)

  locations.each do |location|
    next if location == point1
    next if location == point2
    slope2 = (point1.first * 1.0 - location.first) / (point1.last * 1.0 - location.last)

    slope *= -1 if slope == (-1 * Float::INFINITY)
    slope2 *= -1 if slope2 == (-1 * Float::INFINITY)

    next if slope != slope2
    r = true
    r = false if middle(point1, point2, location) || middle(point2, point1, location)
    if !r
      return r
    end
  end

  return true
end

center = [19, 27]

seen = locations.select {|location| can_see(locations, center, location) }

#slopes = seen.map{|seen| [seen, (center.first * 1.0 - seen.first) / (center.last * 1.0 - seen.last)] }.sort{|a, b| a.last <=> b.last }
#

l = seen.select{|location| (location.first < center.first) && (location.last == center.last) }

l += seen.select{|location| (location.first < center.first) && (location.last > center.last) }

l += seen.select{|location| (location.first == center.first) && (location.last > center.last) }

l += seen.select{|location| (location.first > center.first) && (location.last > center.last) }

l += seen.select{|location| (location.first > center.first) && (location.last == center.last) }

l += seen.select{|location| (location.first > center.first) && (location.last < center.last) }

l += seen.select{|location| (location.first == center.first) && (location.last < center.last) }

puts l.length # HERE

a = seen.select{|location| (location.first < center.first) && (location.last < center.last) }

a = a.map{|seen| [seen, (center.last * 1.0 - seen.last) / (seen.first * 1.0 - center.first)] }.sort{|a, b| a.last <=> b.last }

l += a

puts l[199].inspect








