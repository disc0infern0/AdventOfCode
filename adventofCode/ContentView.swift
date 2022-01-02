// Advent of Code: Day 11: Dumbo Octopus
import SwiftUI

struct ContentView: View {
   @StateObject private var advent = AdventOfCode()

   var body: some View {
      ScrollView {
         VStack {
         	Text("\n--- Day 11: Dumbo Octopus ---\n\n")
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
      .frame(minWidth: 250, maxWidth: .infinity, minHeight: 100 )
   }
}
