// Advent of Code: Day 9: Smoke Basin
import SwiftUI

struct ContentView: View {
   @StateObject private var advent = AdventOfCode()

   var body: some View {
      ScrollView {
         VStack {
         	Text("\n--- Day 9: Smoke Basin ---\n\n")
            if advent.useTestData {
               Text("<<<<<<Using test data>>>>>\n")
            } else {
					Text("<<<<<<Using Puzzle data>>>>>\n")
            }
            Toggle("Use test data?", isOn: $advent.useTestData)
               .tint(Color.accentColor)
            Text("")
            Button("Calculate part One answer") {
               advent.solvePartOne()
            }
            .buttonStyle(.borderedProminent)
            Button("Calculate part Two answer") {
               advent.solvePartTwo()
            }
            .buttonStyle(.borderedProminent)
            if advent.partOne > 0 {
               Text("Part One :  \(String(advent.partOne))")
                  .textSelection(.enabled)
            }
            if advent.partTwo > 0 {
               Text("Part Two :  \(String(advent.partTwo))")
                  .textSelection(.enabled)
            }
         }
      }
      .frame(minWidth:250, maxWidth: .infinity, minHeight: 100 )
   }
}

class AdventOfCode: ObservableObject {
   @Published var useTestData: Bool = true
   @Published var partOne: Int = 0
   @Published var partTwo: Int = 0
   var input: String { useTestData ? testData : puzzleData }
   var data: [[Int]] = []
   struct Point {
      var x: Int
      var y: Int
   }
   var point: Point = Point(x:0,y:0)
   var dataPoint: Int { data[point.y][point.x] }
   enum Locations: CaseIterable { case up, down, left, right }

   func dataAt(_ point: Point, direction: Locations? = nil ) -> Int {
      if let location = direction {
         switch location {
            case .up: if point.y==0 { return 9} else { return data[point.y - 1][point.x] }
            case .left: if point.x==0 { return 9} else { return data[point.y][point.x - 1] }
            case .right: if point.x+1 == data[point.y].count { return 9} else { return data[point.y][point.x + 1] }
            case .down: if point.y+1 == data.count { return 9} else { return data[point.y + 1][point.x] }
         }
      } else {
         return data[point.y][point.x]
      }
   }
   func solvePartOne() {
      parseInput()
      partOne = 0
      var lowPoints: [Int] = []
      for y in 0...data.count-1 {
         for x in 0...data[y].count-1 {
            point = Point(x:x,y:y)
            if allNeighboursHigher(point: point) {
               lowPoints.append(dataAt(point))
            }
         }
      }
      partOne = lowPoints.reduce(0){$0+$1+1}
   }



   func allNeighboursHigher(point: Point) -> Bool {
      Locations.allCases.reduce(true) { $0 && dataAt(point) < dataAt(point, direction: $1) }
   }
   func solvePartTwo() {
      parseInput()
      partTwo = 0
   }

   func parseInput() {
      data = input.components(separatedBy: "\n").map { line in
         line.map{Int(String($0))!}
      }
   }
}
