// Advent of Code: Day Four
import SwiftUI
import Matrix

var testData = false // set to 1 to use test data

// use a struct instead of overwriting the matrix value, when called, to a marker value, e.g. -1

struct CellValue {
   var value: Int
   var called = false
}

// For part two, keep track of what boards have been completed, so we can skip checking them.
class Board {
   var number: Int
   var completed = false
   var matrix: Matrix<CellValue>

   init(number: Int, matrix: Matrix<CellValue>) {
      self.number = number
      self.matrix = matrix
   }
}

struct ContentView: View {
   var body: some View {
      let calls: [Int] = parseCalls(input: testData ? testCalls : puzzleCalls)
      let boards = parseBoards(input: testData ? testBoards: puzzleBoards )

      ScrollView {
         VStack {
            if let partOneAnswer = partOne(calls, boards) {
               Text("Answers found !")
               showBoard(board: partOneAnswer.board)
               Text("last called: \(partOneAnswer.call) X \(sumUnmarked(partOneAnswer.board))")
               Text(String("\(partOneAnswer.call * sumUnmarked(partOneAnswer.board))"))
                  .textSelection(.enabled)
            } else {
               Text("Board not found")
            }
            if let partTwoAnswer = partTwo(calls, boards) {
               Text("Answers found !")
               showBoard(board: partTwoAnswer.board)
               Text("last called: \(partTwoAnswer.call) X \(sumUnmarked(partTwoAnswer.board))")
               Text(String("\(partTwoAnswer.call * sumUnmarked(partTwoAnswer.board))"))
                  .textSelection(.enabled)
            }
         }
      }
		.frame(minWidth:250, minHeight: 100)
   }

}

func sumUnmarked(_ board: Board) -> Int {
   board.matrix.values.reduce(0) { i,j in j.called ? i : i+j.value}
}
struct showBoard: View {
   var board: Board
   var body: some View {
      VStack {
         Text("Board number: \(board.number)")
         ForEach(0..<board.matrix.colLength) { i in
            let row = board.matrix.row[i]
            let tmp: [String] = row.map { c in
               c.called ? "X" : String(c.value)
            }
            Text( tmp.asString() )
               .font(.title).padding(2)
         }

      }
   }
}


func partOne(_ calls: [Int], _ boards: [Board]) -> (
   call: Int, board: Board )? {
   for call in calls {
      for board in boards {
         for row in 0...4 {
            for column in 0...4 {
               if board.matrix[row,column].value == call {
                  board.matrix[row,column].called = true
                  if hasBingo(board,row,column) {
                     return (call: call,board: board)
                  }
               }
            }
         }
      }
   }
   return nil
}


func partTwo(_ calls: [Int], _ boards: [Board]) -> (
   call: Int, board: Board )? {
      let boardCount = boards.count
      var completedCount = 0
      for call in calls {
         for board in boards where board.completed == false {
            for row in 0...4 {
               for column in 0...4 {
                  if board.matrix[row,column].value == call {
                     board.matrix[row,column].called = true
                     if hasBingo(board,row,column) {
                        board.completed = true
                        completedCount += 1
                        if completedCount == boardCount {
                           return (call: call, board: board)
                        }
                     }
                  }
               }
            }
         }
      }
      return nil
   }


func hasBingo(_ board: Board, _ row: Int, _ column: Int ) -> Bool {

   func isLine(_ input: [CellValue]) -> Bool {
      return  input.reduce(true) { i,j in i==true && j.called }
   }
   return isLine(board.matrix.row[row]) || isLine(board.matrix.column[column]) ? true : false
}

func parseCalls(input: String) -> [Int] {
   var output: [Int] = []
   var tmp: String = ""

   for c in input {
      if c == "\n" || c=="," {
         if !tmp.isEmpty, let int = Int(tmp) { output.append(int) }
         tmp = ""
      } else {
         tmp += String(c)
      }
   }
   if !tmp.isEmpty, let i = Int(tmp) {
      output.append(i)
   }
   return output
}


func parseBoards(input: String) -> [Board] {
   var returnArray: [Board] = []
   let carriageReturn: Character = "\n"
   var lastWasCR = false
   var row:[CellValue] = []
   var tmp: String = ""
   var counter = 0

   func addNumber() {
      if !tmp.isEmpty, tmp != " ", let i = Int(tmp) {
         row.append(CellValue(value: i))
      }
      tmp = ""
   }

   for c in input {
      switch c {
         case carriageReturn: //check if blank line, or just finished a line
            if lastWasCR {
               // blank line indicates end of input
               addNumber()
               returnArray.append(Board(number: counter, matrix: Matrix(row, rowLength: 5)))
               counter += 1
               row = []
            } else {
               addNumber()
            }
         case " ": // add number
            addNumber()
         default:
            tmp += String(c)
      }
//      if c==carriageReturn { lastWasCR = true } else { lastWasCR = false }
   	lastWasCR = (c==carriageReturn)
   }
   return returnArray
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
