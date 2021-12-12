
import SwiftUI

// Advent of Code blank starting point

struct ContentView: View {

    var body: some View {
       let depths = transformPuzzleInput()
       let answer = increases(depths: depths)
       Text("The answer is \(answer)")
          .padding()
          .frame(minWidth:150, minHeight: 100)
    }
}
func transformPuzzleInput() -> [Int] {
   var depths: [Int] = []
   var tmp: String = ""
   for char in puzzleInput {
      if char == "\n" {
         depths.append( Int(tmp) ?? 0 )
         tmp=""
      } else {
			tmp = tmp + String(char)
      }
   }
   return depths
}

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
