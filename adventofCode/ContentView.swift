
import SwiftUI

// Advent of Code: Day One parts one and two

struct ContentView: View {

    var body: some View {
       let depths = transformPuzzleInput()
       let answer = increasesByThrees(depths: depths)
       Text("The answer is \(answer)")
          .padding()
          .frame(minWidth:150, minHeight: 100)
    }
}
func transformPuzzleInput() -> [Int] {
   var depths: [Int] = []
   var tmp: String = ""
   for char in puzzleInput {
//   for char in testInput {
      if char == "\n" {
         depths.append( Int(tmp) ?? 0 )
         tmp=""
      } else {
			tmp = tmp + String(char)
      }
   }
   return depths
}

// Part 2 of Day 2
func increasesByThrees(depths: [Int]) -> Int {
   var counter = 0
   var last = depths[0] + depths[1] + depths[2]
   for i in 1...(depths.count-3) {
		let next = depths[i]+depths[i+1]+depths[i+2]
      if next > last { counter += 1 }
      last = next
   }
	return counter
}

// Part 1 of Day 1
func increases(depths: [Int]) -> Int {
   var counter = 0
   let initialdepth = depths.max()
   let _ = depths.reduce(initialdepth) { i,j in
      if j > i ?? 0 {
         counter += 1
      }
      return j
   }
   return counter
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
