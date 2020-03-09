package main

import(
  "fmt"
  "bufio"
  "os"
  //"strconv"
)

type Point struct {
  x, y, z, vx, vy, vz int
}

func main() {
  f, _ := os.Open("input.txt")
  scanner := bufio.NewScanner(f)

  var x, y, z int;
  objects := make([]Point, 0)
  originals := make([]Point, 0)

  for scanner.Scan() {
    line := scanner.Text()
    fmt.Sscanf(line, "<x=%d, y=%d, z=%d>", &x, &y, &z)
    objects = append(objects, Point{x, y, z, 0, 0, 0})
    originals = append(originals, Point{x, y, z, 0, 0, 0})
  }

  step := 0
  //last := step

  for true {
    if (step % 1000000 == 0) { fmt.Println(step / 1000000) }

    for i := 0; i < 3; i++ {
      object1 := &objects[i]
      for j := (i + 1); j < 4; j++ {
        object2 := &objects[j]
        if object1.x < object2.x { object1.vx += 1; object2.vx -= 1 } else if object1.x > object2.x { object1.vx -= 1; object2.vx += 1 }
        if object1.y < object2.y { object1.vy += 1; object2.vy -= 1 } else if object1.y > object2.y { object1.vy -= 1; object2.vy += 1 }
        if object1.z < object2.z { object1.vz += 1; object2.vz -= 1 } else if object1.z > object2.z { object1.vz -= 1; object2.vz += 1 }
      }
    }
    for i := 0; i < 4; i++ {
      object1 := &objects[i]
      object1.x += object1.vx
      object1.y += object1.vy
      object1.z += object1.vz
    }

    step += 1

    //if objects[0] == originals[0] {
    //  fmt.Println(step - last)
    //  last = step
    //}

    //fmt.Println(objects[0].x)

    match := true

    for i := 0; i < 4; i++ {
      //match = match && objects[i].x == originals[i].x && objects[i].vx == 0
      //match = match && objects[i].y == originals[i].y && objects[i].vy == 0
      match = match && objects[i].z == originals[i].z && objects[i].vz == 0
    }

    // The 3 outputs, we take the LCM of them, and that's the answer
    if match {
      fmt.Println(step)
      break
    }

  }
}
