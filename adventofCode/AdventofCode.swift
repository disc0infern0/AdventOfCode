//
let title = "AdventofCode Day 12: Caves "
//

import Foundation
import Metal

class AdventOfCode: ObservableObject {
   //== Template variables for View ==//
   @Published var dataSet: Int = 1
   @Published var partOne: Int = -1
   @Published var partTwo: Int = -1
   var input: String {
      switch dataSet {
      case 0: return puzzleData
      case 1: return testData1
      case 2: return testData2
      case 3: return testData3
      default: return testData1
      }
   }

   //== Puzzle Code ==//
   var data: [Set<Vertex>] = []
   let start = Vertex(name: "start")
   let end = Vertex(name: "end")

   enum CaveSize { case small, big }

   struct Vertex: Hashable, Equatable {
      var name: String
      var size: CaveSize { name.uppercased() == name ? .big : .small }
   }

   func solvePartOne() {
      loadData()
      partOne = 0
      calcRoutesPartOne(from: start)
   }

   func calcRoutesPartOne(from vertex: Vertex, with vertices: [Vertex] = []) {
      var currentVertices = vertices
      currentVertices.append(vertex)
      for v in connections(from: vertex)
      where v.size == .big || (v.size == .small && !currentVertices.contains(v)) {
         if v == end {
            partOne += 1
         } else {
            calcRoutesPartOne(from: v, with: currentVertices)
         }
      }
   }

   func connections(from v: Vertex) -> [Vertex] {
      data.filter { $0.contains(v) } .map { set -> Vertex in
         let pair = [Vertex](set)
         return pair[0].name == v.name ? pair[1] : pair[0]
      }.filter { $0.name != "start" }
   }

   func solvePartTwo() {
      loadData()
      partTwo = 0
      calcRoutesPartTwo(from: start)
   }

   func calcRoutesPartTwo(from vertex: Vertex, with vertices: [Vertex] = []) {
      var currentVertices = vertices; currentVertices.append(vertex)
      let twoVisited = !currentVertices.filter({$0.size == .small}).allSatisfy {vtx in
         currentVertices.filter { $0 == vtx }.count < 2 }
      for v in connections(from: vertex)
      where v.size == .big || (v.size == .small &&
       ( !currentVertices.contains(v)  ||
         currentVertices.filter {$0 == v}.count == 1 && twoVisited == false ) ) {
         if v == end {
            partTwo += 1
         } else {
            calcRoutesPartTwo(from: v, with: currentVertices)
         }
      }
   }

   func loadData() {
      data = input.split(separator: "\n")
         .reduce(into: [Set<Vertex>]()) { rolling, value in
         	let caves = value.components(separatedBy: "-")
            rolling.append([Vertex(name: caves[0]), Vertex(name: caves[1])])
         }
   }
}
