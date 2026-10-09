//
// page 1: stacking stuff
// VStack = top to bottom, HStack = side by side

import SwiftUI

struct Page1: View {
  var body: some View {
    // the whole page is one column...
    VStack {
      // ...row 1: two shapes side by side
      HStack {
        // Image(systemName:) = a built in sf symbol
        Image(systemName: "rectangle")
          // resizable = let me change its size (otherwise it stays icon size)
          .resizable()
          // random width + height between 50 and 200
          // (it changes every time the page redraws, like when you rotate the phone)
          .frame(width:.random(in:50..<200), height: .random(in:50..<200))
        Image(systemName: "rectangle")
          .resizable()
          .frame(width:.random(in:50..<200), height: .random(in:50..<200))
      }
      // ...row 2: two more
      HStack {
        Image(systemName: "square.and.arrow.up")
          .resizable()
          .frame(width:.random(in:50..<200), height: .random(in:50..<200))
        Image(systemName: "rectangle.portrait.and.arrow.right")
          .resizable()
          .frame(width:.random(in:50..<200), height: .random(in:50..<200))
      }
    }
  }
}

#Preview {
    Page1()
}
