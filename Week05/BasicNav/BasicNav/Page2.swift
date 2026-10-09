//
// page 2: one list of names -> one picture each, with ForEach

import SwiftUI

// my list of sf symbol names. pages 2-8 all use this one list
let imageArray = [
  "rectangle",
  "triangle",
  "hexagon",
  "pentagon",
  "rhombus",
  "diamond",
  "circle",
  "seal",
  "oval",
  "capsule"
]

struct Page2: View {
  var body: some View {
    VStack {
      // ForEach = do this once for every name in the list
      // id: \.self = each name is its own id (works because they're all different)
      ForEach(imageArray, id: \.self) { item in
        // item = the name we're on right now
        Image(systemName: item)
          .resizable()
          .frame(width:100, height: 100)
      }
    }
  }
}

#Preview {
    Page2()
}

// https://tisch.nyu.edu/about/directory
