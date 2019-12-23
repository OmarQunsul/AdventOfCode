@lines = File.read("input.txt").split("\n")

N = 119315717514047

def find(i, level)
  raise "ERROR #{i}" if i < 0 || i >= N

  return i if level < 0

  line = @lines[level]

  if line.start_with?("deal into new stack")
    find(N - 1 - i, level - 1)
  elsif line.start_with?("cut")
    n = line.split(" ").last.to_i
    if n > 0
      comp = N - n
      if i >= comp
        find(i - comp, level - 1)
      else
        find(n + i, level - 1)
      end
    elsif n < 0
      n = N + n

      # The same
      comp = N - n
      if i >= comp
        find(i - comp, level - 1)
      else
        find(n + i, level - 1)
      end

    end
  elsif line.start_with?("deal with increment")

    n = line.split(" ").last.to_i

    start = 0
    count = 0
    while (i - start) % n > 0
      start += n - (N % n)
      count += N / n + 1
    end
    count += (i - start) / n

    new_count = count

    #current_i = 0
    #count = 0
    #while current_i != i
    #  # SLOW
    #  current_i = (current_i + n) % N
    #  count += 1
    #end

    #puts [count, new_count].inspect

    find(count, level - 1)

  else
    raise "ERROR #{line}"
  end
end

current = 2020
visited = {}
i = 0
while true
  #visited[current] = true
  n = find(current, @lines.length - 1)
  diff = n - current
  raise if visited[diff] == true
  visited[diff] = true
  current = n
  i += 1
  puts visited.length if i % 10000 == 0
  #raise i.inspect if visited[current]
end
