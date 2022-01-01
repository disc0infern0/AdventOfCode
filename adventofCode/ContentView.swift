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

   struct Point: Hashable {
      var x: Int
      var y: Int
      init(x: Int, y: Int) {
         self.x = x; self.y = y
      }
      init(_ x: Int, _ y: Int) {
         self.x = x; self.y = y
      }
   }
   enum Locations: CaseIterable { case up, down, left, right }

   func next(_ point: Point, along location: Locations ) -> Point? {
      var next: Point?
      switch location {
         case .up: if point.y>0 { next = Point(point.x, point.y - 1) }
         case .left: if point.x>0 { next = Point(point.x - 1, point.y) }
         case .right: if (point.x)+1 != data[point.y].count { next = Point(point.x + 1,point.y) }
         case .down: if (point.y)+1 != data.count { next = Point(point.x,point.y + 1) }
      }
      return next
   }

   func dataAt(_ point: Point, direction: Locations? = nil ) -> Int {
      if direction == nil {
         return data[point.y][point.x]
      } else {
         if let p = next(point, along: direction!) {
            return data[p.y][p.x]
         } else {
            return 9
         }
      }
   }

   func allNeighboursHigher(point: Point) -> Bool {
      Locations.allCases.reduce(true) { $0 && dataAt(point) < dataAt(point, direction: $1) }
   }

   func getLowPoints() -> [Point] {
   	var lowPoints: [Point] = []
      for y in 0...data.count-1 {
         for x in 0...data[y].count-1 {
            let p = Point(x:x,y:y)
            if allNeighboursHigher(point: p) {
               lowPoints.append(p)
            }
         }
      }
      return lowPoints
   }

   func solvePartOne() {
      parseInput()
      partOne = getLowPoints().reduce(0){$0+dataAt($1)+1}
   }

   func solvePartTwo() {
      let s = getLowPoints().map { getBasinSize(at: $0) }.sorted(by: >)
      guard s.count >= 3 else { print("no solution"); return}
      partTwo = s[0]*s[1]*s[2]
   }

   // We don't need all the basin points, just it's total size
   func getBasinSize(at point: Point) -> Int {
      var basinSize = 0
      func check(point: Point) {
         guard dataAt(point) != 9 else {return}
         basinSize += 1
         data[point.y][point.x] = 9 // don't retrace steps
         for direction in Locations.allCases {
            if let nxt = next(point, along: direction) { check(point: nxt) }
         }
      }
      check(point: point)
      return basinSize
   }

   func parseInput() {
      data = input.components(separatedBy: "\n").map { line in
         line.map{Int(String($0))!}
      }
   }
}
