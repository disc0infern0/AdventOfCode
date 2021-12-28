// Advent of Code: Day Seven
import SwiftUI

struct ContentView: View {
   @StateObject private var crabShuffler = ShuffleCrabs()

   var body: some View {
      ScrollView {
         VStack {
            Text("\nCrab Shuffler!! \n")
            Toggle("Use test data?", isOn: $crabShuffler.useTestData)
               .tint(Color.accentColor)
            Text("")
            Button("Calculate part One answer") {
               crabShuffler.calculatePosition(forPartOne: true )
            }
            .buttonStyle(.borderedProminent)
            Button("Calculate part Two answer") {
               crabShuffler.calculatePosition(forPartOne: false)
            }
            .buttonStyle(.borderedProminent)
            if crabShuffler.bestPosition > -1 {
               Text("Best position :  \(String(crabShuffler.bestPosition))")
               Text("with a fuel cost of :  \(String(crabShuffler.fuel))")
                  .textSelection(.enabled)
            }
         }
      }
      .frame(minWidth:250, maxWidth: .infinity, minHeight: 100 )
   }
}

class ShuffleCrabs: ObservableObject {
   @Published var useTestData: Bool = true
   @Published var forPartOne: Bool = true
   
   @Published var bestPosition: Int = -1
   @Published var fuel: Int = 0

   var positions: [Int] = []

   func calculatePosition(forPartOne: Bool)  {
      var fuelCalculator: (Int) -> Int
      if forPartOne {
         fuelCalculator = calcFuelPart1 }
      else {
         fuelCalculator = calcFuelPart2
      }

      positions = parseInput(input: useTestData ? testData : puzzleData )
      let min = positions.min() ?? 0
      let max = positions.max() ?? 0

      bestPosition = -1
      var lastFuel = fuelCalculator(min)
      print("min position fuel \(lastFuel)")
      for position in min+1...max {
         fuel = fuelCalculator(position)
         if fuel > lastFuel { break }
         lastFuel = fuel
         bestPosition = position
      }
      fuel = lastFuel
   }

   func calcFuelPart1(_ point: Int) -> Int{
      positions.reduce(0) {rolling,next in
         abs(next-point)+rolling }
   }
   func calcFuelPart2(_ point: Int) -> Int{
      positions.reduce(0) {rolling,next in
         ((abs(next-point)*(abs(next-point)+1))/2) + rolling }
   }

   func parseInput(input: String) -> [Int] {
      input.components(separatedBy: ",").map{ Int(String($0))! }.sorted()
   }

}
