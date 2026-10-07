//
// array and ForEach

import SwiftUI

// Array of image names
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
      ForEach(imageArray, id: \.self) { item in
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
