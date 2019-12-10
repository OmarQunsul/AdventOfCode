package main

import(
  "fmt"
  "bufio"
  "os"
  "strconv"
  "strings"
)

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

  original := make([]int64, len(memory))
  copy(original, memory)

  var noun int64 = 0;
  var verb int64 = 0;

  for (noun < 100) {
    verb = 0

    for (verb < 100) {
      copy(memory, original)

      memory[1] = noun
      memory[2] = verb

      counter := 0

      for (memory[counter] != 99) {
        target := memory[counter + 3]
        op1 := memory[memory[counter + 1]]
        op2 := memory[memory[counter + 2]]
        if memory[counter] == 1 {
          memory[target] = op1 + op2
        } else if memory[counter] == 2 {
          memory[target] = op1 * op2
        }
        counter += 4
      }

      //fmt.Println(memory[0])

      if memory[0] == 19690720 {
        fmt.Println(100 * noun + verb)
        os.Exit(0)
      }

      verb += 1
    }

    noun += 1
  }

}
