package main

import (
	"fmt"
	"strconv"
	"strings"
)

func works(num int64) bool {
  var n string = strconv.Itoa(int(num))
  //var dup bool = false
  var i int
  var visits [10]int

  for i = 0; i < 5; i++ {
    if n[i + 1] < n[i] { return false }
    visits[n[i] - '0']++
  }
  visits[n[i] - '0']++

  for _, val := range(visits) { if val == 2 { return true } }
  return false
}

func main() {
  var input string = "347312-805915"
  parts := strings.Split(input, "-")
  var start, end int64
  start, _ = strconv.ParseInt(parts[0], 10, 64)
  end, _ = strconv.ParseInt(parts[1], 10, 64)
  count := 0
  for i := start; i <= end; i++ {
    if (works(i)) { count += 1 }
  }

  fmt.Println(count)
}
