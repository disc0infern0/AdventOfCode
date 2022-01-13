//
let title = """
Advent of Code
Day 14 Extended Polymerization
"""
//
//swiftlint:disable superfluous_disable_command
//swiftlint:disable colon
//swiftlint:disable line_length
//swiftlint:disable function_body_length

import Foundation
import Metal
import SwiftUI

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

   struct Pair: Equatable, Hashable { var first: Character, second: Character }

   /// Initial algorithm based on maintaining the polymer in an array of pairs, which can be iterated on by applying a closure to each pair
   /// that will return the two new pairs, which can be inserted into a new array of pairs in iteration.
   /// The solution for part Two is 12 lines longer and uses a different algorithm entirely, though the structure of the code is similar
   func solvePartOne() {
      var polymer: [Pair] = []
      var last = ""
      typealias Rule = (Pair) -> [Pair]
      var rules: [Rule] = []

      func loadData() {
         let components = input.components(separatedBy: "\n\n")
         let template = components[0]
         last = String(template.last!)

         polymer = Array(zip(template, String(template.dropFirst()) + "|"))
            .reduce(into: [Pair]()) { $0.append(Pair(first: $1.0, second: $1.1)) }

         rules = components[1]
            .components(separatedBy: "\n")
            .map { line in
               let idx = line.startIndex
               return createRule( pair: Pair(first: line[idx], second: line[line.index(idx, offsetBy: 1)]),
                                  target: line[line.index(idx, offsetBy: 6) ]
               )
            }
      }
      func createRule(pair: Pair, target: Character) -> Rule {
         return { p -> [Pair] in
            guard p == pair else { return [] }
            return [Pair(first: p.first, second: target), Pair(first: target, second: p.second)]
         }
      }
      loadData()

      for _ in (1...10) {
         polymer = polymer.reduce(into: [Pair]() ) { array, pair in
            for rule in rules {
               array.append(contentsOf: rule(pair))
            }
         }
      }
      //
      let counts = (polymer.reduce("", { string, next in string + String(next.first)}) + last)
         .reduce(into: [Character: Int]()) { $0[$1, default:0] += 1 }
         .values.sorted()
      partOne = counts.last! - counts.first!
   }
   /// Using the above algorithm requires maintaining a very long sequence of pairs in the polymer, which on this device
   /// causes a lockup at around the 21st iteration.
   /// Since we ultimately only need the counts of each character in the final polymer, the actual order of the pairs is irrelevant,
   /// so we can instead use a dictionary to count the number of each distinct pair of characters in the rules.
   /// The dictionary is then limited in size to at most 26 x 26 values
   /// To manage the transformation at each iteration, define a dictionary of closures,
   /// keyed on each unique pair in the rules, that returns the two new pairs created by that rule, with the counts
   /// from the originating pair.
   /// e.g. NB -> C  means when NB is found, the pairs NC and BC should be substitued. If the pair NB occurs 10 times in the polymer, then
   /// the next iteration will have 10 of NC and 10 of BC
   /// of the target pairs/original pair respectively.
   func solvePartTwo() {
      var polymerPairs: [Pair: Int] = [:]
      typealias Rule = () -> [Pair:Int]
      var rules: [Pair: Rule] = [:]
      var firstChar: Character = "|"
      var lastChar: Character = "|"

      func loadData() {
         let components = input.components(separatedBy: "\n\n")
         let template = components[0]
         firstChar = template.first!
         lastChar = template.last!

         polymerPairs = Array(zip(template, String(template.dropFirst()) ))
            .reduce(into: [Pair: Int]()) { dict, next in
               dict[Pair(first: next.0, second: next.1), default: 0] += 1
            }
         // Dictionary of closures to create two pairs from one, and copy counts across to each new pair
         rules = components[1]
            .components(separatedBy: "\n")
            .reduce(into: [Pair: Rule]()) { rules, line in
               let p = Array(line)
               let pair = Pair(first: p[0], second: p[1] )
               rules[pair] = {
                  var dict = [Pair:Int]()
                  dict[Pair(first: pair.first, second: p[6]), default: 0 ] += polymerPairs[pair]!
                  dict[Pair(first: p[6], second: pair.second), default: 0] += polymerPairs[pair]!
                  return dict
               }
            }
      }
      loadData()
      // Iterate over the dictionary of pairs, getting a new dictionary each iteration.
      for _ in (1...40) {
         polymerPairs = polymerPairs.keys
            .reduce(into: [Pair: Int]()) { dict, pair in
               rules[pair]!().forEach { p in // the rule returns two dictionary pairs
                  dict[p.key, default:0] += p.value
               }
            }
      }
      // Get counts of each character from each pair in the final dictionary of pairs
      // Each character, apart from the first and last, is double counted since it occurs in two pairs.
      var counts = polymerPairs.keys
         .reduce(into: [Character: Int]() ) { dict, pair in
            dict[pair.first, default: 0] += polymerPairs[pair]!
            dict[pair.second, default: 0] += polymerPairs[pair]!
         }
      counts[firstChar, default: 0] += 1
      counts[lastChar, default: 0] += 1
      partTwo = counts.values.max()!/2 - counts.values.min()!/2
   }
}
