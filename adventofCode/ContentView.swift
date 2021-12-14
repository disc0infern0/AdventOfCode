
import SwiftUI

// Advent of Code blank starting point

struct ContentView: View {
   var body: some View {

      // Common
      let parsed = parse(input: puzzleData)

      // Part One
      let transformed = transform(input: parsed)
      let gamma = getGamma(input: transformed)
      let epsilon = getEpsilon(input: gamma)
      let partOne = String(gamma * epsilon)

      // Part Two
      let oxygenRating = getOxygenRating(strings: parsed)
      let carbonRating = getCarbonRating(strings: parsed)
      let partTwo = String(oxygenRating*carbonRating)


      Text("The answer to part one is \(partOne)")
         .padding(4)
         .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50 )
         .textSelection(.enabled)
      Text("The answer to part two is \(partTwo)")
         .padding(4)
         .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50 )
         .textSelection(.enabled)
   }
}
func getGamma(input: [[Int]]) -> Int {
   var tmp = ""
   for column in input {
      let sum = column.reduce(0,+)
      let count = column.count
      tmp += sum >= count/2 ? "1" : "0"
   }
   return Int(tmp, radix: 2)!
}

func getEpsilon(input: Int) -> Int {
   let data = String(input, radix: 2)
   var epsilonString = ""
   for c in data {
      epsilonString += c=="1" ? "0" : "1"
   }
   return Int(epsilonString, radix: 2)!
}
// String subscripts
extension String {
   subscript(i: Int) -> String {
      return String(self[index(startIndex, offsetBy: i)])
   }
}

// Oxygen Rating
// given a position, filter the array to show only the lines with the
// most common digit in that position. if 0 and 1's are both equal, select the 1's
func getOxygenRating(strings: [String]) -> Int {
   guard strings.count > 0 else { return -1 }
   var filteredStrings = strings
   for digit in 0...filteredStrings[0].count {
      filteredStrings = o2iterate(digit: digit, strings: filteredStrings)
      if filteredStrings.count == 1 {
         return Int(filteredStrings[0], radix: 2)!
      }
   }
   print("o2 rating not found")
   return -1
}

func o2iterate(digit: Int, strings: [String]) -> [String] {
   guard strings.count > 0, digit < strings[0].count else { return ["error"] }

   let column = transform(input: strings)[digit]
   let sum: Double = Double( column.reduce(0,+) )
   let midpoint: Double = Double(column.count) / 2
   let filter = sum >= midpoint ? "1" : "0"

   return strings.filter { string in string[digit] == filter }
}

// Carbon Rating
// given a position, filter the array to show only the lines with the
// least common digit in that position. if 0 and 1's are both equal, select the 0's
func getCarbonRating(strings: [String]) -> Int {
   guard strings.count > 0 else { return 3 }
   var filteredStrings = strings
   for digit in 0...filteredStrings[0].count {
      filteredStrings = carbonIterate(digit: digit, strings: filteredStrings)
      if filteredStrings.count == 1 {
         return Int(filteredStrings[0], radix: 2)!
      }
   }
   print("carbon rating not found")
   return 2
}

func carbonIterate(digit: Int, strings: [String]) -> [String] {
   guard strings.count > 0 else { return ["error"] }

   let column = transform(input: strings)[digit]
   let sum: Double = Double( column.reduce(0,+) )
   let midpoint: Double = Double(column.count) / 2
   let filter = sum >= midpoint ? "0" : "1"

   return strings.filter { string in string[digit] == filter }
}

func parse(input: String) -> [String] {
   var output: [String] = []
   var tmp: String = ""

   for c in input {
      if c == "\n" {
         output.append(tmp)
         tmp = ""
      } else {
         tmp += String(c)
      }
   }
   if tmp != "" {
      output.append(tmp)
   }
   return output
}

func transform(input: [String]) -> [[Int]] {


   let digitCount = input[0].count
   let lineCount = input.count
   let column = Array(repeating: 0, count: lineCount)
   var output = Array(repeating: column, count: digitCount)

   var col=0
   var row=0
   for line in input {
      col=0
      for c in line {
         output[col][row] = Int(String(c))!
         col+=1
      }
      row+=1
   }

   return output
}


struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}
