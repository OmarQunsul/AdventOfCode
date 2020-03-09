package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

type Point struct{ X, Y int64 }

func main() {
	f, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(f)
	scanner.Scan()
	line1 := scanner.Text()
	scanner.Scan()
	line2 := scanner.Text()
	strings1 := strings.Split(line1, ",")
	strings2 := strings.Split(line2, ",")

	visited := make(map[Point]int)

	min := math.Inf(1)

  var steps int = 0

	current := []int64{0, 0}
	for _, move := range strings1 {
		direction := move[0]
		number, _ := strconv.ParseInt(move[1:], 10, 64)

		var i int64
		for i = 0; i < number; i++ {
      steps += 1
			if direction == 'D' {
				current[1] += 1
			} else if direction == 'R' {
				current[0] += 1
			} else if direction == 'L' {
				current[0] -= 1
			} else if direction == 'U' {
				current[1] -= 1
			}

      if visited[Point{current[0], current[1]}] == 0 {
        visited[Point{current[0], current[1]}] = steps
      }
		}
	}

	current = []int64{0, 0}

  steps = 0

	for _, move := range strings2 {
		direction := move[0]
		number, _ := strconv.ParseInt(move[1:], 10, 64)

		var i int64
		for i = 0; i < number; i++ {
      steps += 1

			if direction == 'D' {
				current[1] += 1
			} else if direction == 'R' {
				current[0] += 1
			} else if direction == 'L' {
				current[0] -= 1
			} else if direction == 'U' {
				current[1] -= 1
			}

			if visited[Point{current[0], current[1]}] > 0 {
				distance := visited[Point{current[0], current[1]}] + steps
				if float64(distance) < min {
					min = float64(distance)
				}
			}
		}
	}

	fmt.Println(min)
}
