//
//  AdventofCode.swift
//

import Foundation

class AdventOfCode: ObservableObject {
   @Published var useTestData: Bool = true
   @Published var partOne: Int = 0
   @Published var partTwo: Int = 0
   var input: String { useTestData ? testData : puzzleData }
   var data: [[Int]] = []
   var gridsize = 0

   func solvePartOne() {
      loadData()
      partOne = 0
      print("\nBeginning"); printData()
      for _ in 1...100 {
         incrementAll()
         partOne += flashed()
      	_ = zeroFlashed()
      }
      print("\nAfter step 100, there were \(partOne) flashes:"); printData()
   }

   func incrementAll() {
      for row in 0..<gridsize {
         for column in 0..<gridsize {
            data[row][column] += 1
         }
      }
   }
   func isValid(_ row: Int, _ col: Int) -> Bool {
      row >= 0 && row < gridsize && col >= 0 && col < gridsize && data[row][col] != -1
   }
   func increaseNeighbours(_ row: Int, _ column: Int) {
      for rowAdjust in [-1, 0, 1] {
         for columnAdjust in [-1, 0, 1]
         	where rowAdjust != 0 || columnAdjust != 0 {
            let r = row+rowAdjust; let c = column+columnAdjust
            if isValid(r, c) {
               data[r][c] += 1
            }
         }
      }
   }

   func zeroFlashed() -> Int {
      var counter = 0
      for row in (0..<gridsize) {
         for col in (0..<gridsize) where data[row][col] == -1 {
            counter += 1
            data[row][col] = 0
         }
      }
      return counter
   }

   func flashed() -> Int {
      var flashes: Int = 0
      var newFlashes: Int
      repeat {
         newFlashes = 0
         for row in 0..<gridsize {
            for column in 0..<gridsize where data[row][column] > 9 {
               newFlashes += 1
               data[row][column] = -1
               increaseNeighbours(row, column)
            }
         }
         flashes += newFlashes
      } while newFlashes > 0

      return flashes
   }

   func solvePartTwo() {
      var step = 0
      loadData()
      partTwo = 0
      repeat {
         step += 1
         incrementAll()
         partOne += flashed()
      } while zeroFlashed() != gridsize*gridsize
      partTwo = step
   }

   func loadData() {
      data = input.components(separatedBy: "\n").map { $0.map { Int(String($0))! }}
      gridsize = data.count
   }
}
