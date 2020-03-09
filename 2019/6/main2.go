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

func search(sum int, current string, neighbours map[string][]string, visited map[string]bool, min *[]int) {
  if (visited[current]) { return }
  visited[current] = true
  if (current == "SAN") {
    *min = append(*min, sum)
  }
  for _, n := range(neighbours[current]) {
    search(sum + 1, n, neighbours, visited, min)
  }
}

func main() {
  f, _ := os.Open("input.txt")
  scanner := bufio.NewScanner(f)

  neighbours := make(map[string][]string)
  visited := make(map[string]bool)

  for scanner.Scan() {
    line := scanner.Text()
    parts := strings.Split(line, ")")

    neighbours[parts[0]] = append(neighbours[parts[0]], parts[1])
    neighbours[parts[1]] = append(neighbours[parts[1]], parts[0])
  }

  var min []int

  search(0, "YOU", neighbours, visited, &min)

  var m int = min[0]
  for _, v := range(min) {
    if v < m { m = v }
  }

  fmt.Println(m - 2)
}
