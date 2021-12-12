
import SwiftUI

// Advent of Code: Day Two

enum Direction: String, CaseIterable {
   case forward, up, down

   static let allStrings: [String] = Direction.allCases.map { $0.rawValue }
}
struct Movement {
   var direction: Direction
   var amount: Int
}
struct ContentView: View {

   var body: some View {
      let movements = transformPuzzleInput()
      //       let answer = partOne(after: movements)
      //       Text("The answer to part One is \(answer.x) x \(answer.y) = \(answer.x * answer.y)")
      let answer = partTwo(after: movements)
      Text("The answer to part Two is \(answer.x) x \(answer.y) = \(answer.x * answer.y)")
         .padding()
         .frame(minWidth:250, minHeight: 100)
   }
}
func transformPuzzleInput() -> [Movement] {
   var answer: [Movement] = []
   var direction : Direction?
   var tmp: String = ""
   for char in puzzleInput {
      let c = String(char)
      if c == " " { continue }
      if char == "\n" {
         if let d = direction, let amount = Int(tmp) {
            answer.append(Movement(direction: d, amount: amount))
            tmp = ""
            direction = nil
            continue
         }
      }
      tmp = tmp + c
      if (direction==nil) {
         if let _ = Direction.allStrings.firstIndex(of: tmp) {
            direction = Direction(rawValue: tmp)
            tmp = ""
         }
      }
   }
   return answer
}

func partOne(after movements: [Movement]) -> (x: Int, y: Int) {
   var x = 0
   var y = 0
   for movement in movements {
      switch movement.direction {
         case .up: y = y - movement.amount
         case .down: y = y + movement.amount
         case .forward: x = x + movement.amount
      }
   }
   return (x,y)
}

func partTwo(after movements: [Movement]) -> (x: Int, y: Int) {
   var forward: Int = 0
   var depth: Int = 0
   var aim: Int = 0
   for movement in movements {
      switch movement.direction {
         case .up: aim -= movement.amount
         case .down: aim += movement.amount
         case .forward:
            forward += movement.amount
            depth += aim * movement.amount
      }
   }
   print(forward*depth)
   return (forward, depth)
}


struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}
