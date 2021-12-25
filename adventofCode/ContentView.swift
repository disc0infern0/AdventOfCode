// Advent of Code: Day Five
import SwiftUI
import Matrix

var testData = false // set to true to use test data

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

   func markGridPosition(row: Int, column: Int) {
      if grid[row][column] == 1 {
         overlapped += 1
      }
      grid[row][column] += 1
   }

   func order(_ line: Line) -> (start: Point, end: Point) {
      line.from.x < line.to.x || line.from.y < line.to.y ? (start: line.from, end: line.to) : (start: line.to, end: line.from)
   }

   for line in lines where line.from.x == line.to.x || line.from.y == line.to.y {
      // get orderd pair of start/end points, such that start point can
      // be iterated on up to end point.
      let (start, end) = order(line)
      // plot line on grid
      let addColumn = line.from.x == line.to.x ? 0 : 1
      let addRow = line.from.y == line.to.y ? 0 : 1
      var current = start
      repeat {
         markGridPosition( row: current.y, column: current.x )
         current.x += addColumn
         current.y += addRow
      } while (current.x <= end.x && current.y <= end.y)
   }
//   print("Final grid")
//   for row in grid { print(row.reduce("") { j,i in i==0 ? j+"." : j+String(i)}) }

   return overlapped

}

func partTwo(_ lines: [Line]) -> Int {
   var overlapped = 0
   let arraySize = testData ? 10 : 1000
   let row = Array(repeating: 0, count: arraySize)
   var grid = Array(repeating: row, count: arraySize)

   func markGridPosition(row: Int, column: Int) {
      if grid[row][column] == 1 {
         overlapped += 1
      }
      grid[row][column] += 1
   }

   for line in lines {
      print("from \(line.from.x),\(line.from.y) to \(line.to.x),\(line.to.y)")
      var columnIncrement = 0
      var rowIncrement = 0

      // plot line on grid
      if line.from.x == line.to.x { columnIncrement = 0} else {
         if line.to.x > line.from.x { columnIncrement = 1 } else {
            columnIncrement = -1
         }
      }
      if line.from.y == line.to.y { rowIncrement = 0} else {
         if line.to.y > line.from.y { rowIncrement = 1 } else {
            rowIncrement = -1
         }
      }
      print(" starting at \(line.from.x), \(line.from.y) ")
      print("adding to columns: \(columnIncrement)")
      print("adding to rows: \(rowIncrement)")

      func pointIsOnLine() -> Bool {
         current.x.isBetween(line.from.x, line.to.x) &&
         current.y.isBetween(line.from.y, line.to.y )
      }
      var current = line.from
      repeat {
         markGridPosition( row: current.y, column: current.x )
         current.x += columnIncrement
         current.y += rowIncrement
      } while (pointIsOnLine() )
   }
      print("Final grid")
      for row in grid { print(row.reduce("") { j,i in i==0 ? j+"." : j+String(i)}) }

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
