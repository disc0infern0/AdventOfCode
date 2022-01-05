// Advent of Code: 
import SwiftUI

struct ContentView: View {
   @StateObject private var advent = AdventOfCode()
   @State private var selected = 1

   var body: some View {
      ScrollView {
         VStack {
         	Text("\n\(title)\n\n")

            Picker(selection: $advent.dataSet, label: Text("Data Set:")) {
               Text("Test Set One").tag(1)
               Text("Test Set Two").tag(2)
               Text("Test Set Three").tag(3)
               Text("Puzzle Data").tag(0)
            }
            .pickerStyle(.radioGroup)
//            .horizontalRadioGroupLayout()
            .padding(20)
            .border(Color.gray)

            Text("")
            Button("Calculate part One answer") {
               advent.solvePartOne()
            }
            .buttonStyle(.borderedProminent)
            Button("Calculate part Two answer") {
               advent.solvePartTwo()
            }
            .buttonStyle(.borderedProminent)
            if advent.partOne != -1 {
               Text("Part One :  \(String(advent.partOne))")
                  .textSelection(.enabled)
                  .padding(10)
                  .border(Color.gray)
            }
            if advent.partTwo != -1 {
               Text("Part Two :  \(String(advent.partTwo))")
                  .textSelection(.enabled)
                  .padding(10)
                  .border(Color.gray)
            }
         }
      }
      .frame(minWidth: 250, maxWidth: .infinity, minHeight: 100 )
   }
}
