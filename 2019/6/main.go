package main

import(
  "fmt"
  "bufio"
  "os"
  "strings"
)

func add(sum *int, parents map[string][]string, key string) {
  for _, child := range(parents[key]) {
    *sum += 1
    add(sum, parents, child)
  }
}

func main() {
  f, _ := os.Open("input.txt")
  scanner := bufio.NewScanner(f)

  parents := make(map[string][]string)

  sum := 0

  for scanner.Scan() {
    line := scanner.Text()
    parts := strings.Split(line, ")")
    parents[parts[0]] = append(parents[parts[0]], parts[1])
  }

  for _, v := range(parents) {
    for _, child := range(v) {
      sum += 1
      add(&sum, parents, child)
    }
  }

  fmt.Println(sum)
}
