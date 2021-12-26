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
            Text("Fish population :  \(fishCounter.count)")
               .textSelection(.enabled)
         }
      }
		.frame(minWidth:250, minHeight: 100)
   }
}

class Fish {
   var timer: Int
   var next: Fish?
   var new: Bool = false

   init(timer: Int){
      self.timer = timer
      if timer == 8 {
         self.new = true
      }
   }
}


class CountFish: ObservableObject {
   @Published var count: Int = 0

	var firstFish: Fish?
	var lastFish: Fish?

   func printFish() {
      var currentFish = firstFish
      print("Current Fish...")
      while currentFish != nil {
         print(String(currentFish!.timer), terminator: "")
         currentFish = currentFish?.next
      }
      print("\n")
   }

   func calculatePopulationAfter(days: Int)  {
      count = 0
      firstFish = nil
      lastFish = nil
      parseLines(input: useTestData ? testData : puzzleData )
      guard days > 0 else { return }
      var currentFish: Fish?
      for day in 1...days {
         currentFish = firstFish
         while currentFish != nil {
            switch currentFish!.timer {
               case 0:
                  newFish()
                  currentFish!.timer = 6
               case 1,2,3,4,5,6,7:
                  currentFish!.timer -= 1
               case 8:
                  if currentFish!.new {
                     currentFish!.new = false
                  } else {
                     currentFish!.timer -= 1
                  }
               default: fatalError("Timer too large")
            }
            currentFish = currentFish!.next
         }
         print("After Day \(day), the count is : \(count)")
         if day < 50 {
            printFish()
         }
      }
      deleteFish()
   }

   func deleteFish() {
      var currentFish = firstFish
      while currentFish != nil {
         if let nextFish = currentFish?.next {
            currentFish = nil
            currentFish = nextFish
         } else {
            currentFish = nil
         }
      }
   }

   func parseLines(input: String) {
      for c in input where c != "," {
         newFish(timer: Int(String(c))!)
      }
   }

   func newFish(timer: Int = 8) {
      var currentFish = lastFish
      let new = Fish(timer: timer)
      count += 1
      if currentFish == nil {
         currentFish = new
         firstFish = new
      } else {
         currentFish?.next = new
         currentFish = new
      }
      lastFish = currentFish
   }

}



//func printFish(_ fish: [Fish]) {
//   _ = fish.map { f in
//      print("\(f.timer),", terminator: "" )
//   }
//   print("")
//}



extension Comparable  {
   func isBetween (_ value1: Self, _ value2: Self) -> Bool {
      let lower = min(value1,value2)
      let upper = max(value1,value2)
      return lower <= self  && self <= upper
   }
}





// String subscripts
extension String {
   subscript(i: Int) -> String {
      return String(self[index(startIndex, offsetBy: i)])
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}
