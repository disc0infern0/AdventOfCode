//
let title = """
AdventofCode Day 13
Transparent Origami
"""
//

import Foundation
import Metal

class AdventOfCode: ObservableObject {
   //== Template variables for View ==//
   @Published var dataSet: Int = 1
   @Published var partOne: Int = -1
   @Published var partTwo: Int = -1
   var input: String {
      switch dataSet {
      case 0: return puzzleData
      case 1: return testData
      case 2: return testData2
      case 3: return testData3
      default: return testData
      }
   }

   //== Puzzle Code ==//
   struct Point: Hashable { var x: Int, y: Int }
   enum Axis { case x, y }
   struct Fold { var axis: Axis; var amount: Int }
   var points: Set<Point> = []
   var folds: [Fold] = []

   func solvePartOne() {
      loadData()
      doFold(folds[0], to: &points )
      partOne = points.count
   }

   func solvePartTwo() {
      loadData()
      for fold in folds {
         doFold(fold, to: &points )
      }
      for y in 0...points.map(\.y).max()! {
         for x in 0...points.map(\.x).max()! {
            print("\(points.contains(Point(x: x, y: y)) ? "🟩" : "⬛️")", terminator: "")
         }
         print("")
      }
   }

   func doFold(_ fold: Fold, to points: inout Set<Point>) {
      func mod(_ xOrY: Int, _ amount: Int) -> Int {
         xOrY > amount ? amount*2 - xOrY : xOrY
      }
      points = Set(points.map { point in
         switch fold.axis {
         case .x: return( Point(x: mod(point.x, fold.amount), y: point.y))
         case .y: return( Point(x: point.x, y: mod(point.y, fold.amount)))
         }
      })
   }

   func loadData() {
      let components = input.components(separatedBy: "\n\n")

      points = components[0]
         .components(separatedBy: "\n")
         .map { $0.split(separator: ",")}
         .map { p in Point(x: Int(p[0])!, y: Int(p[1])!)}
         .reduce(into: Set<Point>()) { points, point in points.insert(point) }

      folds = components[1]
         .components(separatedBy: "\n")
         .map { $0.split(separator: "=")}
         .map { f in Fold(axis: f[0].last == "x" ? .x : .y, amount: Int(f[1])!) }
   }
}
