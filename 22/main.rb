@lines = File.read("input.txt").split("\n")

N = 10007

def find(i, level)
  raise "ERROR #{i}" if i < 0 || i >= N
  puts "Level #{level}"

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
      puts start
    end
    count += (i - start) / n

    new_count = count


    current_i = 0
    count = 0
    while current_i != i
      # SLOW
      current_i = (current_i + n) % N
      count += 1
    end

    puts [count, new_count].inspect


    find(count, level - 1)

  else
    raise "ERROR #{line}"
  end
end

puts find(8191, @lines.length - 1)
