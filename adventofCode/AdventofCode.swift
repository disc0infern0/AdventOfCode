//
let title = "AdventofCode Day 12: Caves "
//

import Foundation

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
   let start = Vertex("start")
   let end = Vertex("end")

   enum CaveSize { case small, big
      static func type(_ name: String) -> CaveSize {
         return name.uppercased() == name ? .big : .small
      }
   }

   struct Vertex: Hashable, Equatable {
      var name: String
      var size: CaveSize

      func canBeVisited() -> Bool {
			return true
      }
      init(_ name: String) {
         self.name = name
         self.size = CaveSize.type(name)
      }
   }

   func solvePartOne() {
      loadData()
      routes = []
      calcRoutes(from: start)
      print("Routes!!!!!!!!!!!!!!!!")
      for route in routes {
         printVertices(route)
      }
      partOne = routes.count
   }

   func printVertices(_ vs: [Vertex]) {
      for v in vs { print(v.name, terminator: ", ") }
      print("")
   }

   func calcRoutes(from v: Vertex, with vertices: [Vertex] = []) {
      var currentVertices = vertices
      currentVertices.append(v)
      let linkedVertices = getVertices(from: v)
      print("Calculating Route from \(v.name) whose vertices  are: ", terminator: "" ); printVertices(linkedVertices)
      print("Route so far is: ", terminator: ""); printVertices(currentVertices)

      func isOkToVisit(_ v: Vertex) -> Bool { v.size == .small && currentVertices.contains(v) ? false : true }
      for vertex in linkedVertices where isOkToVisit(vertex) {
         print("In for loop on: \(vertex.name)")
         if vertex == end {
            var s = currentVertices
         	s.append(vertex)
            print("route found! = ", terminator: ""); printVertices(s)
            routes.append(s)
         } else {
            calcRoutes(from: vertex, with: currentVertices)
            print("Finished calculating routes from  \(v.name) for \(vertex.name). Fallthrough to next vertex")
      		print("      Route so far is ", terminator: ""); printVertices(currentVertices)
         }
      }
   }

   func getVertices(from v: Vertex) -> [Vertex] {
      data.filter { $0.contains(v) } .map { set -> Vertex in
         let pair = [Vertex](set)
         return pair[0].name == v.name ? pair[1] : pair[0]
      }.filter { $0.name != "start" }
   }
   var currentVertices: [Vertex] = []
   var routes: [[Vertex]] = []
   /*

    iterate(from: "start")
    routesSoFar: [Vertex] = [start]
    validRoutes: [Vertex] = []
    func iterate(from current: Vertex )

   	for each route from current where routes exist and not visited {
      	if route.contains("end") { add 1 to endCount; add routeSoFar to validRoutes  ]
    		add route.to  to routeSoFar array
			iterate(from: route.to)
      }

    	func canVisited(v: Vertex) -> Bool {
    		!routeSoFar.contains(v) || v.size == .large
    	}
    }
    */

   func solvePartTwo() {
      loadData()
      partTwo = 1
   }

   func loadData() {
      data = []
      var s: Set<Vertex> = []
      for pair in input.components(separatedBy: "\n") {
         let vertices = pair.components(separatedBy: "-")
         guard vertices.count == 2 else { return }
         s = []
         s.insert(Vertex(vertices[0] ))
         s.insert(Vertex(vertices[1] ))
         data.append(s)
      }

   }
}
