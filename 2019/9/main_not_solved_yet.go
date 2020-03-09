package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func readValue(instructions []int64, value int64, mode int64) int64 {
	if mode == 0 {
		return instructions[value]
	} else {
		return value
	}
}

func main() {
	f, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(f)
	scanner.Scan()
	line := scanner.Text()
	strings := strings.Split(line, ",")
	memory := make([]int64, 0)
	for _, str := range strings {
		temp, _ := strconv.ParseInt(str, 10, 64)
		memory = append(memory, temp)
	}

	var counter int64
	var output int64

	for memory[counter] != 99 {
		instruction := memory[counter] % 100
		mode := memory[counter] / 100
		modes := make([]int64, 0)
		for mode > 0 {
			modes = append(modes, mode%10)
			mode /= 10
		}
		modes = append(modes, 0)
		modes = append(modes, 0)
		modes = append(modes, 0)

		modeCounter := 0

		var target int64

		if instruction == 1 {
			op1 := readValue(memory, memory[counter+1], modes[modeCounter])
			modeCounter++
			op2 := readValue(memory, memory[counter+2], modes[modeCounter])
			modeCounter++
			target = counter + 3
			if modes[modeCounter] == 0 {
				target = memory[target]
			}
			memory[target] = op1 + op2
			counter += 4
		} else if instruction == 2 {
			op1 := readValue(memory, memory[counter+1], modes[modeCounter])
			modeCounter++
			op2 := readValue(memory, memory[counter+2], modes[modeCounter])
			modeCounter++
			target = counter + 3
			if modes[modeCounter] == 0 {
				target = memory[target]
			}
			memory[target] = op1 * op2
			counter += 4
		} else if instruction == 3 {
			target = counter + 1
			if modes[modeCounter] == 0 {
				target = memory[target]
			}
			memory[target] = 5
			counter += 2
		} else if instruction == 4 {
			output = readValue(memory, memory[counter+1], modes[modeCounter])
			fmt.Println("Output ", output)
			counter += 2
		} else if instruction == 5 {
			val := readValue(memory, memory[counter+1], modes[modeCounter])
			modeCounter++
			if val != 0 {
				counter = readValue(memory, memory[counter+2], modes[modeCounter])
			} else {
				counter += 3
			}
		} else if instruction == 6 {
			val := readValue(memory, memory[counter+1], modes[modeCounter])
			modeCounter++
			if val == 0 {
				counter = readValue(memory, memory[counter+2], modes[modeCounter])
			} else {
				counter += 3
			}
		} else if instruction == 7 {
			op1 := readValue(memory, memory[counter+1], modes[modeCounter])
			modeCounter++
			op2 := readValue(memory, memory[counter+2], modes[modeCounter])
			modeCounter++
			target = counter + 3
			if modes[modeCounter] == 0 {
				target = memory[target]
			}
			if op1 < op2 {
				memory[target] = 1
			} else {
				memory[target] = 0
			}
			counter += 4
		} else if instruction == 8 {
			op1 := readValue(memory, memory[counter+1], modes[modeCounter])
			modeCounter++
			op2 := readValue(memory, memory[counter+2], modes[modeCounter])
			modeCounter++
			target = counter + 3
			if modes[modeCounter] == 0 {
				target = memory[target]
			}
			if op1 == op2 {
				memory[target] = 1
			} else {
				memory[target] = 0
			}
			counter += 4
		} else {
			fmt.Println("Error Instruction %d", instruction)
			break
		}
	}
}
