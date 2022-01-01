// Advent of Code: Day 10: Syntax
import SwiftUI

struct ContentView: View {
   @StateObject private var advent = AdventOfCode()

   var body: some View {
      ScrollView {
         VStack {
         	Text("\n--- Day 10: Syntax ---\n\n")
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
   var data: [String] = []

   let corruptScores: [Character: Int]! = [")":3, "]":57 , "}":1197, ">":25137 ]
   let incompleteScores: [Character: Int]! = [")":1, "]":2 , "}":3, ">":4 ]
   let openers: Set<Character> = Set("({[<")
   let closers: [Character:Character]! = [ "(":")", "[":"]", "{":"}", "<":">" ]

   struct Stack<Element> {
      var items: [Element] = []
      mutating func push(_ item: Element) {
         items.append(item)
      }
      mutating func pop() -> Element {
         return items.removeLast()
      }
   }
   enum lineType { case corrupt(Int), incomplete(Int), ok }

   func solvePartOne() {
      loadData()
      partOne = data.map {
         switch(getLineType(line:$0)) {
         case .corrupt(let score): return score
         default: return 0
      	}
      }.reduce(0,+)
   }


   func getLineType(line: String) -> lineType {
      var stack = Stack<Character>()
      print(line)
      for c in line {
         if openers.contains(c) {
            stack.push(c)
         } else {
            let pop = stack.pop()
            if c == closers[pop] {
               // nothing to do
            } else {
               print("no match ==> Corrupt. Read \(String(c)) expected: \(String(pop))")
               // corrupt
               let score = corruptScores[c]
               return .corrupt(score!)
            }
         }
      }
      if stack.items.count > 0 {
         var score = 0
         while ( stack.items.count > 0) {
            let c = closers[stack.pop()]!
            print( "scoring: \(String(c))")
            score = score*5 + incompleteScores[c]!
         }
         print("incomplete (\(score))")
         return .incomplete(score)
      } else {
         print("all ok!")
         return .ok
      }
   }
   func solvePartTwo() {
      loadData()
      let incompletes = data.map { line -> Int in
         switch(getLineType(line: line)) {
            case .incomplete(let score): return score
            default: return 0
         }
      }.filter { $0 != 0 }.sorted()
      print(incompletes)
      partTwo = incompletes[incompletes.count/2]
   }

   func loadData() {
      data = input.components(separatedBy: "\n")
   }
}
