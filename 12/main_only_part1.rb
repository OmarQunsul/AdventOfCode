lines = File.read("input.txt").split("\n")
objects = []
lines.each do |line|
  x = line.match(/x=(-?\d+)/)[1].to_i
  y = line.match(/y=(-?\d+)/)[1].to_i
  z = line.match(/z=(-?\d+)/)[1].to_i
  objects << [x, y, z, 0, 0, 0]
end

original = []
objects.each{|o| original << o.dup }

states = Hash.new()
step = 0

#key = objects.map{|object| object.join(",")}.join(",")

while true
  #states[objects.map{|object| object.join(",")}.join(",")] = step

  (0...(objects.length - 1)).each do |ind|
    object = objects[ind]
    ((ind + 1)...objects.length).each do |ind2|
      object2 = objects[ind2]
      (0..2).each do |i|
        if object[i] < object2[i]
          object[i + 3] += 1
          object2[i + 3] -= 1
        elsif object[i] > object2[i]
          object[i + 3] -= 1
          object2[i + 3] += 1
        end
      end
    end
  end
  objects.each do |object|
    object[0] += object[3]
    object[1] += object[4]
    object[2] += object[5]
  end
  step += 1

  puts step / 1000000 if step % 1000000 == 0

  if objects == original
    puts step
    break
  end
  # Check
  #key = objects.map{|object| object.join(",")}.join(",")
  #if states[key]
  #  puts (step - states[key])
  #  puts step
  #  break
  #end
end

#sum = 0
#objects.each do |object|
#  sum += (object["x"].abs + object["y"].abs + object["z"].abs) * (object["vx"].abs + object["vy"].abs + object["vz"].abs)
#end
#
#puts sum
