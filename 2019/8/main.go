package main

import(
  "fmt"
  "bufio"
  "os"
  "bytes"
  //"strconv"
  //"strings"
)

func main() {
  f, _ := os.Open("input.txt")
  scanner := bufio.NewScanner(f)
  scanner.Scan()
  array := scanner.Bytes()
  pixelsCount := 6 * 25;
  layersCount := len(array) / pixelsCount
  layerLength := len(array) / layersCount

  layers := make([][]byte, 0)

  for i := 0; i < layersCount; i++ {
    layers = append(layers, array[0:layerLength])
    array = array[layerLength:]
  }

  fmt.Println(layers)

  min := layerLength
  var answer int
  var count int

  for i := 0; i < layersCount; i++ {
    count = 0
    for j := 0; j < layerLength; j++ {
      //fmt.Printf("%s", string(layers[i][j])) JUST FOR FUN
      if layers[i][j] == byte('0') { count ++ }
    }
    if (count < min) {
      min = count
      answer = bytes.Count(layers[i], []byte("1")) * bytes.Count(layers[i], []byte("2"))
    }
  }

  //fmt.Println(min)
  fmt.Println(answer)
  //fmt.Println("end")
}
