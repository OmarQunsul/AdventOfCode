package main

import(
  "fmt"
  "bufio"
  "os"
  "strconv"
)

func fuelFor(v int64) int64 {
  if (v == 0) {
   return 0
 }
  v /= 3.0
  num := int64(v) - 2
  if (num < 0) { num = 0 }
  return num + fuelFor(num)
}

func main() {
  f, _ := os.Open("input.txt")
  scanner := bufio.NewScanner(f)
  var sum int64
  sum = 0

  for scanner.Scan() {
    f, _ := strconv.ParseInt(scanner.Text(), 10, 64)
    sum += fuelFor(f)
  }

  fmt.Println(sum)
}
