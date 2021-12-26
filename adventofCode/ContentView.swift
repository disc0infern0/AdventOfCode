// Advent of Code: Day Five
import SwiftUI

var testData = true // set to true to use test data

// use a struct instead of overwriting the matrix value, when called, to a marker value, e.g. -1
struct Point: Equatable {
   var x: Int
   var y: Int
   init(_ x: Int, _ y: Int) {
      self.x = x; self.y = y
   }

   static var empty = Point(-1,-1)

   var isEmpty: Bool {
      self == Point.empty
   }

   static func ==(lhs: Point, rhs: Point) -> Bool {
      lhs.x == rhs.x && lhs.y == rhs.y
   }
}
struct Line {
   var from: Point
   var to: Point
}

struct ContentView: View {
   var body: some View {
      let lines: [Line] = parseLines(input: testData ? testLines : puzzleLines)

      ScrollView {
         VStack {
            let partOneAnswer = partOne(lines)
            Text("Lines overlapping: Part One: \(partOneAnswer) !")
               .textSelection(.enabled)

            let partTwoAnswer = partTwo(lines)
            Text("Lines overlapping: Part Two: " + String(partTwoAnswer) )
               .textSelection(.enabled)
         }
      }
		.frame(minWidth:250, minHeight: 100)
   }
}

func partOne(_ lines: [Line]) -> Int {
   var overlapped = 0
   let arraySize = testData ? 10 : 1000
   let row = Array(repeating: 0, count: arraySize)
   var grid = Array(repeating: row, count: arraySize)

   for line in lines where line.from.x == line.to.x || line.from.y == line.to.y {
      overlapped += countOverlaps(in: line, on: &grid)
   }
   print("Part One")
   printGrid(grid)
   return overlapped
}

func printGrid(_ grid: [[Int]]) {
   print("Final grid")
   for (counter, row) in grid.enumerated() {
      print("\(counter+1)\t\t", terminator: "")
      print(row.reduce("") { j,i in i==0 ? j+"." : j+String(i) })
   }
}

func countOverlaps(in line: Line, on grid: inout [[Int]]) -> Int {
   var overlapped = 0

   func markGridPosition(row: Int, column: Int) {
      if grid[row][column] == 1 {
         overlapped += 1
      }
      grid[row][column] += 1
   }
   func calcIncrementor(_ from: Int, _ to: Int) -> Int {
      if from == to { return 0} else {
         if to > from { return 1 } else {
            return -1
         }
      }
   }
   func pointIsOnLine() -> Bool {
      current.x.isBetween(line.from.x, line.to.x) &&
      current.y.isBetween(line.from.y, line.to.y )
   }
   // plot line on grid
   var current = line.from
   let columnIncrement = calcIncrementor(line.from.x, line.to.x)
   let rowIncrement = calcIncrementor(line.from.y, line.to.y)
   repeat {
      markGridPosition( row: current.y, column: current.x )
      current.x += columnIncrement
      current.y += rowIncrement
   } while (pointIsOnLine() )

   return overlapped
}

func partTwo(_ lines: [Line]) -> Int {
   var overlapped = 0
   let arraySize = testData ? 10 : 1000
   let row = Array(repeating: 0, count: arraySize)
   var grid = Array(repeating: row, count: arraySize)

   for line in lines {
 		overlapped += countOverlaps(in: line, on: &grid)
   }
   print("\nPart Two")
   printGrid(grid)
   return overlapped
}

extension Comparable  {
   func isBetween (_ value1: Self, _ value2: Self) -> Bool {
      let lower = min(value1,value2)
      let upper = max(value1,value2)
      return lower <= self  && self <= upper
   }
}

func parseLines(input: String) -> [Line] {
   var output: [Line] = []
   let carriageReturn: Character = "\n"

   var first: Point = .empty
   var second: Point = .empty
	var tmp = 0

   for char in input {
      switch char {
      case carriageReturn:
            second.y = tmp; tmp = 0
            output.append(Line(from: first, to: second))
            first = .empty; second = .empty
            break
      case ",":
            if first.isEmpty {
               first.x = tmp; tmp = 0
            } else {
               second.x = tmp; tmp = 0
            }
            break
      case "-":
            first.y = tmp; tmp = 0
            break
      case " ",">":
            break
      default:
            if let i = Int(String(char)) {
            	tmp = tmp*10 + i
            }
      }
   }

   return output
}



// String subscripts
extension String {
   subscript(i: Int) -> String {
      return String(self[index(startIndex, offsetBy: i)])
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}
