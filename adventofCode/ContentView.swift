// Advent of Code: Day 8: Seven Segment Search
import SwiftUI

struct ContentView: View {
   @StateObject private var segment = Segment()

   var body: some View {
      ScrollView {
         VStack {
         	Text("\nDay 8: Seven Segment Search\n\n")
            if segment.useTestData {
               Text("<<<<<<Using test data>>>>>\n")
            } else {
					Text("<<<<<<Using Puzzle data>>>>>\n")
            }
            Toggle("Use test data?", isOn: $segment.useTestData)
               .tint(Color.accentColor)
            Text("")
            Button("Count easy numbers (part 1)") {
               segment.solvePartOne()
            }
            .buttonStyle(.borderedProminent)
            Button("Calculate part Two answer") {
               segment.solvePartTwo()
            }
            .buttonStyle(.borderedProminent)
            if segment.partOne > 0 {
               Text("Part One :  \(String(segment.partOne))")
                  .textSelection(.enabled)
            }
            if segment.partTwo > 0 {
               Text("Part Two :  \(String(segment.partTwo))")
                  .textSelection(.enabled)
            }
         }
      }
      .frame(minWidth:250, maxWidth: .infinity, minHeight: 100 )
   }
}

class Segment: ObservableObject {
   @Published var useTestData: Bool = true
   @Published var partOne: Int = 0
   @Published var partTwo: Int = 0
   var input: String { useTestData ? testData : puzzleData }

   var matched: [Int: Set<Character>] = [:]  // solved digits

   var lhs: [[Set<Character>]] = []  // the input lines
   var rhs: [[Set<Character>]] = []  // the output lines

   func solvePartOne() {
      parseInput()
      partOne = rhs.reduce(0) { $0 + getEasyMatches(in: $1) }
   }
   func solvePartTwo() {
      parseInput()
      partTwo = 0
      var haveAllDigits: Bool { (0...9).reduce(true) {$0 && matched[$1] != nil } }
      //enumerate lhs so we can match the index in the rhs after each line is decoded
      for (idx, digits) in lhs.enumerated() {
         matched = [:]
         _ = getEasyMatches(in: digits)
			// Harder digits - keep checking the same line until no more digits matched.
         while digits.reduce(0, {$0 + checkDigit($1)}) > 0 {}
         guard haveAllDigits else { fatalError("Undecipherable!!") }
         // now decode rhs using index from above, and add up
         partTwo += rhs[idx].reduce(0) {roll, next in
            roll*10 + matched.first(where: { $0.value == next })!.key
         }
      }
   }

   func parseInput() {
      lhs = []
      rhs = []
      func parseSegments(_ input: String) -> [Set<Character>] {
         input.components(separatedBy: " ").map { Set($0) }
      }
      let lines = input.components(separatedBy: "\n")
      for line in lines {
         let bothsides = line.components(separatedBy: " | ")
         lhs.append(parseSegments(bothsides[0]))
         rhs.append(parseSegments(bothsides[1]))
      }
   }

   func  getEasyMatches(in digits: [Set<Character>]) -> Int {
      digits.reduce(0) { rolling, digit in
         switch(digit.count) {
            case 2: matched[1] = digit; return rolling + 1
            case 3: matched[7] = digit; return rolling + 1
            case 4: matched[4] = digit; return rolling + 1
            case 7: matched[8] = digit; return rolling + 1
            default: return rolling
         }
      }
   }
   /// Deduce intended mapping from supplied digit.  This is the only area of the solution that needed some deduction!
   func checkDigit(_ digit: Set<Character>) -> Int {
      // 9
      if matched[9] == nil,
         digit.count == 6,
         digit.contains(matched[4]!)
      {
        matched[9] = digit
        return 1
      }
      // 6
      if matched[6] == nil,
         digit.count == 6,
         matched[9] != nil,
         digit != matched[9],
		 	matched[0] != nil,
         digit != matched[0]
      {
        matched[6] = digit
        return 1
      }
      // 0 : length 6, contains 1, != matched[9]
      if matched[0] == nil,
         digit.count == 6,
         matched[9] != nil,
         digit.contains(matched[1]!),
         digit != matched[9]
      {
        matched[0] = digit
        return 1
      }
      // 3 : length 5, contains 1
      if matched[3] == nil,
         digit.count == 5,
         digit.contains(matched[1]!)
      {
        matched[3] = digit
        return 1
      }
      // 5 : length 5, != matched[3], contains 5 chars in 9
      if matched[5] == nil,
         digit.count == 5,
         matched[3] != nil,
         digit != matched[3],
         matched[9] != nil,
         digit.intersection(matched[9]!).count == 5
      {
        matched[5] = digit
        return 1
      }

      // 2: length 5, 3 and 5 already found
      if matched[2] == nil,
         digit.count == 5,
         matched[3] != nil,
         digit != matched[3],
         matched[5] != nil,
         digit != matched[5]
      {
        matched[2] = digit
        return 1
      }
      //nothing found!
      return 0
   }

}

extension Set {
   func toString(sorted: Bool = true ) -> String where Element == Character {
      // Sort set values for easier inspection/comparison by eye when printing
      if sorted {
         return self.sorted().reduce("") {$0+String($1)}
      } else {
      	return self.reduce("") {$0+String($1)}
      }
   }
   func contains(_ s: Set<Character> ) -> Bool where Element == Character {
      s.reduce(true) {$0 && self.contains($1) }
   }
}
