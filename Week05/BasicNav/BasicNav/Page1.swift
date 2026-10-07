//
//  Layout with VStack and HStack

import SwiftUI

struct Page1: View {
  var body: some View {
    VStack {
      HStack {
        Image(systemName: "rectangle")
          .resizable()
          .frame(width:.random(in:50..<200), height: .random(in:50..<200))
        Image(systemName: "rectangle")
          .resizable()
          .frame(width:.random(in:50..<200), height: .random(in:50..<200))
      }
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


