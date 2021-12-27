// Advent of Code: Day Five
import SwiftUI

var useTestData = true
//var useTestData = false


struct ContentView: View {
   @StateObject private var fishCounter = CountFish()
   @State private var days: Int = 0
   @State private var stringDays: String = "8"
   var body: some View {
      ScrollView {
         VStack {
            Text("\nFish Counter!! \n")
            TextField("enter days", text: $stringDays )
               .padding(20)
               .onSubmit {
                  days = Int(stringDays) ?? 0
                  fishCounter.calculatePopulationAfter(days: days)
               }
            Text("Fish population :  \(String(fishCounter.count))")
               .textSelection(.enabled)
         }
      }
		.frame(minWidth:250, minHeight: 100)
   }
}

let Timers = [1,2,3,4,5,6,7,8,0]
typealias FishKey = Int
typealias FishValue = Int
typealias FishTimerDict = [FishKey: FishValue]

class CountFish: ObservableObject {
   @Published var count: Int = 0

   func calculatePopulationAfter(days: Int)  {
      count = 0
      guard days > 0 else { return }
      var fish = parseInput(input: useTestData ? testData : puzzleData )
      for _ in 1...days {
         var fishAtEndofDay: FishTimerDict! = [:]
         for timer in Timers where fish[timer] ?? 0  > 0 {
            switch timer {
               case 1,2,3,4,5,6,7,8:
                     fishAtEndofDay[timer-1] = fish[timer]
               case 0:
                  fishAtEndofDay[8] = fish[0]!
                  fishAtEndofDay[6] = (fishAtEndofDay[6] ?? 0) + fish[0]!
               default: break
            }
         }
         fish = fishAtEndofDay
         // show(fish)
      }
      count = fish.values.reduce(0,+)
   }

   func parseInput(input: String) -> FishTimerDict {
      Dictionary(uniqueKeysWithValues: zip(0...8, (0...8).map{ k in input.filter{$0 != ","}.map{Int(String($0))!}.filter{$0==k}.count } ))
   }

   func show(_ fish: FishTimerDict) {
      for t in 0...8 {
         print(String(fish[t] ?? 0), terminator: ".")
      }
      print("")
   }
}
