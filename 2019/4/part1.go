package main

import (
  //"bufio"
	"fmt"
	//"math"
	//"os"
	"strconv"
	"strings"
)


func works(num int64) bool {
  var n string = strconv.Itoa(int(num))
  var dup bool = false
  var i int

  for i = 0; i < 5; i++ {
    if n[i + 1] < n[i] { return false }
    if n[i + 1] == n[i] { dup = true }
  }

  return dup
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
